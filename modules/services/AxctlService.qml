pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property var focusedMonitor: null
    property var focusedWorkspace: null
    property var focusedClient: null

    property QtObject clients: QtObject {
        property var values: []
    }

    property QtObject monitors: QtObject {
        property var values: []
    }

    property QtObject workspaces: QtObject {
        property var values: []
    }

    signal rawEvent(var event)

    function dispatch(command) {
        if (!command) return;

        let spaceIdx = command.indexOf(' ');
        let action = spaceIdx !== -1 ? command.substring(0, spaceIdx).trim() : command.trim();
        let rawArgs = spaceIdx !== -1 ? command.substring(spaceIdx + 1).trim() : "";

        let getAddr = (str) => {
            let m = str.match(/address:([^\s,]+)/);
            return m ? m[1] : str.trim();
        };

        let cmdArgs = [];

        if (action === "workspace") {
            cmdArgs = ["workspace", "switch", rawArgs];
        } else if (action === "closewindow") {
            cmdArgs = ["window", "close", getAddr(rawArgs)];
        } else if (action === "focuswindow") {
            cmdArgs = ["window", "focus", getAddr(rawArgs)];
        } else if (action === "movetoworkspacesilent") {
            let subParts = rawArgs.split(',');
            cmdArgs = ["window", "move-to-workspace-silent", subParts[0].trim()];
            if (subParts.length > 1) {
                cmdArgs.push(getAddr(subParts[1]));
            }
        } else if (action === "togglespecialworkspace") {
            cmdArgs = ["workspace", "toggle-special"];
            if (rawArgs) cmdArgs.push(rawArgs);
        } else {
            cmdArgs = ["system", "execute", "hyprctl dispatch " + command];
        }

        let finalCommand = ["axctl"].concat(cmdArgs.filter(x => x !== "" && x !== undefined));
        
        let proc = Qt.createQmlObject('import Quickshell.Io; Process {}', root);
        proc.command = finalCommand;
        proc.onExited.connect(() => proc.destroy());
        proc.running = true;
    }

    function monitorFor(screen) {
        if (!screen) return null;
        let screenName = screen.name || screen;
        let values = root.monitors.values || [];
        for (let i = 0; i < values.length; i++) {
            if (values[i].name === screenName) return values[i];
        }
        return null;
    }

    property Process axctlProcess: Process {
        command: ["axctl", "daemon"]
        running: true
        stdout: SplitParser {
            onRead: (data) => {
                // JSON-RPC parsing to be implemented in Task 2
            }
        }
        onExited: (code) => {
            console.warn("axctl daemon exited with code:", code)
        }
    }
    
    Component.onDestruction: {
        axctlProcess.running = false
    }
}
