/**
 * Class CandidateView
 */
public class CandidateView {

  private Candidate candidate;
  private float x, y;
  private float size = 0;
  private float counter;
  private float diffX = 0.0, diffY = 0.0;
  private boolean locked = false;
  private boolean visible = true;

  public CandidateView(Candidate candidate, float x, float y) {
    this.candidate = candidate;
    setSize(int(map(candidate.getEstimateVotes(), 0, meter.FIRST_ROUND_VOTERS, 100, WIDTH*1/2)));
    setPosition(x, y);
  }

  public Candidate getCandidate() {
    return candidate;
  }

  public float getX() {
    return this.x;
  }

  public float getY() {
    return this.y;
  }

  public float getSize() {
    return size;
  }

  public float getCounter() {
    return counter;
  }

  public boolean isVisible() {
    return visible;
  }

  public void setSize(float size) {
    this.size = constrain(size, 0, WIDTH/3);
  }

  public void setCounter(float counter) {
    this.counter = counter;
  } 

  public void setPosition(float x, float y) {
    this.x =  constrain(x, 50+size/2, WIDTH-50-size/2); 
    this.y =  constrain(y, 150+size/2, HEIGHT-250-size/2);
  }

  public void setVisible(boolean visible) {
    this.visible = visible;
  }

  /**
   * Display the view
   */
  public void display() {
    updateParameters();
    if (visible) {
      addBorders();
      addCircle();
      addText();
    }
  }

  /**
   * Update the view parameters
   */
  private void updateParameters() {
    //Calcule la taille et le compteur en fonction de la transition courante
    float sizeFirstRound = int(map(candidate.getFirstRoundVotes(), 0, meter.FIRST_ROUND_VOTERS, 100, WIDTH*1/2));
    float sizeEstimate = int(map(candidate.getEstimateVotes(), 0, meter.FIRST_ROUND_VOTERS, 100, WIDTH*1/2));
    float sizeSecondRound = int(map(candidate.getSecondRoundVotes(), 0, meter.SECOND_ROUND_VOTERS, 100, WIDTH*1/2));

    switch(meter.roundStep) {

      //First round results
    case 1:
      setCounter(meter.calculateTransitionFromTo(counter, candidate.getFirstRoundVotes(), SPEED*2));
      setSize(meter.calculateTransitionFromTo(size, sizeFirstRound, SPEED*2));
      break;

      //Estimate results
    case 2:
      //Si le candidat est au second tour
      if (candidate.getSecondRoundVotes() > 0) {  
        setCounter(meter.calculateTransitionFromTo(counter, candidate.getEstimateVotes(), SPEED*2));
        setSize(meter.calculateTransitionFromTo(size, sizeEstimate, SPEED*2));
        //Si le candidat n'est pas au second tour
      } else {
        setCounter(meter.calculateTransitionFromTo(counter, candidate.getFirstRoundVotes(), SPEED*2));
        setSize(meter.calculateTransitionFromTo(size, sizeFirstRound, SPEED*2));
      }
      break;

      //Second round results
    default:
      //Si le candidat est au second tour
      if (candidate.getSecondRoundVotes() > 0) {  
        setCounter(meter.calculateTransitionFromTo(counter, candidate.getSecondRoundVotes(), SPEED*2));
        setSize(meter.calculateTransitionFromTo(size, sizeSecondRound, SPEED*2));
        //Si le candidat n'est pas au second tour
      } else {
        setCounter(meter.calculateTransitionFromTo(counter, 0, SPEED*2));
        setSize(meter.calculateTransitionFromTo(size, 0, SPEED*2));
      }
      break;
    }
  }

  /**
   * Add a circle
   */
  private void addCircle() {

    rectMode(RADIUS);  
    fill(candidate.getColour());
    if (meter.roundStep == 2 && candidate.getSecondRoundVotes() == 0) {
      fill(candidate.getColour(), 127);
    }
    ellipse(x, y, size, size);

    //Ajoute l'image du candidat
    PImage img = loadImage(RESOURCE_FOLDER + candidate.getImage());
    img.resize(round(size/3)+1, 0);
    tint(255, 126);
    image(img, x-size/6, y-size/6);
  }

  /**
   * Add borders
   */
  private void addBorders() {
    noStroke();
    if (isMouseOver()) {  //Add a green border when the mouser hovers  the candidate
      strokeWeight(5);
      stroke(0, 255, 0);
    } 
    if (locked) { //Add a red border when the candidate is selected
      strokeWeight(5);
      stroke(255, 0, 0);
    }
  }

  /**
   * Add text
   */
  private void addText() {
    textLeading(20);
    fill(163);
    textAlign(CENTER, CENTER);
    textSize(size*0.10);

    String str = candidate.getName();
    String name = str.substring(0, str.indexOf(" "))+"\n"+str.substring(str.indexOf(" "));
    text(name, x, y-size*1/3, size*2/3, size/2);
    textSize(size*0.08);
    text(nfc((int)counter)+" votes", x, y+size*1/4, size/3, size/2);
  }

  /**
   * If the user hovers the area
   */
  private boolean isMouseOver() {
    float disX = x - mouseX;
    float disY = y - mouseY;
    if (sqrt(sq(disX) + sq(disY)) < size/2 ) {
      return true;
    } else {
      return false;
    }
  }

  /**
   * If the user clicks the area
   */
  private void click() {
    if (isMouseOver() && visible) {
      locked = true;
    } else {
      locked = false;
    }
    diffX = mouseX - x;
    diffY = mouseY - y;
  }

  /**
   * If the user drags the area
   */
  private void drag() {
    if (locked && visible) {
      setPosition(mouseX - diffX, mouseY - diffY);
    }
  }

  /**
   * If the user release the mouse
   */
  private void release() {
    locked = false;
  }
}
