import processing.opengl.*;

PImage img;

int windowWidth  = 512;
int windowHeight = 512;
float circleRadius = 220;
int circleSliceCount = 8;
float centerX = windowWidth  /2;
float centerY = windowHeight /2;
float centerOffset = 30;
float lineWidthStep = 5;
color colors[];


void setup() {
  size(windowWidth, windowHeight, OPENGL);
  img = loadImage("particle.png");
  
  // no triangle borders
  noStroke();

  textureMode(NORMAL);

  colors = new color [circleSliceCount];
  for (int i = 0; i < circleSliceCount; i++) {
    colors[i] = color(random(50,255), random(0,255), random(0,255), random(100,255));
  }
}

void draw() {
  background(0);

  for (int i = 0; i < circleSliceCount; i++) {
    
    float cosa = cos(i * (360/circleSliceCount) * PI / 180.0);
    float sina = sin(i * (360/circleSliceCount) * PI / 180.0);
    
    float x2 = centerX + circleRadius * cosa;
    float y2 = centerY + circleRadius * sina;

    float dx = centerOffset * cosa;
    float dy = centerOffset * sina;
    
    // emulate vertex/texture color
    tint(colors[i]);
    //stroke(255);
    
    sprite_line(centerX + dx, centerY + dy, x2, y2, lineWidthStep * (i + 1));
  }
}

void sprite_line(float x1, float y1, float x2, float y2, float w)
{
  PVector start = new PVector(x1, y1, 0);
  PVector end = new PVector(x2, y2, 0);
  PVector diff = new PVector(x2 - x1, y2 - y1);
  PVector direction = new PVector(diff.x, diff.y);
  direction.normalize();
  PVector perpendicular = new PVector(-direction.y, direction.x);
  
  float length = diff.mag();
  float lineWidth = w;
  
  float spriteStep = lineWidth / 8;
  int spriteCount = (int)max(length / spriteStep, 1);
  
  int vertexCount = spriteCount * 6;
  
  PVector vertices[] = new PVector[vertexCount];
  PVector textures[] = new PVector[vertexCount];
  
  for (int i = 0; i < vertexCount; i++)
  {
    vertices[i] = new PVector(0, 0, 0);
    textures[i] = new PVector(0, 0, 0);
  }

    for (int i = 0; i < spriteCount; i++)
    {
        PVector ptV1 = new PVector(0, 0, 0);
        
        ptV1.x = start.x + (diff.x * ((float)i)) / ((float) spriteCount);
        ptV1.y = start.y + (diff.y * ((float)i)) / ((float) spriteCount);
        
        
        PVector ptV2 = PVector.add(ptV1, PVector.mult(direction, lineWidth));
        
        PVector ptVC = PVector.add(ptV1, PVector.mult(perpendicular, lineWidth / 2.0f));
        PVector ptVD = PVector.sub(ptV1, PVector.mult(perpendicular, lineWidth / 2.0f));

        PVector ptVA = PVector.add(ptV2, PVector.mult(perpendicular, lineWidth / 2.0f));
        PVector ptVB = PVector.sub(ptV2, PVector.mult(perpendicular, lineWidth / 2.0f));
        
        
        int n = i * 6;

        vertices[n + 0].x = ptVD.x;
        vertices[n + 0].y = ptVD.y;
        vertices[n + 0].z = 0.0f;
        textures[n + 0].x = 0.0f;
        textures[n + 0].y = 0.0f;
        
        vertices[n + 1].x = ptVB.x;
        vertices[n + 1].y = ptVB.y;
        vertices[n + 1].z = 0.0f;
        textures[n + 1].x = 1.0f;
        textures[n + 1].y = 0.0f;
        
        vertices[n + 2].x = ptVC.x;
        vertices[n + 2].y = ptVC.y;
        vertices[n + 2].z = 0.0f;
        textures[n + 2].x = 0.0f;
        textures[n + 2].y = 1.0f;
        
        vertices[n + 3].x = ptVB.x;
        vertices[n + 3].y = ptVB.y;
        vertices[n + 3].z = 0.0f;
        textures[n + 3].x = 1.0f;
        textures[n + 3].y = 0.0f;
        
        vertices[n + 4].x = ptVA.x;
        vertices[n + 4].y = ptVA.y;
        vertices[n + 4].z = 0.0f;
        textures[n + 4].x = 1.0f;
        textures[n + 4].y = 1.0f;
        
        vertices[n + 5].x = ptVC.x;
        vertices[n + 5].y = ptVC.y;
        vertices[n + 5].z = 0.0f;
        textures[n + 5].x = 0.0f;
        textures[n + 5].y = 1.0f;
    }
    
  beginShape(TRIANGLE);
  texture(img);
  for (int i = 0; i < vertexCount; i++)
  {
    vertex(vertices[i].x, vertices[i].y, vertices[i].z, textures[i].x, textures[i].y);
  }
  endShape();
}

