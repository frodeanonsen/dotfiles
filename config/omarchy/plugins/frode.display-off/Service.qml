import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

// Turns the displays off after 5 minutes of idle, in place of omarchy's
// screensaver. The screensaver runs a ttfx animation in a terminal on every
// monitor, which keeps the CPU and GPU busy enough to spin up the fans, so
// the screensaver is switched off (`omarchy toggle screensaver`, done by
// scripts/bootstrap_omarchy.sh) and this blanks the screens at the time it
// would have started. omarchy's own idle service still locks at idle.lock.
//
// Hyprland lights the displays again on the first key press or mouse move
// (key_press_enables_dpms and mouse_move_enables_dpms in omarchy's defaults);
// the explicit `on` covers wake-ups that arrive another way. Idle inhibitors
// (video playback) hold the blanking off, and so does omarchy's "Stay awake"
// toggle, which this checks the same way frode.battery-suspend does.
Item {
  id: root

  // Fixed at load: changing an IdleMonitor's timeout on a running shell left
  // omarchy's own monitor dead until the shell was restarted.
  readonly property int timeoutSeconds: 300

  function log(message) {
    console.log("display-off " + new Date().toISOString() + " " + message)
  }

  IdleMonitor {
    id: idleMonitor
    timeout: root.timeoutSeconds
    respectInhibitors: true
    onIsIdleChanged: {
      root.log(isIdle ? "idle, displays off" : "active, displays on")
      if (isIdle) offProcess.running = true
      else onProcess.running = true
    }
  }

  Process {
    id: offProcess
    command: ["bash", "-c", "if [[ -f $HOME/.local/state/omarchy/indicators/stay-awake ]]; then echo stay-awake; else omarchy-brightness-display off; fi"]
    stdout: SplitParser {
      onRead: function(line) { root.log("skipped: " + line) }
    }
    onExited: function(exitCode) { root.log("off exitCode=" + exitCode) }
  }

  Process {
    id: onProcess
    command: ["bash", "-c", "omarchy-brightness-display on"]
    onExited: function(exitCode) { root.log("on exitCode=" + exitCode) }
  }

  Component.onCompleted: log("ready timeout=" + timeoutSeconds)
}
