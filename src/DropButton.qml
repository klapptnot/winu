import QtQuick 2.15

QtObject {
  id: root

  property string text: ""
  property string tooltipText: ""
  property string layout: "column"

  property var menuModel: null
  property Component menuDelegate: null

  default property list<ColumnMenuItem> menuItems;
}
