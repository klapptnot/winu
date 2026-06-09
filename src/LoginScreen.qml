import QtGraphicalEffects 1.5
import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
  id: loginScreen

  property var blurSource
  property var inactivityTimer
  property string selectedUser: userModel.lastUser || userModel.data(userModel.index(0, 0), Qt.UserRole + 1)
  property int selectedSession: sessionModel.lastIndex
  property bool loginErrorVisible: false

  onSelectedUserChanged: {
    mainAvatar.source = `/var/lib/AccountsService/icons/${selectedUser}`
  }

  function forceInputFocus() {
    passwordField.input.forceActiveFocus();
  }

  function isInputFocused() {
    return passwordField.input.activeFocus;
  }

  function clearInputFocus() {
    loginScreen.forceActiveFocus();
  }

  function getUserProp(userName, prop) {
    var roles = {
      name: Qt.UserRole + 1,
      realName: Qt.UserRole + 2,
      homeDir: Qt.UserRole + 3,
      icon: Qt.UserRole + 4
    };

    for (var i = 0; i < userModel.rowCount(); i++) {
      var idx = userModel.index(i, 0);

      if (userModel.data(idx, roles.name) === userName)
        return userModel.data(idx, roles[prop]);
    }

    return null;
  }

  Connections {
    target: sddm
    function onLoginFailed() {
      welcomeAnim.stop();
      passwordField.visible = true;
      loginScreen.loginErrorVisible = true;
      passwordField.input.forceActiveFocus();
      passwordField.input.selectAll();
    }
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true

    onClicked: {
      clearInputFocus()
      systemControls.closeAllBut()
      inactivityTimer.restart()
    }

    onPositionChanged: {
      inactivityTimer.restart();
    }
  }

  GaussianBlur {
    id: blurEffect
    anchors.fill: parent
    visible: conf.use_blur
    source: loginScreen.blurSource
    radius: conf.blur_radius
    samples: conf.blur_samples
    cached: true
  }

  Column {
    anchors.horizontalCenter: parent.horizontalCenter
    y: parent.height / 3.5
    spacing: 20

    Connections {
      target: sddm

      function onLoginFailed() {
        welcomeAnim.stop();
        loginScreen.loginErrorVisible = true;
        passwordField.visible = true;

        if (passwordField.input) {
          passwordField.input.forceActiveFocus();
          passwordField.input.selectAll();
        }
      }

      function onLoginSucceeded() {
        welcomeAnim.text = "Welcome";
        welcomeAnim.start();
      }
    }

    Rectangle {
      id: mainAvatarFrame
      width: 192
      height: 192
      radius: width / 2
      visible: false
    }

    OpacityMask {
      width: 192
      height: 192
      anchors.horizontalCenter: parent.horizontalCenter

      source: Image {
        id: mainAvatar
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop

        source: `/var/lib/AccountsService/icons/${selectedUser}`

        onStatusChanged: {
          if (status === Image.Error && source != "../assets/user-pic.png") {
            source = "../assets/user-pic.png";
          }
        }
      }

      maskSource: mainAvatarFrame
    }

    Text {
      id: usernameText
      anchors.horizontalCenter: parent.horizontalCenter
      text: getUserProp(selectedUser, "realName")
      font.pixelSize: 26
      font.weight: Font.Bold
      font.family: conf.font.primary
      color: conf.color.on_background
    }

    InputPassword {
      id: passwordField
      width: 296
      height: 36
      anchors.horizontalCenter: parent.horizontalCenter

      onLoginRequested: function(password) {
        welcomeAnim.text = "Starting"
        welcomeAnim.start();
        passwordField.visible = false;
        sddm.login(getUserProp(selectedUser, "name"), password, selectedSession);
      }

      Connections {
        target: passwordField.input
        function onTextChanged() {
          if (loginScreen.loginErrorVisible) {
            loginScreen.loginErrorVisible = false;
          }
          inactivityTimer.restart();
        }
      }
    }

    InfoChip {
      id: capsIndicator
      text: "Caps Lock is on"
      visible: keyboard.capsLock && !loginScreen.loginErrorVisible
    }

    InfoChip {
      id: loginErrorIndicator
      text: "Incorrect password"
      visible: loginScreen.loginErrorVisible && !keyboard.capsLock
    }

    Item {
      width: 1
      height: 40
    }

    Spinner {
      id: welcomeAnim
      text: "Starting"
      width: 296
      height: 90
      hideOnComplete: false
    }
  }

  ListView {
    id: userList
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    anchors.margins: 24
    width: 150
    height: 120
    model: userModel
    interactive: count > 3

    delegate: MouseArea {
      id: userItemFrame
      width: parent.width
      height: 60
      hoverEnabled: true

      onClicked: {
        selectedUser = model.name;
        loginScreen.forceInputFocus();
      }

      Rectangle {
        anchors.fill: parent
        radius: 6
        color: conf.color.on_surface
        opacity: userItemFrame.containsMouse ? 0.4 : (selectedUser === model.name ? 0.2 : 0.0)
        Behavior on opacity { NumberAnimation { duration: 150 } }
      }

      Row {
        height: 60
        spacing: 12
        anchors.fill: parent
        anchors.leftMargin: 8

        Rectangle {
          id: avatarMask
          width: 48
          height: 48
          radius: width / 2
          visible: false
          anchors.verticalCenter: parent.verticalCenter
        }

        OpacityMask {
          width: 48
          height: 48
          anchors.verticalCenter: parent.verticalCenter

          source: Image {
            width: 48
            height: 48
            source: `/var/lib/AccountsService/icons/${model.name}`
            fillMode: Image.PreserveAspectCrop

            onStatusChanged: {
              if (status === Image.Error && source != "../assets/user-pic.png") {
                source = "../assets/user-pic.png";
              }
            }
          }

          maskSource: avatarMask
        }

        Text {
          text: model.realName || model.name
          color: conf.color.on_background
          font.family: conf.font.primary
          anchors.verticalCenter: parent.verticalCenter
          font.pixelSize: 13
        }
      }
    }
  }

  DropButtonRow {
    id: systemControls

    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.margins: 24

    DropButton {
      text: "\ue77b"
      tooltipText: "Display Server Session"

      menuModel: sessionModel
      menuDelegate: ColumnMenuItem {
        label: name
        desc: selectedSession === index ? "Currently active" : "Switch environment " + name
        icon: selectedSession === index ? "\ue73a" : "\ue739"
        callback: function() { selectedSession = index; }
      }
    }

    // DropButton {
    //   text: "\ue774"
    //   tooltipText: "Languages"
    //
    //   menuModel: keyboard
    //   menuDelegate: ColumnMenuItem {
    //     label: model.longName
    //     desc: keyboard.currentLayout === index ? "Currently active" : "Switch layout to " + model.shortName
    //     icon: keyboard.currentLayout === index ? "\ue73a" : "\ue739"
    //     callback: function() { keyboard.currentLayout = index; }
    //   }
    // }

    DropButton {
      text: "\ue7e8"
      tooltipText: "Power"

      menuModel: [
        {
          label: "Sleep",
          desc: "Put the system to sleep",
          icon: "\ue708",
          callback: function() { sddm.suspend() }
        },
        {
          label: "Restart",
          desc: "Reboot the computer",
          icon: "\ue777",
          callback: function() { sddm.reboot() }
        },
        {
          label: "Shutdown",
          desc: "Power off the system",
          icon: "\ue7E8",
          callback: function() { sddm.powerOff() }
        }
      ]

      menuDelegate: ColumnMenuItem {
        label: modelData.label
        desc: modelData.desc
        icon: modelData.icon
        callback: modelData.callback
      }
    }
  }
}
