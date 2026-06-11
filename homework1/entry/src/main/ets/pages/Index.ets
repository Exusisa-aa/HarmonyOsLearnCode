@Entry
@Component
struct Index {
  @State todoList: string[] = []
  @State showModal: boolean = false
  @State showDeleteModal: boolean = false
  @State currentInput: string = ''
  @State selectedIndex: number = -1

  aboutToAppear(): void {
    // 可以在这里初始化数据
  }

  build() {
    Column({ space: 20 }) {
      // 显示今天的日期
      Row() {
        Text(this.getCurrentDate())
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .padding({ left: 20, top: 20, bottom: 20 })
        Blank()
      }
      .width('100%')

      // 添加事项按钮
      Button('添加事项')
        .width(260)
        .height(40)
        .onClick(() => {
          this.showModal = true
        })

      // 事项列表
      List({ space: 10 }) {
        ForEach(this.todoList, (item: string, index: number) => {
          ListItem() {
            Column() {
              Row() {
                Text(this.getCurrentDate() + ' 待办事项')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                Blank()
              }
              .margin({top:20})
              Row() {
                Text(item)
                  .fontSize(14)
                  .fontColor('#666666')
                Blank()
              }.margin({top:20})
            }
            .height(80)
            .backgroundColor(Color.White)
            .borderRadius(8)
            .margin({left:20})
            .onClick(() => {
              this.selectedIndex = index
              this.showDeleteModal = true
            })
          }
        })
      }
      .layoutWeight(1)
      .width('100%')

      // 添加事项弹窗
      if (this.showModal) {
        this.AddModal()
      }

      // 删除确认弹窗
      if (this.showDeleteModal) {
        this.DeleteModal()
      }
    }
    .width('100%')
    .height('100%')
    .padding({ top: 20 })
  }

  getCurrentDate(): string {
    const date = new Date()
    const year = date.getFullYear()
    const month = date.getMonth() + 1
    const day = date.getDate()
    return `${year}年${month}月${day}日`
  }

  @Builder
  AddModal() {
    Stack() {
      // 遮罩层
      Rect()
        .fill(Color.Black)
        .opacity(0.5)
        .onClick(() => {
          this.currentInput = ''
          this.showModal = false
        })

      // 弹窗主体
      Column() {
        // 标题
        Text('添加事项')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 20, bottom: 10 })

        // 输入框
        TextInput({ placeholder: '请输入事项内容' })
          .width('90%')
          .height(40)
          .borderRadius(8)
          .margin({ top: 20, bottom: 20 })
          .onChange((value: string) => {
            this.currentInput = value
          })

        // 按钮区域
        Row() {
          Button('取消')
            .onClick(() => {
              this.currentInput = ''
              this.showModal = false
            })
            .layoutWeight(1)
            .margin({ left: 20, right: 10 })

          Button('确定')
            .onClick(() => {
              if (this.currentInput.trim() !== '') {
                this.todoList.push(this.currentInput)
                this.currentInput = ''
              }
              this.showModal = false
            })
            .layoutWeight(1)
            .margin({ left: 10, right: 20 })
            .backgroundColor(Color.Red)
        }
        .width('100%')
        .margin({ top: 10, bottom: 20 })
      }
      .width('80%')
      .height(200)
      .backgroundColor(Color.White)
      .borderRadius(20)
      .border({ width: 1, color: Color.Gray })
    }
    .position({ x: 0, y: 0 })
    .width('100%')
    .height('100%')
  }

  @Builder
  DeleteModal() {
    Stack() {
      // 遮罩层
      Rect()
        .fill(Color.Black)
        .opacity(0.5)
        .onClick(() => {
          this.selectedIndex = -1
          this.showDeleteModal = false
        })

      // 弹窗主体
      Column() {
        // 标题
        Text('删除确认')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 20, bottom: 10 })

        // 提示信息
        Text('确定要删除该项事项吗？')
          .fontSize(16)
          .margin({ top: 20, bottom: 20 })

        // 按钮区域
        Row() {
          Button('取消')
            .onClick(() => {
              this.selectedIndex = -1
              this.showDeleteModal = false
            })
            .layoutWeight(1)
            .margin({ left: 20, right: 10 })

          Button('确定')
            .onClick(() => {
              if (this.selectedIndex >= 0) {
                this.todoList.splice(this.selectedIndex, 1)
                this.selectedIndex = -1
              }
              this.showDeleteModal = false
            })
            .layoutWeight(1)
            .margin({ left: 10, right: 20 })
            .backgroundColor(Color.Red)
        }
        .width('100%')
        .margin({ top: 10, bottom: 20 })
      }
      .width('80%')
      .height(200)
      .backgroundColor(Color.White)
      .borderRadius(20)
      .border({ width: 1, color: Color.Gray })
    }
    .position({ x: 0, y: 0 })
    .width('100%')
    .height('100%')
  }
}
