pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.SystemTray
import qs.modules.components

MouseArea {
    id: root

    required property var bar
    required property SystemTrayItem item
    property int trayItemSize: 20
    property bool isHovered: false
    readonly property string trayIconSource: getTrayIconSource()

    acceptedButtons: Qt.LeftButton | Qt.RightButton
    Layout.fillHeight: bar.orientation === "horizontal"
    Layout.fillWidth: bar.orientation === "vertical"
    implicitWidth: trayItemSize
    implicitHeight: trayItemSize

    onClicked: event => {
        switch (event.button) {
        case Qt.LeftButton:
            item.activate();
            break;
        case Qt.RightButton:
            if (item.hasMenu) {
                systrayPopup.toggle();
            }
            break;
        }
        event.accepted = true;
    }

    function getTrayIconSource() {
        const icon = root.item?.icon ? root.item.icon.toString() : "";
        if (icon === "") {
            return "image://icon/image-missing";
        }

        if (icon.includes("spotify")) {
            return Quickshell.iconPath("spotify-client", "spotify");
        }

        if (icon.startsWith("/") || icon.startsWith("file:") || icon.startsWith("image:") || icon.startsWith("qrc:") || icon.startsWith("data:")) {
            return icon;
        }

        if (icon.endsWith("-symbolic")) {
            const fullColorIcon = icon.slice(0, -"-symbolic".length);
            if (Quickshell.iconPath(fullColorIcon, true) !== "") {
                return "image://icon/" + fullColorIcon;
            }
        }

        return "image://icon/" + icon;
    }

    BarPopup {
        id: systrayPopup
        anchorItem: root
        bar: root.bar

        // Use a reasonable width for the menu
        contentWidth: 220
        // Height adapts to content, with a max limit if needed.
        // Must include vertical padding (8 top + 8 bottom = 16)
        contentHeight: Math.min(itemsColumn.implicitHeight + 16, 400)

        popupPadding: 8
        // 8px standard margin + 8px SysTray container padding to ensure correct offset from the main bar
        visualMargin: 16

        // Using QsMenuOpener to access menu items
        QsMenuOpener {
            id: menuOpener
            menu: root.item.menu
        }

        ScrollView {
            anchors.fill: parent
            contentWidth: availableWidth
            clip: true

            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

            ColumnLayout {
                id: itemsColumn
                width: parent.width
                spacing: 2

                Repeater {
                    model: menuOpener.children ? menuOpener.children.values : []

                    delegate: ColumnLayout {
                        required property var modelData
                        required property int index
                        property bool isSeparatorEntry: modelData ? (modelData.isSeparator || false) : false
                        property bool prevIsSeparator: (index > 0 && menuOpener.children && menuOpener.children.values && menuOpener.children.values[index - 1]) ? (menuOpener.children.values[index - 1].isSeparator || false) : false
                        property bool shouldHideSeparator: isSeparatorEntry && (index === 0 || prevIsSeparator || index === (menuOpener.children && menuOpener.children.values ? menuOpener.children.values.length - 1 : -1))
                        visible: !shouldHideSeparator

                        Layout.fillWidth: true
                        spacing: 2

                        property bool submenuExpanded: false

                        SystrayMenuItem {
                            Layout.fillWidth: true

                            textStr: modelData.text || ""
                            iconSource: modelData.icon || ""
                            isImageIcon: iconSource.indexOf("/") !== -1 || iconSource.indexOf(".") !== -1
                            isSeparator: modelData.isSeparator || false
                            hasSubmenu: modelData.hasChildren || false
                            expanded: parent.submenuExpanded
                            buttonType: modelData.buttonType || 0
                            checkState: modelData.checkState || 0

                            onClicked: {
                                if (modelData.hasChildren) {
                                    parent.submenuExpanded = !parent.submenuExpanded;
                                } else {
                                    if (modelData.triggered) {
                                        modelData.triggered();
                                    } else if (modelData.activate) {
                                        modelData.activate();
                                    }
                                    systrayPopup.close();
                                }
                            }
                        }

                        // Submenu children — uses its own QsMenuOpener to trigger lazy loading
                        ColumnLayout {
                            visible: submenuExpanded && modelData.hasChildren
                            Layout.fillWidth: true
                            spacing: 2

                            QsMenuOpener {
                                id: subMenuOpener
                                menu: modelData.hasChildren ? modelData : null
                            }

                            Repeater {
                                model: subMenuOpener.children ? subMenuOpener.children.values : []

                                delegate: SystrayMenuItem {
                                    required property var modelData
                                    required property int index
                                    property bool isSeparatorEntry: modelData ? (modelData.isSeparator || false) : false
                                    property bool prevIsSeparator: (index > 0 && subMenuOpener.children && subMenuOpener.children.values && subMenuOpener.children.values[index - 1]) ? (subMenuOpener.children.values[index - 1].isSeparator || false) : false
                                    property bool shouldHideSeparator: isSeparatorEntry && (index === 0 || prevIsSeparator || index === (subMenuOpener.children && subMenuOpener.children.values ? subMenuOpener.children.values.length - 1 : -1))
                                    visible: !shouldHideSeparator

                                    Layout.fillWidth: true
                                    depth: 1

                                    textStr: modelData.text || ""
                                    iconSource: modelData.icon || ""
                                    isImageIcon: iconSource.indexOf("/") !== -1 || iconSource.indexOf(".") !== -1
                                    isSeparator: modelData.isSeparator || false
                                    buttonType: modelData.buttonType || 0
                                    checkState: modelData.checkState || 0

                                    onClicked: {
                                        if (modelData.triggered) {
                                            modelData.triggered();
                                        } else if (modelData.activate) {
                                            modelData.activate();
                                        }
                                        systrayPopup.close();
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Image {
        id: trayIcon
        source: root.trayIconSource
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectFit
        mipmap: true
        smooth: true

        onStatusChanged: {
            if (status === Image.Error) {
                console.warn("Failed to load systray icon:", root.item?.id, root.item?.title, root.item?.icon, "resolved as", source);
            }
        }
    }

    StyledToolTip {
        show: root.isHovered
        tooltipText: root.item.tooltipTitle || root.item.title
        desciription: root.item.tooltipDescription || ""
    }

    HoverHandler {
        onHoveredChanged: root.isHovered = hovered
    }
}
