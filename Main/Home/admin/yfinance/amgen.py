import yfinance as yf
amgen = yf.Ticker("amgn")
amgen.actions.to_csv("amgen.csv")