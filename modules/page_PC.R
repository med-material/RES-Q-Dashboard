page_PC <- function(id, df) {
  fluidPage(
    fixedRow(
      QI_PC_UI(id = id, database = df),
      visualization_Layout(id = id, database = df)
      
    )
  )
}
