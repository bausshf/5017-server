module conquer.world.network.gameclient;

import cheetah;

import conquer.network : NetworkPacket, NetworkClient;

/// Wrapper for the game client.
class GameClient : NetworkClient {
  private:
  /// The socket client.
  SocketClient!GameClient _socketClient;

  public:
  /**
  * Creates a new game client.
  * Params:
  *   socketClient =  The associated socket client.
  */
  this(SocketClient!GameClient socketClient) {
    // crypto = new ServerCryptographer;
    _socketClient = socketClient;
  }

  @property {
    /// Gets the socket client.
    auto socketClient() const { return _socketClient; }
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
      _socketClient.write(buffer);
    }
  }
}
