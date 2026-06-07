import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
  id: menuItem

  property string label: ""
  property string desc: ""
  property string icon: ""
  property var callback: null
  readonly property bool hovered: hoverHandler.hovered

  width: parent.width
  height: 40
  radius: 4
  color: hoverHandler.hovered ? conf.color.primary : "transparent"

  Row {
    anchors.fill: parent
    anchors.leftMargin: 12
    anchors.rightMargin: 12
    spacing: 10

    Text {
      id: iconText
      text: menuItem.icon
      font.family: conf.font.segoe_ui
      font.pixelSize: 16
      color: hoverHandler.hovered ? conf.color.on_primary : conf.color.on_background
      anchors.verticalCenter: parent.verticalCenter
    }

    Item {
      height: parent.height
      width: parent.width - iconText.width - parent.spacing
      clip: true
      anchors.verticalCenter: parent.verticalCenter

      Text {
        id: labelText
        text: menuItem.label
        font.family: conf.font.primary
        font.pixelSize: 14
        color: hoverHandler.hovered ? conf.color.on_primary : conf.color.on_background
        anchors.verticalCenter: parent.verticalCenter

        readonly property bool isOverflowing: implicitWidth > parent.width

        SequentialAnimation on x {
          id: scrollAnimation
          running: labelText.isOverflowing && hoverHandler.hovered
          loops: Animation.Infinite

          PauseAnimation { duration: 1000 }

          NumberAnimation {
            to: parent.width - labelText.implicitWidth - 4
            duration: Math.max(1000, labelText.implicitWidth * 15)
            easing.type: Easing.InOutQuad
          }

          PauseAnimation { duration: 1000 }

          NumberAnimation {
            to: 0
            duration: Math.max(1000, labelText.implicitWidth * 15)
            easing.type: Easing.InOutQuad
          }
        }

        onIsOverflowingChanged: x = 0
        Connections {
          target: hoverHandler
          function onHoveredChanged() {
            if (!hoverHandler.hovered) {
              labelText.x = 0;
            }
          }
        }
      }
    }
  }

  HoverHandler { id: hoverHandler }

  Tooltip {
    text: menuItem.desc
    target: menuItem
  }

  TapHandler {
    onTapped: {
      if (menuItem.callback) {
        menuItem.callback();
      }
      // menuItem.parent.parent.visible = false;
    }
  }
}
