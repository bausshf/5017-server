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
  /**
  * Creates a new auth login packet.
  * Params:
  *   buffer =  The buffer.
  */
  this(ubyte[] buffer) {
    super(buffer);

    account = readString(16);
    auto passwordBuffer = readBuffer(16);
    password = decryptRc5(passwordBuffer);
    server = readString(16);
  }

  public:
  /// The account.
  immutable(string) account;
  /// The password.
  immutable(string) password;
  /// The server.
  immutable(string) server;

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
