@Entry
@Component
struct Index {
  @Builder
  topNav(title:string){
    Text(title)
      .font({weight: FontWeight.Bold,size: 20})
  }

  build() {
    Column(){
      this.topNav("Index1")
      this.topNav("Index2")
    }
  }
}