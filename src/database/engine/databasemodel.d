module conquer.database.engine.databasemodel;

import std.variant;
/// Alias to give Variant a better name.
alias DbParam = Variant;

public {
  import std.conv : to;
  import mysql.result;
  import std.datetime : DateTime;
}

private {
	import conquer.database.models;

	/// Member information struct.
	struct MemberInfo {
		/// The type.
		string type;
		/// The name.
		string name;
	}

	/// Gets member names of a specific type.
	auto getMemberNames(T)() @safe pure {
		string[] members;

		foreach (derived; __traits(derivedMembers, T)) {
			members ~= derived;
		}

		return members;
	}

	/// Gets members of a specific type.
	auto getMembers(T)() @safe pure {
		import std.traits : Fields;
		MemberInfo[] members;

		foreach (fieldType; Fields!T) {
			members ~= MemberInfo(fieldType.stringof, "");
		}

		auto derived = getMemberNames!T;

		foreach (i; 0 .. derived.length) {
			if (derived[i][0] != '_') {
				members[i].name = derived[i];
			}
		}

		return members;
	}

	/**
	* Mixin template for retrieving database row retriements.
	* Params:
	*	T =			The model type.
	*	members =	The members.
	*/
	mixin template Retrieve(T, MemberInfo[] members) {
		import std.traits;

		/// Gets nullable checks.
		auto getIsNullable() @safe {
			auto retrieveString = "enum bool[string] nullableChecks = [";
			foreach (member; members) {
				retrieveString ~= format("\"%s\" : hasUDA!(%s.%s, DbNull),", member.name, T.stringof, member.name);
			}

			retrieveString.length -= 1;

			return retrieveString ~ "];";
		}

		mixin(getIsNullable);

		/// Gets all retrievements.
		auto getRetrieves() @safe {
			string retrieveString;

			foreach (member; members) {
				if (nullableChecks[member.name]) {
					retrieveString ~= format("model.%s = retrieve!(%s, true);", member.name, member.type);
				}
				else {
					retrieveString ~= format("model.%s = retrieve!%s;", member.name, member.type);
				}
			}

			return retrieveString;
		}

		/// Handles the retrieves.
		void handle() @system {
			mixin(getRetrieves);
		}
	}
}

/// Attribute for marking a field as db null.
struct DbNull { }

/// Interface for database models.
interface IDatabaseModel { }

/// A wrapper around a database model for usage with readSingle() and readMany().
class DatabaseModel(T) : IDatabaseModel {
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
  T retrieve(T, bool nullable = false)(size_t column) @system {
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
  T retrieve(T, bool nullable = false)() @system {
    auto value = retrieve!(T, nullable)(_index);
    _index++;
    return value;
  }

  public:
  /// Fills the model.
  final void fill() @system {
    internalFill(cast(T)this);
  }

  /**
  *	Internally fills the model.
  *	Params:
  *		model =	The model to fill.
  */
  private void internalFill(T model) @system {
    import std.string : format;

    enum members = getMembers!T;
    mixin Retrieve!(T, members);
    handle();
  }
}
