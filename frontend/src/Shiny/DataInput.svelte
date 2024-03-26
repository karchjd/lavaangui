<div class="form-group shiny-input-container">
  <label
    class="control-label shiny-label-null"
    for="fileInput"
    id="fileInput-label"
  />
  <div class="input-group">
    <label class="input-group-btn input-group-prepend">
      <span class="btn btn-default btn-file">
        Browse...
        <input
          id="dataUpload-fileInput"
          name="fileInput"
          type="file"
          style="position: absolute !important; top: -99999px !important; left: -99999px !important;"
          accept=".csv,.sav, .xlsx, .rds"
        />
      </span>
    </label>
    <input
      type="text"
      class="form-control"
      placeholder="No file selected"
      readonly="readonly"
    />
  </div>
  <div
    id="fileInput_progress"
    class="progress active shiny-file-input-progress"
  >
    <div class="progress-bar" />
  </div>
</div>

<style>
  div {
    display: none;
  }
</style>
