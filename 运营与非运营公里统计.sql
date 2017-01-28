select cc.routeid,bus.busselfid,cc.drivername,cc.stewardname,
sum(case when cc.rectype=1 then cc.milenum else 0 end) yy,
sum(case when cc.rectype=1 then cc.seqnum else 0 end) yycc,
sum(case when cc.rectype=2 then cc.milenum else 0 end) fyy,
sum(case when cc.rectype=2 then cc.seqnum else 0 end) fyycc,
sum(cc.milenum) lchj,
sum(cc.seqnum) cchj
 from fdisbusrunrecgd cc,mcbusinfogs bus
where to_char(cc.rundatadate,'yyyy-mm-dd')='2015-10-17' and cc.routeid=4 and cc.rectype=1 and cc.isavailable=1
and cc.busid=bus.busid(+) group by cc.routeid,bus.busselfid,cc.drivername,cc.stewardname
