import QtQuick 2.0
import QtQuick.Controls 1.4

import com.bcon.datamanager 1.0

Item {
    id: addTokensOverlay
    state: "processing"

    property int tokensToAdd: 0

    onVisibleChanged: {
        if ( visible )
        {
            stateChangeTimer.start();
            tokensToAdd = Math.floor( Math.random() * 20 ) + 10; // 10-20 tokens
            DataManager.addTokens( tokensToAdd );
        }
        else
        {
            state = "processing";
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#1c1c1c"

        Item {
            id: processingContainer
            anchors.centerIn: parent
            height: processingAnimation.height + processingText.height

            BusyIndicator {
                id: processingAnimation
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: processingText
                anchors.top: processingAnimation.bottom
                anchors.topMargin: 40
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 24
                horizontalAlignment: Text.AlignHCenter
                color: "white"
                text: qsTr( "Processing Payment..." )
            }
        }

        Item {
            id: addedContainer
            anchors.centerIn: parent
            height: successIcon.height + processingText.height + 60

            Image {
                id: successIcon
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                source: "qrc:/images/check-success.png"
            }

            Text {
                id: addedTokensText
                anchors.top: successIcon.bottom
                anchors.topMargin: 60
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 28
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                color: "white"
                text: qsTr( "Successfully added " + tokensToAdd + " tokens." )
            }
        }

        Timer {
            id: stateChangeTimer
            interval: 2500
            running: false
            repeat: false

            onTriggered: addTokensOverlay.state = "confirmation"
        }

        MenuButton {
            id: backButton
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 40
            buttonWidth: 300
            buttonHeight: 75
            buttonText: qsTr( "Close" )

            onClicked: addTokensOverlay.visible = false;
        }
    }

    states: [
        State {
            name: "processing"

            PropertyChanges {
                target: processingContainer
                visible: true
            }

            PropertyChanges {
                target: addedContainer
                visible: false
            }

            PropertyChanges {
                target: backButton
                visible: false
            }
        },

        State {
            name: "confirmation"

            PropertyChanges {
                target: processingContainer
                visible: false
            }

            PropertyChanges {
                target: addedContainer
                visible: true
            }

            PropertyChanges {
                target: backButton
                visible: true
            }
        }

    ]
}
