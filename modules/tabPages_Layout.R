tabPages_HO <- function(tab_id, tab_df) {
  fluidPage(
    fixedRow(
      QI_Layout_HO(id = tab_id, database = tab_df),
      visualization_Layout(id = tab_id, database = tab_df)

    )
  )
}

tabPages_PC <- function(tab_id, tab_df) {
  fluidPage(
    fixedRow(
      QI_Layout_PC(id = tab_id, database = tab_df),
      visualization_Layout(id = tab_id, database = tab_df)

    )
  )
}

tabPages_Bleeding <- function(tab_id, tab_df) {
  fluidPage(
    fixedRow(
      QI_Layout_Bleeding(id = tab_id, database = tab_df),
      visualization_Layout(id = tab_id, database = tab_df)
      
    )
  )
}

tabPages_Imaging <- function(tab_id, tab_df) {
  fluidPage(
    fixedRow(
      QI_Layout_Imaging(id = tab_id, database = tab_df),
      visualization_Layout(id = tab_id, database = tab_df)
      
    )
  )
}

tabPages_Treatment <- function(tab_id, tab_df) {
  fluidPage(
    fixedRow(
      QI_Layout_Treatment(id = tab_id, database = tab_df),
      visualization_Layout(id = tab_id, database = tab_df)
      
    )
  )
}

tabPages_PO <- function(tab_id, tab_df) {
  fluidPage(
    fixedRow(
      QI_Layout_PO(id = tab_id, database = tab_df),
      visualization_Layout(id = tab_id, database = tab_df)
      
    )
  )
}

tabPages_Discharge <- function(tab_id, tab_df) {
  fluidPage(
    fixedRow(
      QI_Layout_Discharge(id = tab_id, database = tab_df),
      visualization_Layout(id = tab_id, database = tab_df)
      
    )
  )
}