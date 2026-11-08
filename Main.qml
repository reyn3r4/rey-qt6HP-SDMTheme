/***************************************************************************
* Featured by Reyner Labrada — Dark Theme Edition v2
***************************************************************************/

import QtQuick 2.15
import SddmComponents 2.0
import "reyComponents"

Rectangle {
    id: container
    width: 1024
    height: 768

    // ── Paleta oscura (tonos grises, sin azules) ────────────────
    readonly property color clrAccent:        "#94a3b8"   // slate-400 — foco, glow, día
    readonly property color clrTextPrimary:   "#e2e8f0"   // blanco suave
    readonly property color clrTextSecondary: "#6b7280"   // gris medio
    readonly property color clrSurface:       "#12FFFFFF"  // glassmorphism cards
    readonly property color clrSurfaceBorder: "#1AFFFFFF"
    readonly property color clrOverlay:       "#D01a1a1a"  // barra superior gris oscuro
    readonly property color clrDark:          "#141414"    // fondo inputs
    readonly property color clrInputBorder:   "#3d3d3d"    // borde inputs
    // ────────────────────────────────────────────────────────────

    property int sessionIndex: session.index

    TextConstants { id: textConstants }

    // Qt 6: sintaxis de función obligatoria
    Connections {
        target: sddm
        function onLoginSucceeded() {}
        function onLoginFailed() {
            txtMessage.text = textConstants.loginFailed
            listView.currentItem.password.text = ""
        }
    }

    // Imagen base directa — fix para modo test donde Background/screenModel no carga
    Image {
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
        smooth: true
    }

    // Multi-monitor: sobreescribe la imagen base en cada pantalla real
    Repeater {
        model: screenModel
        Background {
            x: geometry.x; y: geometry.y; width: geometry.width; height: geometry.height
            source: config.background
            fillMode: Image.PreserveAspectCrop
            onStatusChanged: {
                if (status == Image.Error && source != config.defaultBackground) {
                    source = config.defaultBackground
                }
            }
        }
    }

    // Contenido del monitor primario
    Rectangle {
        property var geometry: screenModel.geometry(screenModel.primary)
        x: geometry.x; y: geometry.y; width: geometry.width; height: geometry.height
        color: "transparent"

        // Overlay oscuro sobre el wallpaper
        Rectangle {
            anchors.fill: parent
            color: "#88141414"
        }

        // ── Delegate de usuario ───────────────────────────────────
        Component {
            id: userDelegate
            ReyPictureBox {
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                name: (model.realName === "") ? model.name : model.realName
                icon: model.icon

                focus: (listView.currentIndex === index)
                state: (listView.currentIndex === index) ? "active" : ""

                onLogin: sddm.login(model.name, password, sessionIndex)

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: listView.currentIndex = index
                    onClicked: listView.focus = true
                }

                shadow:              "#AA000000"
                canvas:              container.clrSurface
                passwordColor:       container.clrDark
                passwordTextColor:   container.clrTextPrimary
                passwordBorderColor: container.clrInputBorder
                passwordFocusColor:  container.clrAccent
            }
        }

        // ── Barra superior ────────────────────────────────────────
        Rectangle {
            id: actionBar
            anchors.top: parent.top
            width: parent.width; height: 72
            color: container.clrOverlay

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width; height: 1
                color: container.clrSurfaceBorder
            }

            // Izquierda: sesión + layout de teclado
            Row {
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8

                ComboBox {
                    id: session
                    width: 220
                    anchors.verticalCenter: parent.verticalCenter
                    model:       sessionModel
                    index:       sessionModel.lastIndex
                    font.pixelSize: 14; font.family: "Ubuntu"
                    color:       "transparent"
                    menuColor:   container.clrDark
                    borderColor: container.clrSurfaceBorder
                    focusColor:  container.clrAccent
                    hoverColor:  "#2a2a2a"
                    textColor:   container.clrTextPrimary
                    arrowColor:  "transparent"
                    arrowIcon:   "chevron-down.png"
                    KeyNavigation.backtab: nextUser; KeyNavigation.tab: layoutBox
                }

                // LayoutBox: override rowDelegate para forzar texto blanco
                // (el delegate interno de LayoutBox.qml no usa textColor)
                LayoutBox {
                    id: layoutBox
                    width: 100
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 14
                    color:       "transparent"
                    menuColor:   container.clrDark
                    borderColor: container.clrSurfaceBorder
                    focusColor:  container.clrAccent
                    hoverColor:  "#2a2a2a"
                    textColor:   "white"
                    arrowColor:  "transparent"
                    arrowIcon:   "chevron-down.png"

                    rowDelegate: Rectangle {
                        color: "transparent"
                        Image {
                            id: flagImg
                            source: "/usr/share/sddm/flags/%1.png".arg(
                                modelItem && modelItem.modelData
                                    ? modelItem.modelData.shortName : "zz")
                            anchors.left:    parent.left
                            anchors.top:     parent.top
                            anchors.bottom:  parent.bottom
                            anchors.margins: 4
                            fillMode: Image.PreserveAspectFit
                        }
                        Text {
                            anchors.left:    flagImg.right
                            anchors.right:   parent.right
                            anchors.top:     parent.top
                            anchors.bottom:  parent.bottom
                            anchors.margins: 4
                            verticalAlignment: Text.AlignVCenter
                            text:  modelItem && modelItem.modelData
                                       ? modelItem.modelData.shortName : ""
                            color: "white"
                            font.pixelSize: 14
                            font.family:    "Ubuntu"
                        }
                    }

                    KeyNavigation.backtab: session; KeyNavigation.tab: btnShutdown
                }
            }

            // Derecha: botones de energía (sin visible:canXxx — se ocultaban en modo test)
            Row {
                anchors.right: parent.right
                anchors.rightMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8

                ImageButton {
                    id: btnSuspend
                    height: 40
                    anchors.verticalCenter: parent.verticalCenter
                    source: "suspend.png"
                    onClicked: sddm.suspend()
                    KeyNavigation.backtab: layoutBox; KeyNavigation.tab: btnReboot
                }

                ImageButton {
                    id: btnReboot
                    height: 40
                    anchors.verticalCenter: parent.verticalCenter
                    source: "reboot.png"
                    onClicked: sddm.reboot()
                    KeyNavigation.backtab: btnSuspend; KeyNavigation.tab: btnShutdown
                }

                ImageButton {
                    id: btnShutdown
                    height: 40
                    anchors.verticalCenter: parent.verticalCenter
                    source: "shutdown.png"
                    onClicked: sddm.powerOff()
                    KeyNavigation.backtab: btnReboot; KeyNavigation.tab: prevUser
                }
            }
        }
        // ── Fin barra superior ────────────────────────────────────

        // ── Área central: card de usuario + reloj ─────────────────
        //    Row centra el bloque completo en la pantalla.
        //    Hijos directos del Row solo usan width/height (sin anchors).
        Row {
            id: centerRow
            anchors.centerIn: parent
            spacing: 52

            // — Bloque de usuarios —
            Item {
                id: usersContainer
                width: 440; height: 265

                ImageButton {
                    id: prevUser
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    source: "angle-left.png"
                    onClicked: listView.decrementCurrentIndex()
                    KeyNavigation.backtab: btnShutdown; KeyNavigation.tab: listView
                }

                ListView {
                    id: listView
                    height: parent.height
                    anchors.left: prevUser.right
                    anchors.right: nextUser.left
                    anchors.margins: 8

                    clip: true
                    focus: true
                    spacing: 16
                    model: userModel
                    delegate: userDelegate
                    orientation: ListView.Horizontal
                    currentIndex: userModel.lastIndex

                    // Centra el item activo (fix para usuario único que aparecía a la izquierda)
                    Component.onCompleted: {
                        positionViewAtIndex(currentIndex, ListView.Center)
                    }

                    KeyNavigation.backtab: prevUser; KeyNavigation.tab: nextUser
                }

                ImageButton {
                    id: nextUser
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    source: "angle-right.png"
                    onClicked: listView.incrementCurrentIndex()
                    KeyNavigation.backtab: listView; KeyNavigation.tab: session
                }
            }

            // — Separador vertical —
            Item {
                width: 1; height: 265
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 1; height: 200
                    color: container.clrSurfaceBorder
                }
            }

            // — Reloj analógico + digital + fecha —
            Item {
                id: clockItem
                width: 230; height: 265

                // Timer: redibuja Canvas y actualiza fecha cada segundo
                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: {
                        clockCanvas.requestPaint()
                        var now = new Date()
                        dayText.text  = Qt.formatDate(now, "dddd")
                        dateText.text = Qt.formatDate(now, "d MMMM yyyy")
                    }
                }

                // ── Cara del reloj analógico ──────────────────────
                Canvas {
                    id: clockCanvas
                    width: 210; height: 210
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top

                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.clearRect(0, 0, width, height)

                        var cx = width  / 2
                        var cy = height / 2
                        var r  = width  / 2 - 6

                        // — Fondo de la esfera —
                        ctx.beginPath()
                        ctx.arc(cx, cy, r, 0, 2 * Math.PI)
                        ctx.fillStyle = "rgba(255, 255, 255, 0.05)"
                        ctx.fill()

                        // — Aro exterior —
                        ctx.beginPath()
                        ctx.arc(cx, cy, r, 0, 2 * Math.PI)
                        ctx.strokeStyle = "rgba(255, 255, 255, 0.14)"
                        ctx.lineWidth = 1.5
                        ctx.stroke()

                        // — Marcas de minutos (60) y horas (12) —
                        for (var i = 0; i < 60; i++) {
                            var isHour = (i % 5 === 0)
                            var a      = (i * 6 - 90) * Math.PI / 180
                            var inner  = isHour ? r - 14 : r - 8
                            ctx.beginPath()
                            ctx.moveTo(cx + r     * Math.cos(a), cy + r     * Math.sin(a))
                            ctx.lineTo(cx + inner * Math.cos(a), cy + inner * Math.sin(a))
                            ctx.strokeStyle = isHour
                                ? "rgba(226, 232, 240, 0.9)"
                                : "rgba(107, 114, 128, 0.45)"
                            ctx.lineWidth = isHour ? 2 : 0.8
                            ctx.stroke()
                        }

                        var now = new Date()
                        var h   = now.getHours()   % 12
                        var m   = now.getMinutes()
                        var s   = now.getSeconds()

                        // — Hora digital HH:mm:ss (dibujada ANTES de las manecillas → queda detrás) —
                        ctx.textAlign    = "center"
                        ctx.textBaseline = "middle"

                        // HH:mm en blanco suave
                        ctx.font      = "bold 15px sans-serif"
                        ctx.fillStyle = "rgba(226, 232, 240, 0.78)"
                        ctx.fillText(Qt.formatTime(now, "HH:mm"), cx, cy + 33)

                        // :ss más pequeño debajo
                        ctx.font      = "11px sans-serif"
                        ctx.fillStyle = "rgba(148, 163, 184, 0.70)"
                        ctx.fillText(Qt.formatTime(now, "ss"), cx, cy + 47)

                        // — Manecilla de horas —
                        var hAngle = ((h + m / 60) * 30 - 90) * Math.PI / 180
                        ctx.beginPath()
                        ctx.moveTo(cx - 8 * Math.cos(hAngle), cy - 8 * Math.sin(hAngle))
                        ctx.lineTo(cx + r * 0.50 * Math.cos(hAngle), cy + r * 0.50 * Math.sin(hAngle))
                        ctx.strokeStyle = "#e2e8f0"
                        ctx.lineWidth   = 5
                        ctx.lineCap     = "round"
                        ctx.stroke()

                        // — Manecilla de minutos —
                        var mAngle = ((m + s / 60) * 6 - 90) * Math.PI / 180
                        ctx.beginPath()
                        ctx.moveTo(cx - 10 * Math.cos(mAngle), cy - 10 * Math.sin(mAngle))
                        ctx.lineTo(cx + r * 0.70 * Math.cos(mAngle), cy + r * 0.70 * Math.sin(mAngle))
                        ctx.strokeStyle = "#e2e8f0"
                        ctx.lineWidth   = 3
                        ctx.lineCap     = "round"
                        ctx.stroke()

                        // — Manecilla de segundos —
                        var sAngle = (s * 6 - 90) * Math.PI / 180
                        ctx.beginPath()
                        ctx.moveTo(cx - 16 * Math.cos(sAngle), cy - 16 * Math.sin(sAngle))
                        ctx.lineTo(cx + r * 0.80 * Math.cos(sAngle), cy + r * 0.80 * Math.sin(sAngle))
                        ctx.strokeStyle = "#94a3b8"
                        ctx.lineWidth   = 1.5
                        ctx.lineCap     = "round"
                        ctx.stroke()

                        // — Centro —
                        ctx.beginPath()
                        ctx.arc(cx, cy, 5, 0, 2 * Math.PI)
                        ctx.fillStyle = "#94a3b8"
                        ctx.fill()
                        ctx.beginPath()
                        ctx.arc(cx, cy, 2.5, 0, 2 * Math.PI)
                        ctx.fillStyle = "#e2e8f0"
                        ctx.fill()
                    }

                    Component.onCompleted: requestPaint()
                }

                // — Día y fecha debajo del reloj —
                Column {
                    anchors.top:              clockCanvas.bottom
                    anchors.topMargin:        10
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 3

                    Text {
                        id: dayText
                        text: Qt.formatDate(new Date(), "dddd")
                        color: "#94a3b8"
                        font.pixelSize: 15
                        font.family:    "Ubuntu"
                        font.capitalization: Font.Capitalize
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        id: dateText
                        text: Qt.formatDate(new Date(), "d MMMM yyyy")
                        color: "#6b7280"
                        font.pixelSize: 13
                        font.family:    "Ubuntu"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        }
        // ── Fin área central ──────────────────────────────────────

        // ── Mensaje de estado ────────────────────────────────────
        Text {
            id: txtMessage
            anchors.top: centerRow.bottom
            anchors.topMargin: 28
            anchors.horizontalCenter: parent.horizontalCenter
            color: container.clrTextSecondary
            text: textConstants.promptSelectUser
            font.pixelSize: 15
            font.family: "Ubuntu"
        }
    }
}
