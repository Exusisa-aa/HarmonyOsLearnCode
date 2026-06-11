@Entry
@Component
struct SurveyForm {
  @State firstDose: boolean = false
  @State secondDose: boolean = false
  @State thirdDose: boolean = false
  @State gender: string = ''
  @State reaction: string = ''
  @State showSubmitDialog: boolean = false

  build() {
    Scroll() {
      Column({ space: 10 }) {
        // 标题
        Text('调查问卷')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 20, bottom: 30 })

        // 第一个小标题
        Text('打过几针疫苗')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .alignSelf(ItemAlign.Start)
          .margin({ left: 20 })

        // Checkbox选项
        Row({ space: 20 }) {
          Checkbox()
            .onChange((value: boolean) => {
              this.firstDose = value
            })
            .select(this.firstDose)
          Text('第一针')
            .fontSize(16)

          Checkbox()
            .onChange((value: boolean) => {
              this.secondDose = value
            })
            .select(this.secondDose)
          Text('第二针')
            .fontSize(16)

          Checkbox()
            .onChange((value: boolean) => {
              this.thirdDose = value
            })
            .select(this.thirdDose)
          Text('第三针')
            .fontSize(16)
        }
        .margin({ top: 10 })

        // 第二个小标题
        Text('性别')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .alignSelf(ItemAlign.Start)
          .margin({ top: 30, left: 20 })

        // Radio选项
        Row({ space: 20 }) {
          Radio({ value: 'male', group: 'gender' })
            .onChange((value: boolean) => {
              if (value) {
                this.gender = 'male'
              }
            })
            .checked(this.gender === 'male')
          Text('男')
            .fontSize(16)

          Radio({ value: 'female', group: 'gender' })
            .onChange((value: boolean) => {
              if (value) {
                this.gender = 'female'
              }
            })
            .checked(this.gender === 'female')
          Text('女')
            .fontSize(16)
        }
        .margin({ top: 10 })

        // 第三个小标题
        Text('是否有过不良反应')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .alignSelf(ItemAlign.Start)
          .margin({ top: 30, left: 20 })

        // 输入框
        TextInput({ placeholder: '请输入不良反应情况', text: this.reaction })
          .width('90%')
          .height(40)
          .borderRadius(8)
          .margin({ top: 10 })
          .onChange((value: string) => {
            this.reaction = value
          })

        // 按钮区域
        Row() {
          Button('重填')
            .width(120)
            .height(40)
            .margin({ top: 30, right: 10 })
            .onClick(() => {
              this.resetForm()
            })

          Button('提交')
            .width(120)
            .height(40)
            .margin({ top: 30, left: 10 })
            .backgroundColor(Color.Red)
            .onClick(() => {
              this.showSubmitDialog = true
            })
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('90%')

        // 提交成功弹窗
        if (this.showSubmitDialog) {
          this.buildSubmitDialog()
        }
      }
      .width('100%')
      .padding({ bottom: 20 })
    }
    .backgroundColor('#f5f5f5')
  }

  resetForm() {
    this.firstDose = false
    this.secondDose = false
    this.thirdDose = false
    this.gender = ''
    this.reaction = ''
  }

  @Builder
  buildSubmitDialog() {
    Stack() {
      // 遮罩层
      Rect()
        .fill(Color.Black)
        .opacity(0.5)
        .onClick(() => {
          this.showSubmitDialog = false
        })

      // 弹窗主体
      Column() {
        Text('已提交')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 30, bottom: 30 })

        Button('确定')
          .width(120)
          .height(40)
          .margin({ bottom: 30 })
          .backgroundColor(Color.Red)
          .onClick(() => {
            this.showSubmitDialog = false
            this.resetForm()
          })
      }
      .width('80%')
      .height(180)
      .backgroundColor(Color.White)
      .borderRadius(20)
    }
    .position({ x: 0, y: 0 })
    .width('100%')
    .height('100%')
  }
}


