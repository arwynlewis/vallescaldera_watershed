# Valles Caldera Watershed- Interactive Data Visualization 
This R Shiny app provides a look into interactive data visualization for analyzing water quality in the East Fork Jemez River of the Valles Caldera. 
The app allows users to explore two variables: dissolved oxygen and turbidity.

## Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Data Sources](#data-sources)
- [Contributors](#contributors)

## Introduction
This app utilizes the R Shiny framework to create a user interface for analyzing water quality data in the Valles Caldera watershed. 
It aims to uncover new information and trends in hopes of promoting new findings about the ecological resilience of the area. 

## Features
- Interactive visualization of dissolved oxygen and turbidity data
- Filtering options based on pre or post fire data and monsoon season
- Date range selection for specific time periods

## Installation
To run the app locally, follow these steps:

1. Clone the repository to your local machine.
2. Make sure you have R and RStudio installed.
3. Install the required packages by running the following commands in RStudio:
```R
install.packages(c("shiny", "ggplot2", "shinythemes"))
```
4. Run the app by executing the following command in RStudio:
```R
shiny::runApp("path/to/the/cloned/repository")
```
Replace "path/to/the/cloned/repository" with the actual path to the cloned repository on your machine.

## Usage
Once the app is running, you can use the sidebar panel to interact with the data and explore the different variables and filtering options. 
Here's a brief overview of the available options:

* __Pre or Post Fire__: Select either pre-fire or post-fire data.
* __Monsoon Season__: Choose between non-monsoon or monsoon season data.
* __Date Range Selection__: Specify a date range to filter the data.
<br/>
The main panel of the app displays visualizations of dissolved oxygen and turbidity based on the selected options. 
You can observe the trends and patterns in the data and try to answer specific questions related to water quality in the Valles Caldera watershed.

## Data Sources
The data used in this app was collected and researched by Bob Parmenter and Laura Crossey. 
The research was motivated by Alex Webster and her analysis of the ecological resilience of the area. 
The specific data files used in the app are:

* __EFJ turbidity data__: `EFJ_turb.rds`
* __EFJ dissolved oxygen data__: `EFJ_DO.rds`

## Contributors
This app would have not been possible without the data collection done by Laura Crossey and Bob Parmenter, as well as the guidance of
my mentor, Alex Webster. 
