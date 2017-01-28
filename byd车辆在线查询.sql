---byd车辆在线情况查询
select a.co,
b.ORGname,b.ROUTENAME,b.BUSSELFID,b.CARDID,a.productid,a.num,a.min_time,a.max_time,a.max_routeid,a.min_routeid from mcbusinfosvw b ,(
select substr( a.productid,4,1) co, productid,count(1) num,min(a.actdatetime) min_time, max(a.actdatetime) max_time ,
max(routeid) max_routeid,min(routeid)  min_routeid
  from bsvcbuslastpositiondatald5 a 
  where a.actdatetime>to_date('2016-9-28 18:40:00','yyyy-mm-dd hh24:mi:ss') /*between date'2016-9-28'+18/24  and date'2016-9-28'+20/24 */
  and a.productid like '500_9%'
  and a.productid not between 50029449 and 50029500
  and a.productid not between 50039301 and 50039355
  and a.productid not between 50089301 and 50089325
  and a.productid not between 50089401 and 50089488
  and a.productid not between 50029501 and 50029600
  group by productid ) a where b.PRODUCTID(+)=a.productid --and a.min_routeid=0
order by a.co,b.ORGname,b.ROUTENAME,a.productid;

SELECT * FROM bsvcbusarrlftld5 b WHERE b.actdatetime>DATE'2016-10-1' b.routeid IS NULL;
