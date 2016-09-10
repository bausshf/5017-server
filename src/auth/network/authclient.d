module conquer.auth.network.authclient;

import conquer.security.auth.servercryptographer;
import conquer.network.networkclient;

/// Wrapper for the auht client.
class AuthClient : NetworkClient {
  public:
  /// Creates a new auth client.
  this() {
    crypto = new ServerCryptographer;
  }
}
