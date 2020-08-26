/**
 * Main
 */
import controlP5.*;

String RESOURCE_FOLDER = "../resources/";
int WIDTH = 900;
int HEIGHT = 900;
float SPEED = 0.01;

ControlP5 cp5;
Meter meter;

/**
 * Processing Setup
 */
public void setup() {

  cp5 = new ControlP5(this);
  
  meter = new Meter(); 
  meter.setup();

  frameRate(24);
  size(900, 900, P2D);
  smooth();
}

/**
 * Processing Draw
 */
void draw() {

  background(0); 
  meter.draw();

  //Reset the format
  noStroke();
  tint(255, 255);
}

/**
 * Processing Events
 */
void controlEvent(ControlEvent theEvent) {
  meter.controlEvent(theEvent);
}

void mousePressed() {
  meter.mousePressed();
}

void mouseDragged() {
  meter.mouseDragged();
}

void mouseReleased() {
  meter.mouseReleased();
}
