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


Class Sample.DBExpansion.Util.REST.spec Extends %REST.Spec [ ProcedureBlock ]
{

XData OpenAPI [ MimeType = application/json ]
{
{
  "swagger":"2.0",
  "info":{
    "description":"Retrieve Data of Globals Tables and DB Tables stored in IRIS database",
    "version":"1.0.0",
    "title":"DB Analysis REST API"
  },
  "basePath":"/dbAnalysis",
  "schemes":[
    "http"
  ],
  "paths":{
    "/globals/all":{
      "get":{
        "x-ISC_CORS":true, 
        "summary":"Get globals info",
        "description":"Get stats on all globals in table",
        "operationId":"getAllGlobals",
        "produces":[
          "application/json"
        ],
        "responses":{
          "200":{
            "description":"OK"
          }
        }
      }
    },
    "/global/{globalName}":{
      "get":{
        "x-ISC_CORS":true,
        "summary":"Get info on one global",
        "description":"Get stats on one particular database",
        "operationId":"getUniqueGlobal",
        "produces":[
          "application/json"
        ],
        "parameters":[
          {
            "name":"globalName",
            "in":"path",
            "description":"nameofglobal",
            "required":true,
            "type":"string"
          }
        ],
        "responses":{
          "200":{
            "description":"OK"
          }
        }
      }
    },
        "/globals/table/{timeback}":{
      "get":{
        "x-ISC_CORS":true,
        "summary":"Get info on one global",
        "description":"Get stats on one particular database",
        "operationId":"getAllGlobalsTable",
        "produces":[
          "application/json"
        ],
        "parameters":[
          {
            "name":"timeback",
            "in":"path",
            "description":"days back to look",
            "required":true,
            "type":"string"
          }
        ],
        "responses":{
          "200":{
            "description":"OK"
          }
        }
      }
    },
    "/db/history":{
      "get":{
        "x-ISC_CORS":true,
        "summary":"Get info on one db",
        "description":"Get stats on single db in table",
        "operationId":"getDBHistory",
        "produces":[
          "application/json"
        ],
        "responses":{
          "200":{
            "description":"OK"
          }
        }
      }
    }
  }
}
}

}
