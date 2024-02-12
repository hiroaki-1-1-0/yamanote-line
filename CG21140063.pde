PImage woodTexture, trainTexture, trainFrontTexture;

float angle = 0;
float count1 = 0.5;
float count2 = 3;

float[][] particle;
float[][] particlesSpeed;

float[][] particlesNew;
float[][] particlesSpeedNew;

float particelGain = 0.00999;
float forceGain = 0.999; // Speed

int funberOfPArticles = 100;
float CameraX = 800;
float CameraY = 1500;
float CameraZ = 300;

float CameraMovments = 0;
int CameraMovInt = 0;

float zoom = 1000 / funberOfPArticles;
float offset = 0;

float waveOrNot = -5;

float ellipseWidth = funberOfPArticles * 0.3;
float ellipseHeight = funberOfPArticles * 0.6;

float maxAmplitude = 50.0;
float minAmplitude = -50.0;

Rain[] rain;

void setup(){
  size(600, 450, P3D);
  noStroke();
  smooth();
  noFill();
  particle = new float[funberOfPArticles][funberOfPArticles];
  particlesSpeed = new float[funberOfPArticles][funberOfPArticles];
  particlesNew = new float[funberOfPArticles][funberOfPArticles];
  particlesSpeedNew = new float[funberOfPArticles][funberOfPArticles];

  for (int x = 1; x<funberOfPArticles-1; x++) {
    for (int y = 1; y<funberOfPArticles-1; y++) {
      

      particle[x][y] = 0.0;
      particlesNew[x][y] = 0.0;
      particlesSpeed[x][y] = 0.0;
      particlesSpeedNew[x][y] = 0.0;
    }
  }
  rain = new Rain[500];
  for (int i = 0; i < rain.length; i++) {
    rain[i] = new Rain();
  }
  woodTexture = loadImage("wood.jpg");
  trainTexture = loadImage("train.jpg");
  trainFrontTexture = loadImage("trainFront.jpeg");
  frameRate(80);
}

void draw(){
   background(80*0.75,180*0.75,230*0.75);
   directionalLight(200, 200, 200, -40, 50, -40);
   
   angle += 0.01;
   count1 += 0.015;
   count2 += 0.01;
 
   float cameraX = 1400 * cos(angle) + width / 2;
   float cameraZ = 1400 * sin(angle) + height / 2;
   camera(cameraX, -400, cameraZ, width / 2, height / 2 - 50, 0, 0, 1, 0);

   translate(width / 2, height / 2, -50);
   rotateX(PI/2);
   pushMatrix();
     translate(300,-100,-35);
     rotateZ(PI/2);
     updateMesh();
     drawMesh();
     translate(-300,50,35);
     translate(620,550,-35);
     rotateZ(PI);
     updateMesh();
     drawMesh();
   popMatrix();
   boolean bar1 = false;
   boolean bar2 = false;
   rotateX(-PI/2);
   scale(100, 100, 100);
   ground();
   if (angle%(2*PI) > PI/2 && angle%(2*PI) < PI) {
     bar1 = true;
   }
   if (angle%(2*PI) > 3*PI/2 && angle%(2*PI) < 2*PI - PI/32) {
     bar2 = true;
   }
   if (abs(count1%5.5-4.5) < 0.1 && angle%(2*PI) > PI/2 && angle%(2*PI) < PI) {
     count1 -= 0.015;
   }
   if (count1 < 0.1 && angle%(2*PI) > 3*PI/2 && angle%(2*PI) < 2*PI - PI/32) {
     count1 = 5.4;
   }
   car(count1);
   if (abs(count2%5.5-4.5) < 0.1 && angle%(2*PI) > PI/2 && angle%(2*PI) < PI) {
     count2 -= 0.01;
   }
   if (count2 < 0.1 && angle%(2*PI) > 3*PI/2 && angle%(2*PI) < 2*PI - PI/32) {
     count2 =5.4;
   }
   crossing(bar1);
   pushMatrix();
     rotateY(PI);
     crossing(bar2);
   popMatrix();
   pushMatrix();
     translate(0,0,1.32);
     car(count2);
   popMatrix();
   train(angle);
   pushMatrix();
     translate(-100, 0, 0);
     for (int i = 0; i < rain.length; i++) {
       rain[i].update();
       rain[i].display();
     }
   popMatrix();

}

