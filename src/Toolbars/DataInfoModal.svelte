<script>
  import { appState, dataInfo, columnNamesSTore } from "../stores";
  import { applyLinkedClass } from "../Shiny/applyLinkedClass";

  let state;
  let summary;
  let summaryAvail = false;

  let unsubscribe = appState.subscribe((newState) => {
    state = newState;
  });

  // Parsing the HTML string and storing all td elements
  let parser;
  let doc;
  let tds;

  function arraysAreEqual(arr1, arr2) {
    if (arr1.length !== arr2.length) return false;

    for (let i = 0; i < arr1.length; i++) {
      if (arr1[i] !== arr2[i]) return false;
    }

    return true;
  }

  let unsubscribe2 = dataInfo.subscribe((newState) => {
    if (
      state.dataAvail &&
      state.columnNames !== undefined &&
      state.ids !== undefined
    ) {
      if (arraysAreEqual(state.columnNames, state.ids)) {
        summary = newState;
        parser = new DOMParser();
        doc = parser.parseFromString(summary, "text/html");
        tds = Array.from(doc.querySelectorAll("td"));
        summaryAvail = true;
      } else {
        throw new Error(
          "Columnnames and ids where not the same after dataInfo was updated, should never happene"
        );
      }
    } else {
      summaryAvail = false;
    }
  });

  let unsubscribe3 = columnNamesSTore.subscribe((newState) => {
    if (state.dataAvail && newState !== undefined && state.ids !== undefined) {
      if (!arraysAreEqual(newState, state.ids)) {
        Shiny.setInputValue("newnames", JSON.stringify(newState));
        applyLinkedClass(newState, true);
      }
    }
  });

  function getTdsAfterId(id) {
    let found = false;
    let tdsAfterId = [];
    let rowsAfterId = [];
    let last_td;
    for (let td of tds) {
      if (found) {
        tdsAfterId.push(td.textContent.trim());
        if (!td.nextElementSibling) {
          last_td = td;
          break; // Break if we've reached the end of the row
        }
      } else if (td.textContent === id) {
        found = true;
      }
    }
    const lastElement = tdsAfterId[tdsAfterId.length - 1];
    if (lastElement == "") {
      let nextRow = last_td.parentElement.nextElementSibling;
      while (nextRow) {
        let firstTdInRow = nextRow
          .querySelector("td:first-child")
          .textContent.trim();
        if (firstTdInRow.startsWith("...")) {
          rowsAfterId.push(
            Array.from(nextRow.querySelectorAll("td")).map((t) =>
              t.textContent.trim()
            )
          );
          nextRow = nextRow.nextElementSibling;
        } else {
          break;
        }
      }
    }

    return {
      tdsAfterId: tdsAfterId,
      rowsAfterId: rowsAfterId,
    };
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
        <table>
          <tr>
            <th style="width: 22%; text-align: left">Variable</th>
            <th style="width: 11%; text-align: right">N</th>
            <th style="width: 11%; text-align: right">Mean</th>
            <th style="width: 11%; text-align: right">Std. Dev.</th>
            <th style="width: 11%; text-align: right">Min</th>
            <th style="width: 11%; text-align: right">Pctl. 25</th>
            <th style="width: 11%; text-align: right">Pctl. 75</th>
            <th style="width: 11%; text-align: right">Max</th>
          </tr>
          {#if summaryAvail}
            {#each $appState.columnNames as variable, i}
              {@const tdsAfter = getTdsAfterId(state.ids[i])}
              <tr>
                <td style="width: 22%; text-align: left"
                  ><input bind:value={variable} />
                </td>
                {#each tdsAfter.tdsAfterId as variable_info}
                  <td style="width: 11%; text-align: right">
                    {variable_info}
                  </td>
                {/each}
              </tr>
              {#if tdsAfter.rowsAfterId}
                {#each tdsAfter.rowsAfterId as row}
                  <tr>
                    {#each row as cell}
                      <td style="width: 11%; text-align: right">
                        {cell}
                      </td>
                    {/each}
                  </tr>
                {/each}
              {/if}
            {/each}
          {/if}
        </table>
      </div>
    </div>
  </div>
</div>

<style>
  p {
    font-size: smaller;
  }
  table {
    border: 0px;
    border-collapse: collapse;
    font-size: smaller;
    table-layout: fixed;
    margin-left: 0%;
    margin-right: auto;
  }
  .headtab {
    width: 100%;
    margin-left: auto;
    margin-right: auto;
  }
  th {
    background-color: #ffffff;
    font-weight: bold;
    text-align: left;
  }
  table tr:nth-child(odd) td {
    background-color: #ffffff;
    padding: 4px;
    word-wrap: break-word;
    word-break: break-all;
  }
  table tr:nth-child(even) td {
    background-color: #d3d3d3;
    padding: 4px;
    word-wrap: break-word;
    word-break: break-all;
  }

  input {
    width: 98%;
    padding: 1%;
  }
</style>
