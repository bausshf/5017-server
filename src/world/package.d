module conquer.world;

import conquer.debugging;

public {
  import conquer.world.network;
}

/// Function called before the server has loaded.
void beforeLoad() {
  logCall();

  log("Started Conquer Online - World ...");
}

/// Function called after the server has loaded.
void afterLoad() {
  logCall();

  log("Loaded Conquer Online - World ...");
}

/// Function called when the server starts running.
void run() {
  logCall();

  log("Running Conquer Online - World ...");
}
