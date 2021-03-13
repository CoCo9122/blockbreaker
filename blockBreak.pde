color bg = color(255, 255, 255, 255);
int Rate = 100;
final int IDLE = 0;
final int started = 1;
final int OVER = 2;
final int CLEAR = 3;
int status = IDLE;
int count = 0;
int countreset = 0;
int countstart = 0;
int point;
int v = 5;
int t = 0;
int p = 0;
float side = 150;
boolean clicked = false;
String[] countdown= new String[]{"3","2","1","START"};

Ball ball1; 
Bar bar;
PointUp plus;
TextBox pointtext = new TextBox(750, 100, 30, "0", color(0));
TextBox resettext = new TextBox(400, 800, 30, "Click to restart", color(0));
TextBox[] countdowntext = new TextBox[4];
Block[] sideblock = new Block[2];
Block[][] blocks= new Block[5][8];

void setup(){
  size(800, 1000);
  background(bg);
  frameRate(Rate);
  ball1 = new Ball(400, 900, -v, -5, 20, color(0));
  bar = new Bar(400, 900+20,100,20,color(0,0,200));
  plus = new PointUp(0,0);
  sideblock[0] = new Block(0, 0, side, height, color(124,252,0,120));
  sideblock[1] = new Block(width - side, 0, side, height, color(124,252,0,120));
  for(int i = 0; i < 5 ; i++){
    for(int j = 0; j < 8; j++){
      blocks[i][j] = new Block(150+15+97*i, 50+35*j, 82, 20, color(255-j*20,100+j*20, 0));
    }
  }
  point = 0;
}

void draw(){
  clear();
  sideblock[0].display();
  sideblock[1].display();
  switch(status){
    
    case IDLE:
    countreset = 0;
    countstart = 0;
    t = 0;
    ground("Click to START", started);
    
    break;
    
    case started:
    
    for(int i = 0; i < 5 ; i++){
      for(int j = 0; j < 8; j++){
        if(ball1._y > blocks[i][j]._y
        && ball1._y < blocks[i][j]._y+blocks[i][j]._b
        && ball1._x + ball1._r/2 > blocks[i][j]._x
        && ball1._x - ball1._r/2 < blocks[i][j]._x+bar._a){
          ball1._vx = -ball1._vx;
          plus._x = blocks[i][j]._x+blocks[i][j]._a;
          plus._y = blocks[i][j]._y-blocks[i][j]._b;
          blocks[i][j].delete();
          p = 0;
        }
        if(ball1._x > blocks[i][j]._x
        && ball1._x < blocks[i][j]._x+blocks[i][j]._a
        && ball1._y + ball1._r/2 > blocks[i][j]._y
        && ball1._y - ball1._r/2 < blocks[i][j]._y+bar._b){
          ball1._vy = -ball1._vy;
          plus._x = blocks[i][j]._x+blocks[i][j]._a;
          plus._y = blocks[i][j]._y-blocks[i][j]._b;
          blocks[i][j].delete();
          p = 0;
        }
        blocks[i][j].display();
      }
    }
    
    if(p < Rate){
      plus.display();
    }
    
    if(countstart < Rate && t < 4){
      countdowntext[t] = new TextBox(400, 500, 30+countstart/3, countdown[t], color(0));
      countdowntext[t].displayC();
    }
    if(countstart == Rate){
      countstart = 0;
      t++;
    }
    
    pointtext._s = str(point);
    pointtext.displayR();
    
    bar.display();
    if(t > 3){
      bar.move();
    }
    
    ball1.display();
    if(t > 3){
      ball1.update();
      ball1.bound();
    }
    
    
    if(ball1._x > bar._xo-bar._a/2
    && ball1._x < bar._xo+bar._a/2
    && ball1._y + ball1._r/2 > bar._yo-bar._b/2){
      ball1._vy = -ball1._vy;
    }
    
    if(ball1._y > bar._yo-bar._b/2
    && ball1._y < bar._yo+bar._b/2
    && ball1._x + ball1._r/2 > bar._xo-bar._a/2
    && ball1._x - ball1._r/2 < bar._xo+bar._a/2){
      ball1._vx = -ball1._vx;
    }
    
    
    if(ball1._y > bar._yo-bar._b/2 && point < 40){
      status = OVER;
      ball1.delete();
      break;
    }
    if(point == 40){
      status = CLEAR;
      break;
    }
    countstart++;
    p++;
    break;
    
    case CLEAR:
    ground("ALL CLEAR", CLEAR);
    break;
    
    case OVER:
    ground("GAME OVER", OVER);
    if(countreset > 180){
      resettext.displayC();
      if(clicked){
        status = IDLE;
        setup();
      }
    }
    countreset++;
    break;
  }
  count++;
}

