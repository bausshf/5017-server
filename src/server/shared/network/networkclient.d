module conquer.network.networkclient;

import std.traits : isInstanceOf;

import conquer.security.cryptographer;

/// Wrapper for a network client.
class NetworkClient {
  public:
  /// The size of the current packet.
  size_t packetSize;
  /// The type of the current packet.
  ushort packetType;
  /// The cryptographer to use for the client.
  Cryptographer crypto;
}
