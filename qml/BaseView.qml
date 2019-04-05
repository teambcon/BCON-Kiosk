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

        Column {
            id: actionButtons
            anchors.top: subHeader.bottom
            anchors.topMargin: 60
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 30
            visible: false

            MenuButton {
                id: checkStatsButton
                anchors.horizontalCenter: parent.horizontalCenter
                buttonWidth: 400
                buttonHeight: 75
                buttonText: qsTr( "Check Statistics" )

                onClicked: gameStatsOverlay.visible = true
            }

            MenuButton {
                id: addTokensButton
                anchors.horizontalCenter: parent.horizontalCenter
                buttonWidth: 400
                buttonHeight: 75
                buttonText: qsTr( "Add Tokens" )

                onClicked: addTokensOverlay.visible = true
            }

            MenuButton {
                id: changeScreenNameButton
                anchors.horizontalCenter: parent.horizontalCenter
                buttonWidth: 400
                buttonHeight: 75
                buttonText: qsTr( "Change Screen Name" )
            }

            MenuButton {
                id: exitButton
                anchors.horizontalCenter: parent.horizontalCenter
                buttonWidth: 400
                buttonHeight: 75
                buttonText: qsTr( "Exit" )

                onClicked: baseView.state = "idle"
            }
        }
    }

    CreatePlayerOverlay {
        id: createPlayerOverlay
        anchors.fill: parent
        visible: false

        onCancel: baseView.state = "idle"
        onCreated: lookupOverlay.visible = true
    }

    LookupOverlay {
        id: lookupOverlay
        anchors.fill: parent
        visible: false

        onExistingPlayer: {
            if ( ( "idle" == baseView.state ) || ( "newPlayer" == baseView.state ) )
            {
                baseView.state = "active";
            }
        }

        onNewPlayer: {
            if ( "idle" == baseView.state )
            {
                baseView.state = "newPlayer";
            }
        }
    }

    GameStatsOverlay {
        id: gameStatsOverlay
        anchors.fill: parent
        visible: false
    }

    AddTokensOverlay {
        id: addTokensOverlay
        anchors.fill: parent
        visible: false
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
            }

            PropertyChanges {
                target: subHeader
                anchors.topMargin: 100
                text: qsTr( "Please tap your RFID card." )
            }


            PropertyChanges {
                target: actionButtons
                visible: false
            }

            PropertyChanges {
                target: createPlayerOverlay
                visible: false
            }

            PropertyChanges {
                target: lookupOverlay
                visible: false
            }

            PropertyChanges {
                target: rfidIcon
                visible: true
            }
        },

        State {
            name: "newPlayer"

            PropertyChanges {
                target: statusBar
                visible: false
            }

            PropertyChanges {
                target: createPlayerOverlay
                visible: true
            }

            PropertyChanges {
                target: lookupOverlay
                visible: false
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
            }

            PropertyChanges {
                target: subHeader
                anchors.topMargin: 20
                text: qsTr( "What would you like to do?" )
            }

            PropertyChanges {
                target: actionButtons
                visible: true
            }

            PropertyChanges {
                target: createPlayerOverlay
                visible: false
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
