//https://github.com/ihla/filters/blob/master/co-joyatwork-filters/src/co/joyatwork/filters/MovingAverage.java
/**
 * Calculates moving average from the most recent samples.
 * <p> 
 * To use it, push the newly collected sensor value using pushValue() 
 * and then get the averaged value using getValue().
 *
 */
public class MovingAverage {

  private float circularBuffer[];
  private float avg;
  private int circularIndex;
  private int count;
  private boolean isFirstCall;

  /**
   * Calculates moving average from the most recent samples.
   * <p>
   * Constructor creates circular buffer for storing recent samples.
   * @param k - buffer size
   */
  public MovingAverage(int k) {
    circularBuffer = new float[k];
    count = 0;
    isFirstCall = true;
    circularIndex = 0;
    avg = 0;
  }

  /** Get the current moving average. */
  public float getValue() {
    return avg;
  }

  /** Calculate moving average and store last value in circular buffer. */
  public void pushValue(float x) {
    if (isFirstCall) {
      primeBuffer(x);
      isFirstCall = false;
    }
    count++;
    float lastValue = circularBuffer[circularIndex];
    avg = avg + (x - lastValue) / circularBuffer.length;
    circularBuffer[circularIndex] = x;
    circularIndex = nextIndex(circularIndex);
  }

  public long getCount() {
    return count;
  }

  private void primeBuffer(float val) {
    for (int i = 0; i < circularBuffer.length; ++i) {
      circularBuffer[i] = val;
    }
    avg = val;
  }

  private int nextIndex(int curIndex) {
    if (curIndex + 1 >= circularBuffer.length) {
      return 0;
    }
    return curIndex + 1;
  }
}