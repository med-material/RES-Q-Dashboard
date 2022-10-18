# Define a navbar structure with each tabPanel corresponding to a tab in the dashboard.
# If you want to add more tabs, simply add a tabPanel and either a page_Generic module or you can create as custom one.
# Note the module takes an input id which will identify an instance of the module, these id's need to be unique so that shiny knows which module to load where
dashboard_Structure_UI <- function(id) {

  # NS function creates a unique namespace with the current id so that modules can be called without interfering each other.
  # If you look at the logs in your console the "name" field contains the namespace given to interactive modules, that is the best way to wrap your head about how it works.
  # Example, the Bleeding generic page will be called "Dashboard-Bleeding" as NS takes the current id and adds it to the input string.
  # This is why all module id's in the UI are wrapped around an ns(x).
  ns <- NS(id)

  navbarPage(
    "RES-Q Dashboard",
    tabPanel(
      "Hospital Overview",
      page_Generic_UI(ns("Imaging"), "Imaging")
    )
    # tabPanel(
    #   "Hospital Overview",
    #   page_HO(ns("HO"))
    # ),
    # tabPanel(
    #   "Patient Profiles",
    #   page_PC(ns("PC"))
    # ),
    # tabPanel(
    #   "Bleeding",
    #   page_Generic_UI(ns("Bleeding"), "Bleeding")
    # ),
    # tabPanel(
    #   "Imaging",
    #   page_Generic_UI(ns("Imaging"), "Imaging")
    # ),
    # tabPanel(
    #   "Treatment",
    #   page_Generic_UI(ns("Treatment"), "Treatment")
    # ),
    # tabPanel(
    #   "Phase One",
    #   page_Generic_UI(ns("PO"), "PO")
    # ),
    # tabPanel(
    #   "Discharge",
    #   page_Generic_UI(ns("Discharge"), "Discharge")
    # )
  )
}


# Server side of the structure, if you want to add more tabs you have to match the module calls in the UI with a module call in the server side.
# Note that this convention for server side of modules with a function inside is pretty new, but is more compact.
# Note on the server side there is no need to use the NS function as Shiny is able to match the namespace'd UI with its matching server.
dashboard_Structure <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      page_Generic("Imaging", "Imaging")
      # page_Generic("Bleeding", "Bleeding")
      # page_Generic("Imaging", "Imaging")
      # page_Generic("Treatment", "Treatment")
      # page_Generic("PO", "PO")
      # page_Generic("Discharge", "Discharge")
    }
  )
}
