import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import qs.modules.theme
import qs.modules.components
import qs.modules.globals
import qs.modules.services
import qs.config
import "calendar"

Rectangle {
    color: "transparent"
    implicitWidth: 500
    implicitHeight: 750

    property int leftPanelWidth: 0

    RowLayout {
        anchors.fill: parent
        spacing: 8

        FullPlayer {
            Layout.preferredWidth: 216
            Layout.fillHeight: true
        }

        // Widgets column (quick actions + notifications)
        ColumnLayout {
            id: widgetsContainer
            Layout.preferredWidth: controlButtonsContainer.implicitWidth
            Layout.fillHeight: true
            spacing: 8

            // Control buttons - 5 buttons wrapped in StyledRect pane > internalbg
            QuickControls {
                id: controlButtonsContainer
            }

            // Notification History below quick actions
            NotificationHistory {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }

        // Circular controls column removed.
    }
}