void ground() {
  pushMatrix();
    fill(125);
    translate(0, 1, 0);
    cylinder(10, 1);
    pushMatrix();
      rotateX(PI/2);
      translate(0,0,0.5);
      ellipse(0,0,2*10,2*10);
    popMatrix();
    fill(192);
    cylinder(9, 1.05);
    cylinder(9.5, 1.05);
    railBase();
    fill(235);
    translate(0,0,1.25);
    box(19.78,1.05,0.125);
    translate(0,0,-1.25);
    fill(255,255,0);
    box(19.9,1.05,0.125);
    translate(0,0,-1.25);
    fill(235);
    box(19.78,1.05,0.125);
  popMatrix();
}

void crossing(boolean a) {
  pushMatrix();
    fill(125);
    translate(8,0,1.5);
    fill(255,255,0);
    cylinder(.1, 2);
    if (a) {
      pushMatrix();
        fill(255,0,0);
        translate(0,-.5,-0.2);
        rotateZ(PI/2);
        rotateX(PI/2);
        ellipse(0,0,0.2,0.2);        
        translate(-.3,0,0);
        ellipse(0,0,0.2,0.2);        
      popMatrix();
      translate(0,-.25,-1.5);
      rotateX(PI/2);
      fill(255,0,0);
      cylinder(.05, 4.5);
    } else {
      pushMatrix();
        fill(0,255,0);
        translate(0,-.5,-0.2);
        rotateZ(PI/2);
        rotateX(PI/2);
        ellipse(0,0,0.2,0.2);        
        translate(-.3,0,0);
        ellipse(0,0,0.2,0.2);        
      popMatrix();
      translate(0,0,.175);
      fill(255,0,0);
      cylinder(.05, 4.5);
    }
  popMatrix();
}

void railBase() {
  textureMode(NORMAL);
  pushMatrix();
  for (int i = 0; i <= 100+25; i++) {
    rotateY(radians(360/100));
    pushMatrix();
      translate(9.25, 0, 0);
      beginShape(QUADS);
        texture(woodTexture);
        // Front face
        vertex(-0.4, -0.5125, 0.125, 0, 0);
        vertex(0.4, -0.5125, 0.125, 1, 0);
        vertex(0.4, 0, 0.125, 1, 1);
        vertex(-0.4, 0, 0.125, 0, 1);
        // Back face
        vertex(0.4, -0.5125, -0.125, 0, 0);
        vertex(-0.4, -0.5125, -0.125, 1, 0);
        vertex(-0.4, 0, -0.125, 1, 1);
        vertex(0.4, 0, -0.125, 0, 1);
        // Right face
        vertex(0.4, -0.5125, -0.125, 0, 0);
        vertex(0.4, -0.5125, 0.125, 1, 0);
        vertex(0.4, 0, 0.125, 1, 1);
        vertex(0.4, 0, -0.125, 0, 1);
        // Left face
        vertex(-0.4, -0.5125, 0.125, 0, 0);
        vertex(-0.4, -0.5125, -0.125, 1, 0);
        vertex(-0.4, 0, -0.125, 1, 1);
        vertex(-0.4, 0, 0.125, 0, 1);
        // Top face
        vertex(-0.4, -0.5125, -0.125, 0, 0);
        vertex(0.4, -0.5125, -0.125, 1, 0);
        vertex(0.4, -0.5125, 0.125, 1, 1);
        vertex(-0.4, -0.5125, 0.125, 0, 1);
      endShape();
    popMatrix();
  }
  popMatrix();
}

