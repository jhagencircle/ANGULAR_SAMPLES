SELECT distinct top 5000 req.InsertDate,
res.SerializedData,
len(serializedData) dataLen, 
JSON_VALUE(res.RequestEDI,'$[0].provider."npi"') as NPI,
req.SubscriberId,
JSON_VALUE(res.RequestEDI,'$[0].provider."taxId"') as TaxId,
FORMAT(req.DateOfBirth, 'MM/dd/yyyy', 'en-US' ) as DateOfBirth,
JSON_VALUE(res.SerializedData,'$[0].Claims[0]."Status"') as ClaimCode,
MemberFirstName, MemberLastName,
JSON_VALUE(res.SerializedData,'$[0].Claims[0]."StatusDisplay"') as ClaimStatus,
JSON_VALUE(res.SerializedData,'$[0]."DependentFirstName"') DependentFirstName,
JSON_VALUE(res.SerializedData,'$[0]."DependentLastName"') DependentLastName,
JSON_VALUE(res.SerializedData,'$[0].DependentGender') DependentGender,
req.ClaimsFound,
req.RequestId,
res.ResponseId,
JSON_VALUE(res.RequestEDI,'$[0].claim."beginningDateOfService"') as BegainDateOfService,
JSON_VALUE(res.RequestEDI,'$[0].claim."endDateOfService"') as EndDateOfService,
JSON_VALUE(res.RequestEDI,'$[0].provider."lastName"') as ProviderName,
*
FROM claim.Request req with (nolock) 
LEFT JOIN claim.Response res with (nolock) on req.RequestId = res.RequestId  
Where	
    ISNULL(res.SerializedData, '') <> '' and
   ISNULL(res.RequestEDI,'')<>''    
	--and req.SubscriberId like 'NNJ850133451'
	and userId like '%tawny1%'
   --ResponseId = '32924'
ORDER BY 1 DESC



--CTE NOTE:  From this we need Claims Status = None and Total ProcessTime > 12
--WITH InternalLog_CTE (CorrId,MSGAGENT,SysLogsStatus,TotalProcessTime,MSGDATE,RespIdStart,PlusDiff,Inf, RespId, SerialData)
--AS
--(
--	SELECT 	SUBSTRING(Info, 0,CHARINDEX(':', Info)) CorrId, 	
--	MSGAGENT, MSGSTRING,TotalProcessTime,MSGDATE,CHARINDEX('ResponseId:',Info) RespIdStart,CHARINDEX('ResponseType:',Info) - CHARINDEX('ResponseId:',Info) PlusDiff,Info Inf
--	,REPLACE(REPLACE(SUBSTRING(Info,CHARINDEX('ResponseId:',Info), CHARINDEX('ResponseType:',Info) - CHARINDEX('ResponseId:',Info)),'ResponseId: ',''),',','') RespId
--	,CASE WHEN SerializedData IS NULL OR SerializedData = '' THEN 'None' ELSE SerializedData END
--	FROM SystemLogs.dbo.TblInternalLog S WITH(NOLOCK) INNER  JOIN 	claim.Response R with (nolock) ON SUBSTRING(Info, 0,CHARINDEX(':', Info)) = R.CorrelationIds 
--	WHERE S.MSGTYPE = 'P_ClaimSum' 	
--	and 	CHARINDEX('ResponseType:',Info) - CHARINDEX('ResponseId:',Info)  > 0
--)
--select top 50
--CASE WHEN SerialData != 'None' THEN
--JSON_VALUE(SerialData,'$[0].Claims[0]."StatusDisplay"') 
--ELSE SerialData
--END ClaimsStatus
--,MSGAGENT, SysLogsStatus, TotalProcessTime, *
--FROM claim.Request RQ with (nolock) LEFT JOIN 	claim.Response RS with (nolock) 
--	on RQ.RequestId = RS.RequestId INNER JOIN 	InternalLog_CTE C with (nolock) 
--	ON RS.correlationIds = C.CorrId where
----and UserId = 'tawny1'	
-- C.CorrId != '' and C.CorrId IS NOT NULL --and TotalProcessTime > 50
--ORDER BY C.MSGDATE DESC

