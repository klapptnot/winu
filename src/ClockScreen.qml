import QtQuick 2.15

Item {
  id: clockScreen

  function updateTime() {
    var date = new Date();
    timeText.text = Qt.formatTime(date, "hh:mm");
    dateText.text = Qt.formatDate(date, "dddd, d MMMM");
  }

  Timer {
    id: clockTimer
    interval: 1000
    running: true
    repeat: true
    onTriggered: clockScreen.updateTime()
  }

  Component.onCompleted: clockScreen.updateTime()

  Column {
    anchors.horizontalCenter: parent.horizontalCenter
    y: parent.height / 6
    spacing: 8

    Text {
      id: timeText
      anchors.horizontalCenter: parent.horizontalCenter
      font.pixelSize: 108
      font.weight: Font.Normal
      font.family: conf.font.primary
      color: conf.color.primary
    }

    Text {
      id: dateText
      anchors.horizontalCenter: parent.horizontalCenter
      font.pixelSize: 24
      font.weight: Font.DemiBold
      font.family: conf.font.primary
      color: conf.color.primary
    }
  }
}
