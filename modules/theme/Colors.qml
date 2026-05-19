pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.config

FileView {
    id: colors
    // QUICKSHELL-GIT: path: Quickshell.cachePath("colors.json")
    path: Quickshell.env("HOME") + "/.cache/rshell/colors.json"
    preload: true
    watchChanges: true
    onFileChanged: {
        reload();
        generationTimer.restart();
    }

    property Connections oledWatcher: Connections {
        target: Config
        function onOledModeChanged() {
            generationTimer.restart();
        }
    }

    property Connections themeWatcher: Connections {
        target: Config.loader
        function onFileChanged() {
            generationTimer.restart();
        }
    }

    property QtCtGenerator qtCtGenerator: QtCtGenerator {
        id: qtCtGenerator
    }

    property GtkGenerator gtkGenerator: GtkGenerator {
        id: gtkGenerator
    }

    property PywalGenerator pywalGenerator: PywalGenerator {
        id: pywalGenerator
    }

    property GhosttyGenerator ghosttyGenerator: GhosttyGenerator {
        id: ghosttyGenerator
    }

    property NvChadGenerator nvChadGenerator: NvChadGenerator {
        id: nvChadGenerator
    }

    property DiscordGenerator discordGenerator: DiscordGenerator {
        id: discordGenerator
    }

    property Timer generationTimer: Timer {
        id: generationTimer
        interval: 100
        repeat: false
        onTriggered: {
            qtCtGenerator.generate(colors);
            gtkGenerator.generate(colors);
            pywalGenerator.generate(colors);
            ghosttyGenerator.generate(colors);
            nvChadGenerator.generate(colors);
            discordGenerator.generate(colors);
        }
    }

    adapter: JsonAdapter {
        property color background: "#0d0d0d"
        property color blue: "#ffffff"
        property color blueContainer: "#d4d4d4"
        property color blueSource: "#0000ff"
        property color blueValue: "#0000ff"
        property color cyan: "#ffffff"
        property color cyanContainer: "#d4d4d4"
        property color cyanSource: "#00ffff"
        property color cyanValue: "#00ffff"
        property color error: "#ffb4ab"
        property color errorContainer: "#93000a"
        property color green: "#ffffff"
        property color greenContainer: "#d4d4d4"
        property color greenSource: "#00ff00"
        property color greenValue: "#00ff00"
        property color inverseOnSurface: "#303030"
        property color inversePrimary: "#5e5e5e"
        property color inverseSurface: "#e2e2e2"
        property color lightBlue: "#ffffff"
        property color lightCyan: "#ffffff"
        property color lightGreen: "#ffffff"
        property color lightMagenta: "#ffffff"
        property color lightRed: "#ffffff"
        property color lightYellow: "#ffffff"
        property color magenta: "#ffffff"
        property color magentaContainer: "#d4d4d4"
        property color magentaSource: "#ff00ff"
        property color magentaValue: "#ff00ff"
        property color overBackground: "#e2e2e2"
        property color overBlue: "#1b1b1b"
        property color overBlueContainer: "#000000"
        property color overCyan: "#1b1b1b"
        property color overCyanContainer: "#000000"
        property color overError: "#690005"
        property color overErrorContainer: "#ffdad6"
        property color overGreen: "#1b1b1b"
        property color overGreenContainer: "#000000"
        property color overMagenta: "#1b1b1b"
        property color overMagentaContainer: "#000000"
        property color overPrimary: "#1b1b1b"
        property color overPrimaryContainer: "#000000"
        property color overPrimaryFixed: "#ffffff"
        property color overPrimaryFixedVariant: "#e2e2e2"
        property color overRed: "#1b1b1b"
        property color overRedContainer: "#000000"
        property color overSecondary: "#1b1b1b"
        property color overSecondaryContainer: "#e2e2e2"
        property color overSecondaryFixed: "#1b1b1b"
        property color overSecondaryFixedVariant: "#3b3b3b"
        property color overSurface: "#e2e2e2"
        property color overSurfaceVariant: "#c6c6c6"
        property color overTertiary: "#1b1b1b"
        property color overTertiaryContainer: "#000000"
        property color overTertiaryFixed: "#ffffff"
        property color overTertiaryFixedVariant: "#e2e2e2"
        property color overWhite: "#1b1b1b"
        property color overWhiteContainer: "#000000"
        property color overYellow: "#1b1b1b"
        property color overYellowContainer: "#000000"
        property color outline: "#919191"
        property color outlineVariant: "#474747"
        property color primary: "#ffffff"
        property color primaryContainer: "#d4d4d4"
        property color primaryFixed: "#5e5e5e"
        property color primaryFixedDim: "#474747"
        property color red: "#ffffff"
        property color redContainer: "#d4d4d4"
        property color redSource: "#ff0000"
        property color redValue: "#ff0000"
        property color scrim: "#000000"
        property color secondary: "#c6c6c6"
        property color secondaryContainer: "#474747"
        property color secondaryFixed: "#c6c6c6"
        property color secondaryFixedDim: "#ababab"
        property color shadow: "#000000"
        property color surface: "#131313"
        property color surfaceBright: "#393939"
        property color surfaceContainer: "#1f1f1f"
        property color surfaceContainerHigh: "#2a2a2a"
        property color surfaceContainerHighest: "#353535"
        property color surfaceContainerLow: "#1b1b1b"
        property color surfaceContainerLowest: "#0e0e0e"
        property color surfaceDim: "#131313"
        property color surfaceTint: "#c6c6c6"
        property color surfaceVariant: "#474747"
        property color tertiary: "#e2e2e2"
        property color tertiaryContainer: "#919191"
        property color tertiaryFixed: "#5e5e5e"
        property color tertiaryFixedDim: "#474747"
        property color white: "#ffffff"
        property color whiteContainer: "#d4d4d4"
        property color whiteSource: "#ffffff"
        property color whiteValue: "#ffffff"
        property color yellow: "#ffffff"
        property color yellowContainer: "#d4d4d4"
        property color yellowSource: "#ffff00"
        property color yellowValue: "#ffff00"
        property color sourceColor: "#4285f4"
    }

    property color background: Config.oledMode ? "#000000" : adapter.background

    property color surface: Qt.tint(background, Qt.rgba(adapter.overBackground.r, adapter.overBackground.g, adapter.overBackground.b, 0.1))
    property color surfaceBright: Qt.tint(background, Qt.rgba(adapter.overBackground.r, adapter.overBackground.g, adapter.overBackground.b, 0.2))
    property color surfaceContainer: adapter.surfaceContainer
    property color surfaceContainerHigh: adapter.surfaceContainerHigh
    property color surfaceContainerHighest: adapter.surfaceContainerHighest
    property color surfaceContainerLow: adapter.surfaceContainerLow
    property color surfaceContainerLowest: adapter.surfaceContainerLowest
    property color surfaceDim: adapter.surfaceDim
    property color surfaceTint: adapter.surfaceTint
    property color surfaceVariant: adapter.surfaceVariant

    // Direct color properties from adapter
    property color blue: adapter.blue
    property color blueContainer: adapter.blueContainer
    property color blueSource: adapter.blueSource
    property color blueValue: adapter.blueValue
    property color cyan: adapter.cyan
    property color cyanContainer: adapter.cyanContainer
    property color cyanSource: adapter.cyanSource
    property color cyanValue: adapter.cyanValue
    property color error: adapter.error
    property color errorContainer: adapter.errorContainer
    property color green: adapter.green
    property color greenContainer: adapter.greenContainer
    property color greenSource: adapter.greenSource
    property color greenValue: adapter.greenValue
    property color inverseOnSurface: adapter.inverseOnSurface
    property color inversePrimary: adapter.inversePrimary
    property color inverseSurface: adapter.inverseSurface
    property color lightBlue: adapter.lightBlue
    property color lightCyan: adapter.lightCyan
    property color lightGreen: adapter.lightGreen
    property color lightMagenta: adapter.lightMagenta
    property color lightRed: adapter.lightRed
    property color lightYellow: adapter.lightYellow
    property color magenta: adapter.magenta
    property color magentaContainer: adapter.magentaContainer
    property color magentaSource: adapter.magentaSource
    property color magentaValue: adapter.magentaValue
    property color overBackground: adapter.overBackground
    property color overBlue: adapter.overBlue
    property color overBlueContainer: adapter.overBlueContainer
    property color overCyan: adapter.overCyan
    property color overCyanContainer: adapter.overCyanContainer
    property color overError: adapter.overError
    property color overErrorContainer: adapter.overErrorContainer
    property color overGreen: adapter.overGreen
    property color overGreenContainer: adapter.overGreenContainer
    property color overMagenta: adapter.overMagenta
    property color overMagentaContainer: adapter.overMagentaContainer
    property color overPrimary: adapter.overPrimary
    property color overPrimaryContainer: adapter.overPrimaryContainer
    property color overPrimaryFixed: adapter.overPrimaryFixed
    property color overPrimaryFixedVariant: adapter.overPrimaryFixedVariant
    property color overRed: adapter.overRed
    property color overRedContainer: adapter.overRedContainer
    property color overSecondary: adapter.overSecondary
    property color overSecondaryContainer: adapter.overSecondaryContainer
    property color overSecondaryFixed: adapter.overSecondaryFixed
    property color overSecondaryFixedVariant: adapter.overSecondaryFixedVariant
    property color overSurface: adapter.overSurface
    property color overSurfaceVariant: adapter.overSurfaceVariant
    property color overTertiary: adapter.overTertiary
    property color overTertiaryContainer: adapter.overTertiaryContainer
    property color overTertiaryFixed: adapter.overTertiaryFixed
    property color overTertiaryFixedVariant: adapter.overTertiaryFixedVariant
    property color overWhite: adapter.overWhite
    property color overWhiteContainer: adapter.overWhiteContainer
    property color overYellow: adapter.overYellow
    property color overYellowContainer: adapter.overYellowContainer
    property color outline: adapter.outline
    property color outlineVariant: adapter.outlineVariant
    property color primary: adapter.primary
    property color primaryContainer: adapter.primaryContainer
    property color primaryFixed: adapter.primaryFixed
    property color primaryFixedDim: adapter.primaryFixedDim
    property color red: adapter.red
    property color redContainer: adapter.redContainer
    property color redSource: adapter.redSource
    property color redValue: adapter.redValue
    property color scrim: adapter.scrim
    property color secondary: adapter.secondary
    property color secondaryContainer: adapter.secondaryContainer
    property color secondaryFixed: adapter.secondaryFixed
    property color secondaryFixedDim: adapter.secondaryFixedDim
    property color shadow: adapter.shadow
    property color tertiary: adapter.tertiary
    property color tertiaryContainer: adapter.tertiaryContainer
    property color tertiaryFixed: adapter.tertiaryFixed
    property color tertiaryFixedDim: adapter.tertiaryFixedDim
    property color white: adapter.white
    property color whiteContainer: adapter.whiteContainer
    property color whiteSource: adapter.whiteSource
    property color whiteValue: adapter.whiteValue
    property color yellow: adapter.yellow
    property color yellowContainer: adapter.yellowContainer
    property color yellowSource: adapter.yellowSource
    property color yellowValue: adapter.yellowValue
    property color sourceColor: adapter.sourceColor

    property color criticalText: "#FF6B08"
    property color criticalRed: "#FF0028"

    // Semantic aliases
    property color warning: adapter.yellow
    property color success: adapter.green

    // List of available color names for color pickers (excludes internal/source colors)
    readonly property var availableColorNames: ["background", "surface", "surfaceBright", "surfaceContainer", "surfaceContainerHigh", "surfaceContainerHighest", "surfaceContainerLow", "surfaceContainerLowest", "surfaceDim", "surfaceTint", "surfaceVariant", "primary", "primaryContainer", "primaryFixed", "primaryFixedDim", "secondary", "secondaryContainer", "secondaryFixed", "secondaryFixedDim", "tertiary", "tertiaryContainer", "tertiaryFixed", "tertiaryFixedDim", "error", "errorContainer", "overBackground", "overSurface", "overSurfaceVariant", "overPrimary", "overPrimaryContainer", "overPrimaryFixed", "overPrimaryFixedVariant", "overSecondary", "overSecondaryContainer", "overSecondaryFixed", "overSecondaryFixedVariant", "overTertiary", "overTertiaryContainer", "overTertiaryFixed", "overTertiaryFixedVariant", "overError", "overErrorContainer", "outline", "outlineVariant", "inversePrimary", "inverseSurface", "inverseOnSurface", "shadow", "scrim", "blue", "blueContainer", "overBlue", "overBlueContainer", "lightBlue", "cyan", "cyanContainer", "overCyan", "overCyanContainer", "lightCyan", "green", "greenContainer", "overGreen", "overGreenContainer", "lightGreen", "magenta", "magentaContainer", "overMagenta", "overMagentaContainer", "lightMagenta", "red", "redContainer", "overRed", "overRedContainer", "lightRed", "yellow", "yellowContainer", "overYellow", "overYellowContainer", "lightYellow", "white", "whiteContainer", "overWhite", "overWhiteContainer"]
}
