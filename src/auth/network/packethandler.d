module conquer.auth.network.packethandler;

import conquer.network.packethandler;

mixin RegisterPacketHandlers!("conquer.auth.network.packets", [
  PacketHandler("authlogin.AuthLogin", 1051)
  // TODO: other packets here ...
]);
