module conquer.debugging.logging;

// TODO: add log settings etc ...

import std.stdio;
import std.string : format;

import conquer.core : EmptyArray, settings;

/// The call stack of the current thread.
private shared string[] callStack = EmptyArray!string;

/**
* Logs a call into the call stack.
* Params:
*   DO NOT MODIFY THESE.
*/
void logCall(string file = __FILE__, size_t line = __LINE__, string mod = __MODULE__, string func = __PRETTY_FUNCTION__) {
  // TODO: Make sure the call stack doesn't have unlimited entries ...
  // TODO: Use concurrent message pipes ...
  // If possible std.concurrency, use that, else vibe.d's
  // if (settings && settings.logCalls) {
     callStack ~= format("module: '%s', file: '%s' line: '%s' function: '%s'", mod, file, line, func);
  // }
}

/// Clears the call stack.
void clearCallStack() {
  callStack = EmptyArray!string;
}

/// Prints the call stack.
void printCallStack() {
  foreach (call; callStack) {
    log(call);
  }
}

/**
* Prints a line of data.
* Params:
*   data =  The data to print.
*/
void log(T...)(T data) {
  writeln(data);
}

/**
* Prints a formatted line.
* Params:
*   msg = The formatted message.
*   args =  The arguments to format.
*/
void logf(T...)(string msg, T args) {
  writefln(msg, args);
}

/**
* Prints a line of data, when compiling with verbose.
* Params:
*   data =  The data to print.
*/
void logv(T...)(T data) {
  // if (settings && settings.verbose) {
  //   log(data);
  // }
}

/**
* Prints a formatted line, when compiling with verbose.
* Params:
*   msg = The formatted message.
*   args =  The arguments to format.
*/
void logvf(T...)(string msg, T args) {
  // if (settings && settings.verbose) {
  //   logf(msg, args);
  // }
}
