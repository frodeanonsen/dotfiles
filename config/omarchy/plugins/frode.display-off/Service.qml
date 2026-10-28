import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland

// Turns the displays off after 15 minutes of idle, in place of omarchy's
// screensaver. The screensaver runs a ttfx animation in a terminal on every
// monitor, which keeps the CPU and GPU busy enough to spin up the fans, so
// the screensaver is switched off (`omarchy toggle screensaver`, done by
// scripts/bootstrap_omarchy.sh) and this blanks the screens at the time it
// would have started. omarchy's own idle service still locks at idle.lock.
//
// External monitors are disabled as outputs rather than blanked with dpms.
// The Samsung S27A850 on the HP USB-C to DP adapter drops its hotplug line
// about ten seconds after the link goes to sleep and then comes back, which
// Hyprland takes as a replug and powers the monitor on again; a disabled
// output ignores the replug and stays dark. The laptop panel is blanked with
// dpms as before. On activity the monitor rules are reloaded from the config,
// which re-enables the externals and moves their workspaces back, and only
// then is dpms turned on; the reload is skipped when nothing was disabled.
//
// A disabled output is still not enough for the Samsung on its own: with
// source detection on auto it woke itself every 5 minutes to probe for a
// signal (two hotplug drops 5 s apart, logged by the shell as a removal of
// DP-4), lighting up each time. Setting source detection to manual in the
// monitor's menu stopped that. Do not try to sleep it over DDC/CI instead:
// `ddcutil setvcp d6 4` blanks it, but it then answers no DDC, no modeset
// trains the link (amdgpu: "enabling link 1 failed") and a debugfs
// trigger_hotplug does nothing; only the power button wakes it.
//
// The idle monitor is input-only (respectInhibitors false) and inhibitors
// are checked by hand. With the lid closed the external is the only output,
// and disabling it leaves Hyprland with none; it then creates a headless
// FALLBACK output, drops the window focus and re-checks idle inhibitors.
// That re-check (Hyprland 0.56, CIdleNotifyProtocol::setInhibit) resets
// every inhibitor-obeying idle notification even when nothing inhibits, so
// the shell saw "resumed" 0.4 s after the disable and lit the monitor again,
// which would have repeated every 5 minutes. An input-only notification only
// resumes on a key or pointer event. When a window inhibits idle (video
// playback) the blanking is skipped and retried every minute while still
// idle, so it still happens once the video ends. omarchy's "Stay awake"
// toggle is checked the same way frode.battery-suspend does.
//
// An inhibitor only holds the displays on for an hour past the idle timeout;
// after that they are blanked regardless. A Home Assistant dashboard left open
// in Vivaldi inhibited idle all night (most likely its camera feeds count as
// video playback). The stay-awake toggle has no such limit. The same
// inhibitor keeps omarchy's idle service from locking at idle.lock, so a
// blanking past the limit locks the session too, before the outputs go away.
//
// A config reload re-applies the monitor rules and so re-enables a disabled
// external; theme-mode-auto's evening theme switch lit the monitor that way
// with nobody at it. While the displays are off, a reload makes this blank
// them again after a short wait, through the same inhibitor checks.
//
// Hyprland lights the displays again on the first key press or mouse move
// (key_press_enables_dpms and mouse_move_enables_dpms in omarchy's defaults);
// the explicit `on` covers wake-ups that arrive another way.
Item {
  id: root

  // Fixed at load: changing an IdleMonitor's timeout on a running shell left
  // omarchy's own monitor dead until the shell was restarted.
  readonly property int timeoutSeconds: 900
  readonly property int retrySeconds: 60
  readonly property int maxInhibitSeconds: 3600
  property double idleSince: 0
  // Set before each run, since the command binding does not see time pass.
  property bool inhibitorsExpired: false
  property bool blanked: false

  function log(message) {
    console.log("display-off " + new Date().toISOString() + " " + message)
  }

  IdleMonitor {
    id: idleMonitor
    timeout: root.timeoutSeconds
    respectInhibitors: false
    onIsIdleChanged: {
      root.log(isIdle ? "idle, displays off" : "active, displays on")
      retryTimer.stop()
      reblankTimer.stop()
      root.blanked = false
      if (isIdle) root.idleSince = Date.now()
      root.inhibitorsExpired = false
      if (isIdle) offProcess.running = true
      else onProcess.running = true
    }
  }

  // Re-tries the blanking while idle after it was skipped for an inhibitor
  // or the stay-awake toggle.
  Timer {
    id: retryTimer
    interval: root.retrySeconds * 1000
    repeat: false
    onTriggered: {
      if (!idleMonitor.isIdle) return
      root.inhibitorsExpired = Date.now() - root.idleSince >= root.maxInhibitSeconds * 1000
      offProcess.running = true
    }
  }

  Connections {
    target: Hyprland
    function onRawEvent(event) {
      if (event && event.name === "configreloaded" && root.blanked) reblankTimer.restart()
    }
  }

  // Gives the reload time to bring the outputs back before blanking again.
  Timer {
    id: reblankTimer
    interval: 2000
    repeat: false
    onTriggered: {
      if (!idleMonitor.isIdle || !root.blanked) return
      root.log("config reloaded while off, blanking again")
      root.blanked = false
      retryTimer.triggered()
    }
  }

  Process {
    id: offProcess
    command: ["bash", "-c", `
      if [[ -f $HOME/.local/state/omarchy/indicators/stay-awake ]]; then
        echo stay-awake
        exit 2
      fi
      if [[ $1 == expired ]]; then
        echo "inhibitors ignored after ${root.maxInhibitSeconds} s idle"
        if [[ $(omarchy-shell lock isLocked 2>/dev/null) != true ]]; then
          omarchy-system-lock && echo locked
          sleep 1
        fi
      elif hyprctl clients -j | jq -e 'any(.[]; .inhibitingIdle)' >/dev/null; then
        echo "inhibited by $(hyprctl clients -j | jq -r '[.[] | select(.inhibitingIdle) | .class] | unique | join(" ")')"
        exit 2
      fi
      state="$XDG_RUNTIME_DIR/display-off-disabled"
      externals=$(hyprctl monitors -j | jq -r '.[] | select(.disabled | not) | select(.name | test("^(eDP|LVDS|DSI)-") | not) | .name')
      for m in $externals; do
        hyprctl eval "hl.monitor({ output = \\"$m\\", disabled = true })" >/dev/null && echo "disabled $m" && echo "$m" >>"$state"
      done
      omarchy-brightness-display off
    `, "display-off", root.inhibitorsExpired ? "expired" : ""]
    stdout: SplitParser {
      onRead: function(line) { root.log("off: " + line) }
    }
    onExited: function(exitCode) {
      root.log("off exitCode=" + exitCode)
      root.blanked = exitCode === 0 && idleMonitor.isIdle
      if (exitCode === 2 && idleMonitor.isIdle) retryTimer.restart()
    }
  }

  Process {
    id: onProcess
    command: ["bash", "-c", `
      state="$XDG_RUNTIME_DIR/display-off-disabled"
      if [[ -f $state ]]; then
        echo "re-enabling $(tr '\\n' ' ' <"$state")"
        rm -f "$state"
        hyprctl reload >/dev/null
        sleep 2
      fi
      omarchy-brightness-display on
    `]
    stdout: SplitParser {
      onRead: function(line) { root.log("on: " + line) }
    }
    onExited: function(exitCode) { root.log("on exitCode=" + exitCode) }
  }

  Component.onCompleted: log("ready timeout=" + timeoutSeconds + " externals=disable inhibitors=manual retry=" + retrySeconds + " maxInhibit=" + maxInhibitSeconds)
}
