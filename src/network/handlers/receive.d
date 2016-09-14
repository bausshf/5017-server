module conquer.network.handlers.receive;

import vibe.d : logInfo;

import cheetah;

import conquer.network.server;

/// Handling receive for the packet head
void onReceiveHead(SocketEventArgs!Client e) {
  auto client = e.client;

  client.read(4 - e.currentReceiveAmount);

  if (e.currentReceiveAmount >= 4) {
    auto buffer = e.buffer;
    client.data.crypto.decrypt(buffer);

    auto ptr = buffer.ptr;

    client.data.packetSize = (*cast(ushort*)(ptr));
    client.data.packetType = (*cast(ushort*)(ptr + 2));

    e.resetReceive(e.currentReceiveAmount);
    client.moveNext(SocketEventType.receive);
  }
}

/// Handling receive for the packet body
void onReceiveBody(SocketEventArgs!Client e) {
  auto client = e.client;

  client.read(client.data.packetSize - e.currentReceiveAmount);

  if (e.currentReceiveAmount >= client.data.packetSize) {
    auto buffer = e.buffer[4 .. client.data.packetSize];

    client.data.crypto.decrypt(buffer);

    version (AUTH_SERVER) {
      import conquer.auth.network : handlePacket;
    }
    else version (WORLD_SERVER) {
      import conquer.world.network : handlePacket;
    }

    handlePacket(client.data, client.data.packetType, e.buffer[0 .. client.data.packetSize]);

    e.resetReceive(e.currentReceiveAmount - client.data.packetSize);
    client.moveNext(SocketEventType.receive);
  }
}
