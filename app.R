# Load packages
library(shiny)
library(ggplot2)
library(shinythemes)
library(pryr)



#### load data ####
# Memory check
message('Before Bytes')
message(mem_used())

# New RDS file that only has EFJ turbidity data
EFJ_turb <- readRDS("data/EFJ_turb.rds")
# New RDS file that only has EFJ DO data
EFJ_Dissolved_Oxygen   <- readRDS("data/EFJ_DO.rds")

# Helper functions file for indexing data
source("helpers.R")
# Memory check
message(mem_used())

# Accessing variables from helper functions
EFJ_turb_sm <- EFJ_turbidity(EFJ_turb)
new_turbidity <- index_roll_turbidity(EFJ_turb_sm)
pre_fire_turb <- new_turbidity$pre_fire_turb
post_fire_turb <- new_turbidity$post_fire_turb
monsoon_turb <- new_turbidity$monsoon_turb
non_monsoon_turb <- new_turbidity$non_monsoon_turb

EFJ_DO_sm <- EFJ_DO(EFJ_Dissolved_Oxygen)
new_DO <- index_roll_DO(EFJ_DO_sm)
pre_fire_DO <- new_DO$pre_fire_DO
post_fire_DO <- new_DO$post_fire_DO
monsoon_DO <- new_DO$monsoon_DO
non_monsoon_DO <- new_DO$non_monsoon_DO

