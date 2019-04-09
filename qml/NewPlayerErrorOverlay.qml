import QtQuick 2.0
import QtQuick.Controls 1.4

import com.bcon.datamanager 1.0

Item {
    id: newPlayerErrorOverlay

    signal exit()

    MouseArea {
        id: mouseCatcher
        anchors.fill: parent
        visible: parent.visible
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#1c1c1c"

        Image {
            id: errorIcon
            anchors.top: parent.top
            anchors.topMargin: 60
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
            width: 150
            source: "qrc:/images/error-icon.png"
        }

        Text {
            id: header
            anchors.top: errorIcon.bottom
            anchors.topMargin: 60
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
            font.pixelSize: 32
            font.bold: true
            text: qsTr( "Looks like you're new here!" )
        }

        Text {
            id: subHeader
            anchors.top: header.bottom
            anchors.topMargin: 80
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 40
            color: "white"
            font.pixelSize: 28
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            text: qsTr( "Before playing games, you'll need to head to a general kiosk and create your profile." )
        }

        MenuButton {
            id: exitButton
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 40
            anchors.horizontalCenter: parent.horizontalCenter
            buttonWidth: 200
            buttonHeight: 75
            buttonText: qsTr( "Exit" )

            onClicked: {
                newPlayerErrorOverlay.visible = false;
                newPlayerErrorOverlay.exit()
            }
        }
    }
}
