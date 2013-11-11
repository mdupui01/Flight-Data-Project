import pandas as pd
import os

filepath = '/Users/mfdupuis/Documents/Kaggle/Python/Flight-Data-Project/'

os.chdir(filepath)

# Important the csv files created in prepdata.py
bycarrier1 = pd.read_csv('00-12_bycarrier.csv')
bycarrier2 = pd.read_csv('13_bycarrier.csv')

pieces = [bycarrier1, bycarrier2]
bycarrier_output = pd.concat(pieces, ignore_index = True)

bycarrier_output.__delitem__("Unnamed: 0")


# Important the carrier info to get names of carriers by carrier ID

base = pd.read_csv('carriers.csv', usecols=['Code', 'Description'])
baseDict = dict(zip(base.Code, base.Description))

for index, ID in enumerate(bycarrier_output["CarrierID"]):
    if bycarrier_output.at[index, "CarrierID"] in baseDict:
        bycarrier_output.at[index, "CarrierID"] = baseDict[ID]
        if 'America West Airlines Inc. (Merged with' in baseDict[ID]:
            bycarrier_output.at[index, "CarrierID"] = "US Airways"
        elif 'US Airways Inc. (Merged' in baseDict[ID]:
            bycarrier_output.at[index, "CarrierID"] = "US Airways"
    else:
        pass

print bycarrier_output[:50]
bycarrier_output.to_csv('byCarrier.csv', sep=',')

