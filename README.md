# Terraclimate Viewer 🌍

A simple Shiny web application for exploring TerraClimate data for any location globally, built using the [`climateR`](https://github.com/earthlab/climateR) package.

🌐 **Live App**: [Terraclimate Viewer](https://hemedlungo.shinyapps.io/Terraclimate_Viewer/)

## 🔍 Overview

This interactive tool allows users to:
- Visualize TerraClimate variables (e.g., temperature, precipitation)
- Select locations on a map
- Generate time series charts
- Export plots and summaries

The app utilizes real-time access to TerraClimate data through the `climateR` package.

## 📦 Built With

- [**Shiny**](https://shiny.posit.co/) – R package for interactive web apps
- [**climateR**](https://github.com/earthlab/climateR) – For querying and retrieving TerraClimate data
- [**leaflet**](https://rstudio.github.io/leaflet/) – Interactive mapping
- [**ggplot2**](https://ggplot2.tidyverse.org/) – Visualization
- [**dplyr**](https://dplyr.tidyverse.org/) – Data wrangling

## 🧠 How It Works

The app fetches TerraClimate data dynamically based on the selected location and time range. Users can interact with the map to choose a point and generate plots showing trends for selected climate variables.

## 🙏 Acknowledgements

- Huge thanks to [@mikejohnson51](https://github.com/mikejohnson51) as creator of [`climateR`](https://github.com/earthlab/climateR) package.
- TerraClimate data courtesy of the [University of Idaho](https://www.climatologylab.org/terraclimate.html).
- The app was inspired by open climate data and geospatial tool accessibility for broader climate analysis and education.


---

*Made with ❤️ by [Hemed Lungo](https://github.com/Heed725)*
