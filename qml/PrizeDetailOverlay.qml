import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.12

import com.bcon.datamanager 1.0

Item {
    id: prizeDetailOverlay

    property string name: ""
    property string description: ""
    property int ticketCost: -1
    property int availableQuantity: -1
    property string imageData: ""
    property int modelIndex: -1

    signal redeemed();

    MouseArea {
        id: mouseCatcher
        anchors.fill: parent
        visible: parent.visible
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

        RowLayout {
            id: infoLayout
            anchors.centerIn: parent
            width: parent.width - 80
            spacing: 20

            Image {
                id: prizeImage
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                Layout.fillHeight: true
                width: parent.width / 2 - 20
                fillMode: Image.PreserveAspectFit
                source: ( "" != imageData ) ? ( "data:image/png;base64," + imageData ) : ""
            }

            Item {
                id: prizeInfoContainer
                width: parent.width / 2 - 20
                Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                Layout.fillWidth: true
                Layout.fillHeight: true

                Text {
                    id: prizeName
                    anchors.top: parent.top
                    anchors.left: parent.left
                    color: "white"
                    font.pixelSize: 32
                    font.bold: true
                    text: qsTr( name )
                }

                Text {
                    id: prizeDescription
                    anchors.top: prizeName.bottom
                    anchors.topMargin: 20
                    width: parent.width - 20
                    color: "white"
                    font.pixelSize: 18
                    wrapMode: Text.Wrap
                    text: qsTr( description )
                }

                Text {
                    id: prizeCostLabel
                    anchors.top: prizeDescription.bottom
                    anchors.topMargin: 40
                    color: "white"
                    font.pixelSize: 18
                    text: qsTr( "Cost: " )
                }

                Text {
                    id: prizeCost
                    anchors.verticalCenter: prizeCostLabel.verticalCenter
                    anchors.left: prizeCostLabel.right
                    anchors.leftMargin: 2
                    color: "white"
                    font.pixelSize: 18
                    font.bold: true
                    text: qsTr( ticketCost + " tickets" )
                }

                Text {
                    id: prizeQuantity
                    anchors.top: prizeCostLabel.bottom
                    anchors.topMargin: 20
                    color: ( 0 != availableQuantity ) ? "white" : "#ff4d4d"
                    font.pixelSize: 16
                    font.italic: true
                    text: qsTr( availableQuantity + " available" )
                }
            }
        }

        Text {
            id: notEnoughTicketsHeadline
            anchors.bottom: buttonGroup.top
            anchors.bottomMargin: 30
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            color: "#ff4d4d"
            font.pixelSize: 20
            font.bold: true
            text: qsTr( "You do not have enough tickets to redeem this prize!")
            visible: DataManager.tickets < ticketCost
        }

        Row {
            id: buttonGroup
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 40
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 40

            MenuButton {
                id: closeButton
                buttonWidth: 200
                buttonHeight: 75
                buttonText: qsTr( "Close" )

                onClicked: prizeDetailOverlay.visible = false
            }

            MenuButton {
                id: redeemButton
                buttonWidth: 200
                buttonHeight: 75
                buttonText: qsTr( "Redeem" )
                enabled: ( DataManager.tickets >= ticketCost ) && ( 0 != availableQuantity )

                onClicked: {
                    DataManager.redeemPrize( modelIndex );
                    prizeDetailOverlay.visible = false;
                    prizeDetailOverlay.redeemed();
                }
            }
        }
    }
}
