module conquer.core.arrays;

/// Template to create an empty array.
template EmptyArray(T) {
  public enum EmptyArray = new T[0];
}
