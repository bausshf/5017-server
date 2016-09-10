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

private enum connectionStringFormat = "host=%s;port=3306;user=%s;pwd=%s;db=%s";

// TODO: Load from config ...
private enum _authDbConnectionString = connectionStringFormat.format("127.0.0.1", "root", "1234", "cq_auth");

private string _worldDbConnectionString = connectionStringFormat.format("127.0.0.1", "root", "1234", "cq_world");

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
}

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
*	Executes a single sql read.
*	Params:
*		sql =				The sql query.
*		params = 			The parameters.
*		connectionString =	The connection string (Will default to auth or world db)
*	Returns:
*		The model of the first row read.
*/
T readSingle(T : DatabaseModel)(string sql, DbParam[] params, string connectionString = null) {
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
auto readMany(T : DatabaseModel)(string sql, DbParam[] params, string connectionString = null) {
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

  // Executes the statement ...
  return cmd.execPreparedResult().map!((row) {
    auto result = new T(row);
    result.fill();
    return result;
  });
}
