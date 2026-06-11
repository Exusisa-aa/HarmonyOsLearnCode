import { avSession } from '@kit.AVSessionKit';
import { playerManager } from './AudioPlayerManager';
import { common } from '@kit.AbilityKit';
import { image } from '@kit.ImageKit';

export class AVSessionController {
  private session: avSession.AVSession | null = null;
  private isActive: boolean = false;

  private static instance: AVSessionController;

  static getInstance(): AVSessionController {
    if (!AVSessionController.instance) {
      AVSessionController.instance = new AVSessionController();
    }
    return AVSessionController.instance;
  }

  async createSession(context: common.UIAbilityContext): Promise<void> {
    try {
      this.session = await avSession.createAVSession(
        context,
        'audio',
        'audio'
      );

      this.session.on('play', () => {
        playerManager.togglePlayPause();
      });

      this.session.on('pause', () => {
        playerManager.togglePlayPause();
      });

      this.session.on('stop', () => {
        playerManager.stop();
      });

      this.session.on('playNext', () => {
        playerManager.next();
      });

      this.session.on('playPrevious', () => {
        playerManager.previous();
      });

      this.session.on('seek', (position: number) => {
        playerManager.seekTo(position);
      });

      this.session.activate();
      this.isActive = true;
    } catch (err) {
      console.error('Failed to create AVSession:', JSON.stringify(err));
    }
  }

  async updateMetadata(): Promise<void> {
    if (!this.session || !this.isActive) {
      return;
    }
    try {
      const song = playerManager.currentSong;
      if (song != null) {
        const metadata: avSession.AVMetadata = {
          assetId: song.id.toString(),
          title: song.name,
          artist: song.artist
        };

        try {
          const pixelMap = await this.loadMediaImage(song.picture);
          if (pixelMap != null) {
            metadata.mediaImage = pixelMap;
          }
        } catch (imgErr) {
          console.error('Failed to load media image:', JSON.stringify(imgErr));
        }

        this.session.setAVMetadata(metadata);
      }
    } catch (err) {
      console.error('Failed to update AVSession metadata:', JSON.stringify(err));
    }
  }

  async setPlaybackState(isPlaying: boolean): Promise<void> {
    if (!this.session || !this.isActive) {
      return;
    }
    try {
      this.session.setAVPlaybackState({
        state: isPlaying ?
          avSession.PlaybackState.PLAYBACK_STATE_PLAY :
          avSession.PlaybackState.PLAYBACK_STATE_PAUSE
      });
    } catch (err) {
      console.error('Failed to set playback state:', JSON.stringify(err));
    }
  }

  async destroy(): Promise<void> {
    if (this.session) {
      try {
        this.session.deactivate();
        this.session.destroy();
      } catch (err) {
        console.error('Failed to destroy AVSession:', JSON.stringify(err));
      }
    }
    this.session = null;
    this.isActive = false;
  }

  private async loadMediaImage(picture: Resource): Promise<image.PixelMap | null> {
    try {
      const ctx = getContext() as common.UIAbilityContext;
      const resource = await ctx.resourceManager.getMediaContent(picture);
      const imageSource = image.createImageSource(resource.buffer);
      const pixelMap = await imageSource.createPixelMap();
      imageSource.release();
      return pixelMap;
    } catch (err) {
      console.error('Failed to load media image:', JSON.stringify(err));
      return null;
    }
  }
}

export const avSessionController = AVSessionController.getInstance();
