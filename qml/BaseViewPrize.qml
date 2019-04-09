import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

import com.bcon.datamanager 1.0

Item {
    id: baseView
    objectName: "baseView"
    state: "idle"

    Connections {
        target: DataManager
        onCardInserted: {
            if ( ( "idle" == baseView.state ) && ( !lookupOverlay.visible ) )
            {
                lookupOverlay.visible = true
            }
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#1c1c1c"

        StatusBar {
            id: statusBar
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 60
        }

        Text {
            id: header
            anchors.top: parent.top
            anchors.topMargin: 120
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
            font.pixelSize: 32
            font.bold: true
        }

        Text {
            id: subHeader
            anchors.top: header.bottom
            anchors.topMargin: 100
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
            font.pixelSize: 28
        }

        AnimatedImage {
            id: rfidIcon
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 100
            anchors.horizontalCenter: parent.horizontalCenter
            source: "qrc:/images/rfid.gif"
            width: 128
            height: 128
        }

        GridView {
            id: prizesGrid
            anchors.top: subHeader.bottom
            anchors.topMargin: 40
            anchors.leftMargin: 40
            anchors.rightMargin: 40
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: exitButton.top
            anchors.bottomMargin: 40
            width: parent.width - 80
            cellWidth: 180
            cellHeight: 230
            clip: true
            ScrollBar.vertical: ScrollBar {}
            model: DataManager.prizes
            delegate: Rectangle {
                id: prizeDelegate
                width: 160
                height: 210
                color: "dimgray"
                radius: 4

                MouseArea {
                    id: clickArea
                    anchors.fill: parent

                    onClicked: {
                        prizeDetailOverlay.name = modelData[ "name" ];
                        prizeDetailOverlay.description = modelData[ "description" ];
                        prizeDetailOverlay.ticketCost = modelData[ "ticketCost" ];
                        prizeDetailOverlay.availableQuantity = modelData[ "availableQuantity" ];
                        prizeDetailOverlay.imageData = modelData[ "imageData" ];
                        prizeDetailOverlay.modelIndex = index;
                        prizeDetailOverlay.visible = true;
                    }
                }

                Image {
                    id: prizeImage
                    anchors.top: parent.top
                    anchors.topMargin: 6
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width - 12
                    fillMode: Image.PreserveAspectFit
                    source: ( "" !== modelData[ "imageData" ] ) ? ( "data:image/png;base64," + modelData[ "imageData" ] ) : ""
                }

                Rectangle {
                    id: outofStockBadge
                    anchors.top: prizeImage.top
                    anchors.left: prizeImage.left
                    anchors.right: prizeImage.right
                    height: 20
                    opacity: 0.9
                    color: "#ff4d4d"
                    visible: 0 >= modelData[ "availableQuantity" ]

                    Text {
                        anchors.centerIn: parent
                        font.pixelSize: 16
                        font.bold: true
                        color: "white"
                        text: qsTr( "OUT OF STOCK!" )
                    }
                }

                Rectangle {
                    id: redeemedBadge
                    anchors.top: prizeImage.top
                    anchors.left: prizeImage.left
                    anchors.right: prizeImage.right
                    height: 20
                    opacity: 0.9
                    color: "#33cc33"
                    visible: ( "redeemed" == baseView.state ) && ( prizeDetailOverlay.modelIndex == index )

                    Text {
                        anchors.centerIn: parent
                        font.pixelSize: 16
                        font.bold: true
                        color: "white"
                        text: qsTr( "REDEEMED!" )
                    }
                }

                Text {
                    id: nameLabel
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: ticketCostLabel.top
                    anchors.bottomMargin: 6
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 16
                    font.bold: true
                    text: qsTr( modelData[ "name" ] )
                    color: "white"
                }

                Text {
                    id: ticketCostLabel
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 6
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 16
                    text: qsTr( modelData[ "ticketCost" ] + " tickets" )
                    color: "white"
                }
            }
        }

        MenuButton {
            id: exitButton
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 40
            buttonWidth: 400
            buttonHeight: 75
            buttonText: qsTr( "Exit" )

            onClicked: baseView.state = "idle"
        }
    }

    LookupOverlay {
        id: lookupOverlay
        anchors.fill: parent
        visible: false

        onExistingPlayer: {
            if ( "idle" == baseView.state )
            {
                baseView.state = "active";
            }
        }

        onNewPlayer: {
            if ( "idle" == baseView.state )
            {
                newPlayerErrorOverlay.visible = true;
            }
        }
    }

    NewPlayerErrorOverlay {
        id: newPlayerErrorOverlay
        anchors.fill: parent
        visible: false

        onExit: lookupOverlay.visible = false
    }

    PrizeDetailOverlay {
        id: prizeDetailOverlay
        anchors.fill: parent
        visible: false

        onRedeemed: {
            baseView.state = "redeemed";
            redeemTimer.start();
        }

        Timer {
            id: redeemTimer
            running: false
            repeat: false
            interval: 5000

            onTriggered: baseView.state = "active"
        }
    }

    MouseArea {
        id: keyboardMask
        height: parent.height - inputPanel.height
        y: parent.y
        anchors.left: parent.left
        anchors.right: parent.right
        visible: Qt.inputMethod.visible ? true : false

        onClicked: {
            Qt.inputMethod.hide();
            baseView.forceActiveFocus();
        }
    }

    states: [
        State {
            name: "idle"

            PropertyChanges {
                target: statusBar
                visible: false
            }

            PropertyChanges {
                target: header
                text: qsTr( "Welcome to the Kiosk!" )
                anchors.topMargin: 120
            }

            PropertyChanges {
                target: subHeader
                anchors.topMargin: 100
                text: qsTr( "Please tap your RFID card." )
                font.pixelSize: 28
            }

            PropertyChanges {
                target: prizesGrid
                visible: false
            }

            PropertyChanges {
                target: exitButton
                visible: false
            }

            PropertyChanges {
                target: lookupOverlay
                visible: false
            }

            PropertyChanges {
                target: newPlayerErrorOverlay
                visible: false
            }

            PropertyChanges {
                target: rfidIcon
                visible: true
            }
        },

        State {
            name: "active"

            PropertyChanges {
                target: statusBar
                visible: true
            }

            PropertyChanges {
                target: header
                text: qsTr( "Hey there, " + DataManager.firstName + "!" )
                anchors.topMargin: 90
            }

            PropertyChanges {
                target: subHeader
                anchors.topMargin: 20
                text: qsTr( "Scroll through prizes below. Tap one for more info or to redeem." )
                font.pixelSize: 24
            }

            PropertyChanges {
                target: prizesGrid
                visible: true
            }

            PropertyChanges {
                target: exitButton
                visible: true
            }

            PropertyChanges {
                target: lookupOverlay
                visible: false
            }

            PropertyChanges {
                target: rfidIcon
                visible: false
            }
        },

        State {
            name: "redeemed"

            PropertyChanges {
                target: statusBar
                visible: true
            }

            PropertyChanges {
                target: header
                text: qsTr( "Way to go, " + DataManager.firstName + "!" )
                anchors.topMargin: 90
            }

            PropertyChanges {
                target: subHeader
                anchors.topMargin: 20
                text: qsTr( "You just redeemed a " + prizeDetailOverlay.name.toLowerCase() + " for " + prizeDetailOverlay.ticketCost + " tickets." )
                font.pixelSize: 24
            }

            PropertyChanges {
                target: prizesGrid
                visible: true
            }

            PropertyChanges {
                target: exitButton
                visible: true
            }

            PropertyChanges {
                target: lookupOverlay
                visible: false
            }

            PropertyChanges {
                target: rfidIcon
                visible: false
            }
        }

    ]
}
