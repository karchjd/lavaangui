<script>
  function showHelp() {
    window.$("#help").modal();
  }
</script>

<li><a href={'#'} id="help-menu-item" on:click={showHelp}>Help</a></li>
<div class="modal fade" tabindex="-1" role="dialog" id="help">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button
          type="button"
          class="close"
          data-dismiss="modal"
          aria-label="Close"
        >
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title">Help</h4>
      </div>
      <div class="modal-body" id="help-content">
        <table class="table">
          <thead>
            <tr>
              <th>Command</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>Hold command/ctrl</td>
              <td>Draw directed arrows</td>
            </tr>
            <tr>
              <td>Hold space</td>
              <td>
                Draw undirected arrows (currently disabled because of bug)
              </td>
            </tr>
            <tr>
              <td>Backspace</td>
              <td>Delete selected elements</td>
            </tr>
            <tr>
              <td>o</td>
              <td>Create observed variable at mouse location</td>
            </tr>
            <tr>
              <td>l</td>
              <td>Create latent variable at mouse location</td>
            </tr>
            <tr>
              <td>c</td>
              <td>Create constant variable at mouse location</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>
