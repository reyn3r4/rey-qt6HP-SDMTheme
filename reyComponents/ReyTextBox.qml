/***************************************************************************
* Copyright (c) 2013 Abdurrahman AVCI — Dark Theme Edition
***************************************************************************/

import QtQuick 2.15

FocusScope {
    id: container
    width: 80; height: 30

    // Defaults oscuros — se sobreescriben desde ReyPasswordBox/Main
    property color color:       "#141414"
    property color borderColor: "#3d3d3d"
    property color focusColor:  "#94a3b8"
    property color hoverColor:  "#2a2a2a"

    property alias radius:    main.radius
    property alias font:      txtMain.font
    property alias textColor: txtMain.color
    property alias echoMode:  txtMain.echoMode
    property alias text:      txtMain.text

    Rectangle {
        id: main
        anchors.fill: parent
        color: container.color
        border.color: container.borderColor
        border.width: 1
        radius: 6

        Behavior on border.color { ColorAnimation { duration: 120 } }
        Behavior on border.width { NumberAnimation { duration: 120 } }

        states: [
            State {
                name: "hover"
                when: mouseArea.containsMouse && !container.activeFocus
                PropertyChanges { target: main; border.color: container.hoverColor }
            },
            State {
                name: "focus"
                when: container.activeFocus
                PropertyChanges { target: main; border.color: container.focusColor; border.width: 2 }
            }
        ]
    }

    MouseArea {
        id: mouseArea
        anchors.fill: container
        cursorShape: Qt.IBeamCursor
        hoverEnabled: true
        onClicked: container.focus = true
    }

    TextInput {
        id: txtMain
        width: parent.width - 16
        anchors.centerIn: parent
        color: "#e2e8f0"
        clip: true
        focus: true
        passwordCharacter: "\u25cf"
    }
}
