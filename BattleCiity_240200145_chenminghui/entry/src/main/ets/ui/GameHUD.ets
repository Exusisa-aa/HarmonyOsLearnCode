import { ActiveEffect } from '../game/systems/PowerUpManager';
import { PowerUpType } from '../common/Constants';

@Component
export struct GameHUD {
  @Prop score: number = 0;
  @Prop lives: number = 3;
  @Prop level: number = 1;
  @Prop activeEffects: ActiveEffect[] = [];

  build() {
    Row() {
      // Left side - Score and Lives
      Column() {
        // Score
        Row() {
          Text($r('app.string.score_label'))
            .fontSize($r('app.float.hud_font_size'))
            .fontColor('#888888')
            .margin({ right: 8 })
          Text(this.score.toString())
            .fontSize($r('app.float.hud_large_font_size'))
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Bold)
        }
        .margin({ bottom: 4 })

        // Lives
        Row() {
          Text($r('app.string.lives_label'))
            .fontSize($r('app.float.hud_font_size'))
            .fontColor('#888888')
            .margin({ right: 8 })
          ForEach(Array.from({ length: this.lives }), (_: number, index: number) => {
            Text('♥')
              .fontSize($r('app.float.hud_large_font_size'))
              .fontColor('#FF4444')
              .margin({ right: 4 })
          })
        }
      }
      .alignItems(HorizontalAlign.Start)

      Blank()

      // Center - Level number
      Column() {
        Text($r('app.string.level_label'))
          .fontSize($r('app.float.hud_font_size'))
          .fontColor('#888888')
        Text(this.level.toString())
          .fontSize($r('app.float.hud_large_font_size'))
          .fontColor('#FFD700')
          .fontWeight(FontWeight.Bold)
      }

      Blank()

      // Right side - Active power-up effects
      Column() {
        if (this.activeEffects.length > 0) {
          ForEach(this.activeEffects, (effect: ActiveEffect) => {
            Row() {
              Text(this.getEffectIcon(effect.type))
                .fontSize($r('app.float.hud_font_size'))
                .fontColor(this.getEffectColor(effect.type))
                .margin({ right: 4 })
              // Timer bar
              Progress({
                value: effect.remainingMs,
                total: 15000,
                type: ProgressType.Linear,
              })
                .width(60)
                .height(6)
                .color(this.getEffectColor(effect.type))
            }
            .margin({ bottom: 2 })
          })
        }
      }
      .alignItems(HorizontalAlign.End)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 8 })
    .alignItems(VerticalAlign.Top)
  }

  private getEffectIcon(type: PowerUpType): string {
    switch (type) {
      case PowerUpType.SPEED: return '⚡';
      case PowerUpType.SHIELD: return '🛡';
      case PowerUpType.FIREPOWER: return '💥';
      case PowerUpType.BASE_REINFORCE: return '🏰';
    }
  }

  private getEffectColor(type: PowerUpType): string {
    switch (type) {
      case PowerUpType.SPEED: return '#00FFAA';
      case PowerUpType.SHIELD: return '#4488FF';
      case PowerUpType.FIREPOWER: return '#FF4444';
      case PowerUpType.BASE_REINFORCE: return '#FFD700';
    }
  }
}
