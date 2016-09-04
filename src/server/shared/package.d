module conquer;

public {
  import conquer.debugging;
  import conquer.network;
}

import vibe.d : logInfo;

/// Entry point ...
shared static this() {
  logCall();

  version (AUTH_SERVER) {
    import conquer.auth;
  }
  else version (WORLD_SERVER) {
    import conquer.world;
  }

  beforeLoad();
  // TODO: load data ...
  afterLoad();

  openServer(&run);
}
