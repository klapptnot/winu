import QtQuick 2.15
import QtQuick.Window 2.15

Rectangle {
    id: tooltipBox

    property Item target
    property string text
    property int size: 15
    property int delay: 500
    property int pad: size / 2.5
    property bool active: true

    visible: false
    opacity: 0

    radius: 6
    color: conf.color.surface
    // border.color: conf.color.outline
    anchors.bottomMargin: 8
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.top

    implicitWidth: tooltipText.implicitWidth + pad * 2
    implicitHeight: tooltipText.implicitHeight + pad * 2

    x: Math.max(0, Math.min(
        target.x + target.width / 2 - width / 2,
        Screen.width - width
    ))

    Behavior on opacity {
        NumberAnimation { duration: 120 }
    }

    Text {
        id: tooltipText
        anchors.centerIn: parent
        text: tooltipBox.text
        color: conf.color.on_background
        font.family: conf.font.primary
        font.weight: Font.DemiBold
        font.pixelSize: size
    }

    Timer {
        id: showTimer
        interval: tooltipBox.delay
        repeat: false
        onTriggered: {
            tooltipBox.visible = true
            tooltipBox.opacity = 1
        }
    }

    Connections {
        target: tooltipBox.target

        function onHoveredChanged() {
            if (tooltipBox.target.hovered && tooltipBox.active) {
                showTimer.restart()
            } else {
                showTimer.stop()
                tooltipBox.visible = false
                tooltipBox.opacity = 0
            }
        }
    }
}
