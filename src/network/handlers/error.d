module conquer.network.handlers.error;

import cheetah;

import conquer.network.server;

/// Handling errors
void onError(SocketEventArgs!Client e) {
  import conquer.database.engine;
  auto sql = "INSERT INTO `cq_crashlog` (`source`, `message`, `timestamp`) VALUES (?, ?, NOW())";
  auto params = getParams(2);

  if (e.client) {
    params[0] = "client";

    e.client.close();
  }
  else if (e.server) {
    params[0] = "server";

    e.server.stop();
  }


  params[1] = e.error.toString();
  MySql.execute(sql, params, MySql.logDbConnectionString);
}
