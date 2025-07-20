# ---------- LOAD LIBRARIES ----------
library(shiny)
library(terra)
library(ggplot2)
library(tidyterra)
library(climateR)
library(AOI)
library(sf)
library(shinycssloaders)
library(colorspace)
library(rnaturalearth)
library(rnaturalearthdata)

# ---------- GET COUNTRY LIST ----------
countries_sf <- rnaturalearth::ne_countries(scale = "medium", returnclass = "sf")
country_names <- sort(unique(countries_sf$name))

# ---------- UI ----------
ui <- fluidPage(
  titlePanel("🌍 TerraClimate Annual Map Viewer"),
  
  sidebarLayout(
    sidebarPanel(
      radioButtons("aoi_type", "AOI Source",
                   choices = c("Select Country" = "country", "Upload GeoJSON" = "upload")),
      
      conditionalPanel(
        condition = "input.aoi_type == 'country'",
        selectInput("country", "Select a Country", choices = country_names)
      ),
      
      conditionalPanel(
        condition = "input.aoi_type == 'upload'",
        fileInput("geojson", "Upload GeoJSON file", accept = ".geojson")
      ),
      
      selectInput("varname", "Climate Variable", choices = c(
        "Maximum Temperature" = "tmax",
        "Minimum Temperature" = "tmin",
        "Precipitation" = "ppt"
      )),
      
      dateRangeInput("dates", "Date Range", start = "2011-01-01", end = "2012-12-31"),
      
      textInput("custom_title", "Custom Map Title (Optional)", placeholder = "e.g. Annual Precipitation for Nepal"),
      
      actionButton("go", "Generate Map")
    ),
    
    mainPanel(
      withSpinner(plotOutput("climatePlot", height = "700px")),
      verbatimTextOutput("status")
    )
  )
)

# ---------- SERVER ----------
server <- function(input, output, session) {
  
  # Reactive AOI
  user_aoi <- reactive({
    if (input$aoi_type == "country") {
      tryCatch({
        terra::vect(AOI::aoi_get(country = input$country))
      }, error = function(e) {
        output$status <- renderText(paste("Failed to get AOI:", e$message))
        return(NULL)
      })
    } else {
      req(input$geojson)
      tryCatch({
        terra::vect(input$geojson$datapath)
      }, error = function(e) {
        output$status <- renderText(paste("Invalid GeoJSON:", e$message))
        return(NULL)
      })
    }
  })
  
  raster_data <- eventReactive(input$go, {
    output$status <- renderText("Fetching AOI and climate data...")
    
    tryCatch({
      aoi <- user_aoi()
      req(aoi)
      
      # Get TerraClimate data
      rast_list <- getTerraClim(
        AOI = aoi,
        varname = input$varname,
        startDate = input$dates[1],
        endDate = input$dates[2]
      )
      
      if (length(rast_list) == 0) stop("No data returned from TerraClimate.")
      
      r <- rast_list[[1]]
      
      # Dates of raster layers
      layer_dates <- seq.Date(from = as.Date(input$dates[1]), by = "month", length.out = nlyr(r))
      layer_years <- format(layer_dates, "%Y")
      
      # Count layers per year and keep only full years (12 months)
      year_table <- table(layer_years)
      full_years <- names(year_table[year_table == 12])
      
      if (length(full_years) == 0) {
        stop("No full calendar years found in selected date range.")
      }
      
      # Filter layers by full years only
      valid_indices <- which(layer_years %in% full_years)
      r_filtered <- r[[valid_indices]]
      filtered_years <- layer_years[valid_indices]
      group_ids <- match(filtered_years, full_years)
      
      # Aggregate to annual mean
      annual_raster <- tapp(r_filtered, index = group_ids, fun = mean)
      names(annual_raster) <- full_years
      
      # Project AOI to raster CRS
      vect_proj <- terra::project(aoi, crs(annual_raster))
      
      # Mask raster by AOI
      masked_raster <- terra::mask(annual_raster, vect_proj)
      
      output$status <- renderText("Climate data loaded successfully.")
      return(list(raster = masked_raster, vect = vect_proj))
      
    }, error = function(e) {
      output$status <- renderText(paste("Error:", e$message))
      return(NULL)
    })
  })
  
  # ---------- PLOT ----------
  output$climatePlot <- renderPlot({
    data <- raster_data()
    req(data)
    
    # Determine title
    custom_title <- input$custom_title
    default_title <- paste("Annual", input$varname,
                           if (input$aoi_type == "country") paste("for", input$country) else "(Custom AOI)")
    final_title <- ifelse(nzchar(custom_title), custom_title, default_title)
    
    ggplot() +
      geom_spatraster(data = data$raster) +
      geom_spatvector(data = data$vect, fill = NA, color = "black", linewidth = 1) +
      scale_fill_continuous_sequential(
        palette = if (input$varname == "ppt") "Blues 3" else "YlOrRd",
        na.value = "transparent"
      ) +
      facet_wrap(~lyr) +
      labs(
        title = final_title,
        fill = if (input$varname == "ppt") "Precipitation (mm)" else "Temperature (°C)"
      ) +
      theme_minimal()
  })
}

# ---------- RUN APP ----------
shinyApp(ui = ui, server = server)
