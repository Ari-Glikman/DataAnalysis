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


/// Retrieve Data of Globals Tables and DB Tables stored in IRIS database<br/>
/// Business logic class defined by OpenAPI in Sample.DBExpansion.Util.REST.spec<br/>

Class Sample.DBExpansion.Util.REST.impl Extends %REST.Impl [ ProcedureBlock ]
{

/// If ExposeServerExceptions is true, then details of internal errors will be exposed.
Parameter ExposeServerExceptions = 0;

/// Get stats on one particular database<br/>
/// The method arguments hold values for:<br/>
///     globalName, nameofglobal<br/>
ClassMethod getUniqueGlobal(globalName As %String) As %DynamicObject
{
	set obj = {"data": []}
	set statement = ##class(%SQL.Statement).%New()
	#; set query = "SELECT GB.GlobalName, GB.ClassName, GB.UsedMB, GB.AllocatedMB, DB.TimeStampEnd FROM Sample_DBExpansion_Data.DBAnalysisInfo AS DB INNER JOIN Sample_DBExpansion_Data.GlobalAnalysisInfo AS GB ON DB.ID = GB.MetaDataID WHERE GlobalName = ?"
	set query = "SELECT GlobalName, ClassName, UsedMB, AllocatedMB, MetaData->TimeStampEnd FROM Sample_DBExpansion_Data.GlobalAnalysisInfo Where GlobalName = ?"
	set status = statement.%Prepare(query)
	set rs = statement.%Execute(globalName)
		while rs.%Next(){
			set name = "GlobalName"
			if ($length(rs.%Get("ClassName")) > 1)
			{
				set name = "ClassName"
			}
			set global = {
				"Name": (rs.%Get(name)),
				"UsedMB": (rs.%Get("UsedMB")),
				"Date": (rs.%Get("TimeStampEnd")),
				"UsedMB": ((rs.%Get("UsedMB"))),
				"AllocatedMB": (rs.%Get("AllocatedMB"))
			}
			
			do obj.data.%Push(global)
		}
		d obj.%ToJSON()
		///set %response.Status = "200"
	
	Quit obj
}

/// Get stats on single db in table
ClassMethod getDBHistory() As %DynamicObject
{
    set obj = {"data": []}
	set query = "SELECT * FROM Sample_DBExpansion_Data.DBAnalysisInfo"
	set statement = ##class(%SQL.Statement).%New()
	set status = statement.%Prepare(query)
	set rs = statement.%Execute() //when use question mark on query and try to use input here having error
	while rs.%Next(){
		set DBHistory = {
			"Name": (rs.%Get("DatabaseName")),
            "Date": (rs.%Get("TimeStampEnd")),
            "DBUsedSize": (rs.%Get("DBUsedSize")),	
            "DBAllocSize": (+rs.%Get("DBAllocatedSize")) //+ here to change it from string with units to just value, will need to proof this... depends on expected sizes
		}
		
		do obj.data.%Push(DBHistory)
	}
	d obj.%ToJSON()
	Quit obj
}

/// Get stats on all globals in table
ClassMethod getAllGlobals() As %DynamicObject
{
	&sql(SELECT MAX(MetaData) INTO :metaID FROM Sample_DBExpansion_Data.GlobalAnalysisInfo)
	set obj = {"data": []}
	
	set query = "SELECT * From Sample_DBExpansion_Data.GlobalAnalysisInfo WHERE MetaData = ?"
	set statement = ##class(%SQL.Statement).%New()
	set status = statement.%Prepare(query)
	set rs = statement.%Execute(metaID)

	while rs.%Next(){
		set name = "GlobalName"
		if ($length(rs.%Get("ClassName")) > 1)
		{
			set name = "ClassName"
		}
		set global = {
			"Name": (rs.%Get(name)), //will display classname if exists, if not global name
            "UsedMB": (rs.%Get("UsedMB")),
			"AllocatedMB": (rs.%Get("AllocatedMB"))
		}
		
		do obj.data.%Push(global)
	}
	/// d obj.%ToJSON()
	Quit obj
}

/// Get stats on one particular database<br/>
/// The method arguments hold values for:<br/>
///     timeback, days back to look<br/>
ClassMethod getAllGlobalsTable(timeback As %String) As %DynamicObject
{
	try{
	set obj = {"data": []}
	
	set statement1 = ##class(%SQL.Statement).%New()
	set query1 = "SELECT Distinct(GlobalName) From Sample_DBExpansion_Data.GlobalAnalysisInfo"
	set status1 = statement1.%Prepare(query1)
	set rs1 = statement1.%Execute()
		while rs1.%Next(){
			set globalName = rs1.%Get("GlobalName")
			set statement2 = ##class(%SQL.Statement).%New()
			set query2 = "SELECT MIN(MetaData) AS MINID, MAX(MetaData) AS MAXID FROM Sample_DBExpansion_Data.GlobalAnalysisInfo WHERE GlobalName = ? AND DATEDIFF('dd', MetaData->TimeStampEnd, GETDATE()) <= ?"
			set status2 = statement2.%Prepare(query2)
			set rs2 = statement2.%Execute(globalName, timeback)
	 		while rs2.%Next(){
	 			set minMetaID = rs2.%Get("MINID")
	 			set maxMetaID = rs2.%Get("MAXID")
	 		}
	 		set statement3 = ##class(%SQL.Statement).%New()
	 		set query3 = "SELECT ClassName, UsedMB, AllocatedMB, MetaData->TimeStampEnd FROM Sample_DBExpansion_Data.GlobalAnalysisInfo WHERE GlobalName = ? AND MetaData = ?"
	 		set status3 = statement3.%Prepare(query3)
	 		set rs3 = statement3.%Execute(globalName, minMetaID)
	 		while rs3.%Next()
	 		{
	 			set oldAllocMB  = rs3.%Get("AllocatedMB")
	 			set oldUsedMB  = rs3.%Get("UsedMB")
	 			set oldDate = rs3.%Get("TimeStampEnd")
	 		}
			
	 		set rs4 = statement3.%Execute(globalName, maxMetaID)
	 		while rs4.%Next()
	 		{
	 		///	set newAllocMB  = rs4.%Get("AllocatedMB")
	 			set newMB  = rs4.%Get("UsedMB")
	 			set newDate = rs4.%Get("TimeStampEnd")
	 			set className = rs4.%Get("ClassName")
	 		}
			
	 		try{
	 			set change = ((newMB - oldUsedMB)/oldUsedMB)*100
	 		}
	 		catch ex
	 		{
	 			set change = 0
	 		}
	 		set change = $DECIMAL(change, 4)
	 		set global = {
	 		"Name": (globalName), //will display classname if exists, if not global name
             "ClassName": (className),
	 		"OldMB": (oldUsedMB),
	 		"OldDate": (oldDate),
	 		"NewMB": (newMB),
	 		"NewDate": (newDate),
	 		"Change": (change)
	 	}
		
	 	do obj.data.%Push(global)
		}
		Do ..%SetStatusCode(200)
		return obj
	}
	catch error
	{
		Do ..%SetStatusCode(400)
		return "Check that there is data for the dates entered"
	}
}

}
