#load packages
import sys
import yfinance as yf
import pandas as pd
import matplotlib.pyplot as plt
#yahoo finance package
ticker=sys.argv[1]

#return array of monthly closing prices for 12 months, plus percentage change
data=yf.download(tickers=ticker,
                 period= "1y",
                 interval = "1mo",
                 prepost = False,
                 repair = True)

close=data['Close']
#print prices and pct in terminal
print("Monthly Close Price:\n")
print(close)
print("Percentage Change:\n")
print(round(close.pct_change(), 2)*100)

#plot the returns for ticker and save as image in directory
plt.plot(close, marker = 'o')
plt.title("Returns of " + ticker)
plt.grid()
plt.savefig(ticker + " returns")

