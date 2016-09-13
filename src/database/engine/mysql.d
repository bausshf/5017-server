module conquer.database.engine.mysql;

import std.variant;
import std.traits : hasMember;
import std.algorithm : map;

import vibe.d;

import mysql.db;
import mysql.protocol.commands;

import conquer.database.engine.databasemodel;

/// Alias for Variant to give the name more meaning.
alias DbParam = Variant;

/// The connection string format.
private enum connectionStringFormat = "host=%s;port=3306;user=%s;pwd=%s;db=%s";

// TODO: Load from config ...
/// The auth db connection string.
private enum _authDbConnectionString = connectionStringFormat.format("127.0.0.1", "root", "1234", "cq_auth");

/// The world db connection string.
private enum _worldDbConnectionString = connectionStringFormat.format("127.0.0.1", "root", "1234", "cq_world");

/// The log db connection string.
private enum _logDbConnectionString = connectionStringFormat.format("127.0.0.1", "root", "1234", "cq_log");

version (AUTH_SERVER) {
  private alias _defaultConnectionString = _authDbConnectionString;
}
else version (WORLD_SERVER) {
  private alias _defaultConnectionString = _worldDbConnectionString;
}

@property {
  /// Gets the connection string to auth db.
  auto authDbConnectionString() {
    return _authDbConnectionString;
  }

  /// Gets the connection string to world db.
  auto worldDbConnectionString() {
    return _worldDbConnectionString;
  }

  /// Gets the connection string to log db.
  auto logDbConnectionString() {
    return _logDbConnectionString;
  }
}

/// CTFE string for mixin MySql connection setup.
private enum MySqlConnectionSetup = q{
	// Setup connection string ...
	if (!connectionString) {
		connectionString = _defaultConnectionString;
	}

	// Setup MySql connection ...
	import mysql.db;
	auto mdb = new MysqlDB(connectionString);
	auto c = mdb.lockConnection();
	scope(exit) c.close();

	// Prepare the command ...
	auto cmd = new Command(c, sql);
	cmd.prepare();

	// Binds the parameters ...
	cmd.bindParameters(params);
};

/**
*	Executes an sql statement.
*	Params:
*		sql =				The sql query.
*		params = 			The parameters.
*		connectionString =	The connection string (Will default to auth or world db)
*	Returns:
*		The amount of rows affected.
*/
ulong execute(string sql, DbParam[] params, string connectionString = null) {
  // Setsup the mysql connection
  mixin(MySqlConnectionSetup);

  // Executes the statement ...
  ulong affectedRows;
  cmd.execPrepared(affectedRows);

  return affectedRows;
}

/**
*	Executes a scalar sql statement.
*	Params:
*		sql =				The sql query.
*		params = 			The parameters.
*		connectionString =	The connection string (Will default to auth or world db)
*	Returns:
*		The value of the statement.
*/
T scalar(T)(string sql, DbParam[] params, string connectionString = null) {
  // Setsup the mysql connection
  mixin(MySqlConnectionSetup);

  // Executes the statement ...
  auto rows = cmd.execPreparedResult();

  // Checks whether there's a result ...
  if (!rows.length) {
    return T.init;
  }

  // Resturns the first column selected of the first row ...
  return to!T(rows[0][0]);
}

/**
*	Validates whether a row is selected from the query or not.
*	Params:
*		sql =				The sql query.
*		params = 			The parameters.
*		connectionString =	The connection string (Will default to auth or world db)
*	Returns:
*		True if the row exists, false otherwise.
*/
bool exists(string sql, DbParam[] params, string connectionString = null) {
  mixin(MySqlConnectionSetup);

  // Executes the statement ...
  auto rows = cmd.execPreparedResult();

  // Checks whether there's a result ...
  return cast(bool)rows.length;
}

/**
*	Executes a single sql read.
*	Params:
*		sql =				The sql query.
*		params = 			The parameters.
*		connectionString =	The connection string (Will default to auth or world db)
*	Returns:
*		The model of the first row read.
*/
T readSingle(T : IDatabaseModel)(string sql, DbParam[] params, string connectionString = null) {
  // Setsup the mysql connection
  mixin(MySqlConnectionSetup);

  // Executes the statement ...
  auto rows = cmd.execPreparedResult();

  // Checks whether there's a result ...
  if (!rows.length) {
    return T.init;
  }

  // Returns the first row and fills the model ...
  auto row = new T(rows[0]);
  row.fill();
  return row;
}

/**
*	Executes a multi sql read.
*	Params:
*		sql =				The sql query.
*		params = 			The parameters.
*		connectionString =	The connection string (Will default to auth or world db)
*	Returns:
*		A range filled models with the rows returned by the sql read.
*/
auto readMany(T : IDatabaseModel)(string sql, DbParam[] params, string connectionString = null) {
  // Setsup the mysql connection
  mixin(MySqlConnectionSetup);

  // Executes the statement ...
  return cmd.execPreparedResult().map!((row) {
    auto result = new T(row);
    result.fill();
    return result;
  });
}