void cylinder(float r, float h) {
  int sides = 50;
  float angle = 360 / sides;
  beginShape(QUAD_STRIP);
    for (int i = 0; i <= sides+2; i++) {
      float x = cos(radians(i * angle)) * r;
      float z = sin(radians(i * angle)) * r;
      vertex(x, -h/2, z);
      vertex(x, h/2, z);
    }
  endShape();
}

void car(float count) {
  carBody(count);
  carTire(count);
}

void carBody(float count){
  pushMatrix();
    scale(.25, .25, .25);
    fill(100,100,255);
    translate(15*(count%5.5-2.75),1.,-2.5);
    box(4,1,2);
    spotLight(228, 233, 226, 2.002, -0.2, 0, 100, 0, 1, 3*PI/4, 500);
    translate(-.25,-1,0);
    box(1.5,1,2);
    translate(.75,-.5,0);
    beginShape(TRIANGLES);
      vertex(0,0,1); vertex(0,1,1); vertex(1,1,1);
      vertex(0,0,1); vertex(0,0,-1); vertex(1,1,1);
      vertex(0,0,-1); vertex(1,1,1); vertex(1,1,-1);
      vertex(0,0,0); vertex(0,1,0); vertex(1,1,0);
    endShape();
    translate(-2.5,0,0);
    beginShape(TRIANGLES);
      vertex(1,0,1); vertex(1,1,1); vertex(0,1,1);
      vertex(1,0,1); vertex(1,0,-1); vertex(0,1,1);
      vertex(1,0,-1); vertex(0,1,1); vertex(0,1,-1);
      vertex(1,0,0); vertex(1,1,0); vertex(0,1,0);
    endShape();
  popMatrix();  
}

void carTire(float count) {
  pushMatrix();
    scale(.25, .25, .25);
    fill(0);
    translate(15*(count%5.5-2.75),1.,-2.5);

    float radius = 0.5;
    float height = 0.2;

    drawCylinder(-1, 0.5, 1, radius, height);
    drawCylinder(1, 0.5, 1, radius, height);
    drawCylinder(-1, 0.5, -1, radius, height);
    drawCylinder(1, 0.5, -1, radius, height);

  popMatrix();
}

void train(float angle) {
  trainBody(angle, 0);
  trainBody(angle, PI/7);
  trainTire(angle, -PI/21);
  trainTire(angle, PI/21);
  trainTire(angle, -PI/21+PI/7);
  trainTire(angle, PI/21+PI/7);
}

void trainBody(float angle, float a){
  pushMatrix();
    fill(85, 114, 104);
    rotateY(7*PI/8 + a - angle);
    translate(9.25,-.2,0);
    box(1,1,4);
    spotLight(228, 233, 226, 0, -0.2, 2.002, 0, 0, 100, 3*PI/4, 500);
  
    textureMode(NORMAL);
    beginShape(QUADS);
      texture(trainTexture);
        // Right face
      vertex(0.501, -0.5, 2, 0, 0);
      vertex(0.501, -0.5, -2, 1, 0);
      vertex(0.501, 0.5, -2, 1, 1);
      vertex(0.501, 0.5, 2, 0, 1);
        // Left face
      vertex(-0.501, -0.5, -2, 0, 0);
      vertex(-0.501, -0.5, 2, 1, 0);
      vertex(-0.501, 0.5, 2, 1, 1);
      vertex(-0.501, 0.5, -2, 0, 1);
    endShape();

    textureMode(NORMAL);
    beginShape(QUADS);
      texture(trainFrontTexture);
      // Front face
      vertex(-0.5, -0.5, 2.001, 0, 0);
      vertex(0.5, -0.5, 2.001, 1, 0);
      vertex(0.5, 0.5, 2.001, 1, 1);
      vertex(-0.5, 0.5, 2.001, 0, 1);
    
      // Back face
      vertex(0.5, -0.5, -2.001, 0, 0);
      vertex(-0.5, -0.5, -2.001, 1, 0);
      vertex(-0.5, 0.5, -2.001, 1, 1);
      vertex(0.5, 0.5, -2.001, 0, 1);
    endShape();
  popMatrix();  
}