void clear(){
  fill(bg);
  noStroke();
  rect(0, 0, width*2, height*2);
}

void ground(String s, int n){
  textAlign(CENTER, CENTER);
  textSize(50);
  fill(155,255,0);
  text(s, 0, 0, width, height); 
  if (clicked && count > 30) {
    status=n;
    count = 0;
  }
}

public class Block{
  
  private float _x, _y, _a, _b;
  private color _c0;
  
  public Block(float x, float y, float a, float b, color c0){
    _x = x;
    _y = y;
    _a = a;
    _b = b;
    _c0 = c0;
  }
  
  public void display(){
    noStroke();
    fill(_c0);
    rectMode(CORNER);
    rect(_x, _y, _a, _b);
  }
  
  public void delete(){
    _x = 0;
    _y = 0;
    _a = 0;
    _b = 0;
    point++;
  }
}

public class PointUp{
  float _x,_y;
  
  PointUp(float x, float y){
    _x = x;
    _y = y;
  }
  
  public void display(){
    textAlign(CENTER, CENTER);
    textSize(30);
    fill(0);
    text("+1", _x, _y);
  }
}

public class TextBox{
  float _x, _y, _size;
  String _s;
  color _c;
  
  public TextBox(float x, float y,  float size, String s, color c){
    _x = x;
    _y = y;
    _size = size;
    _s = s;
    _c = c;
  }
  
  public void displayR(){
    textAlign(RIGHT);
    textSize(_size);
    fill(_c);
    text(_s, _x, _y);
  }
  
  public void displayC(){
    textAlign(CENTER, CENTER);
    textSize(_size);
    fill(_c);
    text(_s, _x, _y);
  }
  
}

public class Bar{
  
  private float _xo, _yo, _a, _b;
  private color _c0;
  
  public Bar(float xo, float yo, float a, float b, color c0){
    _xo = xo;
    _yo = yo;
    _a = a;
    _b = b;
    _c0 = c0;
  }
  
  public void display(){
    noStroke();
    fill(_c0);
    rectMode(CENTER);
    rect(_xo, _yo, _a, _b);
  }
  
  public void move(){
     if(mouseX < side + _a/2){
       _xo = side + _a/2;
     }else if(mouseX > width - side - _a/2){
       _xo = width - side - _a/2;
     }else{
       _xo = mouseX;
     }
  }
  
  public void autoMode(float x){
    if(x < side + _a/2){
       _xo = side + _a/2;
     }else if(x > width - side - _a/2){
       _xo = width - side - _a/2;
     }else{
       _xo = x;
     }
  }
}

void mousePressed() {
  clicked=true; 
}

void mouseReleased() {
  clicked=false; 
}

public class Ball{
  
  public float _x, _y, _r, _vx, _vy;
  private color _c0;
  
  public Ball(float x, float y, float vx, float vy, float r, color c0){
    _x = x;
    _y = y;
    _vx = vx;
    _vy = vy;
    _r = r;
    _c0 = c0;
  }
  
  public void display(){
    noStroke();
    fill(_c0);
    ellipse(_x, _y, _r, _r);
  }
  
  public void update(){
    _x += _vx;
    _y += _vy;
  }
  
  public void bound(){
    if(_x + _r/2 > width -150|| _x - _r/2 < 150){
      _vx = -_vx;
    }
    if(_y - _r/2 < 0){
      _vy = -_vy;
    }
  }
  
  public void delete(){
    _x = 0;
    _y = 0;
    _vx = 0;
    _vy = 0;
    _r = 0;
  }
}
