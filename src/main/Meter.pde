/**
 * Class Meter
 */
public class Meter {

  int FIRST_ROUND_VOTERS = 47581118;
  int SECOND_ROUND_VOTERS = 47568693;
  int roundStep = 2; //The first screen is the estimate results

  ArrayList<Candidate> candidates = new ArrayList<Candidate>();
  Candidate blankCandidate;
  VoteCarryover[][] carryover;

  int[][] carryoverMatrix;
  int candidateWidth;
  boolean[] hideSlider;
  CheckBox checkbox;

  /**
   * Setup
   */
  void setup() {
    loadData();
    createViews(); 
    defineControlPanel();
  }
  
  /**
   * Draw
   */
  void draw() {  
    addHeadlines();
    addControlPanel();
    addElements();
  }

  /**
   * Populate with data
   */
  void loadData() {

    //Create candidates
    blankCandidate = new Candidate("Abstention Blank and Null", "-", "abstention.jpg", color(255), 11522305, 16187090);

    candidates = new ArrayList() {
      {
        //Abstention
        add(blankCandidate);

        //Candidates who passed the first round
        add(new Candidate("Emmanuel Macron", "En Marche!", "em.jpg", color(255, 204, 0), 8657326, 20743128));
        add(new Candidate("Marine Le Pen", "Front National", "mlp.jpg", color(0, 0, 127), 7679493, 10638475));

        //Candidates who didn't pass the first round
        add(new Candidate("Francois Fillon", "Les Républicains", "ff.jpg", color(0, 0, 255), 7213797, 0));
        add(new Candidate("Jean-Luc Melenchon", "La France Insoumise", "jlm.jpg", color(255, 0, 0), 7060885, 0));
        add(new Candidate("Benoit Hamon", "Parti Socialiste", "bh.jpg", color(255, 127, 0), 2291565, 0));
        add(new Candidate("Nicolas Dupont-Aignan", "Debout la France", "nda.jpg", color(0, 0, 191), 1695186, 0));
        add(new Candidate("Autres candidats", "-", "autres.jpg", color(127), 1460561, 0));
      }
    };

    carryoverMatrix = new int[candidates.size()][3];
    carryover = new VoteCarryover[candidates.size()][3];
    hideSlider = new boolean[candidates.size()];

    //Data for carryover
    //First column: repartition abstention/votes, 2nd and 3rd columns: repartition candidate 1/candidate 2
    carryoverMatrix = new int[][]{
      { 100, 0, 0 }, 
      { 0, 100, 0 }, 
      { 0, 0, 100 }, 
      { 32, 70, 30 }, 
      { 41, 88, 12 }, 
      { 27, 97, 3 }, 
      { 43, 47, 53 }, 
      { 33, 50, 50 }
    };

    for (int i=0; i < carryoverMatrix.length*carryoverMatrix[0].length; i++) {
      int p = (i%carryoverMatrix.length);
      int s = (i/carryoverMatrix.length)%carryoverMatrix[0].length;
      carryover[p][s] = new VoteCarryover(candidates.get(p), candidates.get(s), float(carryoverMatrix[p][s])/100);
    }

    for (Candidate candidate : candidates) {
      updateData(candidates.indexOf(candidate));
    }
  }

  /**
   * Add elements
   */
  private void addElements() {

    //Display the carryover arrows
    for (int i=0; i < carryoverMatrix.length*carryoverMatrix[0].length; i++) {
      int p = (i%carryoverMatrix.length);
      int s = (i/carryoverMatrix.length)%carryoverMatrix[0].length;
      carryover[p][s].getView().display();
    }

    //Display the candidate views
    for ( Candidate candidate : candidates) {   
      candidate.getView().display();
    }
  }

  /**
   * Create views
   */
  private void  createViews() {

    int k = 0;

    //Create the view for each candidate
    for (Candidate candidate : candidates) {
      int t = 360/candidates.size()*(k-3);    
      int x = WIDTH/2 + (int) (WIDTH/2  * cos(radians(t)));
      int y = HEIGHT/2 + (int) (HEIGHT/2 * sin(radians(t)));
      candidate.setView(new CandidateView(candidate, x, y));    
      k++;
    }

    //Create the view for the carryover
    for (int i=0; i < carryoverMatrix.length * carryoverMatrix[0].length; i++) {
      int p = (i % carryoverMatrix.length);
      int s = (i / carryoverMatrix.length) % carryoverMatrix[0].length;
      carryover[p][s].setView(new VoteCarryoverView(carryover[p][s]));
    }
  }


