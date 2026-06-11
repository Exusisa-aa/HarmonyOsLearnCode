import { playerManager } from '../manager/AudioPlayerManager';
import { router } from '@kit.ArkUI';

@ComponentV2
export struct MiniPlayer {
  build() {
    if (playerManager.currentSong != null) {
      Column() {
        Row() {
          Image(playerManager.currentSong.picture)
            .width(48)
            .height(48)
            .border({ radius: 6 })
            .margin({ right: 12 })
            .onClick(() => {
              router.pushUrl({ url: 'pages/NowPlaying' });
            })

          Column() {
            Text(playerManager.currentSong.name)
              .fontColor('#fff')
              .fontSize(15)
              .fontWeight(600)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .width('100%')
            Text(playerManager.currentSong.artist)
              .fontColor('#969696')
              .fontSize(12)
              .maxLines(1)
              .width('100%')
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Start)
          .onClick(() => {
            router.pushUrl({ url: 'pages/NowPlaying' });
          })

          Text(playerManager.isPlaying ? '⏸' : '▶')
            .fontSize(22)
            .fontColor('#fff')
            .width(40)
            .height(40)
            .textAlign(TextAlign.Center)
            .onClick(() => {
              playerManager.togglePlayPause();
            })

          Text('⏭')
            .fontSize(20)
            .fontColor('#fff')
            .width(36)
            .height(36)
            .textAlign(TextAlign.Center)
            .margin({ left: 8 })
            .onClick(() => {
              playerManager.next();
            })
        }
        .width('100%')
        .height(64)
        .padding({ left: 16, right: 16 })
      }
      .width('100%')
      .height(64)
      .backgroundColor('#252525')
      .border({
        width: { top: 0.5 },
        color: '#3A3A3A'
      })
    }
  }
}
