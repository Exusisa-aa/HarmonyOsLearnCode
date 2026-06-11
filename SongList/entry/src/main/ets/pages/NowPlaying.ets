import { playerManager, PlayMode } from '../common/manager/AudioPlayerManager';
import { router } from '@kit.ArkUI';

@Entry
@ComponentV2
struct NowPlaying {
  build() {
    Column() {
      Row() {
        Text('‹')
          .fontSize(32)
          .fontColor('#fff')
          .width(40)
          .height(40)
          .onClick(() => {
            router.back();
          })
        Blank()
        Text('正在播放')
          .fontSize(18)
          .fontColor('#fff')
          .fontWeight(600)
        Blank()
        Text('')
          .width(40)
          .height(40)
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })

      Image(playerManager.currentSong != null ?
        playerManager.currentSong.picture : $r('app.media.zhou'))
        .width(280)
        .height(280)
        .border({ radius: 16 })
        .margin({ top: 40, bottom: 32 })

      Row() {
        Column() {
          Text(playerManager.currentSong != null ?
            playerManager.currentSong.name : '未选择歌曲')
            .fontSize(22)
            .fontColor('#fff')
            .fontWeight(700)
            .maxLines(1)
          Text(playerManager.currentSong != null ?
            playerManager.currentSong.artist : '')
            .fontSize(15)
            .fontColor('#969696')
            .margin({ top: 8 })
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        Text('♡')
          .fontSize(24)
          .fontColor('#969696')
      }
      .width('100%')
      .padding({ left: 32, right: 32 })

      Column() {
        Slider({
          value: playerManager.currentTime,
          min: 0,
          max: playerManager.totalDuration > 0 ? playerManager.totalDuration : 1
        })
          .blockColor('#fff')
          .trackColor('#404040')
          .selectedColor('#fff')
          .trackThickness(2)
          .onChange((value: number) => {
            playerManager.seekTo(value);
          })
          .margin({ top: 24 })

        Row() {
          Text(this.formatTime(playerManager.currentTime))
            .fontSize(12)
            .fontColor('#969696')
          Blank()
          Text(this.formatTime(playerManager.totalDuration))
            .fontSize(12)
            .fontColor('#969696')
        }
        .width('100%')
        .margin({ top: 4 })
      }
      .width('100%')
      .padding({ left: 32, right: 32 })

      Row() {
        Text(this.getModeIcon(playerManager.playMode))
          .fontSize(20)
          .fontColor('#fff')
          .width(40)
          .height(40)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            playerManager.cyclePlayMode();
          })

        Blank()

        Text('⏮')
          .fontSize(30)
          .fontColor('#fff')
          .width(48)
          .height(48)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            playerManager.previous();
          })

        Blank()

        Text(playerManager.isPlaying ? '⏸' : '▶')
          .fontSize(42)
          .fontColor('#fff')
          .width(64)
          .height(64)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            playerManager.togglePlayPause();
          })

        Blank()

        Text('⏭')
          .fontSize(30)
          .fontColor('#fff')
          .width(48)
          .height(48)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            playerManager.next();
          })

        Blank()

        Text('')
          .width(40)
          .height(40)
      }
      .width('100%')
      .padding({ left: 32, right: 32 })
      .margin({ top: 24 })

      Blank()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#131313')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }

  private formatTime(ms: number): string {
    if (ms <= 0) {
      return '00:00';
    }
    const totalSeconds = Math.floor(ms / 1000);
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;
    return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
  }

  private getModeIcon(mode: PlayMode): string {
    switch (mode) {
      case PlayMode.SHUFFLE:
        return '🔀';
      case PlayMode.REPEAT_ONE:
        return '🔂';
      case PlayMode.REPEAT_ALL:
        return '🔁';
      default:
        return '↻';
    }
  }
}
