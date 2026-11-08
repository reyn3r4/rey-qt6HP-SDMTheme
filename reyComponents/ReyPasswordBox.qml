/***************************************************************************
* Copyright (c) 2013 Nikita Mikhaylov — Dark Theme Edition
* Capslock warning: texto en lugar de imagen (warning.png eliminado)
***************************************************************************/

import QtQuick 2.15

FocusScope {
    id: container
    width: 80; height: 30

    property alias color:       txtMain.color
    property alias borderColor: txtMain.borderColor
    property alias focusColor:  txtMain.focusColor
    property alias hoverColor:  txtMain.hoverColor
    property alias radius:      txtMain.radius
    property alias font:        txtMain.font
    property alias textColor:   txtMain.textColor
    property alias echoMode:    txtMain.echoMode
    property alias text:        txtMain.text

    ReyTextConstants {
        id: textConstants
    }

    ReyTextBox {
        id: txtMain
        // Reducir ancho cuando capsLock está activo para no tapar el indicador
        width: capsWarning.visible ? parent.width - capsWarning.width - 4 : parent.width
        height: parent.height
        font.pixelSize: 14
        echoMode: TextInput.Password
        focus: true

        Behavior on width { NumberAnimation { duration: 150 } }
    }

    // Indicador de CapsLock — texto, sin imagen externa
    Rectangle {
        id: capsWarning
        visible: keyboard.capsLock
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        width: capsIcon.implicitWidth + 10
        height: parent.height - 4
        color: "#f59e0b"
        radius: 5
        opacity: visible ? 1.0 : 0.0

        Behavior on opacity { NumberAnimation { duration: 180 } }

        Text {
            id: capsIcon
            anchors.centerIn: parent
            text: "⇪"
            color: "#141414"
            font.pixelSize: 14
            font.bold: true
        }

        // Tooltip nativo QML al hacer hover
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.ArrowCursor

            onContainsMouseChanged: {
                capsTooltip.visible = containsMouse
            }
        }

        Rectangle {
            id: capsTooltip
            visible: false
            anchors.bottom: parent.top
            anchors.right: parent.right
            anchors.bottomMargin: 4
            width: capsTooltipText.implicitWidth + 12
            height: capsTooltipText.implicitHeight + 8
            color: "#141414"
            border.color: "#3d3d3d"
            border.width: 1
            radius: 4
            z: 10

            Text {
                id: capsTooltipText
                anchors.centerIn: parent
                text: textConstants.capslockWarning
                color: "#f59e0b"
                font.pixelSize: 11
                font.family: "Ubuntu"
            }
        }
    }
}
