import QtQuick 2.15

Rectangle {
  id: menuContainer

  property Item target: null
  default property alias menuItems: menuColumn.children

  radius: 6
  color: conf.color.surface

  width: 160
  height: menuColumn.implicitHeight + 16

  visible: false
  opacity: visible ? 1 : 0

  x: -110
  y: target ? target.y - height - 8 : 0

  Behavior on opacity {
    NumberAnimation { duration: 120 }
  }

  Column {
    id: menuColumn
    anchors.fill: parent
    anchors.margins: 8
    spacing: 4
  }

  TapHandler {
    target: null
    gesturePolicy: TapHandler.ReleaseWithinBounds
    onTapped: menuContainer.visible = false
  }
}
