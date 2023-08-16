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

/// Creates a report, stored in the GlobalInvestigationReport and InvestigationMeta tables.
ClassMethod CreateReport(GrowthPercentageWarning As %Decimal, PeriodWarning As %Integer, HistoryLength As %Integer) As %Status
{
	set allowedGrowthPerDay = GrowthPercentageWarning/PeriodWarning

	&sql(INSERT INTO Sample_DBExpansion_Data.InvestigationMeta
		(GrowthPercentageWarning, HistoryLength, PeriodWarning)
	   	VALUES(:GrowthPercentageWarning, :HistoryLength, :PeriodWarning))
	
	if (SQLCODE '=0)
	{
		set status = $$$ERROR($$$GeneralError, "DB Insert Failed, sqlcode: "_SQLCODE_" Message: "_$GET(%msg))
		return status
	}
	set rowID = %ROWID
	
	///////do not need to add date to this query... we are not collecting data apart from names. it will only slow it down here and we will check for dates later
	#; set query = "SELECT GB.GlobalName, GB.ClassName, GB.AllocatedMB, GB.UsedMB, DB.TIMESTAMPEND, DB.FastFlag "_
	#; 			"FROM Sample_DBExpansion_Data.GlobalAnalysisInfo AS GB "_ 
	#; 			"INNER JOIN Sample_DBExpansion_Data.DBAnalysisInfo AS DB ON DB.ID = GB.MetaData "_
	#; 			"WHERE DATEDIFF('dd', DB.TimeStampEnd, GETDATE()) <= ? "_
	#; 			"ORDER BY GLOBALNAME" ///add time stamp to query: ORDER BY GLOBALNAME ASC , DB.TimeStampEnd ASC
	set query = "SELECT GlobalName, ClassName, AllocatedMB, UsedMB, MetaData->TimeStampEnd, MetaData->FastFlag "_ 
				"FROM Sample_DBExpansion_Data.GlobalAnalysisInfo "_
				"WHERE DATEDIFF('dd', MetaData->TimeStampEnd, GETDATE()) <= ? "_
				"ORDER BY GLOBALNAME ASC , MetaData->TimeStampEnd ASC"
	
	set statement = ##class(%SQL.Statement).%New()
	set status = statement.%Prepare(query)
	set resultSet = statement.%Execute(HistoryLength) //check for sql today.

	if (resultSet.%SQLCODE '=0) ///output error
	{
		set status = $$$ERROR($$$GeneralError, "%Execute failed, sqlcode: "_SQLCODE_" Message: "_$GET(%msg))
		return status
	}
	
	////----------------------------------------------------------------------------------------------------///////////////////////
	//// INITIALIZE VARIABLES 
	////----------------------------------------------------------------------------------------------------///////////////////////
	set currGlobalName = -1
	set currClassName = -1
	set currAllocatedSize = -1
	set currUsedSize = -1
	set currDate = -1 
	set firstDate = -1
	set currFastFlag = -1
	set firstMeasurement = 1 //first measurement of each global
	set maxGrowthNormPercentUsed = 0
	set maxGrowthMBUsed = 0
	set maxGrowthNormPercentAlloc = 0
	set maxGrowthMBAlloc = 0
	set fastFlagAll = 0
	///these do not need to be initialized but done so to avoid the squiggly yellow lines...
	set firstMeasurementUsed = -1
	set firstMeasurementAllocated = -1
	set DecreaseAlloc = 0
	set DecreaseUsed = 0
	

	while resultSet.%Next(){ ///note that they will already be ordered by date as well within global as their table insertion is chronological
		

		////----------------------------------------------------------------------------------------------------///////////////////////
		//// SET PREVIOUS Vars
		////----------------------------------------------------------------------------------------------------///////////////////////
		set prevGlobalName = currGlobalName
		set prevClassName = currClassName
		set prevDate = currDate
		set prevUsedSize = currUsedSize
		set prevAllocatedSize = currAllocatedSize
		set prevFastFlag = currFastFlag

		////----------------------------------------------------------------------------------------------------///////////////////////
		//// GET NEW Vars
		////----------------------------------------------------------------------------------------------------///////////////////////
		set currGlobalName = resultSet.%Get("GlobalName")
		set currClassName = resultSet.%Get("ClassName")
		set currDate = resultSet.%Get("TimeStampEnd")
		set currUsedSize = resultSet.%Get("UsedMB")
		set currAllocatedSize = resultSet.%Get("AllocatedMB")
		set currFastFlag = resultSet.%Get("FastFlag")



		////----------------------------------------------------------------------------------------------------///////////////////////
		//// MOVING ON TO NEXT GLOBAL... NEED TO DO ALL COMPARISONS AND FINALIZE ANALYSIS.... attempted to put this in a method but i think it makes the code more difficult to understand (more overhead = 11 parameters... + some processing beforehand) so i kept it like this
		//// firstMeasurement = 0 conditon to make sure first ever iteration not caught in here as no prev global to compare to (set to -1)
		////----------------------------------------------------------------------------------------------------///////////////////////
		////// got to here with tani.... finished loop but need to check final condition here.
		if ((prevGlobalName '= currGlobalName) && (firstMeasurement =0)) { ///note this is not caps sensitive.... gets messed up when two globals with same spelling but some caps some not... cause SQL recognize as same
			set lastDate = prevDate
			set lastMeasurementUsed = prevUsedSize
			set lastMeasurementAllocated = prevAllocatedSize
			#; &sql(SELECT DATEDIFF('dd',:firstDate,:lastDate) INTO :histLengthGlobal)		 ///need to do error checking for this?
			set histLengthGlobal = ##class(%SYSTEM.SQL.Functions).DATEDIFF("dd", firstDate, lastDate)
		
			
			set historicGrowthUsed = lastMeasurementUsed - firstMeasurementUsed
			set historicGrowthAllocated = lastMeasurementAllocated - firstMeasurementAllocated

			#; write !, "last measurement and first measurement for global "_prevGlobalName_ " last: "_lastMeasurementUsed_" first: "_firstMeasurementUsed_" hist growth used: "_historicGrowthUsed

			////----------------------------------------------------------------------------------------------------///////////////////////
			//// if fastFlagOn for any measurement of a global then it's analysis will be done on allocated exclusively
			////----------------------------------------------------------------------------------------------------///////////////////////
			if (fastFlagAll = 0){

				set historicGrowth = historicGrowthUsed
				set maxGrowthRequestedPeriod = maxGrowthNormPercentUsed * 100
				set maxGrowthMB = maxGrowthMBUsed
	
				set Decrease = DecreaseUsed
			}
			else{ ///ran in fast, get alloc
				
				set historicGrowth = historicGrowthAllocated 
				set maxGrowthRequestedPeriod = maxGrowthNormPercentAlloc * 100
				set maxGrowthMB = maxGrowthMBAlloc
				
				set Decrease = DecreaseAlloc
			}
			
			set historicGrowthPerDay = historicGrowth/histLengthGlobal

			set growthForRequestedPeriod = historicGrowthPerDay * PeriodWarning

			if (maxGrowthRequestedPeriod > GrowthPercentageWarning){
				set OverGrew = 1
			}
					
			////----------------------------------------------------------------------------------------------------///////////////////////
			//// COLS / VARS ARE DEFINED AS FOLLOWS 
			//// COL NAME: HistoricGrowthPerDay / VAR NAME: historicGrowthPerDay - defined as total growth over requested history, divided by days passed between last and first measurement. Units: MB/DAY  
			//// COL NAME: MaxGrowthNormalized / VAR NAME: maxGrowthRequestedPeriod - the greatest NORMALIZED PERCENTAGE growth / day  between any two measurements within the history. This means that you take the max growth per day and mutliply by PeriodWarning to make the numbers easily comparable to the user  Units: Normalized %
			////                                       Example of MaxGrowth: if the max growth was determined to be 5% per day over 7 days and the user requested to see a growth of 10% in 10 days then this column will display 5%/day * 10 days = 50% 
			//// COL NAME: MaxGrowthMB / VAR NAME: maxGrowthMB - maximum amount of growth between two measurements (in MB). note that this is independent of time passed unlike the normalized max above. Units: MB
			//// COL NAME: OverGrew / VAR NAME: OverGrew - boolean as to whether the MAXGROWTH (%/DAY) surpassed the allowed growth (converted to a %/DAY equivalence). Units: True/False
			//// COL NAME: AmountGrown / VAR NAME: historicGrowth - the growth from first to last measurement. Units - MB
			//// COL NAME: Decrease / VAR NAME: Decrease - boolean as to whether there was ever a decrease in size between two continual measurements. Units: 1/0
			//// COL NAME: FastFlagAll / VAR NAME: fastFlagAll - boolean that demonstrates if any single measurement for a global was taken in 'fast' mode, meaning that all UsedMB measurements are ignored and only Allocated space will be considered. Units: 1/0
			//// COL NAME: GrowthForRequestedPeriod / VAR NAME: growthForRequestedPeriod - taken as historicGrowthPerDay * PeriodWarning this shows how much MB this would have grown in the requested period had it grown at this rate for that period. to make the numbers more digestible. Units: NORMALIZED MB 
			//// COL NAME: ReportNum / VAR NAME: rowID - corresponds to the ID of the row in the 'Meta' table (Sample_DBExpansion_Data.InvestigationMeta)
			////----------------------------------------------------------------------------------------------------///////////////////////
			
			&sql(Insert into Sample_DBExpansion_Data.GlobalInvestigationReport(ClassName, GlobalName, HistoricGrowthPerDay, MaxGrowthNormalized, MaxGrowthMB, OverGrew, AmountGrown, Decrease, FastFlagAll, GrowthForRequestedPeriod, ReportNum)
	   	 	VALUES (:prevClassName, :prevGlobalName, :historicGrowthPerDay, :maxGrowthRequestedPeriod, :maxGrowthMB,:OverGrew, :historicGrowth, :Decrease, :fastFlagAll, :growthForRequestedPeriod, :rowID))
			if (SQLCODE '=0)
			{
				set status = $$$ERROR($$$GeneralError, "DB Insert Failed, sqlcode: "_SQLCODE_" Message: "_$GET(%msg))
				return status
			}		
			
			/// reset firstMeasurement as changing to next global
			set firstMeasurement = 1 
		}
		////----------------------------------------------------------------------------------------------------///////////////////////
		//// RESET ALL STATS
		////----------------------------------------------------------------------------------------------------///////////////////////
		if (firstMeasurement = 1)
			{
				set OverGrew = 0
				set DecreaseAlloc = 0
				set DecreaseUsed = 0
				set maxGrowthNormPercentUsed = 0
				set maxGrowthNormPercentAlloc = 0
				set maxGrowthMBUsed = 0
				set maxGrowthMBAlloc = 0
				set fastFlagAll = currFastFlag
			
				set firstMeasurementUsed = currUsedSize
				set firstMeasurementAllocated = currAllocatedSize
				set firstDate = currDate
				set firstMeasurement = 0
				
				
			}
			else ///COMPARE IN HERE... NOT FIRST MEASUREMENT BUT STILL WITHIN SAME GLOBAL
			{
				set growthMBFromLastMeasurementUsed = currUsedSize - prevUsedSize
				set growthMBFromLastMeasurementAllocated = currAllocatedSize - prevAllocatedSize
				
				if (growthMBFromLastMeasurementAllocated < 0){
					set DecreaseAlloc = 1
				}
				if (growthMBFromLastMeasurementUsed < 0){
					set DecreaseUsed = 1
				}
				
				#; &sql(SELECT DATEDIFF('dd',:prevDate,:currDate) INTO :currDaysPassed) ///need to do error checking for this?
				set currDaysPassed = ##class(%SYSTEM.SQL.Functions).DATEDIFF("dd", prevDate, currDate)
		

				/// to avoid divide by 0 error
				if (prevUsedSize = 0){
					set prevUsedSize = 0.001
				}
				if (prevAllocatedSize = 0){
					set prevAllocatedSize = 0.001
				}

				//// ( percentage growth / day ) * Period Warning = Normalized %. If user requests 10% in 10 days then we can show what the equivalent growth in 10 days would have been as a %
				set currGrowthNormPercentUsed = ((growthMBFromLastMeasurementUsed / prevUsedSize) / currDaysPassed) * PeriodWarning
				set currGrowthNormPercentAlloc = ((growthMBFromLastMeasurementAllocated / prevAllocatedSize) / currDaysPassed) * PeriodWarning



				if (currGrowthNormPercentUsed > maxGrowthNormPercentUsed)
				{
					set maxGrowthNormPercentUsed = currGrowthNormPercentUsed 
					#; set maxGrowthMBUsed = growthMBFromLastMeasurementUsed
				}			
				if (growthMBFromLastMeasurementUsed > maxGrowthMBUsed){
					set maxGrowthMBUsed = growthMBFromLastMeasurementUsed
				}
				
				if (growthMBFromLastMeasurementAllocated > maxGrowthMBAlloc)
				{
					set maxGrowthMBAlloc = growthMBFromLastMeasurementAllocated
				}
				

				if (currGrowthNormPercentAlloc > maxGrowthNormPercentAlloc)
				{
					set maxGrowthNormPercentAlloc = currGrowthNormPercentAlloc
					#; set maxGrowthMBAlloc = growthMBFromLastMeasurementAllocated
				}
			
			}
	} /// end while loop
		
		
		////----------------------------------------------------------------------------------------------------///////////////////////
		//// NEED TO DO ANALYSIS FOR FINAL GLOBAL AS IT WILL NOT BE DONE IN THE WHILE LOOP AS THERE IS NO NEXT GLOBAL
		////----------------------------------------------------------------------------------------------------///////////////////////
			set lastDate = prevDate 
			set lastMeasurementUsed = prevUsedSize
			set lastMeasurementAllocated = prevAllocatedSize
			
			#; &sql(SELECT DATEDIFF('dd',:firstDate,:lastDate) INTO :histLengthGlobal)	///need to do error checking for this?	
			set histLengthGlobal = ##class(%SYSTEM.SQL.Functions).DATEDIFF("dd", firstDate, lastDate)
			
			set historicGrowthUsed = lastMeasurementUsed - firstMeasurementUsed
			set historicGrowthAllocated = lastMeasurementAllocated - firstMeasurementAllocated

			if (fastFlagAll = 0){
				set historicGrowth = historicGrowthUsed
				set maxGrowthRequestedPeriod = maxGrowthNormPercentUsed * 100
				set maxGrowthMB = maxGrowthMBUsed
				set Decrease = DecreaseUsed
			}

			else{ ///ran in fast, get alloc
				
				set historicGrowth = historicGrowthAllocated //amount grown
				set maxGrowthRequestedPeriod = maxGrowthNormPercentAlloc * 100
				write !, "max growth normalizedfor "_prevGlobalName_"is : "_maxGrowthRequestedPeriod
				set maxGrowthMB = maxGrowthMBAlloc
				set Decrease = DecreaseAlloc
			}
			set historicGrowthPerDay = historicGrowth/histLengthGlobal

			set growthForRequestedPeriod = historicGrowthPerDay * PeriodWarning

			if (maxGrowthRequestedPeriod > GrowthPercentageWarning){
				set OverGrew = 1
			}
							
			
			&sql(Insert into Sample_DBExpansion_Data.GlobalInvestigationReport(ClassName, GlobalName, HistoricGrowthPerDay, MaxGrowthNormalized, MaxGrowthMB, OverGrew, AmountGrown, Decrease, FastFlagAll, GrowthForRequestedPeriod, ReportNum)
	   	 	VALUES (:prevClassName, :prevGlobalName, :historicGrowthPerDay, :maxGrowthRequestedPeriod, :maxGrowthMB, :OverGrew, :historicGrowth, :Decrease, :fastFlagAll, :growthForRequestedPeriod, :rowID))
			if (SQLCODE '=0)
			{
				set status = $$$ERROR($$$GeneralError, "DB Insert Failed, sqlcode: "_SQLCODE_" Message: "_$GET(%msg))
				return status
			}		
			
			

	&sql(
	SELECT SUM(OverGrew) INTO :numGlobalsOverGrew
	FROM Sample_DBExpansion_Data.GlobalInvestigationReport 
	WHERE ReportNum = :rowID
	)
	if (SQLCODE '=0)
	{
		set status = $$$ERROR($$$GeneralError, "Select Sum Failed, sqlcode: "_SQLCODE_" Message: "_$GET(%msg))
		return status
	}
	&sql(
	SELECT TOP 1 GlobalName 
	INTO :biggestGrowerGlobal 
	FROM Sample_DBExpansion_Data.GlobalInvestigationReport 
	ORDER BY AmountGrown DESC  
	)
	if (SQLCODE '=0)
	{
		set status = $$$ERROR($$$GeneralError, "Select Failed, sqlcode: "_SQLCODE_" Message: "_$GET(%msg))
		return status
	}

	&sql(
		SELECT COUNT(*) INTO :NumberOfMeasurementsInspected 
		FROM Sample_DBExpansion_Data.GlobalAnalysisInfo
		WHERE GlobalName = :biggestGrowerGlobal
	)
	if (SQLCODE '=0)
	{
		set status = $$$ERROR($$$GeneralError, "Select Count(*) Failed, sqlcode: "_SQLCODE_" Message: "_$GET(%msg))
		return status
	}

	&sql(
	Update Sample_DBExpansion_Data.InvestigationMeta
	SET NumGlobalsOvergrown = :numGlobalsOverGrew, 
	BiggestGrower = :biggestGrowerGlobal,
	NumberOfMeasurementsInspected = :NumberOfMeasurementsInspected,
	TimeStamp = GETDATE()
	WHERE %ID = :rowID
	)
	if (SQLCODE '=0)
	{
		set status = $$$ERROR($$$GeneralError, "Update Failed, sqlcode: "_SQLCODE_" Message: "_$GET(%msg))
		return status
	}
	
	return $$$OK
}
