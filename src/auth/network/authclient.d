module conquer.auth.network.authclient;

import cheetah;

import conquer.security.auth.servercryptographer;
import conquer.network.networkclient;

/// Wrapper for the auht client.
class AuthClient : NetworkClient {
  private:
  /// The socket client.
  SocketClient!AuthClient _socketClient;

  public:
  /**
  * Creates a new auth client.
  * Params:
  *   socketClient =  The associated socket client.
  */
  this(SocketClient!AuthClient socketClient) {
    crypto = new ServerCryptographer;
    _socketClient = socketClient;
  }

  @property {
    /// Gets the socket client.
    auto socketClient() { return _socketClient; }
  }

  /// Aliasing the auth client to the socketClient property, allowing direct calls to it.
  alias socketClient this;
}
