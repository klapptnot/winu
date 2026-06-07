import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
  id: root

  default property list<DropButton> buttons

  implicitWidth: layoutRow.implicitWidth
  implicitHeight: layoutRow.implicitHeight

  function closeAllBut(idx) {
    for (var i = 0; i < buttonRepeater.count; ++i) {
      var item = buttonRepeater.itemAt(i);
      if (item.menuVisible && i != idx) {
        item.menuVisible = false;
      }
    }
  }

  TapHandler {
    target: null
    gesturePolicy: TapHandler.ReleaseWithinBounds
    onTapped: root.closeAllBut()
  }

  Row {
    id: layoutRow
    spacing: 10
    anchors.fill: parent

    Repeater {
      id: buttonRepeater
      model: root.buttons

      delegate: Button {
        id: btn
        hoverEnabled: true
        text: modelData.text
        anchors.verticalCenter: parent.verticalCenter

        property bool menuVisible: false
        onClicked: {
          root.closeAllBut(index);
          menuVisible = !menuVisible
        }

        onMenuVisibleChanged: {
          dropMenu.visible = menuVisible;
        }

        HoverHandler { id: btnHover }

        Tooltip {
          text: modelData.tooltipText
          active: !btn.menuVisible
          target: btn
        }

        contentItem: Text {
          text: btn.text
          color: btnHover.hovered ? conf.color.primary : conf.color.on_surface
          font.family: conf.font.segoe_ui
          font.pixelSize: 18
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
          Behavior on color { ColorAnimation { duration: 150 } }
        }

        background: Rectangle {
          implicitWidth: 36
          implicitHeight: 36
          radius: 6
          color: btnHover.hovered ? Qt.alpha(conf.color.surface, 0.5) : "transparent"
          Behavior on color { ColorAnimation { duration: 150 } }
        }

        ColumnMenu {
          id: dropMenu
          target: btn
          onVisibleChanged: {
            btn.menuVisible = visible;
          }

          Repeater {
            model: modelData.menuModel
            delegate: modelData.menuDelegate
          }
        }
      }
    }
  }
}
