library(dplyr)
library(zoo)
library(xts)
library(lubridate)

EFJ_turbidity <- function(EFJ_turb) {
  
  # Create a univariate zoo time series
  EFJ_turb_ts <- read.zoo(EFJ_turb, index.column=1, format="%Y-%m-%d %H:%M:%S", tz="America/Denver")
  
  # Smooth the time series
  EFJ_turb_ts_sm <- rollmean(EFJ_turb_ts, 96/4)
  
  # Convert the smoothed time series back to a data frame
  EFJ_turb_sm <- as.data.frame(EFJ_turb_ts_sm)
  EFJ_turb_sm$datetime_NM <- as.POSIXct(row.names(EFJ_turb_sm), tz="America/Denver")
  names(EFJ_turb_sm) <- c("Turb_NTU_Value", "datetime_NM")
  
  # Return the smoothed EFJ turbidity data frame
  return(EFJ_turb_sm)
}

index_roll_turbidity <- function(EFJ_turb_sm) {
  # Pre-fire turbidity data
  pre_fire_turb <- EFJ_turb_sm %>%
    filter(datetime_NM >= as.POSIXct("2005-04-29 17:15:40") &
             datetime_NM <= as.POSIXct("2011-05-29 17:15:40"))
  
  # Post-fire turbidity data
  post_fire_turb <- EFJ_turb_sm %>%
    filter(datetime_NM >= as.POSIXct("2011-05-29 17:15:40") &
             datetime_NM <= as.POSIXct("2020-10-21 10:30:00"))
  
  # Monsoon turbidity data
  monsoon_turb <- data.frame()
  for (year in 2005:2020) {
    data_year <- EFJ_turb_sm %>%
      filter(format(datetime_NM, "%Y") == as.character(year) &
               format(datetime_NM, "%m") %in% c("08", "09")) %>%
      mutate(datetime_NM = as.POSIXct(format(datetime_NM, "%Y-%m-%d")))
    monsoon_turb <- rbind(monsoon_turb, data_year, NA)
  }
  
  # Non-monsoon turbidity data
  non_monsoon_turb <- data.frame()
  for (year in 2005:2020) {
    data_year <- EFJ_turb_sm %>%
      filter(format(datetime_NM, "%Y") == as.character(year) &
               format(datetime_NM, "%m") %in% c("10", "11")) %>%
      mutate(datetime_NM = as.POSIXct(format(datetime_NM, "%Y-%m-%d")))
    non_monsoon_turb <- rbind(non_monsoon_turb, data_year, NA)
  }
  
  # Return a list containing all the turbidity data frames
  return(list(pre_fire_turb = pre_fire_turb,
              post_fire_turb = post_fire_turb,
              monsoon_turb = monsoon_turb,
              non_monsoon_turb = non_monsoon_turb))
}


EFJ_DO <-function(EFJ_Dissolved_Oxygen) {
  
  # Make univariate zoo time series#
  EFJ_DO_ts<-read.zoo(EFJ_Dissolved_Oxygen, index.column=1, format="%Y-%m-%d %H:%M:%S", tz="America/Denver")
  
  # Smooth the time series
  EFJ_DO_ts_sm <- rollmean(EFJ_DO_ts, 96/4)
  
  # Convert the smoothed time series back to a data frame
  EFJ_DO_sm <- as.data.frame(EFJ_DO_ts_sm)
  EFJ_DO_sm$datetime_NM = as.POSIXct(row.names(EFJ_DO_sm), tz="America/Denver")
  names(EFJ_DO_sm) = c("DO_perc_sat_Value","datetime_NM")
  
  # remove rows that contain zeros
  EFJ_DO_sm <- filter(EFJ_DO_sm, DO_perc_sat_Value > 15)
  
  # Return the smoothed EFJ turbidity data frame
  return(EFJ_DO_sm)
}

index_roll_DO <- function(EFJ_DO_sm) {
  # Pre Fire
  pre_fire_DO <- subset(EFJ_DO_sm, datetime_NM >= as.POSIXct("2005-04-29 17:15:40") & datetime_NM <= as.POSIXct("2011-05-29 17:15:40"))
  
  # Post Fire
  post_fire_DO <- subset(EFJ_DO_sm, datetime_NM >= as.POSIXct("2011-05-29 17:15:40") & datetime_NM <= as.POSIXct("2020-10-21 10:30:00"))
  
  # subset df to April and May for each year in range
  
  # define start and end years
  monsoon_DO <- data.frame()
  for (year in 2005:2020) {
    data_year <- subset(EFJ_DO_sm, format(datetime_NM, "%Y") == as.character(year) & 
                          format(datetime_NM, "%m") %in% c("08", "09"))
    data_year$datetime_NM <- as.POSIXct(format(data_year$datetime_NM, "%Y-%m-%d"))
    monsoon_DO <- rbind(monsoon_DO, data_year, NA)
  }
  
  # Non- Monsoon
  non_monsoon_DO <- data.frame()
  for (year in 2005:2020) {
    data_year <- subset(EFJ_DO_sm, format(datetime_NM, "%Y") == as.character(year) & 
                          format(datetime_NM, "%m") %in% c("10", "11"))
    data_year$datetime_NM <- as.POSIXct(format(data_year$datetime_NM, "%Y-%m-%d"))
    non_monsoon_DO <- rbind(non_monsoon_DO, data_year, NA)
  }
  
  # return the four data frames in a list
  return(list(pre_fire_DO = pre_fire_DO,
              post_fire_DO = post_fire_DO,
              monsoon_DO = monsoon_DO,
              non_monsoon_DO = non_monsoon_DO))
}


