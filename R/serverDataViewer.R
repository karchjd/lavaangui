serverDataViewer <- function(id, getData) {
  moduleServer(id, function(input, output, session) {
    callback <- c(
      "var colnames = table.columns().header().to$().map(function(){return this.innerHTML;}).get();",
      "table.on('dblclick.dt', 'thead th', function(e) {",
      "  var $th = $(this);",
      "  var index = $th.index();",
      "  var colname = $th.text(), newcolname = colname;",
      "  var $input = $('<input type=\"text\">')",
      "  $input.val(colname);",
      "  $th.empty().append($input);",
      "  $input.on('change', function(){",
      "    newcolname = $input.val();",
      "    if(newcolname != colname){",
      "      $(table.column(index).header()).text(newcolname);",
      "      colnames[index] = newcolname;",
      "      Shiny.setInputValue('newnames', colnames.slice(1));",
      "      Shiny.setInputValue('sendnames', Math.random());",
      "    }",
      "    $input.remove();",
      "  }).on('blur', function(){",
      "    $(table.column(index).header()).text(newcolname);",
      "    $input.remove();",
      "  });",
      "});"
    )


    output$tbl_data <- DT::renderDT(
      {
        df <- getData()
        # write code that converts every colunm in df that is of class labelled::is.labelled to factor without using dplyr
        df[] <- lapply(df, function(x) if (haven::is.labelled(x)) haven::as_factor(x) else x)

        DT::datatable(df,
          options = list(ordering = FALSE), callback = htmlwidgets::JS(callback)
        )
      },
      server = FALSE
    )
  })
}
