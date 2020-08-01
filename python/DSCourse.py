import pandas as pd

class DSCar:
    def __init__(self,  csvData):
        self.csvData = csvData
        self.dfData = pd.read_csv(csvData)

    def getData():
        return self.dfData
    
    def summary():
        return self.dfData.describe()