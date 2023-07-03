<script>
  import Navbar from "./Navbar.svelte";
</script>

<Navbar>
  <li class="dropdown">
    <a href="#" class="dropdown-toggle" data-toggle="dropdown"
      >File <b class="caret" /></a
    >
    <ul class="dropdown-menu">
      <li id="newDiagramMenuItem"><a href="#">New Model</a></li>
      <li id="loadDiagramMenuItem"><a href="#">Load Model</a></li>
      <li id="loadDataMenuItem"><a href="#">Load Data</a></li>
      <li id="loadModelDataMenuItem">
        <a href="#">Load Model and Data</a>
      </li>
      <li class="divider" />
      <li id="saveDiagramMenuItem"><a href="#">Download Model</a></li>
      <li id="saveModelDataMenuItem">
        <a href="#">Download Model and Data</a>
      </li>
      <li class="divider" />
      <li id="removeDataItem"><a href="#">Remove Data</a></li>
      <li class="divider" />
      <li class="dropdown-submenu">
        <a tabindex="-1" href="#">Export Model</a>
        <ul class="dropdown-menu">
          <li id="exportJPGMenuItem" tabindex="-1">
            <a href="#">JPG</a>
          </li>
          <li id="exportPNGMenuItem" tabindex="-1">
            <a href="#">PNG</a>
          </li>
        </ul>
      </li>
    </ul>
  </li>
  <li class="dropdown">
    <a href="#" class="dropdown-toggle" data-toggle="dropdown"
      >Edit <b class="caret" /></a
    >
    <ul class="dropdown-menu">
      <li><a href="#">Cut</a></li>
      <li><a href="#">Copy</a></li>
      <li><a href="#">Paste</a></li>
    </ul>
  </li>
  <li class="dropdown" />
  <li class="dropdown">
    <a href="#" class="dropdown-toggle" data-toggle="dropdown"
      >Lavaan <b class="caret" /></a
    >
    <ul class="dropdown-menu">
      <li>
        <select class="selectpicker" multiple>
          <option>Option 1</option>
          <option>Option 2</option>
        </select>
      </li>
    </ul>
  </li>
  <li class="dropdown">
    <a href="#" class="dropdown-toggle" data-toggle="dropdown"
      >View <b class="caret" /></a
    >
    <ul class="dropdown-menu">
      <li class="checkmark-container" data-selected="false">
        <span class="checkmark" />
        <a href="#">Show Estimate</a>
      </li>
      <li class="checkmark-container" data-selected="false">
        <span class="checkmark" />
        <a href="#">Show pvalue</a>
      </li>
      <li class="checkmark-container" data-selected="false">
        <span class="checkmark" />
        <a href="#">Show standard error</a>
      </li>
      <li class="checkmark-container" data-selected="false">
        <span class="checkmark" />
        <a href="#">Show confidence interval</a>
      </li>
    </ul>
  </li>
  <li><a href="#" id="help-menu-item">Help</a></li>
</Navbar>
