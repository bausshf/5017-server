module conquer.auth;

import conquer.debugging;

public {
  import conquer.auth.network;
}

/// Function called before the server has loaded.
void beforeLoad() {
  logCall();

  log("Started Conquer Online - Auth ...");
}

/// Function called after the server has loaded.
void afterLoad() {
  logCall();

  log("Loaded Conquer Online - Auth ...");
}

/// Function called when the server starts running.
void run() {
  logCall();

  log("Running Conquer Online - Auth ...");
}
