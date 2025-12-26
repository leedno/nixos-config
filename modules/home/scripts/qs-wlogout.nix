{
  pkgs,
  inputs ? null,
}: let
  icons = pkgs.runCommand "qs-wlogout-icons" {} ''
    mkdir -p $out
    cp ${./qs-wlogout-icons}/* $out/
  '';
in
  pkgs.writeShellScriptBin "qs-wlogout" ''
      #!/usr/bin/env bash
      set -euo pipefail

      [ -n "''${QS_DEBUG:-}" ] && set -x
      DEBUG="''${QS_DEBUG:-}"
      log() { if [ -n "$DEBUG" ]; then echo "[qs-wlogout] $*" >&2; fi }

      ICONS_DIR="''${QS_WLOGOUT_ICONS_DIR:-$HOME/.local/share/qs-wlogout/icons}"
      QML_DIR="''${QS_WLOGOUT_QML_DIR:-$HOME/.local/share/qs-wlogout}"
      SPANISH="''${QS_WLOGOUT_SPANISH:-0}"

      mkdir -p "$(dirname "$ICONS_DIR")"
      mkdir -p "$ICONS_DIR"
      mkdir -p "$QML_DIR"

      if [ ! -f "$ICONS_DIR/lock.png" ]; then
        cp -r ${icons}/* "$ICONS_DIR/" 2>/dev/null || true
      fi

      tmpdir=$(${pkgs.coreutils}/bin/mktemp -d)
      main_qml="$tmpdir/main.qml"

      cat > "$tmpdir/main.qml" <<QML_MAIN
    import QtQuick 2.15
    import QtQuick.Window 2.15
    import QtQuick.Layouts 1.15
    import QtQuick.Controls 2.15

    ApplicationWindow {
        id: window
        visible: true
        flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.Dialog
        color: "transparent"
        title: "qs-wlogout"

        property color menuBackgroundColor: "#aa000000"
        property color buttonColor: "#1e1e1e"
        property color buttonHoverColor: "#3700b3"
        property string iconsPath: "$ICONS_DIR"
        property bool useSpanish: $SPANISH == "1"

        width: 520
        height: 320

        // REFACTORED COMMANDS: Lock-before-sleep added for Suspend and Hibernate
        property var buttons: useSpanish ? [
            { command: "loginctl lock-session", keybind: Qt.Key_L, text: "Bloquear", icon: "lock" },
            { command: "hyprctl dispatch exit", keybind: Qt.Key_E, text: "Cerrar Sesión", icon: "logout" },
            { command: "loginctl lock-session && systemctl suspend", keybind: Qt.Key_U, text: "Suspender", icon: "suspend" },
            { command: "loginctl lock-session && systemctl hibernate", keybind: Qt.Key_H, text: "Hibernar", icon: "hibernate" },
            { command: "systemctl poweroff", keybind: Qt.Key_S, text: "Apagar", icon: "shutdown" },
            { command: "systemctl reboot", keybind: Qt.Key_R, text: "Reiniciar", icon: "reboot" }
        ] : [
            { command: "loginctl lock-session", keybind: Qt.Key_L, text: "Lock", icon: "lock" },
            { command: "hyprctl dispatch exit", keybind: Qt.Key_E, text: "Logout", icon: "logout" },
            { command: "loginctl lock-session && systemctl suspend", keybind: Qt.Key_U, text: "Suspend", icon: "suspend" },
            { command: "loginctl lock-session && systemctl hibernate", keybind: Qt.Key_H, text: "Hibernate", icon: "hibernate" },
            { command: "systemctl poweroff", keybind: Qt.Key_S, text: "Shutdown", icon: "shutdown" },
            { command: "systemctl reboot", keybind: Qt.Key_R, text: "Reboot", icon: "reboot" }
        ]

        function executeCommand(command) {
            console.log("EXEC:" + command);
            Qt.quit();
        }

        Rectangle {
            anchors.fill: parent
            color: menuBackgroundColor
            radius: 20
            border.width: 1
            border.color: "#33ffffff"
            focus: true

            Keys.onPressed: {
                if (event.key === Qt.Key_Escape) Qt.quit();
                else {
                    for (var i = 0; i < window.buttons.length; i++) {
                        if (event.key === window.buttons[i].keybind) {
                            window.executeCommand(window.buttons[i].command);
                            return;
                        }
                    }
                }
            }

            // Fixed background click-to-close
            MouseArea { anchors.fill: parent; onClicked: Qt.quit() }

            GridLayout {
                anchors.fill: parent; anchors.margins: 20
                columns: 3; columnSpacing: 8; rowSpacing: 8

                Repeater {
                    model: window.buttons
                    Rectangle {
                        Layout.fillWidth: true; Layout.fillHeight: true
                        color: mouseArea.containsMouse ? buttonHoverColor : buttonColor
                        radius: 12
                        MouseArea {
                            id: mouseArea; anchors.fill: parent; hoverEnabled: true
                            onClicked: window.executeCommand(modelData.command)
                        }
                        Column {
                            anchors.centerIn: parent; spacing: 12
                            Image {
                                source: "file://" + window.iconsPath + "/" + modelData.icon + ".png"
                                width: 48; height: 48; anchors.horizontalCenter: parent.horizontalCenter
                                fillMode: Image.PreserveAspectFit
                            }
                            Text {
                                text: modelData.text; font.pointSize: 14; font.bold: true
                                color: "white"; anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                }
            }
        }
    }
    QML_MAIN

      export QT_QPA_PLATFORM="wayland;xcb"
      QML_BIN="${pkgs.qt6.qtdeclarative}/bin/qml"

      out=$({ "$QML_BIN" "$main_qml" 2>&1 || true; })
      exec_cmd=$(printf "%s\n" "$out" | ${pkgs.gawk}/bin/awk -F'EXEC:' '/EXEC:/{print $2}' | ${pkgs.coreutils}/bin/tail -n1)

      if [ -n "''${exec_cmd:-}" ]; then
        exec ${pkgs.bash}/bin/bash -c "$exec_cmd"
      fi
  ''
