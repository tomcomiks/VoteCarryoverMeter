/**
 * Class Candidate
 */
public class Candidate {

  private String name;
  private String party;
  private String image;
  private color colour;
  private int firstRoundVotes;
  private int secondTourVotes;
  private int estimateVotes;
  private CandidateView view;

  public Candidate(String name, String party, String image, color colour, int firstRoundVotes, int secondRoundVotes) {
    this.name = name;
    this.party = party;
    this.image = image;
    this.colour = colour;
    this.firstRoundVotes = firstRoundVotes;
    this.secondTourVotes = secondRoundVotes;
  }

  public String getName() {
    return name;
  }

  public color getColour() {
    return colour;
  }

  public String getImage() {
    return image;
  }

  public int getFirstRoundVotes() {
    return firstRoundVotes;
  }

  public int getSecondRoundVotes() {
    return secondTourVotes;
  }

  public int getEstimateVotes() {
    return estimateVotes;
  }

  public CandidateView getView() {
    return view;
  }

  //Settes
  public void setView(CandidateView view) {
    this.view = view;
  } 

  /**
   * Calculate the sum of votes for candidates that passed the first round
   */
  public void calculateEstimateVotes() {

    int sum = 0;

    //If the current candidate passed the first round
    if (this.getSecondRoundVotes() > 0) {

      //For each candidate in the first round
      for (Candidate candidate : meter.candidates) {  

        int candidateIndex = meter.candidates.indexOf(candidate);
        int thisCandidateIndex = meter.candidates.indexOf(this);

        sum += candidate.getFirstRoundVotes()*meter.carryover[candidateIndex][thisCandidateIndex].getPercentage();
      }
    }

    estimateVotes = sum;
  }
}
