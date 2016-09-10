module conquer.network.packethandler;

/// Wrapper for a packet handler.
struct PacketHandler {
  /// The name of the packethandler.
  string name;
  /// The packet type.
  ushort type;
}

/// Source format for the packet handler call.
enum packetSource = q{
  import __MODULE_NAME__;
  case __TYPE__: __NAME__.handle(client, buffer); break;
};

/// Source format for the actual packet handler.
enum handlerSource = q{
  import conquer.network.server : Client;

  void handlePacket(Client client, ushort packetType, ubyte[] buffer) {
    switch (packetType) {
      __HANDLERS__

      default: {
        import vibe.d : logInfo;
        import std.conv : to;
        logInfo("Unknown packet: " ~ to!string(packetType));
        break;
      }
    }
  }
};

/**
* Registers packet handlers.
* Params:
*   namespace =       A shared namespace for all packet handlers.
*   packetHandlers =  The packet handlers to register.
*/
mixin template RegisterPacketHandlers(string namespace, PacketHandler[] packetHandlers) {
  @property auto getSource() {
    import std.array : replace, join, split;
    import std.conv : to;

    auto source = "";

    foreach (handler; packetHandlers) {
      auto namePath = handler.name.split(".");

      source ~= packetSource
        .replace("__MODULE_NAME__", namespace ~ "." ~ namePath[0])
        .replace("__TYPE__", to!string(handler.type))
        .replace("__NAME__", namePath[1]);
    }

    return handlerSource.replace("__HANDLERS__", source);
  }

  mixin(getSource);
}
