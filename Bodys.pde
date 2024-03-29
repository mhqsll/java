class Body{
  public int id;
  public float mass; //质量参数
  public float r;// 半径
  public PVector pos;//位置
  public PVector vel;//速度
  public color col;
  
  ArrayList<PVector> path = new ArrayList<PVector>();
  int MAXPATH=300;
  //构造函数
  public Body(float mass, float x, float y, float vx, float vy,int id ) {
    super();
    this.id = id;
    this.mass = mass;
    this.r = calR(mass);
    this.pos = new PVector(x,y);
    //这里我试图创建一个顺时针宇宙,但是没什么卵用
    if(x>=(width/2) && y>=(height/2)) this.vel = new PVector(vx,-vy);
    if(x<(width/2) && y>=(height/2)) this.vel = new PVector(vx,vy);
    if(x>=(width/2) && y<(height/2)) this.vel = new PVector(-vx,-vy);
    if(x<(width/2) && y<(height/2)) this.vel = new PVector(-vx,vy);
    
    //this.vel = new PVector(vx,vy);
    this.col = color(random(0,255),random(0,255),random(0,255));
  }


  //计算半径,顺便把max质量恒星赋值
  float calR(float mass) {
    // TODO Auto-generated method stub
    //return sqrt(mass/PI);
    if( max==null){
        max=this;
    }
    if(max.mass<=this.mass){
        max=this;
    }
    //球形半径
    return pow(mass/PI * (3f/4f),1f/3f);

  }
  
  //显示球形
  void show(){
    noStroke();
    fill(col);
    ellipse(pos.x, pos.y, r , r);
    //显示星体编号
    fill(255);
    text(id,pos.x, pos.y);
  }
  
  void update(){
    pos.add(vel);
    path.add(new PVector(pos.x, pos.y));
    //星星数量减少时,延长轨迹视图
    if(path.size() > MAXPATH && stars.size()>10){
      path.remove(0);
    }
    
    if(path.size() > MAXPATH*3 ){
      path.remove(0);
    }
    
    //下面反弹效果这部分up主给注释了.留着或者能挽救下跑出屏幕的可怜星星
    if(pos.x <=(-width*2) || pos.x>=(width*2)){
      vel.x *=-1;
    }
    if(pos.y <=(-height*2) || pos.y>=(height*2)){
      vel.y *=-1;
    }
  }
  
  void showPath(){
    stroke(col);
    for(int i = 0 , p= path.size() ; i<p;i++){
      PVector a = path.get(i);
      PVector b;
      if(i+1 == p){
        b = pos;        
      }else{
        b=path.get(i+1);
        line(a.x , a.y , b.x , b.y);
      }
    }
  
  }
  
  //引力部分,纯照抄,公式什么我连看都不想看了,呵呵= =!
  void attract(){
    for(int i = 0,n = stars.size() ; i < stars.size(); i++){
      Body other = stars.get(i);
      if(other == this)
        continue;
      PVector dir = new PVector(this.pos.x - other.pos.x,this.pos.y - other.pos.y);
      if(dir.mag()<=this.r+other.r){
        if(this.mass > other.mass){
          this.vel=PVector.div(PVector.add(PVector.mult(this.vel,this.mass),
                                           PVector.mult(other.vel,other.mass)),
                               this.mass+other.mass);
          this.mass = this.mass + other.mass;
          this.r= calR(this.mass);
          stars.remove(i);//注意这里的remove,优化的时候其他部分for循环中stars.size()先赋值会出错.
        }
         continue;
      }
      
      float forcePower = G *(this.mass * other.mass)/dir.magSq();
      PVector force = dir.normalize().mult(forcePower);
      other.vel.add((force.div(other.mass)).mult(1f / frameRate));
    }
  }
}
