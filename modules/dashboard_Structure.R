dashboard_Structure_UI <- function(id) {
  ns <- NS(id)
  navbarPage(
    "Res-Q Dashboard",
    tabPanel(
      "Hospital Overview",
      page_HO(ns("HO"))
    ),
    tabPanel(
      "Patient Profiles",
      page_PC(ns("PC"))
    ),
    tabPanel(
      "Bleeding",
      page_Generic_UI(ns("Bleeding"), "Bleeding")
    ),
    tabPanel(
      "Imaging",
      page_Generic_UI(ns("Imaging"), "Imaging")
    ),
    tabPanel(
      "Treatment",
      page_Generic_UI(ns("Treatment"), "Treatment")
    ),
    tabPanel(
      "Phase One",
      page_Generic_UI(ns("PO"), "PO")
    ),
    tabPanel(
      "Discharge",
      page_Generic_UI(ns("Discharge"), "Discharge")
    )
  )
}

dashboard_Structure<- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      page_Generic("Bleeding", "Bleeding")
      page_Generic("Imaging", "Imaging")
      page_Generic("Treatment", "Treatment")
      page_Generic("PO", "PO")
      page_Generic("Discharge", "Discharge")
    }
  )
}