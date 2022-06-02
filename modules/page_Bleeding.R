page_Bleeding <- function(id, df) {
  fluidPage(
    fixedRow(
      QI_Bleeding_UI(id = id, database = df),
      visualization_Layout(id = id, database = df)
      
    )
  )
}