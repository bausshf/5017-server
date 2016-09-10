module conquer.network.handlers.error;

import vibe.d : logInfo;

import cheetah;

import conquer.network.server;

/// Handling errors
void onError(SocketEventArgs!Client e) {
  logInfo("Error: " ~ e.error.toString());

  if (e.client) {
    e.client.close();
  }
  else if (e.server) {
    e.server.stop();
  }
}
