module conquer.core.random;

import std.random : Random, uniform;
import std.traits : isNumeric;

/// Thread-local random generator.
private Random generator;

/**
* Generates a random number based on a max value.
* Params:
*   max = The max value.
* Returns: The random number.
*/
auto nextRandomNumber(T)(T max)
if (isNumeric!T) {
  return nextRandomNumber(0, max);
}

/**
* Generates a random number based on a min and max value.
* Params:
*   min = The min value.
*   max = The max value.
* Returns: The random number.
*/
auto nextRandomNumber(T)(T min, T max)
if (isNumeric!T) {
  if (max < 0 || max < min) {
    max = T.max;
  }

  if (min < 0) {
    min = 0;
  }

  return uniform(min, max, generator);
}
