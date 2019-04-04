import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.12

import com.bcon.datamanager 1.0

Item {
    id: gameStatsOverlay

    MouseArea {
        id: mouseCatcher
        anchors.fill: parent
        visible: parent.visible
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#1c1c1c"

        RowLayout {
            id: header
            anchors.top: parent.top
            anchors.topMargin: 40
            anchors.left: parent.left
            anchors.leftMargin: 40
            anchors.right: parent.right
            anchors.rightMargin: 40
            height: 60
            spacing: 2
            visible: 0 !== DataManager.stats.length

            Rectangle {
                id: gameNameHeader
                color: "#666666"
                Layout.fillWidth: true
                Layout.fillHeight: true

                Text {
                    id: gameNameHeaderText
                    anchors.centerIn: parent
                    font.pixelSize: 24
                    font.bold: true
                    color: "white"
                    text: qsTr( "Game Name" )
                }
            }

            Rectangle {
                id: gamesPlayedHeader
                color: "#666666"
                Layout.fillWidth: true
                Layout.fillHeight: true

                Text {
                    id: gamesPlayedHeaderText
                    anchors.centerIn: parent
                    font.pixelSize: 24
                    font.bold: true
                    color: "white"
                    text: qsTr( "Rounds" )
                }
            }

            Rectangle {
                id: ticketsEarnedHeader
                color: "#666666"
                Layout.fillWidth: true
                Layout.fillHeight: true

                Text {
                    id: ticketsEarnedHeaderText
                    anchors.centerIn: parent
                    font.pixelSize: 24
                    font.bold: true
                    color: "white"
                    text: qsTr( "Total Tickets" )
                }
            }

            Rectangle {
                id: highScoreHeader
                color: "#666666"
                Layout.fillWidth: true
                Layout.fillHeight: true

                Text {
                    id: highScoreHeaderText
                    anchors.centerIn: parent
                    font.pixelSize: 24
                    font.bold: true
                    color: "white"
                    text: qsTr( "High Score" )
                }
            }
        }

        ListView {
            id: statsDisplay
            anchors.top: header.bottom
            anchors.topMargin: 10
            anchors.left: header.left
            anchors.right: header.right
            model: DataManager.stats
            height: 400
            clip: true
            visible: 0 !== DataManager.stats.length

            delegate: Item {
                id: statsDelegate
                anchors.left: parent.left
                anchors.right: parent.right
                height: 42

                RowLayout {
                    id: statsDelegateLayout
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 40
                    spacing: header.spacing

                    Rectangle {
                        id: gameName
                        color: "#444444"
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Text {
                            id: gameNameText
                            anchors.centerIn: parent
                            font.pixelSize: 20
                            color: "white"
                            text: modelData[ 0 ]
                        }
                    }

                    Rectangle {
                        id: gamesPlayed
                        color: "#444444"
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Text {
                            id: gamesPlayedText
                            anchors.centerIn: parent
                            font.pixelSize: 20
                            color: "white"
                            text: modelData[ 1 ]
                        }
                    }

                    Rectangle {
                        id: ticketsEarned
                        color: "#444444"
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Text {
                            id: ticketsEarnedText
                            anchors.centerIn: parent
                            font.pixelSize: 20
                            color: "white"
                            text: modelData[ 2 ]
                        }
                    }

                    Rectangle {
                        id: highScore
                        color: "#444444"
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Text {
                            id: highScoreText
                            anchors.centerIn: parent
                            font.pixelSize: 20
                            color: "white"
                            text: modelData[ 3 ]
                        }
                    }
                }

                Rectangle {
                    id: divider
                    anchors.top: statsDelegateLayout.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 2
                    color: background.color
                }
            }
        }

        Item {
            id: emptyText
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 40
            anchors.right: parent.right
            anchors.rightMargin: 40
            height: 100
            visible: 0 === DataManager.stats.length

            Text {
                id: emptyTextHeader
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 32
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                color: "white"
                text: qsTr( "Nothing to see here!" )
            }

            Text {
                id: emptyTextSubHeader
                anchors.top: emptyTextHeader.bottom
                anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 28
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                color: "white"
                text: qsTr( "Play some games and come back to see how you're doing." )
            }
        }
    }

    MenuButton {
        id: backButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40
        buttonWidth: 300
        buttonHeight: 75
        buttonText: qsTr( "Close" )

        onClicked: gameStatsOverlay.visible = false;
    }
}
