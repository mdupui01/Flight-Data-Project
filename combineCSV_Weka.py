import pandas as pd
import os

filepath = '/Users/mfdupuis/Documents/Kaggle/Python/flightData/'

os.chdir(filepath)

# Import the csv files created in prepdata.py
bycarrier1 = pd.read_csv('data2012-01.csv')
bycarrier2 = pd.read_csv('data2012-02.csv')
bycarrier3 = pd.read_csv('data2012-03.csv')
bycarrier4 = pd.read_csv('data2012-04.csv')
bycarrier5 = pd.read_csv('data2012-05.csv')
bycarrier6 = pd.read_csv('data2012-06.csv')
bycarrier7 = pd.read_csv('data2012-07.csv')
bycarrier8 = pd.read_csv('data2012-08.csv')
bycarrier9 = pd.read_csv('data2012-09.csv')
bycarrier10 = pd.read_csv('data2012-10.csv')
bycarrier11 = pd.read_csv('data2012-11.csv')
bycarrier12 = pd.read_csv('data2012-12.csv')

pieces = [bycarrier1, bycarrier2, bycarrier3, bycarrier4, bycarrier5, bycarrier6, bycarrier7, bycarrier8, bycarrier9, bycarrier10, bycarrier11, bycarrier12]
bycarrier_output = pd.concat(pieces, ignore_index = True)

bycarrier_output.__delitem__("YEAR")
bycarrier_output.__delitem__("FL_DATE")
bycarrier_output.__delitem__("DEST_CITY_NAME")
bycarrier_output.__delitem__("DEST_STATE_NM")
bycarrier_output.__delitem__("DEST")
bycarrier_output.__delitem__("ORIGIN")
bycarrier_output.__delitem__("ORIGIN_CITY_NAME")
bycarrier_output.__delitem__("ORIGIN_STATE_NM")
bycarrier_output.__delitem__("DEP_DELAY_NEW")
bycarrier_output.__delitem__("AIR_TIME")
bycarrier_output.__delitem__("ARR_DELAY_NEW")
bycarrier_output.__delitem__("CARRIER_DELAY")
bycarrier_output.__delitem__("WEATHER_DELAY")
bycarrier_output.__delitem__("NAS_DELAY")
bycarrier_output.__delitem__("SECURITY_DELAY")
bycarrier_output.__delitem__("LATE_AIRCRAFT_DELAY")
bycarrier_output.__delitem__("ARR_DEL15")
bycarrier_output.__delitem__("Unnamed: 24")

print bycarrier_output[:10]

bycarrier_output.to_csv('2012data_Weka.csv', sep=',')