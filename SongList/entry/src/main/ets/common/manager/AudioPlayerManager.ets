import { media } from '@kit.MediaKit';
import { resourceManager } from '@kit.LocalizationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { promptAction } from '@kit.ArkUI';
import Song from '../interface/song';
import { avSessionController } from './AVSessionController';

export enum PlayMode {
  SEQUENTIAL = 0,
  SHUFFLE = 1,
  REPEAT_ONE = 2,
  REPEAT_ALL = 3
}

export enum PlaybackState {
  IDLE = 'idle',
  LOADING = 'loading',
  PLAYING = 'playing',
  PAUSED = 'paused',
  COMPLETED = 'completed',
  STOPPED = 'stopped',
  ERROR = 'error'
}

@ObservedV2
export class AudioPlayerManager {
  @Trace isPlaying: boolean = false;
  @Trace currentTime: number = 0;
  @Trace totalDuration: number = 0;
  @Trace currentSong: Song | null = null;
  @Trace playbackState: PlaybackState = PlaybackState.IDLE;
  @Trace playMode: PlayMode = PlayMode.SEQUENTIAL;

  private avPlayer: media.AVPlayer | null = null;
  private resMgr: resourceManager.ResourceManager | null = null;
  private uiContext: common.UIAbilityContext | null = null;
  private playlist: Song[] = [];
  private currentIndex: number = -1;
  private shuffleList: number[] = [];
  private shufflePos: number = -1;
  private avSessionCreated: boolean = false;
  private initPhase: string = '';

  private static instance: AudioPlayerManager;

  static getInstance(): AudioPlayerManager {
    if (!AudioPlayerManager.instance) {
      AudioPlayerManager.instance = new AudioPlayerManager();
    }
    return AudioPlayerManager.instance;
  }

  init(rm: resourceManager.ResourceManager, songs: Song[], context: common.UIAbilityContext): void {
    this.resMgr = rm;
    this.playlist = songs;
    this.uiContext = context;
  }

  setPlaylist(songs: Song[]): void {
    this.playlist = songs;
  }

  getCurrentIndex(): number {
    return this.currentIndex;
  }

  getPlaylist(): Song[] {
    return this.playlist;
  }

  async playByIndex(index: number): Promise<void> {
    if (index < 0 || index >= this.playlist.length) {
      return;
    }
    this.currentIndex = index;
    if (this.playMode === PlayMode.SHUFFLE) {
      this.generateShuffleList(index);
    }
    await this.loadAndPlay(this.playlist[index]);
  }

  async playSong(song: Song): Promise<void> {
    const index = this.playlist.findIndex(s => s.id === song.id);
    if (index === -1) {
      return;
    }
    await this.playByIndex(index);
  }

  async togglePlayPause(): Promise<void> {
    if (!this.avPlayer) {
      return;
    }
    try {
      if (this.isPlaying) {
        await this.avPlayer.pause();
      } else {
        await this.avPlayer.play();
      }
    } catch (err) {
      console.error('togglePlayPause failed:', JSON.stringify(err));
    }
  }

  async next(): Promise<void> {
    const nextIndex = this.getNextIndex();
    if (nextIndex === -1) {
      await this.stop();
      return;
    }
    await this.playByIndex(nextIndex);
  }

  async previous(): Promise<void> {
    if (this.currentTime >= 3000) {
      await this.seekTo(0);
      return;
    }
    const prevIndex = this.getPreviousIndex();
    if (prevIndex === -1) {
      await this.seekTo(0);
      return;
    }
    await this.playByIndex(prevIndex);
  }

  async seekTo(timeMs: number): Promise<void> {
    if (!this.avPlayer) {
      return;
    }
    try {
      await this.avPlayer.seek(timeMs, media.SeekMode.SEEK_PREV_SYNC);
      this.currentTime = timeMs;
    } catch (err) {
      console.error('seekTo failed:', JSON.stringify(err));
    }
  }

  async stop(): Promise<void> {
    try {
      if (this.avPlayer) {
        await this.avPlayer.stop();
        await this.avPlayer.release();
        this.avPlayer = null;
      }
    } catch (err) {
      console.error('stop failed:', JSON.stringify(err));
    }
    this.isPlaying = false;
    this.currentTime = 0;
    this.totalDuration = 0;
    this.playbackState = PlaybackState.STOPPED;
  }

  cyclePlayMode(): void {
    const modes = [PlayMode.SEQUENTIAL, PlayMode.SHUFFLE, PlayMode.REPEAT_ONE, PlayMode.REPEAT_ALL];
    const currentIdx = modes.indexOf(this.playMode);
    this.playMode = modes[(currentIdx + 1) % modes.length];
    if (this.playMode === PlayMode.SHUFFLE && this.currentIndex >= 0) {
      this.generateShuffleList(this.currentIndex);
    }
  }

  release(): void {
    if (this.avPlayer) {
      try {
        this.avPlayer.release();
      } catch (err) {
        console.error('release failed:', JSON.stringify(err));
      }
      this.avPlayer = null;
    }
    avSessionController.destroy();
    this.avSessionCreated = false;
    this.currentSong = null;
    this.currentIndex = -1;
    this.isPlaying = false;
    this.playbackState = PlaybackState.IDLE;
  }

