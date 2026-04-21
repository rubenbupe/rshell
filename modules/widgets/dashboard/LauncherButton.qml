import QtQuick
import Quickshell.Io
import qs.modules.globals
import qs.modules.services
import qs.config
import qs.modules.components

ToggleButton {
    buttonIcon: Config.bar.launcherIcon || Qt.resolvedUrl("../../../assets/rshell/rshell-icon-dark.svg").toString().replace("file://", "")
    iconTint: Config.bar.launcherIconTint
    iconFullTint: Config.bar.launcherIconFullTint
    iconSize: Config.bar.launcherIconSize
    tooltipText: "Open Vicinae"

    Process {
        id: launchVicinaeProcess
        command: ["bash", "-c", "if command -v vicinae >/dev/null; then vicinae toggle; else notify-send 'Vicinae no encontrado' 'Instala Vicinae o ajusta LauncherButton.qml'; fi"]
    }

    onToggle: function () {
        GlobalStates.clearLauncherState();
        Visibilities.setActiveModule("");
        launchVicinaeProcess.running = true;
    }
}
