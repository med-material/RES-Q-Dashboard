page_PO <- function(id, df) {
  fluidPage(
    fixedRow(
      QI_PO_UI(id = id, database = df),
      visualization_Layout(id = id, database = df)
      
    )
  )
}