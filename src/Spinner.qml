import QtQuick 2.15

Item {
  id: spinner

  property bool hideOnComplete: true
  property var onAnimationFinished: null
  property string text
  property bool active: false

  readonly property var spinnerFrames: [
    "\ue052", "\ue053", "\ue054", "\ue055", "\ue056", "\ue057", "\ue058", "\ue059", "\ue05a", "\ue05b", "\ue05c",
    "\ue05d", "\ue05e", "\ue05f", "\ue060", "\ue061", "\ue062", "\ue063", "\ue064", "\ue065", "\ue066", "\ue067",
    "\ue068", "\ue069", "\ue06a", "\ue06b", "\ue06c", "\ue06d", "\ue06e", "\ue06f", "\ue070", "\ue071", "\ue072",
    "\ue073", "\ue074", "\ue075", "\ue076", "\ue077", "\ue078", "\ue079", "\ue07a", "\ue07b", "\ue07c", "\ue07d",
    "\ue07e", "\ue07f", "\ue080", "\ue081", "\ue082", "\ue083", "\ue084", "\ue085", "\ue086", "\ue087", "\ue088",
    "\ue089", "\ue08a", "\ue08b", "\ue08c", "\ue08d", "\ue08e", "\ue08f", "\ue090", "\ue091", "\ue092", "\ue093",
    "\ue094", "\ue095", "\ue096", "\ue097", "\ue098", "\ue099", "\ue09a", "\ue09b", "\ue09c", "\ue09d", "\ue09e",
    "\ue09f", "\ue0a0", "\ue0a1", "\ue0a2", "\ue0a3", "\ue0a4", "\ue0a5", "\ue0a6", "\ue0a7", "\ue0a8", "\ue0a9",
    "\ue0aa", "\ue0ab", "\ue0ac", "\ue0ad", "\ue0ae", "\ue0af", "\ue0b0", "\ue0b1", "\ue0b2", "\ue0b3", "\ue0b4",
    "\ue0b5", "\ue0b6", "\ue0b7", "\ue0b8", "\ue0b9", "\ue0ba", "\ue0bb", "\ue0bc", "\ue0bd", "\ue0be", "\ue0bf",
    "\ue0c0", "\ue0c1", "\ue0c2", "\ue0c3", "\ue0c4", "\ue0c5", "\ue0c6"
  ]
  property int currentFrameIndex: 0

  function start() {
    active = true;
    currentFrameIndex = 0;
    frameTimer.restart();
    playbackTimer.restart();
  }

  function stop() {
    active = false;
    frameTimer.stop();
    playbackTimer.stop();
  }

  implicitWidth: contentColumn.implicitWidth
  implicitHeight: contentColumn.implicitHeight

  visible: opacity > 0
  opacity: active ? 1.0 : 0.0

  Behavior on opacity {
    NumberAnimation {
      duration: 300
      easing.type: Easing.InOutQuad
    }
  }

  Timer {
    id: frameTimer
    interval: 30
    running: false
    repeat: true
    onTriggered: {
      spinner.currentFrameIndex = (spinner.currentFrameIndex + 1) % spinner.spinnerFrames.length;
    }
  }

  Column {
    id: contentColumn
    anchors.centerIn: parent
    anchors.topMargin: 40
    spacing: 24

    Text {
      text: spinner.spinnerFrames[spinner.currentFrameIndex]
      font.family: conf.font.meiryo_boot
      font.pixelSize: 48
      color: conf.color.primary
      anchors.horizontalCenter: parent.horizontalCenter
    }

    Text {
      text: spinner.text
      font.family: conf.font.primary
      font.pixelSize: 24
      font.weight: Font.Light
      color: conf.color.on_background
      anchors.horizontalCenter: parent.horizontalCenter
    }
  }

  Timer {
    id: playbackTimer
    interval: 2500
    running: false
    repeat: false

    onTriggered: {
      if (spinner.hideOnComplete) {
        spinner.active = false;
        frameTimer.stop();
      }
      if (typeof spinner.onAnimationFinished === "function") {
        spinner.onAnimationFinished();
      }
    }
  }
}
