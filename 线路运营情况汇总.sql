select org1.orgname,
       route.routename,
       sum(p1.milenum) sjlc,
       sum(p1.checi) sjcc,
       SUM(CASE WHEN route.routetype=1 THEN p1.checi/2 ELSE p1.checi END) sjcc11,
       sum(p2.jhlc) jhlc,
       sum(p2.jhcc) jhcc,
       SUM(CASE WHEN route.routetype=1 THEN p2.jhcc/2 ELSE p2.jhcc END) jhcc11,
       sum(p3.lblc) lblc,
       sum(p3.lbcc) lbcc,
       sum(p4.milenum) gzlc,
       sum(p4.gzcc) gzcc,
       sum(p5.qtlc) qtlc,
       sum(p5.qtcc) qtcc,
       sum(p1.seqnum) sjcc1,
       sum(p1.seqnum_jb) jbcc,
       sum(p1.seqnum_yb) ybcc,
       sum(p6.jcgl) jcgl,
       sum(p6.qtgl) qtgl,
       sum(p6.xiaoche) xiaoche,
       sum(p6.baoche) baoche,
       sum(p6.fyylc) fyylc,
       sum(dc.diaochj) dianchj,
       SUM(IC.ichj) ichj
  from (select rec.orgid,
               rec.routeid,
               sum(rec.milenum) milenum,
               count(*) checi,
               sum(case
                     when rectype = 1 then
                      rec.seqnum
                     else
                      0
                   end) seqnum,
               sum(case
                     when rectype = 1 and rec.SEQUENCETYPE = '1' then
                      rec.seqnum
                     else
                      0
                   end) seqnum_jb,
               sum(case
                     when rectype = 1 and rec.SEQUENCETYPE = '2' then
                      rec.seqnum
                     else
                      0
                   end) seqnum_yb
          from fdisbusrunrecgd rec
         where rec.isavailable = 1
           and rec.rundatadate between date '&datefrom1' and date
         '&dateto1'
          ---- and rec.rectype = 1 
          and rec.bussid not in ('9','12','13','15','16','17','18','19','21','31','32','41','42','43','44','50','81','84')
         group by rec.orgid, rec.routeid) p1,
       (select jh.orgid, jh.routeid, sum(jh.milenum) jhlc, sum(jh.seqnum) jhcc
          from FDISDISPLANLD jh
         where jh.RUNDATE between date '&datefrom1' and date
         '&dateto1'
           ---and jh.RECTYPE = '1'
           and jh.bussid not in ('9','12','13','15','16','17','18','19','21','31','32','41','42','43','44','50','81','84')
           and jh.ISACTIVE = '1'
         group by jh.orgid,jh.routeid) p2,
       (select rec.orgid,rec.routeid, sum(FAKEMILE) lblc, count(*) lbcc
          from FDISDISPLANLD rec, fdisfakeseqgd lanb
         where rec.displanfakeseqid = lanb.fakeseqid
           and rec.RUNDATE between date '&datefrom1' and date
         '&dateto1'
           and lanb.ISACTIVE = '1'
         group by rec.orgid,rec.routeid) p3,
       (select rec.orgid,rec.routeid, sum(rec.milenum) milenum, count(*) gzcc
          from fdisbusrunrecgd rec
         where rec.isavailable = 1
           and rec.rundatadate between date '&datefrom1' and date
         '&dateto1'
           and rec.rectype = 1
           and rec.DISPLANBUSTRBID is not null
         group by rec.orgid,rec.routeid) p4,
       (select t.orgid,t.routeid,
               sum(case
                     when t.milenum - t.sngmile != '0' then
                      t.milenum
                     else
                      0
                   end) qtlc,
               sum(case
                     when t.milenum - t.sngmile != '0' then
                      1
                     else
                      0
                   end) qtcc
        
          from (select rec.orgid,rec.routeid, rec.milenum, dancheng.sngmile
                  from fdisbusrunrecgd rec, MCSEGMENTINFOGS dancheng
                 where rec.isavailable = 1
                   and rec.rundatadate between date
                 '&datefrom1'
                   and date '&dateto1'
                  ---- and rec.rectype = 1
                   and rec.bussid not in ('9','12','13','15','16','17','18','19','21','31','32','41','42','43','44','50','81','84')
                   and rec.DISPLANBUSTRBID is null
                   and dancheng.segmentid = rec.segmentid) t
         group by t.orgid,t.routeid) p5,
          (select rec.orgid,rec.routeid,
               sum(case
                     when rectype <> 1  then
                      rec.milenum
                     else
                      0
                   end) fyylc,
               sum(case
                     when rectype <> 1 and rec.bussid in ('15', '16') then
                      rec.milenum
                     else
                      0
                   end) jcgl,
               sum(case
                     when rectype <> 1 and
                          rec.bussid not in ('61', '82','83','14', '15', '16') then
                      rec.milenum
                     else
                      0
                   end) qtgl,
               sum(case
                     when rectype <> 1 and rec.bussid = '61' then
                      rec.milenum
                     else
                      0
                   end) xiaoche,
               sum(case
                     when rectype <> 1 and rec.bussid in( '14','82','83') then
                      rec.milenum
                     else
                      0
                   end) baoche
          from fdisbusrunrecgd rec
         where rec.isavailable = 1
           and rec.rundatadate between date '&datefrom1' and date
         '&dateto1'
           and rec.rectype <> 1
         group by rec.orgid,rec.routeid) p6,
                       (select t.orgid,
       t.routeid,
         sum(case
             when t1.dcclasscode <> '0' then
              t1.money
             else
              0
           end)  diaochj
  from BFARETKACNT       t,
       BFAREDCACNTDETAIL t1
 where t.tkacntid = t1.tkacntid
   and t.flag = '1'
   and t.isactive = '1'
   and t.BIZDATE between date '&datefrom1' and date '&dateto1'
 group by t.orgid,
       t.routeid) dc,
  (select che.orgid, T.ROUTEID, SUM(T.ICMONEY) ichj
  FROM fygj.fy_iccarddata t,
       mcbusinfogs      che,
       mcrouteinfogs    xianlu
 where t.routeid = xianlu.routeid
       AND T.BUSNAME = CHE.CARDID
   and t.rundate between date '&datefrom1' and date '&dateto1'
 GROUP BY che.orgid, T.ROUTEID) IC,
 mcorginfogs org,
       mcorginfogs org1,
       mcrouteinfogs route
 where p1.orgid = p2.orgid(+)
   and p1.orgid = p3.orgid(+)
   and p1.orgid = p4.orgid(+)
   and p1.orgid = p5.orgid(+)
   and p1.orgid = p6.orgid(+)
   and p1.orgid = dc.orgid(+)
   and p1.orgid = IC.orgid(+)
   and p1.routeid = p2.routeid(+)
   and p1.routeid = p3.routeid(+)
   and p1.routeid = p4.routeid(+)
   and p1.routeid = p5.routeid(+)
   and p1.routeid = p6.routeid(+)
   and p1.routeid = dc.routeid(+)
   and p1.routeid = IC.routeid(+)
   and p1.orgid = org.orgid(+)
   and p1.routeid = route.routeid(+)
   and org1.orgid = org.PARENTORGID
   and route.routeid in (&routeids)
 group by org1.orgname,route.routename
