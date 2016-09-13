module conquer.database.dal.auth.servers;

import conquer.database.engine;
import conquer.database.models;

private DbServer[string] _serverCache;

/**
* Gets a server based on its name.
* Params:
*   serverName = The server name.
* Returns: The database record model.
*/
auto getServer(string serverName) {
  if (serverName in _serverCache) {
    return _serverCache[serverName];
  }

  auto params = getParams(1);
  params[0] = serverName;

  auto server = MySql.readSingle!DbServer("SELECT * FROM `cq_servers` WHERE `name` = ?", params);

  _serverCache[serverName] = server;

  return server;
}