  /**
   * Define control panel
   */
  private void defineControlPanel() {

    candidateWidth = (WIDTH - 300) / (candidates.size()-3);  

    checkbox = cp5.addCheckBox("checkBox")
      .setPosition(175, 770)
      .setSize(64, 64)
      .setItemsPerRow(candidates.size()-3)
      .setSpacingColumn(candidateWidth-64)
      .setSpacingRow(0)
      .setImage(loadImage(RESOURCE_FOLDER + "checkbox_show.png"), Controller.ACTIVE)
      .setImage(loadImage(RESOURCE_FOLDER + "checkbox_hide.png"), Controller.DEFAULT)
      ;

    cp5.addButton("1")
      .setPosition(50, 850)
      .setSize(200, 19)
      .setLabel("First Round Results")
      .setColorBackground(color(0, 0, 255))
      .setId(1)
      ;

    cp5.addButton("2")
      .setPosition(350, 850)
      .setSize(200, 19)
      .setLabel("Estimates")
      .setColorBackground(color(0, 127, 255))
      .setId(2)
      ;

    cp5.addButton("3")
      .setPosition(650, 850)
      .setSize(200, 19)
      .setLabel("Second Round Results")
      .setColorBackground(color(0, 0, 255))
      .setId(3)
      ;

    int j = 0;
    for (Candidate candidate : candidates) {

      int candidateIndex = candidates.indexOf(candidate);

      //For candidates who didn't pass the first round
      if (candidate.getSecondRoundVotes() == 0) {

        //Slider to define the blank value
        int blankCandidateValue = int(carryover[candidateIndex][candidates.indexOf(blankCandidate)].getRepartition()*100);

        cp5.addSlider("slider_"+candidateIndex+"_"+candidates.indexOf(blankCandidate))
          .setRange(0, 100)
          .setValue(blankCandidateValue)
          .setPosition(j*candidateWidth+150, 715)
          .setSize(candidateWidth-10, 25)
          .setLabel("")
          .setColorActive(blankCandidate.getColour())
          .setColorForeground(blankCandidate.getColour())
          .setColorBackground(color(0, 255, 0))
          .setColorValue(color(127))
          ; 

        //Slider to set the repartition between the candidate 1 and 2
        int SecondRoundCandidateValue = int(carryover[candidateIndex][1].getRepartition()*100);
        cp5.addSlider("slider_"+candidateIndex+"_1")
          .setRange(0, 100)
          .setValue(SecondRoundCandidateValue)
          .setPosition(j*candidateWidth+150, 752)
          .setSize(candidateWidth-10, 25)
          .setLabel("")
          .setColorActive(candidates.get(1).getColour())
          .setColorForeground(candidates.get(1).getColour())
          .setColorBackground(candidates.get(2).getColour())
          ;       

        //Checkbox pour ne pas afficher un candidat
        checkbox.addItem(candidate.getName(), candidates.indexOf(candidate));
        checkbox.hideLabels();
        checkbox.activateAll();
        j++;
      }
    }
  }

  /**
   * Add headlines
   */
  private void addHeadlines() {
    String title = "", subtitle = "";

    switch(roundStep) {
    case 1:
      title = "First Round Results";
      subtitle = "Source: French Ministry of the Interior, May 2017";
      break;

    case 2:
      title = "Vote Carryover Estimates";
      subtitle = "";
      break;

    case 3:
      title = "Second Round Results";
      subtitle = "Source: French Ministry of the Interior, May 2017";
      break;
    }

    //En-têtes
    textAlign(CENTER, CENTER); 
    fill(255);
    textSize(30);
    text(title, WIDTH/2, 50);
    textSize(12);
    text(subtitle, WIDTH/2, 75);
  }

  /**
   * Add control panel
   */
  private void addControlPanel() {

    rectMode(CORNER);

    int j = 0;
    for (Candidate candidate : candidates) {
      if (candidate.getSecondRoundVotes() == 0) {
        fill(candidate.getColour());
        rect((j+0.25)*candidateWidth+150, 667, 40, 40);
        PImage candidateImage = loadImage(RESOURCE_FOLDER + candidate.getImage());
        candidateImage.resize(34, 0);
        image(candidateImage, (j+0.25)*candidateWidth+153, 670);
        j++;
      }
    }

    rectMode(CORNER);

    fill(255);
    textSize(18);
    textAlign(RIGHT, TOP);
    text("Abstention", 20, 715, 100, 50);
    fill(0, 255, 0);
    textAlign(LEFT);
    text("Voters", 760, 715, 100, 50);

    fill(candidates.get(1).getColour());
    rect(87, 747, 40, 40);
    PImage imageCandidate1 = loadImage(RESOURCE_FOLDER + candidates.get(1).getImage());
    imageCandidate1.resize(34, 0);
    image(imageCandidate1, 90, 750);

    fill(candidates.get(2).getColour());
    rect(762, 747, 40, 40);
    PImage imageCandidate2 = loadImage(RESOURCE_FOLDER + candidates.get(2).getImage());
    imageCandidate2.resize(34, 0);
    image(imageCandidate2, 765, 750);
  }

