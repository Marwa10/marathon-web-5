library(forecast)

xdata <- ts(xdata)
fit <- auto.arima(xdata)
# or `fit <- ets(xdata)`
pred_xdata <- forecast(fit, 100)

plot(forecast(fit, 100))