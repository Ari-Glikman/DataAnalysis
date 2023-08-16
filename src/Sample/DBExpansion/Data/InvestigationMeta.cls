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

/// Metadata of GlobalInvestigationReport Table
Class Sample.DBExpansion.Data.InvestigationMeta Extends %Persistent
{

/// Number of globals that grew more than permitted
Property NumGlobalsOvergrown As %Integer;

/// Global that grew the most (by AmountGrown, measured in MB)
Property BiggestGrower As %String;

/// Parameter user inputted to run task. Growing above this percentage will trigger the OverGrown flag
Property GrowthPercentageWarning As %Decimal;

/// How many days to set as the limit for GrowthPercentageWarning. If GrowthPercentageWarning was 10% and PeriodWarning was 5 then the allowed growth would be an equivalent of 10% in 5 days. 
Property PeriodWarning As %Integer;

/// How many days back to investigate.
Property HistoryLength As %Integer;

Property TimeStamp As %TimeStamp;

Property NumberOfMeasurementsInspected As %Integer;

/// what kind of things do we want in here?
Storage Default
{
<Data name="InvestigationMetaDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NumGlobalsOvergrown</Value>
</Value>
<Value name="3">
<Value>BiggestGlobal</Value>
</Value>
<Value name="4">
<Value>BiggestGrower</Value>
</Value>
<Value name="5">
<Value>GrowthPercentageWarning</Value>
</Value>
<Value name="6">
<Value>PeriodWarning</Value>
</Value>
<Value name="7">
<Value>HistoricLength</Value>
</Value>
<Value name="8">
<Value>TimeStamp</Value>
</Value>
<Value name="9">
<Value>NumberOfMeasurementsInspected</Value>
</Value>
<Value name="10">
<Value>HistoryLength</Value>
</Value>
</Data>
<DataLocation>^Sample.DBE95BC.Investigati7DEBD</DataLocation>
<DefaultData>InvestigationMetaDefaultData</DefaultData>
<Description>
<![CDATA[what kind of things do we want in here?]]></Description>
<ExtentSize>1</ExtentSize>
<IdLocation>^Sample.DBE95BC.Investigati7DEBD</IdLocation>
<IndexLocation>^Sample.DBE95BC.Investigati7DEBI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="BiggestGrower">
<AverageFieldSize>33</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="GrowthPercentageWarning">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HistoryLength">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="NumGlobalsOvergrown">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="NumberOfMeasurementsInspected">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PeriodWarning">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="TimeStamp">
<AverageFieldSize>21</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^Sample.DBE95BC.Investigati7DEBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
