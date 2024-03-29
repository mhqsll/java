PFont font;//字体
Body star;
boolean running = false;//暂停键是r
float G = 0.5f;//引力常数

ArrayList<Body> stars = new ArrayList<Body>();
int startBodyCount = 500; //星体数量
PVector startBodyMass = new PVector(500,1000); //星体质量范围
float startBodySpeed = 8; //星体速度
Body max;//最重的
void settings()
{
  size(1200,900);
}

void setup()
{
    frameRate(144);
    background(153);
    font =loadFont("Arial-BoldMT-12.vlw");
    textFont(font,12);
    for(int i=0 ; i < startBodyCount-1 ; i++)
    {
        stars.add(new Body( random(startBodyMass.x,startBodyMass.y),
            random(100,1500),
            random(100,800),
            random(0,startBodySpeed),
            random(0,startBodySpeed),
            i));
            
           max = stars.get(0);
            for(int j=0; j < stars.size() ; j++)
            {    
                if(stars.get(i).mass > max.mass)
                {
                    max = stars.get(i);
                }
            }      
    }  
    stars.add(new Body(5000,width/2,height/2,0,0,startBodyCount-1));
}

void draw()
{
    background(0);
    strokeWeight(1);
    translate(-max.pos.x+(width/2),-max.pos.y+(height/2));
    
    for(int i=0; i < stars.size() ; i++)
    {
        stars.get(i).showPath();
    }
    

    strokeWeight(1);
    for(int i=0 ; i < stars.size() ; i++)
    {
        stars.get(i).show();
        stars.get(i).update();
        stars.get(i).attract();
    }
    translate(max.pos.x-(width/2),max.pos.y-(height/2));
  //show fps
    fill(0,255,0);
    text("fps: "+(int)frameRate , 10 ,20);
  
  //show bodycount
    text("BodyCount: "+ stars.size() , 10 ,35);
    text("========== "+ stars.size() , 10 ,50);
    text("maxId="+max.id+"  max= "+ max.mass, 10 ,65);
  
  
  //show bodyinfo
    for(int i = 0 ; i < stars.size(); i++)
    {
        Body s  = stars.get(i);
        fill(s.col);
        text("Star #" + s.id + "mass="+ s.mass,10 , (i+1)*15+80);
    }

}

void keyPressed()
{
    if(key==' ')
    {
        if(running)
        {
            running = false;
            noLoop();
        }else{
            running = true;
            loop();
        }
    }
}
  

  
