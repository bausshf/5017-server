module conquer.database.engine;

import std.variant;

public {
  import std.datetime : DateTime;

  alias DbParam = Variant;
  import MySql = conquer.database.engine.mysql;
  import conquer.database.engine.databasemodel;
}

auto getParams(size_t count) {
  return new DbParam[count];
}
