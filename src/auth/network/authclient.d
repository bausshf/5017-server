module conquer.auth.network.authclient;

import cheetah;

import conquer.security : ServerCryptographer;
import conquer.network : NetworkPacket, NetworkClient;

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

  /**
  * Sends a packet to the client.
  * Params:
  *   packet =  The packet to send.
  */
  void send(NetworkPacket packet) {
    send(packet.finalize);
  }

  /**
  * Sends a buffer to the client.
  * Params:
  *   buffer =  The buffer to send.
  */
  void send(ubyte[] buffer) {
    synchronized {
      crypto.encrypt(buffer);
      socketClient.write(buffer);
    }
  }

  /// Aliasing the auth client to the socketClient property, allowing direct calls to it.
  alias socketClient this;
}
