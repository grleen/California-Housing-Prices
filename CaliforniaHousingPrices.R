library(shiny)
library(shinydashboard)
library(leaflet)
library(tidyr)



ui <- fluidPage(
  
  #App Title
  titlePanel("California Housing Prices (1990)"),
  
  sidebarLayout(
    sidebarPanel(
      p("Increasing housing in the United States and especially California is an ongoing socio-economic issue in the country. California's housing prices have remained the highest than the rest of the country since the 1970s. This shiny app displays the median housing prices in California for the year 1990. Although, the data is pretty old, it provides several insights into what might affect housing prices in the sate. The data set is taken from Kaggle, an opensource data science platform. The data highlights important factors influencing housing prices like the distance from coast and the distance from other important cities in the state. The scatterplot map on the right shows a block of household within the same coordinates having a certain median house price."),
      
      plotOutput("histogram"),
                 
      selectInput(inputId = "varname", 
                  label = "Choose a variable to display",
                  choices = list("Distance_to_coast", 
                                 "Distance_to_LA",
                                 "Distance_to_SanDiego", 
                                 "Distance_to_SanJose", 
                                 "Distance_to_SanFrancisco"),
                  selected = "Distance_to_coast"),
      helpText("Choose a variable associated with the median housing prices to display a histogram.")
    ),
    mainPanel(
      leafletOutput("map", height = 800)
    )
  )
)


server <- function(input, output) {
  
  library(leaflet)
  
  
  # Loading the data
  
  cali_dat <- read.csv("cali_dat.csv")
  
  # Create the histogram plot
  output$histogram <- renderPlot({
    hist(cali_dat[, input$varname])
  })
  
  
  # Create the map
  output$map <- renderLeaflet({leaflet(cali_dat) %>% 
      setView(lng = -120.01465, lat = 38.57179, zoom = 5) %>%
      addProviderTiles(providers$CartoDB.VoyagerLabelsUnder) %>%
      addCircleMarkers(
        lng = ~cali_dat$Longitude, 
        lat = ~cali_dat$Latitude, weight = 0.3, 
        radius = ~0.3, 
        color = ~cali_dat$color, 
        label = cali_dat$Median_House_Value, 
        opacity = 0.7) %>% 
      addLegend(
        "topright", 
        colors = c("red", "orange", "green", "blue"), 
        labels = c("$385000-$500001", "$247400-$385000", "$145300-$247400", "$14999-$145300"))
   
  })
}



shinyApp(ui = ui, server = server)












