module conquer.database.dal.world.players;

import conquer.database.engine;
import conquer.database.models;

/**
* Updates the login for a client.
* Params:
*   accountId = The account id.
*   serverId =  The server id.
*   clientId =  The client id.
*/
void updateLogin(uint accountId, uint serverId, uint clientId) {
  auto sql = "SELECT * FROM `cq_players` WHERE `accountId` = ? AND `serverId` = ?";
  auto params = getParams(2);
  params[0] = accountId;
  params[1] = serverId;

  if (MySql.exists(sql, params, MySql.worldDbConnectionString)) {
    params[0] = clientId;
    params[1] = accountId;

    sql = "UPDATE `cq_players` SET `lastClientId` = ? WHERE `accountId` = ?";
  }
  else {
    params = getParams(3);
    params[0] = accountId;
    params[1] = clientId;
    params[2] = serverId;

    sql = "INSERT INTO `cq_players` (`accountId`, `lastClientId`, `serverId`) VALUES (?, ?, ?)";
  }

  MySql.execute(sql, params, MySql.worldDbConnectionString);
}
