module conquer.network.server;

import vibe.core.net : listenTCP;
import vibe.d : logInfo;

import conquer.network.client;
import conquer.debugging;

// TODO: Read from some configuration file ...

/// The IP of the server.
private shared auto serverIP = "192.168.8.100";

version (AUTH_SERVER) {
  /// The port of the auth server.
  private shared ushort serverPort = 9958;
}
else version (WORLD_SERVER) {
  /// The port of the world server.
  private shared ushort serverPort = 5817;
}

/// Opens the server.
void openServer(void function() onRun) {
  logCall();

  if (onRun) {
    onRun();
  }
  
  listenTCP(serverPort, (connection) {
    logCall();

    // TODO: error/connection validation ...
    auto client = new Client(connection);

    log("Received a connection ...");

    client.process();
  });
}
