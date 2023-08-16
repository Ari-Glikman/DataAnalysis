/// **********************************************************
/// *                   ** N O T I C E **                    *
/// *                - TEST/DEMO SOFTWARE -                  *
/// * This code is not supported by InterSystems as part     *
/// * of any released product.  It is supplied by            *
/// * InterSystems as a demo/test tool for a specific        *
/// * product and version. The user or customer is fully     *
/// * responsible for the maintenance and testing of this    *
/// * software after delivery, and InterSystems shall bear   *
/// * no responsibility nor liabilities for errors or misuse *
/// * of this code.                                          *
/// **********************************************************


/// This table will store analysis of the globals that were collected on the data collection phase.
/// It will be populated by the <Method> InvestigateInfoTask </Method>
Class Sample.DBExpansion.Data.GlobalInvestigationReport Extends %Persistent
{

Property GlobalName As %String;

Property ClassName As %String;

/// Whether the global grew more than was permitted when the task parameters were set
Property OverGrew As %Boolean;

/// This is the max amount that it has grown between measurements (normalized to the days the task has requested)
/// <br>
/// Example: if a global growth (measured every 7 days) was from 100 MB to 110MB to 105MB the max growth is 10MB = 10% / 7 days * how many days person requested (i.e. 10/7 * 30) 
Property MaxGrowthNormalized As %Float;

/// Maximum growth represented as MB 
/// <br>
/// Note that this is independent of time passed between measurements, unlike the normalized maxgrowth
Property MaxGrowthMB As %Float;

/// This is a percentage of how much it has grown per day from first measurement to last (wihtin history of parameter of task)
/// <br>
/// Example: in the same example as above, the historic growth would be 5% / 14 days
Property HistoricGrowthPerDay As %Float;

/// This is the growth per day (from first to last) multiplied by the period warning to make the numbers more digestible 
/// <br>
/// Example: as per the examples above and assuming the input parameters had requested to look out for a growth of more than 15% in 30 days we would see that this becomes (5% /14days) * 30 days = 10.7% 
Property GrowthForRequestedPeriod As %Float;

/// Growth but as an amount not a percentage (MB)
Property AmountGrown As %Float;

/// Technically 2 tasks could be built, one that runs fast and one slow for the same table, then we need to know when summing sizes whether to account for allocated or used. if this is true at least some data was collected with fast method and allocated sizes will be used
Property FastFlagAll As %Boolean;

/// Whether the global has ever decreased in size as per measurements, indicates purge working to some degree
Property Decrease As %Boolean;

/// Analogous to metaID in data collection task, will correspond to which metadata this belongs
Property ReportNum As %Integer;

ForeignKey InvestigationMetaFK(ReportNum) References Sample.DBExpansion.Data.InvestigationMeta() [ OnDelete = cascade ];

Storage Default
{
<Data name="GlobalInvestigationReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GlobalName</Value>
</Value>
<Value name="3">
<Value>ClassName</Value>
</Value>
<Value name="4">
<Value>OverGrew</Value>
</Value>
<Value name="5">
<Value>MaxGrowth</Value>
</Value>
<Value name="6">
<Value>HistoricGrowth</Value>
</Value>
<Value name="7">
<Value>GrowthForRequestedPeriod</Value>
</Value>
<Value name="8">
<Value>Decrease</Value>
</Value>
<Value name="9">
<Value>MetaData</Value>
</Value>
<Value name="10">
<Value>ReportNum</Value>
</Value>
<Value name="11">
<Value>FastFlagOffAll</Value>
</Value>
<Value name="12">
<Value>FastFlagAll</Value>
</Value>
<Value name="13">
<Value>AmountGrown</Value>
</Value>
<Value name="14">
<Value>HistoricGrowthPerDay</Value>
</Value>
<Value name="15">
<Value>MaxGrowthNormalized</Value>
</Value>
<Value name="16">
<Value>MaxGrowthMB</Value>
</Value>
</Data>
<DataLocation>^Sample.DBE95BC.GlobalInves8D80D</DataLocation>
<DefaultData>GlobalInvestigationReportDefaultData</DefaultData>
<ExtentSize>304</ExtentSize>
<IdLocation>^Sample.DBE95BC.GlobalInves8D80D</IdLocation>
<IndexLocation>^Sample.DBE95BC.GlobalInves8D80I</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,16,$lb("-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000"),$lb(21,21,21,21,21,21,21,21,21,21,21,21,21,21,21),$lb(758198320,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,758198320))</Histogram>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>4</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(2572,2592,2613,2634,2655,2675,2695,2715,2735,2755,2775,2795,2815,2835,2855,2875),$lb(2,1,2,2,2,2,1,2,2,2,2,1,2,2,2),$lb(842348338,926023680,959578112,892940800,909193984,825425920,859045888,859045888,892665856,892665856,926220288,926220288,959774720,909718784,925971712,825556992,859111424,859111424,892665856,892665856,926220288,926220288,959774720,926496000,942748928,825556992,859111424,859111424,892665856,892665856,926220288,842544949))</Histogram>
<Selectivity>1</Selectivity>
</Property>
<Property name="AmountGrown">
<AverageFieldSize>2.61</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(-1327.97,0,0,0,0,0,0,0,0,0,0,0,0,0,0,50),$lb(0,1,1,1,1,1,1,1,1,1,1,1,1,1,0),$lb(758199090,758199090,805306368,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,805306368,892338176,892338176))</Histogram>
<OutlierSelectivity>.960526:0</OutlierSelectivity>
<Selectivity>0.6579%</Selectivity>
</Property>
<Property name="ClassName">
<AverageFieldSize>8.89</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," ARITESTING.GLOBALSTABLEPREV.CLS"," CINEMA.THEATER.CLS"," FCE.CURRENCYORDER.CLS"," SAMPLE.DBEXPANSION.DATA.GLOBALANALYSISINFO.CLS"," USER.PATIENTDATA.CLS"),$lb(2,2,2,2,2,2,2,2,2,2,1,1,1,1,1),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1095911764,1095911764,1128877637,1128877637,1178813742,1178813742,1396788560,1396788560,1431520594,542462789))</Histogram>
<OutlierSelectivity>.717105:</OutlierSelectivity>
<Selectivity>1.0881%</Selectivity>
</Property>
<Property name="Decrease">
<AverageFieldSize>2.02</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1),$lb(1,1,1,1,1,1,1,1,1,1,1,1,1,1,0),$lb(805306368,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,805306368,822083584,822083584))</Histogram>
<OutlierSelectivity>.980263:0</OutlierSelectivity>
<Selectivity>1.9737%</Selectivity>
</Property>
<Property name="FastFlagAll">
<AverageFieldSize>2.01</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1),$lb(1,1,1,1,1,1,1,1,1,1,1,1,1,1,0),$lb(805306368,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,805306368,822083584,822083584))</Histogram>
<OutlierSelectivity>.993421:0</OutlierSelectivity>
<Selectivity>0.6579%</Selectivity>
</Property>
<Property name="GlobalName">
<AverageFieldSize>19.28</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" ALLOCATEDMB"," BARE.BSQW.3"," CINEMAOOFILMD"," DEEPSEE.USERPREFERENCES"," ENS.ALERTING.MANAGEDALERTD"," ENS.CONFIG"," ENS.DEPLOYMENT.TOKEND"," ENS.RULE.DEBUGLOGC"," ENSEDI.ASTM.DESCRIPTION"," ENSLIB.H.MESSAGEI"," FCE.BRANCHS"," HS.FHIRSERVER"," OBJ.GUID"," SAMPLE.DBE95BC.GLOBALANALY9E3AI"," SIMPLE.HUMANI"," ZIPCODEDATA"),$lb(1,1,1,1,5,5,5,4,4,1,1,1,1,2,1),$lb(541150284,1095519311,1111577157,1111577157,1128877637,1128877637,1145390416,1145390416,1162761006,1095517522,1129270854,1129270854,1145393228,1145393228,1381321797,777147724,1162103086,1162103086,1279869486,1162761036,1178813742,1178813742,1213410886,1213410886,1329744430,1329744430,1396788560,1095585868,1229803596,1397312848,1514754115,542787920))</Histogram>
<Selectivity>0.6579%</Selectivity>
</Property>
<Property name="GrowthForRequestedPeriod">
<AverageFieldSize>2.32</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(-4426.566666666666667,0,0,0,0,0,0,0,0,0,0,0,0,0,0,50),$lb(0,1,1,1,1,1,1,1,1,1,1,1,1,1,0),$lb(758395954,758395954,805306368,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,805306368,892338176,892338176))</Histogram>
<OutlierSelectivity>.960526:0</OutlierSelectivity>
<Selectivity>0.6579%</Selectivity>
</Property>
<Property name="HistoricGrowthPerDay">
<AverageFieldSize>2.31</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(-442.6566666666666667,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5),$lb(0,1,1,1,1,1,1,1,1,1,1,1,1,1,0),$lb(758395954,758395954,805306368,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,805306368,889192448,889192448))</Histogram>
<OutlierSelectivity>.960526:0</OutlierSelectivity>
<Selectivity>0.6579%</Selectivity>
</Property>
<Property name="MaxGrowthMB">
<AverageFieldSize>2.05</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,50),$lb(1,1,1,1,1,1,1,1,1,1,1,1,1,1,0),$lb(805306368,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,805306368,892338176,892338176))</Histogram>
<OutlierSelectivity>.973684:0</OutlierSelectivity>
<Selectivity>0.6579%</Selectivity>
</Property>
<Property name="MaxGrowthNormalized">
<AverageFieldSize>2.19</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1400),$lb(1,1,1,1,1,1,1,1,1,1,1,1,1,1,0),$lb(805306368,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,805306368,825503792,825503792))</Histogram>
<OutlierSelectivity>.973684:0</OutlierSelectivity>
<Selectivity>0.6579%</Selectivity>
</Property>
<Property name="OverGrew">
<AverageFieldSize>2.03</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1),$lb(1,1,1,1,1,1,1,1,1,1,1,1,1,1,0),$lb(805306368,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,805306368,822083584,822083584))</Histogram>
<OutlierSelectivity>.973684:0</OutlierSelectivity>
<Selectivity>2.6316%</Selectivity>
</Property>
<Property name="ReportNum">
<AverageFieldSize>3</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2),$lb(1,1,1,1,1,1,1,0,1,1,1,1,1,1,1),$lb(822083584,0,0,0,0,0,0,0,0,0,0,0,0,0,0,822083584,838860800,0,0,0,0,0,0,0,0,0,0,0,0,0,0,838860800))</Histogram>
<Selectivity>50.0000%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-12</BlockCount>
</SQLMap>
<StreamLocation>^Sample.DBE95BC.GlobalInves8D80S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