void trainTire(float angle, float a) {
  pushMatrix();
    fill(100);
    float radius = 0.1;
    float height = 0.08;

    rotateY(7*PI/8 + a - angle);
    translate(9.25,0,0);
    rotateY(PI/2);
    drawCylinder(-0.25, 0.4, 0.4, radius, height);
    drawCylinder(0.25, 0.4, 0.4, radius, height);
    drawCylinder(-0.25, 0.4, -0.4, radius, height);
    drawCylinder(0.25, 0.4, -0.4, radius, height);

  popMatrix();
}

void drawCylinder(float x, float y, float z, float radius, float height) {
  int sides = 30;

  beginShape(TRIANGLE_STRIP);
  for (int i = 0; i <= sides; i++) {
    float theta = map(i, 0, sides, 0, TWO_PI);
    float xPos = x + cos(theta) * radius;
    float yPos = y + sin(theta) * radius;
    float zPos1 = z - height / 2;
    float zPos2 = z + height / 2;

    vertex(xPos, yPos, zPos1);
    vertex(xPos, yPos, zPos2);
  }
  endShape(CLOSE);

  // Draw top face
  beginShape(TRIANGLE_FAN);
  vertex(x, y, z - height / 2);
  for (int i = 0; i <= sides; i++) {
    float theta = map(i, 0, sides, 0, TWO_PI);
    float xPos = x + cos(theta) * radius;
    float yPos = y + sin(theta) * radius;

    vertex(xPos, yPos, z - height / 2);
  }
  endShape(CLOSE);

  // Draw bottom face
  beginShape(TRIANGLE_FAN);
  vertex(x, y, z + height / 2);
  for (int i = 0; i <= sides; i++) {
    float theta = map(i, 0, sides, 0, TWO_PI);
    float xPos = x + cos(theta) * radius;
    float yPos = y + sin(theta) * radius;

    vertex(xPos, yPos, z + height / 2);
  }
  endShape(CLOSE);
}

class Rain {
  PVector position;
  PVector velocity;
  float radius;

  Rain() {
    position = new PVector(random(width), random(-50, -10), random(-20, 20));
    velocity = new PVector(0, random(0.5, 1.5), random(-0.75, 0.5));
    radius = random(0.5, 2);
  }

  void update() {
    position.add(velocity);

    if (position.y > 1) {
      position.y = random(-50, -10);
      position.x = random(width);
      position.z = random(-20, 20);
    }
  }

  void display() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    fill(173, 196, 221);
    noStroke();
//    sphere(radius*0.075);
    box(0.025,radius*0.4,0.025);
    popMatrix();
  }
}

