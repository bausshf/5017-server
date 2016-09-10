module conquer.auth.network.packets.authlogin;

import conquer.network;
import conquer.security : decryptRc5;

/// Packet: AuthLogin - 1051
class AuthLogin : NetworkPacket {
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

    import vibe.d : logInfo;

    import conquer.database : getAccount;
    auto account = getAccount(packet.account);

    // TODO: hash password ...
    // TODO: send response back to client ...
    if (account && account.password == packet.password) {
      logInfo("LOGIN_OK");
    }
    else {
      logInfo("LOGIN_INVALID");
    }
  }
}
