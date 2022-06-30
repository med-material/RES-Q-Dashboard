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
      page_Generic_UI(ns("Bleeding"))
    ),
    tabPanel(
      "Imaging",
      page_Generic_UI(ns("Imaging"))
    ),
    tabPanel(
      "Treatment",
      page_Generic_UI(ns("Treatment"))
    ),
    tabPanel(
      "Phase One",
      page_Generic_UI(ns("PO"))
    ),
    tabPanel(
      "Discharge",
      page_Generic_UI(ns("Discharge"))
    )
  )
}

dashboard_Structure<- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      page_Generic("Bleeding")
      page_Generic("Imaging")
      page_Generic("Treatment")
      page_Generic("PO")
      page_Generic("Discharge")
    }
  )
}