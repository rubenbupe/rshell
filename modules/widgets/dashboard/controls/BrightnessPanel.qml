import QtQuick
import QtQuick.Layouts
import qs.modules.theme
import qs.modules.components
import qs.modules.services
import qs.config

Item {
    id: root

    property var currentMonitor: {
        if (Brightness.monitors.length > 0) {
            let focusedName = RctlService.focusedMonitor?.name ?? "";
            let found = null;
            for (let i = 0; i < Brightness.monitors.length; i++) {
                let mon = Brightness.monitors[i];
                if (mon && mon.screen && mon.screen.name === focusedName) {
                    found = mon;
                    break;
                }
            }
            return found || Brightness.monitors[0];
        }
        return null;
    }

    StyledSlider {
        id: brightnessSlider
        anchors.fill: parent
        anchors.margins: 4
        vertical: false
        smoothDrag: true
        resizeParent: false
        wavy: false
        scroll: true
        iconClickable: false
        sliderVisible: true
        iconPos: "start"
        icon: Icons.sun
        progressColor: Styling.srItem("overprimary")
        value: currentMonitor && currentMonitor.ready ? currentMonitor.brightness : 0
        thickness: 8

        onValueChanged: {
            if (Brightness.syncBrightness) {
                for (let i = 0; i < Brightness.monitors.length; i++) {
                    let mon = Brightness.monitors[i];
                    if (mon && mon.ready) {
                        mon.setBrightness(value);
                    }
                }
            } else if (root.currentMonitor && root.currentMonitor.ready) {
                root.currentMonitor.setBrightness(value);
            }
        }
    }

    Connections {
        target: root.currentMonitor
        ignoreUnknownSignals: true

        function onBrightnessChanged() {
            if (!brightnessSlider.isDragging && root.currentMonitor && root.currentMonitor.ready) {
                brightnessSlider.value = root.currentMonitor.brightness;
            }
        }

        function onReadyChanged() {
            if (root.currentMonitor && root.currentMonitor.ready) {
                brightnessSlider.value = root.currentMonitor.brightness;
            }
        }
    }
}