void updateMesh() {
 for (int x = 1; x<funberOfPArticles-2; x++) {
  for (int y = 1; y<funberOfPArticles-2; y++) {
   //under 
   float force1 = 0.0;
   force1 += particle[x-1][y-1] - particle[x][y];
   force1 += particle[x-1][y] - particle[x][y];
   force1 += particle[x-1][y+1] - particle[x][y];
   //over
   force1 += particle[x+1][y-1] - particle[x][y];
   force1 += particle[x+1][y] - particle[x][y];
   force1 += particle[x+1][y+1] - particle[x][y];
   //sidene
   force1 += particle[x][y-1] - particle[x][y];
   force1 += particle[x][y+1] - particle[x][y];

   force1 -= particle[x][y+1] / 8;

   particlesSpeedNew[x][y] = 0.995 * particlesSpeedNew[x][y] + force1/100;

   particlesNew[x][y] = particle[x][y] + particlesSpeedNew[x][y];
   if (!isInEllipse(x, y, ellipseWidth, ellipseHeight)) {
    if (abs(particlesNew[x][y]) > maxAmplitude) {
      particlesSpeedNew[x][y] *= -1;
    } else if (abs(particlesNew[x][y]) < minAmplitude) {
      particlesSpeedNew[x][y] *= -1;
    }
   }

   particlesNew[x][y] = constrain(particlesNew[x][y], minAmplitude, maxAmplitude);
  }
 }   

 for (int x = 1; x<funberOfPArticles-1; x++) {
  for (int y = 1; y<funberOfPArticles-1; y++) {
   particle[x][y] = particlesNew[x][y];
  }
 }

  float sineWaveAmplitude = 5.0;
  float sineWaveFrequency = 0.1;
  float sineWave = sineWaveAmplitude * sin(offset * sineWaveFrequency);
  particlesSpeedNew[0][0] = sineWave;
  particle[0][0] = sineWave * 10;


 if (waveOrNot != 0) {
  offset += .1;
  int MouseXIndex = 2 + (funberOfPArticles-4) * mouseX / width;
  int MouseYIndex = 2 + (funberOfPArticles-4) * mouseY / height;
  particlesSpeedNew[MouseXIndex][MouseYIndex] = waveOrNot;
  particlesSpeedNew[MouseXIndex+1][MouseYIndex+1] = waveOrNot;
  particlesSpeedNew[MouseXIndex+1][MouseYIndex] = waveOrNot;
  particlesSpeedNew[MouseXIndex+1][MouseYIndex-1] = waveOrNot;
  particlesSpeedNew[MouseXIndex][MouseYIndex-1] = waveOrNot;
  particlesSpeedNew[MouseXIndex-1][MouseYIndex+1] = waveOrNot;
  particlesSpeedNew[MouseXIndex-1][MouseYIndex] = waveOrNot;
  particlesSpeedNew[MouseXIndex-1][MouseYIndex-1] = waveOrNot;

  particle[MouseXIndex][MouseYIndex] = waveOrNot*10;
  particle[MouseXIndex+1][MouseYIndex+1] = waveOrNot*5;
  particle[MouseXIndex+1][MouseYIndex] = waveOrNot*10;
  particle[MouseXIndex+1][MouseYIndex-1] = waveOrNot*5;
  particle[MouseXIndex][MouseYIndex-1] = waveOrNot*10;
  particle[MouseXIndex-1][MouseYIndex+1] = waveOrNot*5;
  particle[MouseXIndex-1][MouseYIndex] = waveOrNot*10;
  particle[MouseXIndex-1][MouseYIndex-1] = waveOrNot*5;
 }
  offset += 0.1;
}

void drawMesh() {
 noStroke();
 fill(80,180,230);
 for (int x = 0; x < funberOfPArticles - 1; x++) {
  for (int y = 0; y < funberOfPArticles - 1; y++) {
   if (isInEllipse(x, y, ellipseWidth, ellipseHeight) &&
       isInEllipse(x + 1, y, ellipseWidth, ellipseHeight) &&
       isInEllipse(x, y + 1, ellipseWidth, ellipseHeight) &&
       isInEllipse(x + 1, y + 1, ellipseWidth, ellipseHeight)) {

     beginShape();
     vertex(x * zoom, y * zoom, particle[x][y]);
     vertex((x + 1) * zoom, y * zoom, particle[x + 1][y]);
     vertex((x + 1) * zoom, (y + 1) * zoom, particle[x + 1][y + 1]);
     vertex(x * zoom, (y + 1) * zoom, particle[x][y + 1]);
     endShape();
   }
  }
 }
}

boolean isInEllipse(float x, float y, float ellipseWidth, float ellipseHeight) {
 float centerX = funberOfPArticles / 2;
 float centerY = funberOfPArticles / 2;
 return pow(x - centerX, 2) / pow(ellipseWidth / 2, 2) + pow(y - centerY, 2) / pow(ellipseHeight / 2, 2) <= 1;
}
