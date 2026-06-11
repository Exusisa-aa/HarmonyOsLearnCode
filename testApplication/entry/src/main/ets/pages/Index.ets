import Good from "../common/interfaces/good"

//基本变量
let name:string = "张三"
let age:number = 18
let isMale:boolean = true
age=19
console.log(name + "今年" + age + "岁性别为男" + isMale);

//数组
let names:string[] = ["张三","李四","王五"]
let names0:Array<string> = ["赵六","孙七","重八"]
console.log(names.join(" ") + ' ' + names0.join(" "));

//对象
let phone:Good = {
  name:"手机",
  price:3500,
  description:"太好用啦",
  number:10,
  totalPrice: 0
}

//函数
function calculateTotalPrice(Phone:Good){
  return Phone.price * Phone.number
}
phone.totalPrice = calculateTotalPrice(phone)
console.log(phone.name + "总价为" + phone.totalPrice + "," + phone.description);

//箭头函数
let totalPrice = (good:Good) => {
  return good.price * good.number
}
phone.totalPrice = totalPrice(phone)
console.log(phone.name + "总价为" + phone.totalPrice + "," + phone.description);



@Entry
@ComponentV2
struct Index {
  //build下面的根组件只能有一个,所以最好是容器组件
  //容器组件 (){}
  //普通组件 ()
  //先在build下写一个容器组件，而后在容器组件里开其他的容器组件
  build() {
    Column() {
      Row() {
        Text('文本一')
        Text('文本二')
          .fontSize(40)
          .fontColor(Color.Red)
          .fontWeight(800)
        Text('文本三')
      }
      Column() {
        Text('文本四')
        Text('文本五')
        Text('文本六')
      }
      Row(){
        Image($r('app.media.zhou')) //图片语法Image($r('app.media.图片名')) $r表示本地查找
          .width("100%")
          .margin({ top: 40 })
          .border({ width:5,color:Color.Orange,style:BorderStyle.Solid,radius:100 })
      }
    }.width('100%')
     .background(Color.Gray)
  }
}