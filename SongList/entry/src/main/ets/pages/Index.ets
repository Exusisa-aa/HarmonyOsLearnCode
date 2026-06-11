import Song from "../common/interface/song";
import { playerManager } from "../common/manager/AudioPlayerManager";
import { MiniPlayer } from "../common/components/MiniPlayer";
import { router } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';

let songList: Song[] = [{
  id: 0,
  name:'BATTLEPLAN ARCLIGHT',
  artist:'塞壬唱片',
  picture:$r('app.media.b'),
  duration: 185000,
  audio:$rawfile('BATTLEPLAN ARCLIGHT.MP3'),
  sourcePath:'BATTLEPLAN ARCLIGHT.MP3'
},{
  id: 1,
  name:'Battleplan Extinguished Sins',
  artist:'塞壬唱片',
  picture:$r('app.media.a'),
  duration: 210000,
  audio:$rawfile('Battleplan Extinguished Sins.MP3'),
  sourcePath:'Battleplan Extinguished Sins.MP3'
}]

@Entry
@ComponentV2
struct Index {
  aboutToAppear(): void {
    playerManager.init(
      getContext().resourceManager,
      songList,
      getContext() as common.UIAbilityContext
    );
  }

  build() {
    Column(){
      Text('我的歌单')
        .fontSize(20)
        .fontColor('#fff')
        .width('100%')
        .margin({ bottom:10 })

      List(){
        ForEach(songList, (item:Song,index:number) => {
          ListItem(){
            Row(){
              Image(item.picture)
                .width(80)
                .height(80)
                .border({radius:8})
                .margin({right:10})
              Column(){
                Text(item.name)
                  .fontColor(playerManager.currentSong != null &&
                    playerManager.currentSong.id === item.id ? '#4CAF50' : '#fff')
                  .width('100%')
                  .fontWeight(800)
                  .margin({bottom:15})
                Row(){
                  Text('VIP')
                    .fontColor('#9A8E28')
                    .border({ color:'#9A8E28',width:1,radius:15 })
                    .padding({left:5,right:5,top:3,bottom:3})
                  Text(item.artist)
                    .fontColor('#696969')
                    .padding({left:10})
                }
                .padding({right:135})
              }
              .layoutWeight(1)
              Column(){
                Text('.')
                  .fontColor('#fff')
                  .padding({right:10})
                  .fontWeight(900)
                Text('.')
                  .fontColor('#fff')
                  .padding({right:10})
                  .fontWeight(900)
                Text('.')
                  .fontColor('#fff')
                  .padding({right:10})
                  .fontWeight(900)
              }
            }
            .width('100%')
            .height(80)
            .margin({bottom:10})
          }
          .onClick(() => {
            const currentSong = playerManager.currentSong;
            if (currentSong != null && currentSong.id === item.id) {
              router.pushUrl({ url: 'pages/NowPlaying' });
              return;
            }
            playerManager.playByIndex(index);
            router.pushUrl({ url: 'pages/NowPlaying' });
          })
        })
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)

      MiniPlayer()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#131313')
    .padding({left:10 , right:10})
    .expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.TOP,SafeAreaEdge.BOTTOM])
  }
}
