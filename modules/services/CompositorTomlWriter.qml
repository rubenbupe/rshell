pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.config

/**
 * CompositorTomlWriter - Generates TOML configuration for rctl
 * Writes to ~/.local/share/rshell/rctl.toml
 */
Singleton {
    id: root

    property string outputPath: (Quickshell.env("XDG_DATA_HOME") || (Quickshell.env("HOME") + "/.local/share")) + "/rshell/rctl.toml"

    property Process writeProcess: Process {
        running: false
        stdout: SplitParser {}
    }

    function writeTomlFile() {
        const escapedPath = root.outputPath.replace(/'/g, "'\\''");
        const scriptPath = Qt.resolvedUrl("../../scripts/generate_rctl_config.py").toString().replace("file://", "");
        const escapedScriptPath = scriptPath.replace(/'/g, "'\\''");

        writeProcess.command = ["bash", "-c", `python3 '${escapedScriptPath}' --repo '${Quickshell.shellDir}' --output '${escapedPath}'`];
        writeProcess.running = true;
        console.log("CompositorTomlWriter: Written TOML to", root.outputPath);
    }

    function refresh() {
        writeTomlFile();
    }

    Component.onCompleted: {
        Qt.callLater(() => {
            if (Config.loader.loaded) {
                writeTomlFile();
            }
        });
    }

    property Connections configConnections: Connections {
        target: Config.loader
        function onLoaded() {
            writeTomlFile();
        }
    }

    property Connections keybindsConnections: Connections {
        target: Config.keybindsLoader
        function onLoaded() {
            writeTomlFile();
        }
        function onFileChanged() {
            writeTomlFile();
        }
        function onAdapterUpdated() {
            writeTomlFile();
        }
        function onPathChanged() {
            writeTomlFile();
        }
    }

    // Compositor section connections
    property Connections compositorConnections: Connections {
        target: Config.compositor

        // Border settings
        function onBorderSizeChanged() {
            writeTomlFile();
        }
        function onRoundingChanged() {
            writeTomlFile();
        }
        function onGapsInChanged() {
            writeTomlFile();
        }
        function onGapsOutChanged() {
            writeTomlFile();
        }
        function onActiveBorderColorChanged() {
            writeTomlFile();
        }
        function onInactiveBorderColorChanged() {
            writeTomlFile();
        }
        function onBorderAngleChanged() {
            writeTomlFile();
        }
        function onInactiveBorderAngleChanged() {
            writeTomlFile();
        }

        // Sync settings that affect derived values
        function onSyncRoundnessChanged() {
            writeTomlFile();
        }
        function onSyncBorderWidthChanged() {
            writeTomlFile();
        }
        function onSyncBorderColorChanged() {
            writeTomlFile();
        }
        function onSyncShadowOpacityChanged() {
            writeTomlFile();
        }
        function onSyncShadowColorChanged() {
            writeTomlFile();
        }

        // Shadow settings
        function onShadowEnabledChanged() {
            writeTomlFile();
        }
        function onShadowRangeChanged() {
            writeTomlFile();
        }
        function onShadowRenderPowerChanged() {
            writeTomlFile();
        }
        function onShadowSharpChanged() {
            writeTomlFile();
        }
        function onShadowIgnoreWindowChanged() {
            writeTomlFile();
        }
        function onShadowColorChanged() {
            writeTomlFile();
        }
        function onShadowColorInactiveChanged() {
            writeTomlFile();
        }
        function onShadowOpacityChanged() {
            writeTomlFile();
        }
        function onShadowOffsetChanged() {
            writeTomlFile();
        }
        function onShadowScaleChanged() {
            writeTomlFile();
        }

        // Blur settings
        function onBlurEnabledChanged() {
            writeTomlFile();
        }
        function onBlurSizeChanged() {
            writeTomlFile();
        }
        function onBlurPassesChanged() {
            writeTomlFile();
        }
        function onBlurIgnoreOpacityChanged() {
            writeTomlFile();
        }
        function onBlurExplicitIgnoreAlphaChanged() {
            writeTomlFile();
        }
        function onBlurIgnoreAlphaValueChanged() {
            writeTomlFile();
        }
        function onBlurNewOptimizationsChanged() {
            writeTomlFile();
        }
        function onBlurXrayChanged() {
            writeTomlFile();
        }
        function onBlurNoiseChanged() {
            writeTomlFile();
        }
        function onBlurContrastChanged() {
            writeTomlFile();
        }
        function onBlurBrightnessChanged() {
            writeTomlFile();
        }
        function onBlurVibrancyChanged() {
            writeTomlFile();
        }
        function onBlurVibrancyDarknessChanged() {
            writeTomlFile();
        }
        function onBlurSpecialChanged() {
            writeTomlFile();
        }
        function onBlurPopupsChanged() {
            writeTomlFile();
        }
        function onBlurPopupsIgnorealphaChanged() {
            writeTomlFile();
        }
        function onBlurInputMethodsChanged() {
            writeTomlFile();
        }
        function onBlurInputMethodsIgnorealphaChanged() {
            writeTomlFile();
        }
    }

    // Theme connections (for blur ignorealpha calculation and shadow color sync)
    property Connections themeConnections: Connections {
        target: Config.theme
        function onSrBarBgChanged() {
            writeTomlFile();
        }
        function onSrBgChanged() {
            writeTomlFile();
        }
        function onShadowColorChanged() {
            writeTomlFile();
        }
        function onShadowOpacityChanged() {
            writeTomlFile();
        }
    }

    // Bar position connection (for workspace animation orientation)
    property Connections barConnections: Connections {
        target: Config.bar
        function onPositionChanged() {
            writeTomlFile();
        }
    }
}