# Define UI
ui <- fluidPage(
  theme = shinytheme("sandstone"),
  # Set the background color
  tags$style(type = "text/css", "body {background-color: #DFEDD9;}"),
  tags$head(
    tags$style(".title h1 { font-family: 'Helvetica Neue', sans-serif; }")
  ),
  # Image orientation
  tags$head(tags$style(
    HTML(
      "
      .logo-container {
        position: absolute;
        top: 5px;
        right: 10px;
        display: flex;
        align-items: center;
      }
      
      .logo {
        width: 70px; /* Adjust the width as needed */
        height: auto; /* Maintain aspect ratio */
        margin-right: 10px; /* Add spacing between logos */
      }
       .watershed {
        float: right;
        width: 250px;
        shape-margin: 20px;
        margin-right: 20px;
        margin-bottom: 20px;
      }
      "
    )
  )),
  
  # Page title with logos
  titlePanel(
    HTML(
      "<div class='title'>
         <div class='logo-container'>
           <img src='UNMlogo.png' class='logo' />
           <img src='nationalparklogo.gif' class='logo' />
         </div>
         <h1>Valles Caldera Watershed - A Look Into Interactive Data Visualization</h1>
       </div>"
    )
  ),
  
  title = "Valles Caldera Watershed - A Look Into Interactive Data Visualization",
  
  
  
  # Sidebar with input widgets
  sidebarLayout(
    sidebarPanel(
      # Explanation of the data, the goal, etc.
      helpText("Created by Arwyn Lewis"),
      helpText("Grand Challenges Water Resources Communications Project"),
      
      helpText(
        "This app was possible due to data collection and research done by Bob Parmenter and Laura Crossey. It was also motivated by Alex Webster,
               and her continued analysis of the ecological resilience of the area."
      ),
      
      helpText(
        "Interactive data visualization is a new and popular method for statistical analysis. It can help make data accessible to anyone from any background.
               I have used the R Shiny software to create a user interface to analyze the water quality in the East Fork Jemez River of the Valles Caldera, in hopes of uncovering
               new information and trends that lead to new findings."
      ),
      
      helpText(
        "The app allows a user to focus on two variables: dissolved oxygen and turbidity. Dissolved oxygen is the measure of how much oxygen is dissolved in the water.
        In other words, the amount of oxygen available to living aquatic organisms. Turbidity, in simple terms, is how much 'stuff' is in the water, i.e. particles
        suspended or dissolved in water that make the water appear cloudy or murky."
      ),
      
      helpText("The user can then filter these variables based on pre or post fire data, if it was monsoon season, or a specific period of time."),
      
      
      tags$div(
        img(src = "JemezMap.png", width = "100%"),
        tags$p("Location of Watershed (Bob Parmenter)")
      ),
      
      
      # Buttons to select pre or post fire
      p("Select Pre or Post Fire"),
      actionButton("button", "Pre Fire"),
      actionButton("button1", "Post Fire"),
      
      # Buttons to select monsoon season
      p("Select Monsoon Season"),
      actionButton("button2", "Non-Monsoon"),
      actionButton("button3", "Monsoon"),
      
      # Date range inputs
      dateRangeInput(
        inputId = "date_range",
        label = "Select Pre-Fire Date Range",
        start = "2005-01-01",
        end = "2011-01-01",
        min = "2005-01-01",
        max = "2011-01-01",
        separator = " - "
      ),
      
      dateRangeInput(
        inputId = "date_range1",
        label = "Select Post-Fire Date Range",
        start = "2011-01-01",
        end = "2020-01-01",
        min = "2011-01-01",
        max = "2020-01-01",
        separator = " - "
      ),
      
      dateRangeInput(
        inputId = "date_range2",
        label = "Select Monsoon Season Date Range",
        start = "2005-01-01",
        end = "2020-01-01",
        min = "2005-01-01",
        max = "2020-01-01",
        separator = " - "
      ),
      
    ),
    
    
    
    
    
    mainPanel(
      fluidRow(
        column(width = 4,
               tags$div(
                 class = "caption",
                 img(src = "SadStream.png", width = "70%"),
                 tags$p("Example of high turbidity stream (Bob Parmenter)")
               )),
        column(width = 4,
               tags$div(
                 img(src = "SadTrees.png", width = "70%"),
                 tags$p("High-severity burn (Bob Parmenter)"),
                 
               )),
        column(width = 4,
               tags$div(
                 img(src = "Sensor.png", width = "70%"),
                 tags$p("Sonde instruments used to measure water quality (Bob Parmenter)")
               )),
        p(strong("What is a watershed?"), style = "font-size:20px;"),
        p("A watershed is a land area that channels rainfall and snowmelt to creeks, streams, and rivers, and eventually to outflow points
          such as reservoirs, bays, and the ocean (National Ocean Service). The Valles Caldera Watershed is the drainage basin and surrounding 
          area of the Valles Caldera National Preserve in northern New Mexico. The Valles Caldera Watershed encompasses the land and water bodies
          that contribute to the flow of water into the Valles Caldera, a large volcanic crater."),
          tags$div(
          class = "caption",
          img(
            class = "watershed",
            src = "watershed.png"
          ),
          tags$p("NSRW Association")),
        p("The Valles Caldera Watershed plays a crucial role in maintaining the ecological health of the region. It supports diverse habitats, including
          forests, grasslands, wetlands, and streams, which are home to various wildlife species. It also serves as a source of water for downstream
          communities, agricultural activities, or other water-dependent uses."),
        p("Given its ecological importance, the Valles Caldera Watershed has been the subject of scientific research and conservation efforts. Understanding
          the water quality and ecological processes within the watershed are essential for its sustainable management and the protection of its natural 
          resources."),
        p("Some questions to consider when interacting with this app:"),
        HTML("<ul><li>Do you notice any periods of time where the dissolved oxygen levels decrease dramatically? What years do you notice this occurring?
             </li><li>What does the turbidity do during this time?</li><li>How does the water quality change after the Las Conchas Wildfire that occurred in July of 2011?
             </li><li>Does the water quality stay the same after the fire? Or does it change? How is it affected by a precipitation event?</li></ul>"),
        
      ),
      # Add placeholders for the plots
      plotOutput("plot1"),
      plotOutput("plot2")
      
    )
  )
)


# Server logic ----
server <- function(input, output, session) {
  #Filter data based on date range input
  # Pre-fire Turbidity
  filtered_data <- reactive({
    subset(pre_fire_turb, datetime_NM >= as.Date(input$date_range[1]) & datetime_NM <= as.Date(input$date_range[2]))
  })
  
  # Post-fire Turbidity
  filtered_data1 <- reactive({
    subset(post_fire_turb, datetime_NM >= as.Date(input$date_range1[1]) & datetime_NM <= as.Date(input$date_range1[2]))
  })
  
  # Non-Monsoon Turbidity
  filtered_data2 <- reactive({
    subset(non_monsoon_turb, datetime_NM >= as.Date(input$date_range2[1]) & datetime_NM <= as.Date(input$date_range2[2]))
  })
  
  # Monsoon Turbidity
  filtered_data3 <- reactive({
    subset(monsoon_turb, datetime_NM >= as.Date(input$date_range2[1]) & datetime_NM <= as.Date(input$date_range2[2]))
  })
  
  # Pre-fire DO
  filtered_data4 <- reactive({
    subset(pre_fire_DO, datetime_NM >= as.Date(input$date_range[1]) & datetime_NM <= as.Date(input$date_range[2]))
  })
  
  # Post-fire DO
  filtered_data5 <- reactive({
    subset(post_fire_DO, datetime_NM >= as.Date(input$date_range1[1]) & datetime_NM <= as.Date(input$date_range1[2]))
  })
  
  # Non-Monsoon DO
  filtered_data6 <- reactive({
    subset(non_monsoon_DO, datetime_NM >= as.Date(input$date_range2[1]) & datetime_NM <= as.Date(input$date_range2[2]))
  })
  
  # Monsoon DO
  filtered_data7 <- reactive({
    subset(monsoon_DO, datetime_NM >= as.Date(input$date_range2[1]) & datetime_NM <= as.Date(input$date_range2[2]))
  })
  
  # Define reactive values based on button presses
  # Fire values
  rv <- reactiveValues(plot_type = "pre-fire")
  
  observeEvent(input$button, {
    rv$plot_type <- "pre-fire"
  })
  
  observeEvent(input$button1, {
    rv$plot_type <- "post-fire"
  })
  
  # Monsoon Values
  rv_season <- reactiveValues(plot_type = "non-monsoon")
  
  observeEvent(input$button2, {
    rv_season$plot_type <- "non-monsoon"
  })
  
  observeEvent(input$button3, {
    rv_season$plot_type <- "monsoon"
  })
  
  # Update monsoon plots
  observe({
    # Mem crutch
    gc()
    if (rv_season$plot_type == "non-monsoon") {
      output$plot1 <- renderPlot({
        ggplot(filtered_data6(), aes(x = datetime_NM, y = DO_perc_sat_Value)) +
          geom_line(color = "darkgreen") +
          ggtitle("Dissolved Oxygen During Non-Monsoon Season") +
          xlab("Date") + ylab("Dissolved Oxygen (% saturation)")
      })
      
      output$plot2 <- renderPlot({
        ggplot(filtered_data2(), aes(x = datetime_NM, y = Turb_NTU_Value)) +
          geom_line(color = "darkgreen") +
          ggtitle("Turbidity During Non-Monsoon Season") +
          xlab("Date") + ylab("Turbidity (NTU)")
      })
    } else if (rv_season$plot_type == "monsoon") {
      output$plot1 <- renderPlot({
        ggplot(filtered_data7(), aes(x = datetime_NM, y = DO_perc_sat_Value)) +
          geom_line(color = "darkgreen") +
          ggtitle("Dissolved Oxygen During Monsoon Season") +
          xlab("Date") + ylab("Dissolved Oxygen (% saturation)")
      })
      
      output$plot2 <- renderPlot({
        ggplot(filtered_data3(), aes(x = datetime_NM, y = Turb_NTU_Value)) +
          geom_line(color = "darkgreen") +
          ggtitle("Turbidity During Monsoon Season") +
          xlab("Date") + ylab("Turbidity (NTU)")
      })
    }
  })
  
  # Update fire plots
  observe({
    # Mem crutch
    gc()
    if (rv$plot_type == "pre-fire") {
      output$plot1 <- renderPlot({
        ggplot(filtered_data4(), aes(x = datetime_NM, y = DO_perc_sat_Value)) +
          geom_line(color = "darkblue") +
          ggtitle("Pre-Fire Dissolved Oxygen") +
          xlab("Date") + ylab("Dissolved Oxygen (% saturation)")
      })
      
      output$plot2 <- renderPlot({
        ggplot(filtered_data(), aes(x = datetime_NM, y = Turb_NTU_Value)) +
          geom_line(color = "darkblue") +
          ggtitle("Pre-Fire Turbidity") +
          xlab("Date") + ylab("Turbidity (NTU)")
      })
    } else if (rv$plot_type == "post-fire") {
      output$plot1 <- renderPlot({
        ggplot(filtered_data5(), aes(x = datetime_NM, y = DO_perc_sat_Value)) +
          geom_line(color = "darkblue") +
          ggtitle("Post-Fire Dissolved Oxygen") +
          xlab("Date") + ylab("Dissolved Oxygen (% saturation)")
      })
      
      output$plot2 <- renderPlot({
        ggplot(filtered_data1(), aes(x = datetime_NM, y = Turb_NTU_Value)) +
          geom_line(color = "darkblue") +
          ggtitle("Post-Fire Turbidity") +
          xlab("Date") + ylab("Turbidity (NTU)")
      })
    }
  })
  
  
  
}

# Run app ----
shinyApp(ui, server)

