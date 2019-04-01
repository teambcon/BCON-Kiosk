import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.12

import com.bcon.datamanager 1.0

Item {
    id: createPlayerOverlay

    signal cancel();
    signal created();

    onVisibleChanged: {
        if ( !visible )
        {
            // Clear the text fields
            firstNameEntry.text = "";
            lastNameEntry.text = "";
            screenNameEntry.text = "";
        }
        else
        {
            // Prevent the first text field from having active focus
            parent.forceActiveFocus();
        }
    }

    MouseArea {
        id: mouseCatcher
        anchors.fill: parent
        visible: parent.visible
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#1c1c1c"

        Text {
            id: header
            anchors.top: parent.top
            anchors.topMargin: 40
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
            font.pixelSize: 32
            font.bold: true
            text: qsTr( "Looks like you're new here!" )
        }

        Text {
            id: subHeader
            anchors.top: header.bottom
            anchors.topMargin: 40
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
            font.pixelSize: 28
            text: qsTr( "Let's create your profile." )
        }

        RowLayout {
            id: nameEntries
            anchors.top: subHeader.bottom
            anchors.topMargin: 80
            anchors.left: parent.left
            anchors.leftMargin: 40
            anchors.right: parent.right
            anchors.rightMargin: 40
            spacing: 20

            TextField {
                id: firstNameEntry
                Layout.fillWidth: true
                Layout.fillHeight: true
                font.pixelSize: 32
                placeholderText: qsTr( "Enter first name..." )

                style: TextFieldStyle {
                    textColor: "black"
                    background: Rectangle {
                        implicitWidth: 300
                        implicitHeight: 75
                        color: "white"
                        radius: 4
                    }
                }
            }

            TextField {
                id: lastNameEntry
                Layout.fillWidth: true
                Layout.fillHeight: true
                font.pixelSize: 32
                placeholderText: qsTr( "Enter last name..." )

                style: TextFieldStyle {
                    textColor: "black"
                    background: Rectangle {
                        implicitWidth: firstNameEntry.implicitWidth
                        implicitHeight: 75
                        color: "white"
                        radius: 4
                    }
                }
            }

        }

        TextField {
            id: screenNameEntry
            anchors.top: nameEntries.bottom
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 40
            anchors.right: parent.right
            anchors.rightMargin: 40
            font.pixelSize: 32
            placeholderText: qsTr( "Pick a screen name..." )

            style: TextFieldStyle {
                textColor: "black"
                background: Rectangle {
                    implicitWidth: 300
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

                onClicked: createPlayerOverlay.cancel()
            }

            MenuButton {
                id: confirmButton
                buttonWidth: 200
                buttonHeight: 75
                buttonText: qsTr( "Confirm" )
                enabled: ( "" != firstNameEntry.text ) && ( "" != lastNameEntry.text ) && ( "" != screenNameEntry.text )

                onClicked: {
                    createPlayerOverlay.created();
                    DataManager.createPlayer( firstNameEntry.text, lastNameEntry.text, screenNameEntry.text );
                }
            }
        }
    }
}
