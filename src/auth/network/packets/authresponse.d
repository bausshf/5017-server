module conquer.auth.network.packets.authresponse;

import conquer.network : NetworkPacket;
import conquer.enums;

/// Packet: AuthResponse - 1055
final class AuthResponse : NetworkPacket {
  final:
  private:
  /// The client id.
  immutable(uint) _clientId;

  /// The status.
  immutable(AuthStatus) _status;

  /// The ip.
  immutable(string) _ip;

  /// The port.
  immutable(ushort) _port;

  public:
  /**
  * Creates a new auth response packet.
  * Params:
  *   clientId =  The client id.
  *   status =    The status.
  *   ip =        The ip.
  *   port =      The port.
  */
  this(uint clientId, AuthStatus status, string ip, ushort port) {
    super(52, 1055);

    _clientId = clientId;
    _status = status;
    _ip = ip;
    _port = port;
  }

  /// Finalizes the packet.
  @property override ubyte[] finalize() {
    write(_clientId);
    write!uint(_status);
    writeString!false(_ip);
    seekWrite(28);
    write(_port);

    return super.finalize;
  }
}
