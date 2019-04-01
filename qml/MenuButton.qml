import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: menuButton
    width: buttonWidth
    height: buttonHeight

    property alias buttonText: buttonText.text
    property int buttonWidth: 200
    property int buttonHeight: 75

    signal clicked()

    Button {
        id: button
        anchors.centerIn: parent

        style: ButtonStyle {
            background: Rectangle {
                implicitWidth: buttonWidth
                implicitHeight: buttonHeight
                radius: 4
                color: control.enabled ? "#007AFF" : "gray"
            }
        }

        Text {
            id: buttonText
            anchors.centerIn: parent
            font.pixelSize: 24
            color: "white"
        }

        Rectangle {
            id: pressed
            anchors.fill: parent
            color: "#777777"
            opacity: 0.5
            visible: button.pressed
        }

        onClicked: menuButton.clicked()
    }
}
