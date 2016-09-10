module conquer.database.engine.databasemodel;

import std.variant;
/// Alias to give Variant a better name.
alias DbParam = Variant;

public {
  import std.conv : to;
  import mysql.result;
}

/// A wrapper around a database model for usage with readSingle() and readMany().
class DatabaseModel {
  private:
  /// The assocaited row.
  Row _row;
  /// The retrieve index.
  size_t _index;

  protected:
  /**
  *	Creates a new instance of the database model.
  *	Params:
  *		row =	The row to fill with.
  */
  this(Row row) {
    _row = row;
  }

  /**
  *	Retrieves a value from the row.
  *	Nullable should be set to true for all values that can become null.
  *	Params:
  *		column =	The column to retrieve the value from.
  *	Returns:
  *		The value retrieved.
  */
  T retrieve(T, bool nullable = false)(size_t column) {
    static if (nullable) {
      return _row.isNull(column) ? T.init : _row[column].get!T;
    }
    else {
      return _row[column].get!T;
    }
  }

  /**
  *	Retrieves a value from the row.
  *	Nullable should be set to true for all values that can become null.
  *
  *	Returns:
  *		The value retrieved.
  */
  T retrieve(T, bool nullable = false)() {
    auto value = retrieve!(T, nullable)(_index);
    _index++;
    return value;
  }

  public:
  /// Fills the model.
  void fill() {
    throw new Exception("fill() must be override.");
  }
}
