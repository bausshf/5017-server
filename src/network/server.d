module conquer.network.server;
import cheetah;

import conquer.debugging;
import conquer.network.handlers;

// TODO: Read from some configuration file ...

/// The IP of the server.
private shared auto serverIP = "192.168.8.100";

version (AUTH_SERVER) {
  /// The port of the auth server.
  private shared ushort serverPort = 9958;

  public import conquer.auth.network.authclient : AuthClient;

  /// Alias for the client.
  public alias Client = AuthClient;
}
else version (WORLD_SERVER) {
  /// The port of the world server.
  private shared ushort serverPort = 5816;

  public import conquer.auth.network.gameclient : GameClient;

  /// Alias for the client.
  public alias Client = GameClient;
}

/**
* Opens the server.
* Params:
*   onRun = Function to run when the server runs.
*/
void openServer(void function() onRun) {
  auto server = new SocketServer!Client(serverIP, serverPort);

  server.attach(SocketEventType.connect, new SocketEvent!Client(&onConnect));
  server.attach(SocketEventType.receive, [
    new SocketEvent!Client(&onReceiveHead),
    new SocketEvent!Client(&onReceiveBody)
  ]);
  server.attach(SocketEventType.disconnect, new SocketEvent!Client(&onDisconnect));
  server.attach(SocketEventType.error, new SocketEvent!Client(&onError));

  server.copyReceiveEvents = true;

  if (onRun) {
    onRun();
  }

  server.start();
}
