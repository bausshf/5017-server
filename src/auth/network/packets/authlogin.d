module conquer.auth.network.packets.authlogin;

import conquer.network : AuthClient, NetworkPacket;
import conquer.security : decryptRc5;
import conquer.database : authenticate, getServer, updateLogin;
import conquer.enums;
import conquer.auth.network.packets.authresponse;
import conquer.core : playerIds;

/// Packet: AuthLogin - 1051
final class AuthLogin : NetworkPacket {
  final:
  private:
  /// The account.
  string _account;
  /// The password.
  string _password;
  /// The server.
  string _server;

  /**
  * Creates a new auth login packet.
  * Params:
  *   buffer =  The buffer.
  */
  this(ubyte[] buffer) {
    super(buffer);

    _account = readString(16);
    auto passwordBuffer = readBuffer(16);
    _password = decryptRc5(passwordBuffer);
    _server = readString(16);
  }

  public:
  @property {
    /// Gets the account.
    auto account() { return _account; }

    /// Gets the password.
    auto password() { return _password; }

    /// Gets the server.
    auto server() { return _server; }
  }

  static:
  /**
  * Handles the auth login packet.
  * Params:
  *   client =  The client.
  *   buffer =  The buffer.
  */
  void handle(AuthClient client, ubyte[] buffer) {
    auto packet = new AuthLogin(buffer);
    uint accountId;
    auto status = authenticate(packet.account, packet.password, accountId);
    auto server = getServer(packet.server);

    if (status != AuthStatus.ready || !server) {
      client.send(new AuthResponse(1000000, status, "10.0.0.0", 9001));
      return;
    }

    auto clientId = playerIds.get();
    updateLogin(accountId, server.id, clientId);

    client.send(new AuthResponse(clientId, status, server.ip, server.port));
  }
}
