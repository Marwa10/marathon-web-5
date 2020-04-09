library(n)
library(dplyr)
library(ggplot2)
library(forecast)
library(plotly)



data_stage_forecast= read.csv2("data/donnees_c2.csv", stringsAsFactors = FALSE) 
data_stage_forecast= data_stage_forecast%>%group_by(Anneeunivconvention
                                                    #,
                                                    #Typeconvention
                                                    ) %>% 
  summarise(total = n())

ggplotly(ggplot(data = data_stage_forecast, 
                mapping = aes(x = Anneeunivconvention, y = total, color = Typeconvention)) +
           geom_line()+
           labs( x = "Année de convention",
                 y = "Nombre de stage ",
                 color = "Type de convention"))




data_stage_forecast_ts <- ts(data_stage_forecast[,])
fit <- auto.arima(data_stage_forecast_ts)
# or `fit <- ets(xdata)`
pred_xdata <-  forecast(fit, 100)

plot(forecast(fit, 100))



