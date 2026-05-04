import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.services
import qs.modules.components
import qs.modules.theme
import qs.config

StyledRect {
    id: root

    required property var bar

    // Orientación derivada de la barra
    property bool vertical: bar.orientation === "vertical"
    property bool hovered: false
    property string textVariant: hovered ? "error" : "overerror"

    // Visible solo cuando se está grabando
    visible: ScreenRecorder.isRecording

    variant: hovered ? "error" : "bg"

    Layout.fillHeight: !vertical
    Layout.fillWidth: vertical

    implicitWidth: vertical ? 36 : rowLayout.implicitWidth + 24
    implicitHeight: vertical ? columnLayout.implicitHeight + 24 : 36

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent
        spacing: 6
        visible: !root.vertical

        Text {
            text: Icons.recordScreen
            font.family: Icons.font
            font.pixelSize: 16
            color: Styling.srItem(root.textVariant)
        }

        Text {
            id: durationText
            text: ScreenRecorder.duration || "00:00"
            font.family: Config.theme.font
            font.pixelSize: Styling.fontSize(-1)
            font.weight: Font.Bold
            color: Styling.srItem(root.textVariant)
            horizontalAlignment: Text.AlignHCenter
        }
    }

    ColumnLayout {
        id: columnLayout
        anchors.centerIn: parent
        spacing: 4
        visible: root.vertical

        Text {
            text: Icons.recordScreen
            font.family: Icons.font
            font.pixelSize: 16
            color: Styling.srItem(root.textVariant)
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: ScreenRecorder.duration || "00:00"
            font.family: Config.theme.font
            font.pixelSize: Styling.fontSize(-2)
            font.weight: Font.Bold
            color: Styling.srItem(root.textVariant)
            Layout.alignment: Qt.AlignHCenter
        }
    }

    MouseArea {
        id: recordingMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            ScreenRecorder.toggleRecording();
        }

        onEntered: {
            root.hovered = true;
        }

        onExited: {
            root.hovered = false;
        }
    }
}
