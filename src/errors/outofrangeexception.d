module conquer.errors.outofrangeexception;

import std.string : format;

/// Out of range exception wrapper.
final class OutOfRangeException : Exception {
  public:
  final:
  /**
  * Creates a new out of range exception.
  * Params:
  *   name =  The name of the source.
  *   index = The index that is out of range, relatively to the source.
  */
  this(string name, size_t index) {
    super(format("The index '%s' was out of range to '%s'.", index, name));
  }
}
