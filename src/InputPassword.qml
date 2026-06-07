import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.5

Item {
  id: root
  implicitWidth: 296
  implicitHeight: 36
  property alias input: passwordInput
  signal loginRequested(string password)

  function selectAllText() {
    innerTextInputId.forceActiveFocus();
    innerTextInputId.selectAll();
  }

  Rectangle {
    id: roundMask
    visible: false
    anchors.fill: root
    radius: 6
    clip: true
  }

  Rectangle {
    id: background
    anchors.fill: parent
    radius: 6
    clip: true

    color: passwordInput.activeFocus
      ? Qt.alpha(conf.color.surface, 0.7)
      : Qt.alpha(conf.color.surface, 0.1)

    border.color: conf.color.outline
    border.width: 1

    Behavior on color { ColorAnimation { duration: 150 } }
    Behavior on border.color { ColorAnimation { duration: 150 } }

    layer.enabled: true
    layer.effect: OpacityMask {
        maskSource: Rectangle {
            width: background.width
            height: background.height
            radius: background.radius
        }
    }

  Rectangle {
      id: bottomLineLine
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      height: 2
      color: passwordInput.activeFocus ? conf.color.primary : conf.color.on_surface
    }

    RowLayout {
      anchors.fill: parent
      anchors.leftMargin: 12
      anchors.rightMargin: 8
      spacing: 4

      TextInput {
        id: passwordInput
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignVCenter

        color: conf.color.on_surface
        font.pixelSize: 14
        selectionColor: conf.color.primary
        selectByMouse: true
        cursorVisible: activeFocus

        echoMode: eyeButton.pressed ? TextInput.Normal : TextInput.Password

        onAccepted: {
          root.loginRequested(passwordInput.text)
        }

        Text {
          text: "Password"
          color: conf.color.on_surface
          font: passwordInput.font
          visible: !passwordInput.text
          anchors.fill: parent
          verticalAlignment: Text.AlignVCenter
        }
      }

      Button {
        id: eyeButton
        Layout.preferredWidth: 22
        Layout.preferredHeight: 22
        Layout.alignment: Qt.AlignVCenter
        visible: passwordInput.text.length > 0
        focusPolicy: Qt.NoFocus
        flat: true

        background: Rectangle {
          color: "transparent" // eyeButton.hovered ? "#15ffffff" : "transparent"
          radius: 4
        }

        contentItem: Text {
          text: "\ue890"
          font.pixelSize: 16
          font.family: conf.font.segoe_ui
          color: eyeButton.hovered ? conf.color.primary : conf.color.on_background
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
        }
      }

      Button {
        id: unlockButton
        Layout.preferredWidth: 32
        Layout.preferredHeight: 22
        Layout.alignment: Qt.AlignVCenter
        hoverEnabled: true
        flat: true

        onClicked: {
          root.loginRequested(passwordInput.text)
        }

        background: Rectangle {
          color: unlockButton.hovered ? conf.color.primary : "transparent"
          radius: 4

          Behavior on opacity { NumberAnimation { duration: 100 } }
        }

        contentItem: Text {
          text: "\uebe7"
          font.pixelSize: 18
          font.family: conf.font.segoe_ui
          color: unlockButton.hovered ? conf.color.surface : conf.color.primary
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter

          Behavior on color { ColorAnimation { duration: 100 } }
        }
      }
    }
  }
}
