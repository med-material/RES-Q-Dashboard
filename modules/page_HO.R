page_HO <- function(id, df) {
  fluidPage(
    fixedRow(
      QI_HO_UI(id = id, database = df),
      visualization_Layout(id = id, database = df)
      
    )
  )
}

