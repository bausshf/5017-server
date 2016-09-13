module conquer;

public {
  import conquer.debugging;
  import conquer.core;
  import conquer.network;
  import conquer.security;
  import conquer.database;

  version (AUTH_SERVER) {
    import conquer.auth;
  }
  else version (WORLD_SERVER) {
    import conquer.world;
  }
}

import vibe.d : logInfo;

/// Entry point ...
shared static this() {
  logCall();

  beforeLoad();
  // TODO: load data ...
  afterLoad();

  openServer(&run);
}
