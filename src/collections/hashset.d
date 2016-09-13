module conquer.collections.hashset;

/// A generic hashset.
class HashSet(T) {
  private:
  /// The set.
  size_t[T] _set;

  public:
  /// Creates a new hashset.
  this() { }

  /**
  * Creates a new hashset.
  * Params:
  *   set = An existing hashset to inherit.
  */
  this(HashSet!T set) {
    _set = set._set;
  }

  /**
  * Adds an item to the hashset.
  * Params:
  *   item =  The item to add.
  * Returns: True if the item was added, false if it's already present.
  */
  bool add(T item) @safe {
    if (item in _set) {
      return false;
    }

    _set[item] = 1;
    return true;
  }

  /**
  * Checks whether an item is present in the hashset or not.
  * Params:
  *   item =  The item to check.
  * Returns: True if it's present, false otherwise.
  */
  bool contains(T item) {
    return cast(bool)(item in _set);
  }
}
