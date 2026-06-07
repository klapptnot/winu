import QtQuick 2.15
import QtQuick.Window 2.15
import "src/Polyfill.js" as CantBelieveIHaveToDoThisInQT5
import "src"

Rectangle {
  id: root
  Config { id: conf }

  width: Screen.width
  height: Screen.height
  color: conf.color.background

  states: [
    State {
      name: "lockscreen"
      PropertyChanges { target: clockLayer; y: 0; opacity: 1 }
      PropertyChanges { target: loginLayer; opacity: 0 }
    },
    State {
      name: "login"
      PropertyChanges { target: clockLayer; y: -root.height; opacity: 0 }
      PropertyChanges { target: loginLayer; opacity: 1 }
    }
  ]

  state: "lockscreen"

  transitions: [
    Transition {
      from: "lockscreen"; to: "login"
      ParallelAnimation {
        NumberAnimation {
          target: clockLayer
          property: "y"
          duration: 500
          easing.type: Easing.OutCubic
        }
        NumberAnimation {
          target: clockLayer
          property: "opacity"
          duration: 200
          easing.type: Easing.Linear
        }
        NumberAnimation {
          target: loginLayer
          property: "opacity"
          duration: 400
          easing.type: Easing.InOutQuad
        }
      }
      ScriptAction { script: loginLayer.forceInputFocus() }
    },
    Transition {
      from: "login"; to: "lockscreen"
      ParallelAnimation {
        NumberAnimation {
          target: clockLayer
          properties: "y,opacity"
          duration: 500
          easing.type: Easing.OutCubic
        }
        NumberAnimation {
          target: loginLayer
          property: "opacity"
          duration: 300
          easing.type: Easing.InOutQuad
        }
      }
    }
  ]

  Timer {
    id: inactivityTimer
    interval: conf.inactivityTimeout
    running: root.state === "login"
    repeat: false
    onTriggered: {
      loginLayer.clearInputFocus();
      root.state = "lockscreen";
    }
  }

  Shortcut {
    sequences: ["Space", "Enter", "Return"]
    enabled: root.state === "lockscreen"
    onActivated: {
      root.state = "login";
    }
  }

  MouseArea {
    anchors.fill: parent
    enabled: root.state === "lockscreen"
    onClicked: {
      root.state = "login";
    }
  }

  Shortcut {
    sequence: "Escape"
    enabled: root.state === "login"
    onActivated: {
      if (loginLayer.isInputFocused()) {
        loginLayer.clearInputFocus();
      } else {
        root.state = "lockscreen";
      }
    }
  }

  Background {
    id: background
    gallery: conf.backgrounds
    enableVideo: conf.use_video
    carousel: conf.image_carousel
    interval: conf.carousel_interval
  }

  LoginScreen {
    id: loginLayer
    anchors.fill: parent
    visible: opacity > 0
    blurSource: background.source
    inactivityTimer: inactivityTimer
  }

  ClockScreen {
    id: clockLayer
    width: parent.width
    height: parent.height
  }
}
