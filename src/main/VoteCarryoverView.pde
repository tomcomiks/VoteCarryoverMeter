/**
 * Class VoteCarryoverView
 */
public class VoteCarryoverView {

  private VoteCarryover voteCarryover;
  private float progression = 0;
  private boolean transition = true;

  private Candidate candidate1, candidate2;
  private float x1, y1;
  private float size1;
  private float vote1;
  private float percentage;
  private float distance;
  private float angle;

  public VoteCarryoverView(VoteCarryover voteCarryover) {
    this.voteCarryover = voteCarryover;       

    candidate1 = voteCarryover.getFirstRoundCandidate();
    candidate2 = voteCarryover.getSecondRoundCandidate();
  }  

  public float getProgression() {
    return progression;
  }

  public boolean getTransition() {
    return transition;
  }

  public void setProgression(float progression) {
    this.progression = progression;
  }

  public void setTransition(boolean transition) {
    this.transition = transition;
  }



  /**
   * Display the view
   */
  public void display() {

    percentage = voteCarryover.getPercentage();  

    if (meter.roundStep != 2) {
      resetProgression();
    }

    if (candidate1.getView().isVisible() && meter.roundStep == 2 && candidate1 != candidate2 && percentage != 0) {
      updateParameters();
      calculateProgression();    
      addArrow();
      addText();
    }
  }

  /**
   * Update the view parameters
   */
  public void updateParameters() {   

    x1 =  candidate1.getView().getX();
    y1 =  candidate1.getView().getY();
    size1 = candidate1.getView().getSize();
    vote1 = candidate1.getFirstRoundVotes();

    float x2 = candidate2.getView().getX();
    float y2 = candidate2.getView().getY();
    float size2 = candidate2.getView().getSize();

    distance = sqrt(sq(x2-x1)+sq(y2-y1)) - size1/2 - size2/2;
    angle = atan2(y2-y1, x2-x1)*57.25;
  }

  /**
   * Add an arrow
   */
  void addArrow() {

    float ax1 = x1 + cos(radians(angle))*(progression*0 + size1/2);
    float ay1 = y1 + sin(radians(angle))*(progression*0 + size1/2);
    float ax2 = x1 + cos(radians(angle))*(progression + size1/2);
    float ay2 = y1 + sin(radians(angle))*(progression + size1/2);

    float offset = map(percentage*vote1, 0, meter.FIRST_ROUND_VOTERS, 0, 500);
    float distance = sqrt(sq(ax2-ax1)+sq(ay2-ay1)) - offset;
    float angle = atan2(ay2-ay1, ax2-ax1);

    strokeWeight(offset);
    int transparency = 500;
    if (candidate1.getSecondRoundVotes() == 0) {
      transparency = 127;
    }

    strokeCap(SQUARE);
    stroke(candidate1.getColour(), map(percentage*vote1, 0, vote1, 51, transparency));
    fill(candidate1.getColour(), map(percentage*vote1, 0, vote1, 51, transparency));

    line(ax1, ay1, ax1+cos(radians(angle*57.25))*distance, ay1+sin(radians(angle*57.25))*distance);    
    pushMatrix();
    translate(ax2, ay2);
    rotate(angle);
    noStroke();
    triangle(0, 0, -offset, offset, -offset, -offset);
    popMatrix();
  }


  /**
   * Add a text
   */
  private void addText() {

    float tx = x1 + cos(radians(angle))*(progression*2/3);
    float ty = y1 + sin(radians(angle))*(progression*2/3);

    noStroke();
    textSize(12);
    fill(255);
    text(round(percentage*100)+"%", tx, ty, 200, 200);
  }


  /**
   * Calculate the arrow progression
   */
  private void calculateProgression() {
    if (progression < distance && transition == true) {
      setProgression(progression + (distance)*SPEED);
    } else {
      setTransition(false);
      setProgression(distance);
    }
  }

  /**
   * Reset the arrow progression
   */
  public void resetProgression() {
    progression = 0;
    transition = true;
  }
}
