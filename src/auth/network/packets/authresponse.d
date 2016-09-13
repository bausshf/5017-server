module conquer.auth.network.packets.authresponse;

import conquer.network : NetworkPacket;
import conquer.enums;

final class AuthResponse : NetworkPacket {
  final:
  private:
  uint _clientId;
  AuthStatus _status;
  string _ip;
  ushort _port;

  public:
  this(uint clientId, AuthStatus status, string ip, ushort port) {
    super(52, 1055);

    _clientId = clientId;
    _status = status;
    _ip = ip;
    _port = port;
  }

  @property override ubyte[] finalize() {
    write(_clientId);
    write!uint(_status);
    writeString!false(_ip);
    seekWrite(28);
    write(_port);

    return super.finalize;
  }
}