  /**
   * Calculate the transition
   */
  public float calculateTransitionFromTo(float start, float target, float speed) {

    float distance = target-start;
    if (abs(distance) >= abs(target*speed/2)) {
      return start+distance*speed;
    } else {
      return target;
    }
  }


  /**
   * Recalculate the sum of votes and percentages
   */
  void updateData(int candidateIndex) {

    VoteCarryover blankCandidateCarryover = carryover[candidateIndex][candidates.indexOf(blankCandidate)];
    VoteCarryover candidate1Carryover = carryover[candidateIndex][candidates.indexOf(candidates.get(1))];
    VoteCarryover candidate2Carryover = carryover[candidateIndex][candidates.indexOf(candidates.get(2))];

    candidate1Carryover.getSecondRoundCandidate().calculateEstimateVotes();
    candidate2Carryover.getSecondRoundCandidate().calculateEstimateVotes();
    blankCandidateCarryover.getSecondRoundCandidate().calculateEstimateVotes();
    candidate1Carryover.calculatePercentage();
    candidate2Carryover.calculatePercentage();
    blankCandidateCarryover.calculatePercentage();
  }

  /**
   * Control event
   */
  void controlEvent(ControlEvent theEvent) {

    //Box to hide/display a candidate who didn't pass the first round
    if (theEvent.isFrom(checkbox)) {  
      for (int i=0; i<checkbox.getArrayValue().length; i++) {
        Candidate candidate = candidates.get(int(checkbox.getItem(i).internalValue()));
        int n = (int)checkbox.getArrayValue()[i];
        if (n==1) {
          candidate.getView().setVisible(true);
        } else {
          candidate.getView().setVisible(false);
        }
      }
    }

    if (theEvent.isController()) {
      int id = theEvent.getController().getId();
      String name =  theEvent.getController().getName();
      float value =  theEvent.getController().getValue();
      selectStep(id, name, value);
    }
  }

  /**
   * Select step
   */
  void selectStep(int eventId, String eventName, float eventValue) {

    switch(eventId) {

      //First round results
    case 1:
      roundStep = 1;
      cp5.getController("1").setColorBackground(color(0, 127, 255));
      cp5.getController("2").setColorBackground(color(0, 0, 255));
      cp5.getController("3").setColorBackground(color(0, 0, 255));
      break;

      //Estimate results
    case 2:
      roundStep = 2;
      cp5.getController("1").setColorBackground(color(0, 0, 255));
      cp5.getController("2").setColorBackground(color(0, 127, 255));
      cp5.getController("3").setColorBackground(color(0, 0, 255));
      break;

      //Second round results
    case 3:
      roundStep = 3;
      cp5.getController("1").setColorBackground(color(0, 0, 255));
      cp5.getController("2").setColorBackground(color(0, 0, 255));
      cp5.getController("3").setColorBackground(color(0, 127, 255));
      break;

    default:
      float valueSlider = eventValue/100;      
      int candidatIndex = int(eventName.substring(7, 8));

      VoteCarryover reportAbstention = carryover[candidatIndex][candidates.indexOf(blankCandidate)];
      VoteCarryover reportCandidat1 = carryover[candidatIndex][candidates.indexOf(candidates.get(1))];
      VoteCarryover reportCandidat2 = carryover[candidatIndex][candidates.indexOf(candidates.get(2))];

      //Slider repartition candidate1/candidate2
      if (eventName.equals("slider_"+candidatIndex+"_"+candidates.indexOf(candidates.get(1)))) {
        reportCandidat1.setRepartition(valueSlider);
        reportCandidat2.setRepartition(1-valueSlider);
        updateData(candidatIndex);
      }

      //Slider repartition abstention
      if (eventName.equals("slider_"+candidatIndex+"_"+candidates.indexOf(blankCandidate))) {

        //Hide the slider repartition candidate1/candidate2 if the absention equals 100%
        if (valueSlider == 1 && hideSlider[candidatIndex] == false) {
          cp5.getController("slider_"+candidatIndex+"_"+candidates.indexOf(candidates.get(1))).setVisible(false);
          hideSlider[candidatIndex] = true;
        } else if (valueSlider < 1 && hideSlider[candidatIndex] == true) {
          cp5.getController("slider_"+candidatIndex+"_"+candidates.indexOf(candidates.get(1))).setVisible(true);
          hideSlider[candidatIndex] = false;
        }

        reportAbstention.setRepartition(valueSlider);
        updateData(candidatIndex);
      }

      break;
    }
  }

  void mousePressed() {
    for ( Candidate candidate : candidates) {   
      candidate.getView().click();
    }
  }

  void mouseDragged() {
    for ( Candidate candidate : candidates) {   
      candidate.getView().drag();
    }
  }

  void mouseReleased() {
    for ( Candidate candidate : candidates) { 
      candidate.getView().release();
    }
  }
}
