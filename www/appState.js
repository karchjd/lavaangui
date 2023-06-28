const appState = {
  columnNamesGlobal: null,
  loadedFileName: null,
  loadingMode: false,
  runCounter: 0,
  modelEmpty: true,
  dataAvail: false,
  setColumnNamesGlobal: function (value) {
    this.columnNamesGlobal = value;
  },
  getColumnNamesGlobal: function () {
    return this.columnNamesGlobal;
  },
  setLoadedFileName: function (value) {
    this.loadedFileName = value;
  },
  getLoadedFileName: function () {
    return this.loadedFileName;
  },
  setLoadingMode: function (value) {
    this.loadingMode = value;
  },
  isLoadingMode: function () {
    return this.loadingMode;
  },
  increaseRun: function () {
    return this.runCounter++;
  },
  modelIsEmpty: function () {
    return this.modelEmpty;
  },
  setModelEmpty: function (value) {
    if (value) {
      $("#saveDiagramMenuItem").addClass("disabled");
      if (this.isDataAvail()) {
        $("#saveModelDataMenuItem").addClass("disabled");
      }
    } else {
      $("#saveDiagramMenuItem").removeClass("disabled");
      if (this.isDataAvail()) {
        $("#saveModelDataMenuItem").removeClass("disabled");
      }
    }
    this.modelEmpty = value;
  },
  isDataAvail: function () {
    return this.dataAvail;
  },
  setDataAvail: function (value) {
    if (value && !this.modelIsEmpty()) {
      $("#saveModelDataMenuItem").removeClass("disabled");
    } else {
      this.getColumnNamesGlobal(null);
      this.loadedFileName = null;
      cy.nodes().removeClass("linked");
      if (!this.modelIsEmpty()) {
        $("#saveModelDataMenuItem").addClass("disabled");
      }
    }
    this.dataAvail = value;
  },
};

$("#saveDiagramMenuItem").addClass("disabled");
$("#saveModelDataMenuItem").addClass("disabled");
