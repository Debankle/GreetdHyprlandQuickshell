import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Greetd

FloatingWindow {
    property string username: ""
    property string password: ""

    Rectangle {
        anchors.fill: parent
        color: "#111318"

        ColumnLayout {
            anchors.centerIn: parent
            width: 340
            spacing: 18

            Text {
                text: "Welcome back"
                color: "#e6e9ef"
                font.pixelSize: 36
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: 10
            }

            ColumnLayout {
                spacing: 6
                Layout.fillWidth: true

                Text {
                    text: "Username"
                    color: "#9aa3b2"
                    font.pixelSize: 13
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 40
                    radius: 8
                    color: "#222633"
                    border.width: usernameField.focus ? 2 : 1
                    border.color: usernameField.focus ? "#4c78ff" : "#2a2f3a"

                    TextInput {
                        id: usernameField
                        anchors.fill: parent
                        anchors.margins: 10
                        color: "#e6e9ef"
                        focus: true

                        onAccepted: passwordField.focus = true
                        onTextChanged: username = text
                    }
                }
            }

            ColumnLayout {
                spacing: 6
                Layout.fillWidth: true

                Text {
                    text: "Password"
                    color: "#9aa3b2"
                    font.pixelSize: 13
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 40
                    radius: 8
                    color: "#222633"
                    border.width: passwordField.focus ? 2 : 1
                    border.color: passwordField.focus ? "#4c78ff" : "#2a2f3a"

                    TextInput {
                        id: passwordField
                        anchors.fill: parent
                        anchors.margins: 10
                        color: "#e6e9ef"
                        echoMode: TextInput.Password

                        onAccepted: {
                            if (username && text) {
                                password = text
                                Greetd.createSession(username)
                            }
                        }

                        onTextChanged: password = text
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 44
                radius: 8
                color: loginMouse.pressed ? "#3b63d6" : "#4c78ff"

                MouseArea {
                    id: loginMouse
                    anchors.fill: parent
                    onClicked: {
                        if (username && password) {
                            Greetd.createSession(username)
                        }
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: "Login"
                    color: "white"
                    font.pixelSize: 15
                    font.weight: Font.Medium
                }
            }
        }
    }

    // Implement the necessary Greetd functions for the Quickshell API
    // https://quickshell.org/docs/v0.2.1/types/Quickshell.Services.Greetd/Greetd/
    Connections {
        target: Greetd
        
        function onAuthMessage(message, error, responseRequired, echoResponse) {
            if (responseRequired) {
                if (message.toLowerCase().includes("password")) {
                    Greetd.respond(password)
                } else {
                    Greetd.respond(username)
                }
            }
        }
        
        function onAuthFailure(message) {
            passwordField.text = ""
            username = ""
            password = ""
        }
        
        function onReadyToLaunch() {
            // Launch default session (Hyprland)
            Greetd.launch(["start-hyprland > /dev/null 2>&1"])
        }
    }
}