  private async loadAndPlay(song: Song): Promise<void> {
    try {
      this.playbackState = PlaybackState.LOADING;
      this.currentSong = song;
      this.currentTime = 0;
      this.totalDuration = 0;
      this.isPlaying = false;

      if (this.avPlayer) {
        await this.avPlayer.release();
        this.avPlayer = null;
      }

      if (!this.resMgr) {
        this.playbackState = PlaybackState.ERROR;
        console.error('ResourceManager not initialized');
        promptAction.showToast({ message: '播放器初始化失败', duration: 2000 });
        return;
      }

      const fdInfo = await this.resMgr.getRawFd(song.sourcePath);
      this.avPlayer = await media.createAVPlayer();
      this.avPlayer.fdSrc = {
        fd: fdInfo.fd,
        offset: fdInfo.offset,
        length: fdInfo.length
      };

      this.initPhase = 'waitingForInit';

      this.avPlayer.on('stateChange', (state: string) => {
        if (this.initPhase === 'waitingForInit' && state === 'initialized') {
          this.initPhase = 'waitingForPrepared';
          this.avPlayer!.prepare();
          return;
        }
        if (this.initPhase === 'waitingForPrepared' && state === 'prepared') {
          this.initPhase = 'done';
          this.avPlayer!.play();
          return;
        }
        this.handleStateChange(state);
      });

      this.avPlayer.on('timeUpdate', (time: number) => {
        this.currentTime = time;
      });

      this.avPlayer.on('error', (err: BusinessError) => {
        console.error('AVPlayer error:', JSON.stringify(err));
        this.playbackState = PlaybackState.ERROR;
        this.isPlaying = false;
      });

      if (!this.avSessionCreated && this.uiContext) {
        await avSessionController.createSession(this.uiContext);
        this.avSessionCreated = true;
      }
      await avSessionController.updateMetadata();
    } catch (err) {
      console.error('loadAndPlay failed:', JSON.stringify(err));
      this.playbackState = PlaybackState.ERROR;
      this.isPlaying = false;
      promptAction.showToast({ message: '音频加载失败，请重试', duration: 2000 });
    }
  }

  private handleStateChange(state: string): void {
    switch (state) {
      case 'playing':
        this.playbackState = PlaybackState.PLAYING;
        this.isPlaying = true;
        if (this.avPlayer && this.totalDuration === 0) {
          this.totalDuration = this.avPlayer.duration;
        }
        avSessionController.setPlaybackState(true);
        break;
      case 'paused':
        this.playbackState = PlaybackState.PAUSED;
        this.isPlaying = false;
        avSessionController.setPlaybackState(false);
        break;
      case 'stopped':
        this.playbackState = PlaybackState.STOPPED;
        this.isPlaying = false;
        break;
      case 'completed':
        this.playbackState = PlaybackState.COMPLETED;
        this.isPlaying = false;
        this.handleTrackComplete();
        break;
      case 'error':
        this.playbackState = PlaybackState.ERROR;
        this.isPlaying = false;
        break;
      case 'prepared':
      case 'initialized':
      case 'idle':
        break;
    }
  }

  private handleTrackComplete(): void {
    if (this.playMode === PlayMode.REPEAT_ONE) {
      if (this.currentSong) {
        this.loadAndPlay(this.currentSong);
      }
      return;
    }
    const nextIndex = this.getNextIndex();
    if (nextIndex === -1) {
      this.playbackState = PlaybackState.STOPPED;
      return;
    }
    this.playByIndex(nextIndex);
  }

  private getNextIndex(): number {
    if (this.playlist.length === 0) {
      return -1;
    }
    if (this.playMode === PlayMode.SHUFFLE) {
      if (this.shufflePos < this.shuffleList.length - 1) {
        this.shufflePos++;
        return this.shuffleList[this.shufflePos];
      }
      if (this.shufflePos >= this.shuffleList.length) {
        return -1;
      }
      return -1;
    }
    const nextIdx = this.currentIndex + 1;
    if (nextIdx >= this.playlist.length) {
      if (this.playMode === PlayMode.REPEAT_ALL) {
        return 0;
      }
      return -1;
    }
    return nextIdx;
  }

  private getPreviousIndex(): number {
    if (this.playlist.length === 0) {
      return -1;
    }
    if (this.playMode === PlayMode.SHUFFLE && this.shufflePos > 0) {
      this.shufflePos--;
      return this.shuffleList[this.shufflePos];
    }
    const prevIdx = this.currentIndex - 1;
    if (prevIdx < 0) {
      if (this.playMode === PlayMode.REPEAT_ALL) {
        return this.playlist.length - 1;
      }
      return -1;
    }
    return prevIdx;
  }

  private generateShuffleList(currentIdx: number): void {
    const indices: number[] = [];
    for (let i = 0; i < this.playlist.length; i++) {
      if (i !== currentIdx) {
        indices.push(i);
      }
    }
    for (let i = indices.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      const temp = indices[i];
      indices[i] = indices[j];
      indices[j] = temp;
    }
    this.shuffleList = [currentIdx, ...indices];
    this.shufflePos = 0;
  }

}

export const playerManager = AudioPlayerManager.getInstance();
