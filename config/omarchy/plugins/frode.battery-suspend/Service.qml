import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import Quickshell.Wayland

// Suspends the machine after 15 minutes of idle, but only while on battery.
// omarchy's own idle service only starts the screensaver and locks; nothing
// suspends on idle, so on battery the laptop otherwise stays up until the lid
// is closed.
//
// The condition is a binding rather than a one-shot timeout, so pulling the
// power cord while already idle suspends too. After a resume the monitor stays
// idle until there is input, so the binding does not flip and there is no
// suspend loop. omarchy's sleep inhibitor locks the screen before suspend.
Item {
  id: root

  // Fixed at load: changing an IdleMonitor's timeout on a running shell left
  // omarchy's own monitor dead until the shell was restarted.
  readonly property int timeoutSeconds: 900
  readonly property bool shouldSuspend: idleMonitor.isIdle && UPower.onBattery

  function log(message) {
    console.log("battery-suspend " + new Date().toISOString() + " " + message)
  }

  onShouldSuspendChanged: {
    if (!shouldSuspend) return
    if (suspendProcess.running) return
    log("idle on battery, suspending")
    suspendProcess.running = true
  }

  IdleMonitor {
    id: idleMonitor
    timeout: root.timeoutSeconds
    respectInhibitors: true
    onIsIdleChanged: root.log(isIdle ? "idle" : "active")
  }

  // The stay-awake file is omarchy's "Stay awake" toggle; it turns off the
  // screensaver and lock, so it should hold off suspend as well.
  Process {
    id: suspendProcess
    command: ["bash", "-c", "if [[ -f $HOME/.local/state/omarchy/indicators/stay-awake ]]; then echo stay-awake; else systemctl suspend; fi"]
    stdout: SplitParser {
      onRead: function(line) { root.log("skipped: " + line) }
    }
    onExited: function(exitCode) { root.log("suspend exitCode=" + exitCode) }
  }

  Component.onCompleted: log("ready timeout=" + timeoutSeconds + " onBattery=" + UPower.onBattery)
}
