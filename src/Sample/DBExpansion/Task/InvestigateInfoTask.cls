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

/// Task that will investigate global growth
Class Sample.DBExpansion.Task.InvestigateInfoTask Extends %SYS.Task.Definition
{

Parameter TaskName = "Report Global Size Anomalies";

/// This is the 'limit' of growth we want to allow (as a percentage). Anything above this will be categorized as overgown.
Property GrowthPercentageWarning As %Decimal [ InitialExpression = 5 ];

/// Amount of days to permit the GrowthPercentageWarning growth to take.
/// must be at least one since the growth gets converted to an amount per day (i.e. we divide by this number)
Property PeriodWarning As %Integer(MINVAL = 1) [ InitialExpression = 7 ];

/// How far back to go check, in days 
Property HistoryLength As %Integer(MINVAL = 0) [ InitialExpression = 30 ];

Method OnTask() As %Status
{
	if ..PeriodWarning < 0 {
		return $$$ERROR($$$GeneralError, "PeriodWarning Must be at least 1") ///note than minval does not enforce this value, merely warns user before attempting to run task
	}
	elseif ..HistoryLength < 0	{
		return $$$ERROR($$$GeneralError, "HistoryLength must be at least 0") ///note than minval does not enforce this value, merely warns user before attempting to run task
	}
	
	/// if got to here then it is fine to run
	set st = ##class(Sample.DBExpansion.DBSizeAnalysis.InvestigateInfo).CreateReport(..GrowthPercentageWarning, ..PeriodWarning, ..HistoryLength)
	return st
}

}
