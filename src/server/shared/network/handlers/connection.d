module conquer.network.handlers.connection;

import vibe.d : logInfo;

import cheetah;

import conquer.network.server : Client;

/// Handling connections
void onConnect(SocketEventArgs!Client e) {
  logInfo("A client has connected ...");

  e.client.data = new Client(e.client);
}

/// Handling disconnections
void onDisconnect(SocketEventArgs!Client e) {
  logInfo("A client has disconnected ...");
}
