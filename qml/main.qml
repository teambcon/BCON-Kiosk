import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.VirtualKeyboard 2.2

Window {
    id: window
    visible: true
    width: 800
    height: 720
    title: qsTr( "BCON Kiosk" )

    Loader {
        id: mainWindowLoader
        anchors.fill: parent
        source: "qrc:/SplashScreen.qml"
    }

    Timer {
        id: splashScreenTimer
        interval: 2500
        running: true
        repeat: false

        onTriggered: mainWindowLoader.source = "qrc:/BaseView.qml"
    }

    InputPanel {
        id: inputPanel
        z: 99
        x: 0
        y: window.height
        width: window.width

        states: State {
            name: "visible"
            when: inputPanel.active
            PropertyChanges {
                target: inputPanel
                y: window.height - inputPanel.height
            }
        }

        transitions: Transition {
            from: ""
            to: "visible"
            reversible: true
            ParallelAnimation {
                NumberAnimation {
                    properties: "y"
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }
}
