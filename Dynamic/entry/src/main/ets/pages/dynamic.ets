//动态参数语法
//1.注解@ComponentV2
//2.用@Local定义变量
//3.在数据变化时用this.变量引用方法
@Entry
@ComponentV2
struct Index {
  @Local num:number = 1;

  build() {
    Column(){
      Row(){
        Text('-')
          .border({width:1})
          .font({ size: 30, weight: 800 })
          .width(30)
          .textAlign(TextAlign.Center)
          .margin({ left: 10, right: 10 })
          .onClick(() => {
            if(this.num > 1){
              this.num--
            }
          })
        Text(this.num.toString())
          .font({ size: 30, weight: 800 })
        Text('+')
          .border({width:1})
          .font({ size: 30, weight: 800 })
          .width(30)
          .textAlign(TextAlign.Center)
          .margin({ left: 10, right: 10 })
          .onClick(() => {
            this.num++
          })
      }
    }
    .width("100%")
  }
}

