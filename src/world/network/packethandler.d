module conquer.world.network.packethandler;

import conquer.network.packethandler;

// Registers packet handlers ...
mixin RegisterPacketHandlers!("conquer.world.network.packets", [
  // TODO: other packets here ...
]);
