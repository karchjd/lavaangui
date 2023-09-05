<script>
    import { appState, dataInfo } from "../stores";
    let state;
    let summary;
  
  
    let unsubscribe = appState.subscribe((newState) => {
      state = newState;
    });
  
    let unsubscribe2 = dataInfo.subscribe((newState) => {
      if (state.dataAvail) {
        summary = newState.summary;
      }
    });
  
    function showInfo() {
      window.$("#data-modal").modal();
    }
  </script>
<div class="modal fade" tabindex="-1" role="dialog" id="data-modal">
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
        <h4 class="modal-title">Data Information</h4>
      </div>
      <div class="modal-body" id="data-content">
        {@html summary}
      </div>
    </div>
  </div>
</div>