--select top 200 Substring(SubscriberId,1,1),ISNUMERIC(Substring(SubscriberId,0,3)),* from claim.Request where ISNUMERIC(Substring(SubscriberId,1,1)) = 1

--print len('ResponseId:') 

--SELECT distinct MSGSTRING FROM SystemLogs.dbo.TblInternalLog S WITH(NOLOCK) WHERE S.MSGTYPE = 'P_ClaimSum'  

--SELECT  JSON_VALUE(res.SerializedData,'$[0].Claims[0]."StatusDisplay"') ClaimStatus, count(*) Ct FROM claim.Request req with (nolock) LEFT JOIN claim.Response res with (nolock) on req.RequestId = res.RequestId Where	
--    ISNULL(res.SerializedData, '') <> '' and ISNULL(res.RequestEDI,'')<>'' group by JSON_VALUE(res.SerializedData,'$[0].Claims[0]."StatusDisplay"')



--SELECT     TOP 100 --PERCENT 
--* --ExceptionId, ParentException, IsHandled, UserId, SessionId, Source, Member, Url, RefererUrl, HttpUserAgent, Form, QueryString, Message, StackTrace, AdditionalInfo, LogTime
--FROM         dbo.utb_ExceptionLog
----and RS.ResponseId = '22928'


--select  *  from claim.Response r
--LEFT JOIN claim.Request q on r.RequestId = q.RequestId
--where ResponseId = '463'




--    S.MSGDATE DESC
 
----select distinct  SystemLogs.dbo.MSGSTRING from TblInternalLog order by 1
----SELECT SUBSTRING(Info, CHARINDEX('ResponseType:',Info) + 13, 99) AS ResponseType,COUNT(*) AS [Count] FROM dbo.TblInternalLog  WITH(NOLOCK)
----WHERE MSGDATE >= '09/27/2020 00:00' AND        MSGTYPE = 'P_Remit' --'P_ClaimSum'
----GROUP BY SUBSTRING(Info, CHARINDEX('ResponseType:',Info) + 13, 99)


--"npi": "1184089625",        
--"taxId": "371786239",        
-- "id": "850115531",
-- 12/01/1952        
-- "firstName": "STEPHEN",        
-- "lastName": "STELFOX",        "dateOfBirth": "1952-12-01"      },      "claim": {        "beginningDateOfService": "2021-01-01",        "endDateOfService": "2021-07-08"      },      "region": "K",      "areaPrefix": "LCL",      "isDependent": false    }  ]  RequestId: 23477, ResponseId: 22929, ResponseType: Error  

--select * FROM dbo.TblInternalLog  WITH(NOLOCK) where  MSGTYPE = 'P_Remit' 
----Note that “Timeout” is not a network timeout (error) but rather that is the response we get back from the Claims system.
----Since we’ve put this in place, there are two exceptions, which I also see in the Exception Log.

--SELECT top 100 * FROM dbo.TblInternalLog WITH(NOLOCK) WHERE MSGTYPE = 'P_Remit' and MSGDATE >= '5/27/2021' order by 1 desc --DATE >= GETDATE() - 100 order by MSGDATE desc

--SELECT top 10000 * FROM dbo.utb_ExceptionLog WITH(NOLOCK)  WHERE LogTime >= GETDATE() - 100 
----AND SessionId = 'Provider Portal' 
--and logTime >= '04/22/2021 00:00'  
--AND [Url] like '%eligi%'--'/v1/claims/inquiry' 

   
--select * from tbl_CorrClaimSubmission
--select * from Request

------**********************************1/7/2021
USE SystemLogs
GO
SELECT TOP 10
    *
FROM
    dbo.utb_ExceptionLog WITH(NOLOCK)
	where
	 --ExceptionId > 220500000
	  userId = 'tawny1'
ORDER BY 1 desc

