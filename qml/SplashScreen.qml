import QtQuick 2.0
import QtQuick.Controls 1.4

Item {
    id: splashScreen

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
                text: qsTr( "Starting Kiosk..." )
            }
        }
    }
}
