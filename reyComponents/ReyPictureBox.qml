/***************************************************************************
* Copyright (c) 2013 Reyner Labrada — Dark Theme Edition
***************************************************************************/

import QtQuick 2.15
import SddmComponents 2.0

FocusScope {
    id: container

    width: 160; height: 195
    clip: true

    property alias name: name.text
    property alias icon: icon.source
    property alias password: password.text
    property bool showPassword: true

    property alias shadow: shadow.color
    property alias canvas: canvas.color
    property alias passwordColor: password.color
    property alias passwordTextColor: password.textColor
    property alias passwordBorderColor: password.borderColor
    property alias passwordFocusColor: password.focusColor

    signal login()

    // Animaciones suaves al cambiar estado
    Behavior on height  { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
    Behavior on opacity { NumberAnimation { duration: 180 } }

    states: [
        State {
            name: ""
            PropertyChanges { target: container; height: 195; opacity: 0.72 }
        },
        State {
            name: "active"
            PropertyChanges { target: container; height: 265; opacity: 1.0 }
        }
    ]

    // Marco oscuro exterior (simula sombra dentro del clip)
    Rectangle {
        id: shadow
        anchors.fill: parent
        color: "#AA000000"
        radius: 14
        opacity: container.state === "active" ? 0.85 : 0.5
        Behavior on opacity { NumberAnimation { duration: 180 } }
    }

    // Card glassmorphism (2px de margen sobre shadow = borde oscuro visible)
    Rectangle {
        id: canvas
        anchors.fill: shadow
        anchors.margins: 2
        color: "#12FFFFFF"
        radius: 12
        border.color: container.state === "active" ? "#94a3b8" : "#1AFFFFFF"
        border.width: 1
        Behavior on border.color { ColorAnimation { duration: 200 } }
    }

    // Glow sutil en el top del card cuando está activo
    Rectangle {
        anchors.top: canvas.top
        anchors.horizontalCenter: canvas.horizontalCenter
        width: canvas.width * 0.6
        height: 2
        radius: 2
        color: container.state === "active" ? "#94a3b8" : "transparent"
        Behavior on color { ColorAnimation { duration: 200 } }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
    }

    Column {
        id: column
        anchors.fill: canvas
        anchors.margins: 6
        spacing: 4
        clip: true

        Image {
            id: icon
            width: parent.width; height: 150
            clip: true
            smooth: true
            fillMode: Image.PreserveAspectCrop
        }

        Text {
            id: name
            height: 20
            anchors { left: parent.left; right: parent.right }
            color: "#e2e8f0"
            elide: Text.ElideRight
            font {
                bold: true
                capitalization: Font.AllUppercase
                pixelSize: 11
                family: "Ubuntu"
            }
            horizontalAlignment: Text.AlignHCenter
        }

        ReyPasswordBox {
            id: password
            width: parent.width; height: showPassword ? 32 : 0
            font.pixelSize: 13
            focus: true
            visible: showPassword

            // Qt 6: parámetro event explícito
            Keys.onPressed: function(event) {
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    container.login()
                    event.accepted = true
                }
            }
        }

        Text {
            id: pressToLogin
            height: 28
            font.pixelSize: 11
            font.family: "Ubuntu"
            anchors { left: parent.left; right: parent.right }
            color: "#94a3b8"
            elide: Text.ElideRight
            font.bold: true
            font.capitalization: Font.AllUppercase
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("Press to login")
        }
    }
}
