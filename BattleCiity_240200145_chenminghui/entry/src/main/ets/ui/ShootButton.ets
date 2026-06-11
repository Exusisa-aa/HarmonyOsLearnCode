@Component
export struct ShootButton {
  @Link shootPressed: boolean;
  @Prop cooldownRatio: number = 0;

  private buttonRadius: number = 45;

  build() {
    Stack() {
      Circle({ width: this.buttonRadius * 2, height: this.buttonRadius * 2 })
        .fill(this.shootPressed ? '#FF444488' : '#FF444444')
        .stroke('#FFFFFF88')
        .strokeWidth(3)
        .opacity(this.cooldownRatio > 0.95 ? 0.3 : 1.0)

      Text('FIRE')
        .fontSize(14)
        .fontColor('#FFFFFF')
        .fontWeight(FontWeight.Bold)
    }
    .width(this.buttonRadius * 2)
    .height(this.buttonRadius * 2)
    .onTouch((event: TouchEvent) => {
      switch (event.type) {
        case TouchType.Down:
          this.shootPressed = true;
          break;
        case TouchType.Up:
        case TouchType.Cancel:
          this.shootPressed = false;
          break;
      }
    })
  }
}
