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


/// Retrieve Data of Globals Tables and DB Tables stored in IRIS database
/// Dispatch class defined by RESTSpec in Sample.DBExpansion.Util.REST.spec
Class Sample.DBExpansion.Util.REST.disp Extends %CSP.REST [ GeneratedBy = Sample.DBExpansion.Util.REST.spec.cls, ProcedureBlock ]
{

/// The class containing the RESTSpec which generated this class
Parameter SpecificationClass = "Sample.DBExpansion.Util.REST.spec";

/// Ignore any writes done directly by the REST method.
Parameter IgnoreWrites = 1;

/// By default convert the input stream to Unicode
Parameter CONVERTINPUTSTREAM = 1;

/// The default response charset is utf-8
Parameter CHARSET = "utf-8";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
  <!-- Get globals info -->
  <Route Url="/globals/all" Method="get" Call="getAllGlobals" Cors="true" />
  <!-- Get info on one global -->
  <Route Url="/global/:globalName" Method="get" Call="getUniqueGlobal" Cors="true" />
  <!-- Get info on one global -->
  <Route Url="/globals/table/:timeback" Method="get" Call="getAllGlobalsTable" Cors="true" />
  <!-- Get info on one db -->
  <Route Url="/db/history" Method="get" Call="getDBHistory" Cors="true" />
</Routes>
}

/// Get globals info
ClassMethod getAllGlobals() As %Status
{
    Try {
        Do ##class(%REST.Impl).%SetContentType("application/json")
        If '##class(%REST.Impl).%CheckAccepts("application/json") Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts)) Quit
        Set response=##class(Sample.DBExpansion.Util.REST.impl).getAllGlobals()
        Do ##class(Sample.DBExpansion.Util.REST.impl).%WriteResponse(response)
    } Catch (ex) {
        Do ##class(%REST.Impl).%ReportRESTError(..#HTTP500INTERNALSERVERERROR,ex.AsStatus(),$parameter("Sample.DBExpansion.Util.REST.impl","ExposeServerExceptions"))
    }
    Quit $$$OK
}

/// Get info on one global
ClassMethod getUniqueGlobal(pglobalName As %String) As %Status
{
    Try {
        Do ##class(%REST.Impl).%SetContentType("application/json")
        If '##class(%REST.Impl).%CheckAccepts("application/json") Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts)) Quit
        Set response=##class(Sample.DBExpansion.Util.REST.impl).getUniqueGlobal(pglobalName)
        Do ##class(Sample.DBExpansion.Util.REST.impl).%WriteResponse(response)
    } Catch (ex) {
        Do ##class(%REST.Impl).%ReportRESTError(..#HTTP500INTERNALSERVERERROR,ex.AsStatus(),$parameter("Sample.DBExpansion.Util.REST.impl","ExposeServerExceptions"))
    }
    Quit $$$OK
}

/// Get info on one global
ClassMethod getAllGlobalsTable(ptimeback As %String) As %Status
{
    Try {
        Do ##class(%REST.Impl).%SetContentType("application/json")
        If '##class(%REST.Impl).%CheckAccepts("application/json") Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts)) Quit
        Set response=##class(Sample.DBExpansion.Util.REST.impl).getAllGlobalsTable(ptimeback)
        Do ##class(Sample.DBExpansion.Util.REST.impl).%WriteResponse(response)
    } Catch (ex) {
        Do ##class(%REST.Impl).%ReportRESTError(..#HTTP500INTERNALSERVERERROR,ex.AsStatus(),$parameter("Sample.DBExpansion.Util.REST.impl","ExposeServerExceptions"))
    }
    Quit $$$OK
}

/// Get info on one db
ClassMethod getDBHistory() As %Status
{
    Try {
        Do ##class(%REST.Impl).%SetContentType("application/json")
        If '##class(%REST.Impl).%CheckAccepts("application/json") Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts)) Quit
        Set response=##class(Sample.DBExpansion.Util.REST.impl).getDBHistory()
        Do ##class(Sample.DBExpansion.Util.REST.impl).%WriteResponse(response)
    } Catch (ex) {
        Do ##class(%REST.Impl).%ReportRESTError(..#HTTP500INTERNALSERVERERROR,ex.AsStatus(),$parameter("Sample.DBExpansion.Util.REST.impl","ExposeServerExceptions"))
    }
    Quit $$$OK
}

}
