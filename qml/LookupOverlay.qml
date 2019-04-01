import QtQuick 2.0
import QtQuick.Controls 1.4

import com.bcon.datamanager 1.0

Item {
    id: lookupOverlay

    Connections {
        target: DataManager

        onStatusCodeChanged: {
            if ( ( lookupOverlay.visible ) && ( 0 != DataManager.statusCode ) )
            {
                if ( 400 == DataManager.statusCode )
                {
                    // Player not found
                    lookupOverlay.newPlayer();
                }
                else
                {
                    // Server errror
                    lookupOverlay.failure();
                }
            }
        }

        onScreenNameChanged: {
            if ( lookupOverlay.visible )
            {
                lookupOverlay.existingPlayer();
            }
        }
    }

    signal newPlayer()
    signal existingPlayer()
    signal failure()

    MouseArea {
        id: mouseCatcher
        anchors.fill: parent
        visible: parent.visible
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#1c1c1c"

        Item {
            id: centeredContainer
            anchors.centerIn: parent
            height: loadingAnimation.height + loadingText.height

            BusyIndicator {
                id: loadingAnimation
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: loadingText
                anchors.top: loadingAnimation.bottom
                anchors.topMargin: 40
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 24
                horizontalAlignment: Text.AlignHCenter
                color: "white"
                text: qsTr( "Looking you up..." )
            }

        }
    }
}
