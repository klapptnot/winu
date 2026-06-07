import QtQuick 2.15

Rectangle {
  id: root

  property alias text: label.text
  property alias font: label.font
  property alias textItem: label

  radius: 8
  color: conf.color.surface

  anchors.horizontalCenter: parent.horizontalCenter
  implicitWidth: contentRow.implicitWidth + 16
  implicitHeight: contentRow.implicitHeight + 12

  Row {
    id: contentRow
    anchors.centerIn: parent
    spacing: 6

    Text {
      id: label
      text: ""
      color: "white"
      font.pixelSize: 12
    }
  }
}