SELECT TOP 10 * --JSON_VALUE(SUBSTRING(Info, CHARINDEX('[',Info)+2,8000),'$[0].ResponseId') ResponseId,    
FROM     SystemLogs.dbo.TblInternalLog S WITH(NOLOCK)
WHERE     --S.MSGTYPE = 'P_ClaimSum'  
	--and TotalProcessTime > 50
	 UserId = 'tawny1'
	--and MSGSTRING IN ('Timeout')	
ORDER BY 1 desc
--
--select * from [provider].Settings
--select * from [provider].SettingTypes
--select * from [provider].UserSettings
--select * from [provider].UserTypeSettings


--SELECT top 100	RQ.InsertDate,	R.InsertDate,	*
--FROM
--	eligibility.Request RQ WITH(NOLOCK) 		INNER JOIN
--	eligibility.RequestXRef X WITH(NOLOCK) ON RQ.RequestId = X.RequestId 		INNER JOIN
--	dbo.tblEligibilityRequests R WITH(NOLOCK) ON X.LegacyRequestId = R.RequestID
	
--SELECT top 2000 insertDate,SubscriberId,FORMAT(DateOfBirth, 'MM/dd/yyyy', 'en-US' ) as DateOfBirth,*   FROM [ProviderInet].[eligibility].[Request] WITH(NOLOCK) 
--where userId = 'tawny1'
--order by 1 desc
--SELECT  top 2000 *   FROM [ProviderInet].[eligibility].[Response] WITH(NOLOCK) where convert(varchar(max),ResponseXml) like ('%Grace%') order by 1 desc 

--SELECT top 400 insertDate,req.SubscriberId,FORMAT(req.DateOfBirth, 'MM/dd/yyyy', 'en-US' ) as DateOfBirth,req.DateOfService,*   FROM [ProviderInet].[eligibility].[Request] req WITH(NOLOCK) INNER JOIN [ProviderInet].[eligibility].[Response] res WITH(NOLOCK)
--ON req.RequestId = res.RequestId 
--where 
--userId = 'tawny1' 
--and req.LastName IN('SAGE')
----req.SubscriberId IN ('NNJ851642662') 
----and convert(varchar(max),ResponseXml) like ('%Grace%Period%')
--order by 1 desc

--select * from tbl_ServiceTypes


--SELECT top 50 len(rp.InquiryEDI),rq.insertDate,rp.SubscriberId,rp.FirstName,rp.LastName,rp.DateOfBirth,InpatientNPI,InpatientTaxId,*   
--FROM [ProviderInet].[eligibility].[Response] rp WITH(NOLOCK) 
--right outer join [ProviderInet].[eligibility].[Request] rq WITH(NOLOCK) on rp.RequestId = rq.RequestId 
--inner join tblEligibilityInquiries ei WITH(NOLOCK) on rp.ControlNumber = ei.ControlNumber
----where --userId like 'tawny1'--serviceType != '30'--
----rp.SubscriberId  like 'SYD%'
----rq.RequestId in (3603)
----rp.lastname like '%Shah%' and --rp.FirstName like '%A%'
----InquiryEDI like '%REF%'
----convert(varchar (max),responseXml) like '%McKesson%'
--order by rq.InsertDate desc

--0 - INVALID
--1 - MEDICARE
--2 - LOCAL
--3 - OOA
--4 - FEP
--5 - CHS


--SELECT distinct c.name AS ColName, t.name AS TableName,* FROM sys.columns c INNER JOIN sys.tables t ON c.object_id = t.object_id
--WHERE c.name LIKE '%ServiceType%'; 



--SELECT distinct c.name AS ColName, t.name AS TableName,DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, NUMERIC_PRECISION, DATETIME_PRECISION, s.IS_NULLABLE 
--FROM sys.columns c
--    INNER JOIN sys.tables t ON c.object_id = t.object_id
--	INNER JOIN INFORMATION_SCHEMA.COLUMNS s ON c.name = s.COLUMN_NAME
--WHERE c.name LIKE '%LOB%' and c.name = s.COLUMN_NAME;