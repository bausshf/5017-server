module conquer.core.math;

import std.traits : isNumeric;

/**
* Returns the smaller of two values.
* Params:
*   x = The first value.
*   y = The second value.
* Returns: The smaller of the two values.
*/
auto min(T)(T x, T y) pure @safe nothrow if (isNumeric!T) {
    return x > y ? y : x;
}

/**
* Returns the bigger of two values.
* Params:
*   x = The first value.
*   y = The second value.
* Returns: The bigger of the two values.
*/
auto max(T)(T x, T y) pure @safe nothrow if (isNumeric!T) {
  return x > y ? x : y;
}
