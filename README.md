### Data Analysis

This is the sequel to [Data Collection](https://github.com/Ari-Glikman/DataCollection/blob/main/README.md#data-collection). If you have not had a chance to go through and install that you should first do that.

**If you already have installed that code, note that there has been updates to make it more efficient. Please download the latest [version2](https://github.com/Ari-Glikman/DataCollection/blob/main/README.md#data-collection), uploaded August 23**

What is provided here is the analysis for the collection of that data that was collected earlier.

In much the same way as was done in that repository you will need to import the xml that makes up this repository. 

Starting at the topmost level there is a task:

*[InvestigateInfoTask](https://github.com/Ari-Glikman/DataAnalysis/blob/main/src/Sample/DBExpansion/Task/InvestigateInfoTask.cls)*

This task will allow us to set parameters that we will be monitoring. They are as follows:

![image](https://github.com/Ari-Glikman/DataAnalysis/assets/73805987/493ef16a-8c3d-4f4b-86a2-68a3f5d630c3)

***GrowthPercentageWarning:***	What percentage growth is 'acceptable' for a global to grow.

***PeriodWarning:*** How many days it's reasonable for the globals to make that growth in.

***HistoryLength:*** How far back to look back into the Sample_DBExpansion_Data.GlobalAnalysisInfo table.

The default is set to a 5% growth in 7 days, looking back over the last 30 days. Once you set the parameters you can still edit them, even after the task has run one or several times. Go to task details, click edit, and change it how you see fit.

The task calls the *CreateReport* method of the [Sample.DBExpansion.DBSizeAnalysis.InvestigateInfo](https://github.com/Ari-Glikman/DataAnalysis/blob/main/src/Sample/DBExpansion/DBSizeAnalysis/InvestigateInfo.cls) class. 

*CreateReport* will populate the two tables as explained below:

1) GlobalInvestigationReport
  - This table will hold the 'report' that analyzed the Sample_DBExpansion_Data.GlobalAnalysisInfo table. There are several fields which will allow us to measure the growth by different parameters. The fields are described below:

![image](https://github.com/Ari-Glikman/DataAnalysis/assets/73805987/d2a9179d-14ef-43f2-9a96-241034fd9095)


 ***FastFlagAll:*** boolean that demonstrates if any single measurement for a global was taken in 'fast' mode, meaning that all UsedMB measurements are ignored and only allocated space will be considered. Units: 1/0

 ***AmountGrown:*** historicGrowth - the growth from first to last measurement. Units - MB

 ***Decrease:*** boolean as to whether there was ever a decrease in size between two continual measurements. Units: 1/0
 
 ***OverGrew:*** boolean as to whether the MaxGrowthNormalized (%/DAY) surpassed the allowed growth (converted to a %/DAY equivalence). Units: 1/0
 
 ***GrowthForRequestedPeriod:*** taken as historicGrowthPerDay * PeriodWarning this shows how much MB this would have grown in the requested period had it grown at this rate for that period. Units: 'Normalized' MB 
 
 ***HistoricGrowthPerDay:*** defined as total growth over requested history, divided by days passed between last and first measurement. Units: MB/DAY  
 
 ***MaxGrowthNormalized:*** the greatest percentage growth / day  between any two measurements within the history. This is per day but we extrapolate it to how many days were set to the PeriodWarning to make the numbers easily comparable to the user.  Units: Normalized %
	                    Example of MaxGrowthNormalized: if the max growth was determined to be 5% per day over 7 days and the user entered as parameters a growth of 10% in 10 days then this column will display 5%/day * 10 days = 50% 
 
 ***MaxGrowthMB:*** maximum amount of growth between two measurements (in MB). Note that this is independent of time passed. Units: MB
 
 ***ReportNum:*** corresponds to the ID of the row in the 'Meta' table (Sample_DBExpansion_Data.InvestigationMeta)
			

2) InvestigationMeta
- This table holds the parameters entered when the task was run in order to be able to reference them. Apart from the 3 parameters  (GrowthPercentageWarning, HistoryLength, and PeriodWarning) there is also:   

![image](https://github.com/Ari-Glikman/DataAnalysis/assets/73805987/9db10ddc-2374-4729-b501-89d6382415b1)

  
   ***BiggestGrower:*** the global with the greatest AmountGrown.
    
   ***NumGlobalsOvergrown:*** how many globals had the OverGrown flag
   
   ***NumberOfMeasurementsInspected:*** how many measurements of each global were taken (how many times the Data Collection task was ran).

Finally note that there is also a unit testing class. It should be used in the same way as [Data Collection](https://github.com/Ari-Glikman/DataCollection/blob/main/README.md#data-collection) used unit testing.

If you have any suggestions on how I can improve this from our end please let me know as well :)

Shoot me an email: ari.glikman@intersystems.com
