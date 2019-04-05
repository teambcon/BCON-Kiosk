import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import com.bcon.datamanager 1.0

Item {
    id: updateScreenNameOverlay

    MouseArea {
        id: mouseCatcher
        anchors.fill: parent
        visible: parent.visible
    }

    onVisibleChanged: {
        if ( !visible )
        {
            // Clear the text field
            screenNameEntry.text = "";
        }
        else
        {
            // Prevent the text field from having active focus
            parent.forceActiveFocus();
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#1c1c1c"

        Text {
            id: header
            anchors.top: parent.top
            anchors.topMargin: 100
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
            font.pixelSize: 32
            font.bold: true
            text: qsTr( "Let's change things up." )
        }

        Text {
            id: subHeader
            anchors.top: header.bottom
            anchors.topMargin: 40
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
            font.pixelSize: 28
            text: qsTr( "Update your screen name below." )
        }

        TextField {
            id: screenNameEntry
            anchors.top: subHeader.bottom
            anchors.topMargin: 80
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 32
            placeholderText: qsTr( "Enter new screen name..." )

            style: TextFieldStyle {
                textColor: "black"
                background: Rectangle {
                    implicitWidth: 450
                    implicitHeight: 75
                    color: "white"
                    radius: 4
                }
            }
        }

        Row {
            id: buttonGroup
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 40
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 40

            MenuButton {
                id: cancelButton
                buttonWidth: 200
                buttonHeight: 75
                buttonText: qsTr( "Cancel" )

                onClicked: updateScreenNameOverlay.visible = false
            }

            MenuButton {
                id: confirmButton
                buttonWidth: 200
                buttonHeight: 75
                buttonText: qsTr( "Confirm" )
                enabled: ( "" != screenNameEntry.text )

                onClicked: {
                    DataManager.updateScreenName( screenNameEntry.text );
                    updateScreenNameOverlay.visible = false;
                }
            }
        }
    }
}
