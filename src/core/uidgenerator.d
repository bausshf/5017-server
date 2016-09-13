module conquer.core.uidgenerator;

import std.traits : isNumeric;

import conquer.collections : HashSet;
import conquer.core.random : nextRandomNumber;

version (AUTH_SERVER) {
  __gshared auto playerIds = new Generator!uint(1000000, 500000000);
}
else version (WORLD_SERVER) {
  __gshared auto botIds = new Generator!uint(500000000, 999999999);
  __gshared auto npcIds = new Generator!uint(1, 150000);
  __gshared auto mobIds = new Generator!uint(400000, 500000);
  __gshared auto itemIds = new Generator!uint(0, 999999999);
}

private class Generator(T) if (isNumeric!T) {
  private:
  HashSet!T _uids;
  T _min;
  T _max;

  this(T min, T max) {
    _min = min;
    _max = max;

    _uids = new HashSet!T;
  }

  public:
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
