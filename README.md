# Terraclimate Viewer 🌍

A Shiny web application for exploring TerraClimate data across the globe using a map-based interface and on-the-fly climate visualizations.

🌐 **Live App**: [Terraclimate Viewer](https://hemedlungo.shinyapps.io/Terraclimate_Viewer/)

## 🔍 Overview

This app allows users to:
- Interactively select any location in the world
- Retrieve TerraClimate data dynamically from the cloud
- Visualize climate variables over time (e.g., temperature, precipitation)
- Download and export charts and data summaries

The app accesses cloud-optimized geospatial data using the `climateR` package, providing real-time TerraClimate data access through STAC endpoints.

## 📦 Packages Used

The app was built using the following R packages:

- [`shiny`](https://shiny.posit.co/) – Web application framework for R
- [`terra`](https://rspatial.org/terra/) – Spatial data processing
- [`ggplot2`](https://ggplot2.tidyverse.org/) – Data visualization
- [`tidyterra`](https://dieghernan.github.io/tidyterra/) – Tidy methods for terra objects
- [`climateR`](https://github.com/earthlab/climateR) – Climate data access via STAC APIs
- [`AOI`](https://github.com/mikejohnson51/AOI) – Area-of-interest selection tools
- [`sf`](https://r-spatial.github.io/sf/) – Simple features for spatial vector data
- [`shinycssloaders`](https://github.com/andrewsali/shinycssloaders) – Loaders for Shiny outputs
- [`colorspace`](https://colorspace.r-forge.r-project.org/) – Advanced color palettes
- [`rnaturalearth`](https://github.com/ropensci/rnaturalearth) – Country and coastline shapefiles
- [`rnaturalearthdata`](https://github.com/ropensci/rnaturalearthdata) – Base data for `rnaturalearth`

## 🙏 Acknowledgements

- Special thanks to [@mikejohnson51](https://github.com/mikejohnson51) for his work on the [`climateR`](https://github.com/earthlab/climateR) and [`AOI`](https://github.com/mikejohnson51/AOI) packages, which power the core data functionality in this app.
- TerraClimate data provided by the [University of Idaho Climatology Lab](https://www.climatologylab.org/terraclimate.html).


---

*Made with ❤️ by [Hemed Lungo](https://github.com/Heed725)*
