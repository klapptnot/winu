(function() {
  if (typeof Qt.alpha === "undefined") {
    Qt.alpha = function(baseColor, alphaValue) {
      var colorStr = baseColor.toString();
      if (colorStr.indexOf("#") === 0) {
        var hex = colorStr.replace("#", "");
        if (hex.length === 3) {
          hex = hex.split("").map(function(char) {
            return char + char;
          }).join("");
        }
        var alphaHex = Math.round(alphaValue * 255).toString(16);
        if (alphaHex.length === 1) {
          alphaHex = "0" + alphaHex;
        }
        return "#" + alphaHex + hex;
      }
      return colorStr;
    };
  }
})();
