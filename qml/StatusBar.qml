import QtQuick 2.0
import QtQuick.Layouts 1.12

import com.bcon.datamanager 1.0

Item {
    id: statusBar

    Rectangle {
        id: background
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 60
        color: "#666666"

        RowLayout {
            id: statusBarItems
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            spacing: 20

            Item {
                id: playerIdWrapper
                Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                Layout.fillWidth: true
                Layout.fillHeight: true

                Text {
                    id: playerIdLabel
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#f2f2f2"
                    font.pixelSize: 16
                    text: qsTr( "Player ID: " )
                }

                Text {
                    id: playerId
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: playerIdLabel.right
                    anchors.leftMargin: 6
                    color: "white"
                    font.pixelSize: 16
                    font.bold: true
                    text: ( "" != DataManager.playerId ) ? DataManager.playerId : "---"
                }
            }

            Item {
                id: screenNameWrapper
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                Layout.fillWidth: true
                Layout.fillHeight: true

                Text {
                    id: screenNameLabel
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#f2f2f2"
                    font.pixelSize: 16
                    text: qsTr( "Screen Name: " )
                }

                Text {
                    id: screenName
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: screenNameLabel.right
                    anchors.leftMargin: 6
                    color: "#ffffff"
                    font.pixelSize: 16
                    font.bold: true
                    text: ( "" != DataManager.screenName ) ? DataManager.screenName : "---"
                }
            }

            Item {
                id: tokensWrapper
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                Layout.fillWidth: true
                Layout.fillHeight: true

                Text {
                    id: tokensLabel
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#f2f2f2"
                    font.pixelSize: 16
                    text: qsTr( "Token Balance: " )
                }

                Text {
                    id: tokens
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: tokensLabel.right
                    anchors.leftMargin: 6
                    color: ( 0 == DataManager.tokens ) ? "#ff4d4d" : "white"
                    font.pixelSize: 16
                    font.bold: true
                    text: ( -1 != DataManager.tokens ) ? DataManager.tokens : "---"
                }
            }

            Item {
                id: ticketsWrapper
                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                Layout.fillWidth: true
                Layout.fillHeight: true

                Text {
                    id: ticketsLabel
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#f2f2f2"
                    font.pixelSize: 16
                    text: qsTr( "Ticket Balance: " )
                }

                Text {
                    id: tickets
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: ticketsLabel.right
                    anchors.leftMargin: 6
                    color: ( 0 == DataManager.tickets ) ? "#ff4d4d" : "white"
                    font.pixelSize: 16
                    font.bold: true
                    text: ( -1 != DataManager.tickets ) ? DataManager.tickets : "---"
                }
            }
        }
    }
}
