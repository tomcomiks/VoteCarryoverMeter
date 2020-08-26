
/**
 * Class VoteCarryover
 */
public class VoteCarryover {

  private Candidate firstRoundCandidate;
  private Candidate secondRoundCandidate;
  private float repartition;
  private float percentage;
  private VoteCarryoverView view;

  public VoteCarryover(Candidate firstRoundCandidate, Candidate secondRoundCandidate, float repartition) {
    this.firstRoundCandidate = firstRoundCandidate;
    this.secondRoundCandidate = secondRoundCandidate;
    this.repartition = repartition;
  }

  public Candidate getFirstRoundCandidate() {
    return firstRoundCandidate;
  }

  public Candidate getSecondRoundCandidate() {
    return secondRoundCandidate;
  }

  public float getRepartition() {
    return repartition;
  }


  public float getPercentage() {
    return percentage;
  }

  public VoteCarryoverView getView() {
    return view;
  }

  public void setRepartition(float repartition) {
    this.repartition = repartition;
  }

  public void setView(VoteCarryoverView view) {
    this.view = view;
  }

  /**
   * Calculate the repartition between abstention/candidate1/candidate2
   */
  public void calculatePercentage() {

    float percentage = 0;

    if (getSecondRoundCandidate() == meter.blankCandidate) {
      percentage = getRepartition();
    } else {
      //Look for the abstention value for the candidate of the first round
      int abstentionIndex = meter.candidates.indexOf(meter.blankCandidate);
      int candidateIndex = meter.candidates.indexOf(firstRoundCandidate);
      float abstentionPercentage = meter.carryover[candidateIndex][abstentionIndex].getRepartition();     
      percentage = (1-abstentionPercentage)*getRepartition();
    }

    this.percentage = percentage;
  }
}
