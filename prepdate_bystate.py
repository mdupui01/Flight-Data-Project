# Script to explore the data from January 2013

import os
import glob
import pandas as pd
import numpy as np
from collections import Counter

filepath = '/Users/mfdupuis/Documents/Kaggle/Python/flightData/'

os.chdir(filepath)

years = range(2013,2014)
months = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']

def extract_info():
    '''
    This generator loads the data from each month and retrieves the relevant information about flights and delays for each carrier.
    '''
    genOutput = pd.DataFrame({'CarrierID': [], 'Delays': [], 'Year': [], 'Month': [], 'NumFlights': [], 'CarrierDel': [], 'WeatherDel': [], 'NASDel': [], 'SecurityDel': [], 'LateAircraftDel': []})
    for year in years:
        for month in months:
            files = 'data' + str(year) + '-' + str(month) + '.csv'
            data = pd.read_csv(files)
            data['NumFlights'] = 1
            data.ix[:, 'CARRIER_DELAY'][data.ix[:, 'CARRIER_DELAY'] > 0] = 1
            data.ix[:, 'WEATHER_DELAY'][data.ix[:, 'WEATHER_DELAY'] > 0] = 1
            data.ix[:, 'NAS_DELAY'][data.ix[:, 'NAS_DELAY'] > 0] = 1
            data.ix[:, 'SECURITY_DELAY'][data.ix[:, 'SECURITY_DELAY'] > 0] = 1
            data.ix[:, 'LATE_AIRCRAFT_DELAY'][data.ix[:, 'LATE_AIRCRAFT_DELAY'] > 0] = 1
            
            tempNumFlights = data.groupby('ORIGIN_STATE_ABR').apply(lambda x: pd.Series(dict(NumFlights=(x.NumFlights.sum()))))
            carrierDel = data.groupby('ORIGIN_STATE_ABR').apply(lambda x: pd.Series(dict(CARRIER_DELAY=(x.CARRIER_DELAY.sum()))))
            weatherDel = data.groupby('ORIGIN_STATE_ABR').apply(lambda x: pd.Series(dict(WEATHER_DELAY=(x.WEATHER_DELAY.sum()))))
            nasDel = data.groupby('ORIGIN_STATE_ABR').apply(lambda x: pd.Series(dict(NAS_DELAY=(x.NAS_DELAY.sum()))))
            securityDel = data.groupby('ORIGIN_STATE_ABR').apply(lambda x: pd.Series(dict(SECURITY_DELAY=(x.SECURITY_DELAY.sum()))))
            lateAircraftDel = data.groupby('ORIGIN_STATE_ABR').apply(lambda x: pd.Series(dict(LATE_AIRCRAFT_DELAY=(x.LATE_AIRCRAFT_DELAY.sum()))))
            cancelled = data.groupby('ORIGIN_STATE_ABR').apply(lambda x: pd.Series(dict(CANCELLED=(x.CANCELLED.sum()))))
            output = data.groupby('ORIGIN_STATE_ABR').apply(lambda x: pd.Series(dict(Delays=(x.DEP_DEL15.sum()))))
            
            output["Year"] = year
            output["Month"] = int(month)
            output["NumFlights"] = tempNumFlights
            output["DepState"] = output.index
            output["Cancelled"] = cancelled
            output["CarrierDel"] = carrierDel
            output["WeatherDel"] = weatherDel
            output["NASDel"] = nasDel
            output["SecurityDel"] = securityDel
            output["LateAircraftDel"] = lateAircraftDel
            
            pieces = [genOutput, output]
            
            genOutput = pd.concat(pieces, ignore_index = True)
                
    yield genOutput

delays = extract_info()
delaysOutput = next(delays)

print delaysOutput[:20]

delaysOutput.to_csv('13_byState.csv', sep=',')

print "Script ended."