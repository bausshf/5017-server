module conquer.auth.network.packethandler;

import conquer.network.packethandler;

// Registers packet handlers ...
mixin RegisterPacketHandlers!("conquer.auth.network.packets", [
  PacketHandler("authlogin.AuthLogin", 1051)
]);
