module conquer.core.uidgenerator;

import std.traits : isNumeric;

import conquer.collections : HashSet;
import conquer.core.random : nextRandomNumber;

version (AUTH_SERVER) {
  /// Generator for player ids.
  __gshared auto playerIds = new UIDGenerator!uint(1000000, 500000000);
}
else version (WORLD_SERVER) {
  /// Generator for bot ids.
  __gshared auto botIds = new UIDGenerator!uint(500000000, 999999999);
  /// Generator for npc ids.
  __gshared auto npcIds = new UIDGenerator!uint(1, 150000);
  /// Generator for mob ids.
  __gshared auto mobIds = new UIDGenerator!uint(400000, 500000);
  /// Generator for item ids.
  __gshared auto itemIds = new UIDGenerator!uint(0, 999999999);
}

/// A unique id generator.
private class UIDGenerator(T) if (isNumeric!T) {
  private:
  /// The hashset to keep track of reserved uids.
  HashSet!T _uids;
  /// The min value.
  T _min;
  /// The max value.
  T _max;

  /**
  * Creates a new unique id generator.
  * Params:
  *   min = The min value.
  *   max = The max value.
  */
  this(T min, T max) {
    _min = min;
    _max = max;

    _uids = new HashSet!T;
  }

  public:
  /// Gets a unique id based on the generator's min/max value.
  auto get() {
    T uid;

    synchronized {
      do {
        uid = nextRandomNumber(_min, _max);
      } while (!_uids.add(uid));
    }

    return uid;
  }
}
