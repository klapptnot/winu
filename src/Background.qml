import QtQuick 2.15
import QtMultimedia 5.15

Item {
  id: root
  anchors.fill: parent

  property var gallery: []
  property bool enableVideo: false
  property bool carousel: false
  property int interval: 60000

  property alias source: bgLoader.item

  property int currentIndex: 0
  property var currentAsset: (gallery && gallery.length > 0) ? gallery[currentIndex] : ""

  function isVideo(path) {
    if (!path) return false;
    var ext = path.split('.').pop().toLowerCase();
    return ext === "mp4" || ext === "webm" || ext === "mkv" || ext === "mov";
  }

  function getFirstVideoIndex() {
    for (var i = 0; i < root.gallery.length; i++) {
      if (isVideo(root.gallery[i])) {
        return i;
      }
    }
    return -1;
  }

  function nextImage() {
    if (!root.gallery || root.gallery.length <= 1) return;

    var nextIdx = root.currentIndex;
    var attempts = 0;

    while (attempts < root.gallery.length) {
      nextIdx = (nextIdx + 1) % root.gallery.length;
      if (!isVideo(root.gallery[nextIdx])) {
        root.currentIndex = nextIdx;

        if (bgLoader.sourceComponent === imageComponent) {
          var container = bgLoader.item;
          if (root.carousel && container.stageImg) {
            container.stageImg.source = root.currentAsset;
          } else if (container.bgImg) {
            container.bgImg.source = root.currentAsset;
          }
        }
        return;
      }
      attempts++;
    }
  }

  Component.onCompleted: {
    if (!root.gallery || root.gallery.length === 0) return;

    if (root.enableVideo) {
      var videoIdx = getFirstVideoIndex();
      if (videoIdx !== -1) {
        root.currentIndex = videoIdx;
      }
    } else {
      if (isVideo(root.currentAsset)) {
        nextImage();
      }
    }
  }

  Loader {
    id: bgLoader
    anchors.fill: parent
    sourceComponent: (root.enableVideo && root.isVideo(root.currentAsset)) ? videoComponent : imageComponent
  }

  Component {
    id: videoComponent
    Video {
      id: video
      anchors.fill: parent
      source: root.currentAsset
      loops: MediaPlayer.Infinite
      flushMode: VideoOutput.LastFrame
      autoPlay: true
      muted: true
      onErrorChanged: {
        root.currentAsset = (gallery && gallery.length > 0) ? gallery[0] : ""
        if (isVideo(root.currentAsset)) nextImage();
        bgLoader.sourceComponent = imageComponent
      }
      onStatusChanged: {
        if (status === MediaPlayer.Loaded) {
          video.play();
          return;
        }
      }
    }
  }

  Component {
    id: imageComponent
    Item {
      anchors.fill: parent

      property alias bgImg: imageBg
      property alias stageImg: imageStage

      Image {
        id: imageBg
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        asynchronous: true

        Component.onCompleted: {
          imageBg.source = root.currentAsset;
        }
      }

      Image {
        id: imageStage
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        opacity: 0
        visible: root.carousel

        onStatusChanged: {
          if (status === Image.Ready && source !== "") {
            fadeAnim.start();
          }
        }

        NumberAnimation {
          id: fadeAnim
          target: imageStage
          property: "opacity"
          to: 1
          duration: 800
          easing.type: Easing.InOutQuad
          onStopped: {
            imageBg.source = imageStage.source;
            imageStage.opacity = 0;
            imageStage.source = "";
          }
        }
      }
    }
  }

  Timer {
    id: carouselTimer
    interval: root.interval
    running: root.carousel && !root.enableVideo
    repeat: true
    onTriggered: root.nextImage()
  }
}
