select p.*,CASE WHEN 
       route.routename
  from (select t.routeid,
               sum(t.sjlc) 实际里程,
               sum(t.yylc) 营运里程,
               sum(t.fyylc) 非营运里程,
               sum(t.jccgl) 进出场里程,
               sum(t.qtgl) 其他里程,
               sum(t.xiaoche) 校车里程,
               sum(t.baoche) 包车公里,
               sum(t.sjcc)/2  实际车次,
               sum(t.sjcc_jb)/2 加班车次,
               sum(t.sjcc_yb)/2 夜班车次,
               sum(t.lbsl)/2 停班班次,
               sum(t.jhlc) 计划里程,
               sum(t.jhcc)/2 计划车次
          from (select p10.rundatadate,
                       p10.routeid,
                       p10.busid,
                       p10.driverid,
                       p11.SHIFTNUM,
                       p11.milenum sjlc,
                       p11.yy_milenum yylc,
                       p11.fyy_milenum fyylc,
                       p11.fyy_milenum_jcgl jccgl,
                       p11.fyy_milenum_qtgl qtgl,
                       p11.fyy_milenum_xiaoche xiaoche,
                       P11.fyy_milenum_baoche baoche,
                       p11.seqnum sjcc,
                       p11.seqnum_jb sjcc_jb,
                       p11.seqnum_yb sjcc_yb,
                       lb.lbsl lbsl,
                       jh1.jhlc jhlc,
                       jh1.jhcc jhcc,
                       dc.diaochj,
                       IC.ichj
                  from ( select p0.rundatadate,
        p0.routeid,
        p0.driverid,
        p0.busid,
        count(*)
   from (select t.BIZDATE  rundatadate,
                t.routeid  routeid,
                t.DRIVERID driverid,
                t.busid    busid
           from BFARETKACNT t
          where t.flag = '1'
            and t.isactive = '1'
            and t.BIZDATE between date '&datefrom1' and date
          '&dateto1'
         union all
         select rec.rundatadate rundatadate,
                rec.routeid     routeid,
                rec.driverid    driverid,
                rec.busid       busid
           from fdisbusrunrecgd rec
          where rec.isavailable = 1
            and rec.rundatadate between date '&datefrom1' and date
          '&dateto1'
          union all
         select rec.RUNDATE rundatadate,
                rec.routeid     routeid,
                rec.driverid    driverid,
                rec.busid       busid
           from FDISDISPLANLD rec
          where rec.RUNDATE between date
                                 '&datefrom1'
                                   and date '&dateto1'
                                   and rec.RECTYPE='1'
                                   and rec.ISACTIVE = '1') p0
  group by p0.rundatadate,
           p0.routeid,
           p0.driverid,
           p0.busid) p10,
                  (select rec.rundatadate,
                               rec.routeid,
                               rec.busid,
                               rec.driverid,
                               rec.SHIFTNUM,
                               f_get_busoilvalue(rec.busid,
                                                 rec.routeid,
                                                 rec.rundatadate) *
                               sum(rec.milenum) / 100 fuelcost_sta,
                               sum(rec.milenum) milenum,
                               sum(case
                                     when rectype = 1 then
                                      rec.milenum
                                     else
                                      0
                                   end) yy_milenum,
                               sum(case
                                     when rectype <> 1 then
                                      rec.milenum
                                     else
                                      0
                                   end) fyy_milenum,
                               sum(case
                                     when rectype <> 1 and rec.bussid in('15','16') then
                                      rec.milenum
                                     else
                                      0
                                   end) fyy_milenum_jcgl,
                               sum(case
                                     when rectype <> 1  and rec.bussid not in('61','14','82','83','15','16')  then
                                      rec.milenum
                                     else
                                      0
                                   end) fyy_milenum_qtgl,
                                sum(case
                                     when rectype <> 1 and rec.bussid='61' then
                                      rec.milenum
                                     else
                                      0
                                   end) fyy_milenum_xiaoche,
                                 sum(case
                                     when rectype <> 1  and rec.bussid in('14','82','83') then
                                      rec.milenum
                                     else
                                      0
                                   end) fyy_milenum_baoche,
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
                                   end) seqnum_yb,
                               0 fuelnum
                          from fdisbusrunrecgd rec
                         where rec.isavailable = 1
                           and rec.rundatadate between date
                         '&datefrom1'
                           and date '&dateto1'
                         group by rec.routeid,
                                  rec.busid,
                                  rec.driverid,
                                  rec.SHIFTNUM,
                                  rec.rundatadate) p11,
                       (select lanban.routeid,
                               lanban.busid,
                               lanban.driverid,
                               lanban.RUNDATE,
                               lanban.SHIFTNUM,
                               count(*) lbsl
                          from (select rec.RUNDATE,
                                       rec.routeid,
                                       rec.busid,
                                       rec.driverid,
                                       rec.SHIFTNUM
                                  from FDISDISPLANLD rec, fdisfakeseqgd lanb
                                 where rec.displanfakeseqid = lanb.fakeseqid
                                   and rec.RUNDATE between date
                                 '&datefrom1'
                                   and date '&dateto1'
                                   and lanb.ISACTIVE = '1') lanban
                         group by lanban.routeid,
                                  lanban.busid,
                                  lanban.driverid,
                                  lanban.SHIFTNUM,
                                  lanban.RUNDATE) lb,
                       (select jh.rundate,
                               jh.routeid,
                               jh.busid,
                               jh.driverid,
                               jh.SHIFTNUM,
                               sum(jh.milenum) jhlc,
                               sum(jh.seqnum) jhcc
                          from (select rec.RUNDATE,
                                       rec.routeid,
                                       rec.busid,
                                       rec.driverid,
                                       rec.milenum,
                                       rec.SHIFTNUM,
                                       rec.seqnum
                                  from FDISDISPLANLD rec
                                 where rec.RUNDATE between date
                                 '&datefrom1'
                                   and date '&dateto1'
                                   and rec.RECTYPE='1'
                                   and rec.ISACTIVE = '1') jh
                         group by jh.rundate,
                                  jh.routeid,
                                  jh.busid,
                                  jh.driverid,jh.SHIFTNUM) jh1,
                    (select t.BIZDATE,
       t.routeid,
       t.DRIVERID,
       t.busid,
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
 group by t.BIZDATE,
          t.routeid,
          t.DRIVERID,
          t.busid) dc,
  (select t.rundate, T.ROUTEID, CHE.BUSID, EMP.EMPID, SUM(T.ICMONEY) ichj
  FROM fygj.fy_iccarddata t,
       MCROUTEINFOGS      xianlu,
       MCBUSINFOGS        CHE,
       mcemployeeinfogs   emp
 where t.routeid = xianlu.routeid
   AND T.BUSNAME = CHE.CARDID
   AND T.EMPCARDID = EMP.CARDID
   and t.rundate between date '&datefrom1' and date '&dateto1'
 GROUP BY t.rundate, T.ROUTEID, CHE.BUSID, EMP.EMPID) IC
                 where  p11.routeid = lb.routeid(+)
                   and p11.busid = lb.busid(+)
                   and p11.driverid = lb.driverid(+)
                   and p11.rundatadate = lb.RUNDATE(+)
                   and p11.SHIFTNUM = lb.SHIFTNUM(+)
                   and p11.routeid = jh1.routeid(+)
                   and p11.busid = jh1.busid(+)
                   and p11.driverid = jh1.driverid(+)
                   and p11.rundatadate = jh1.RUNDATE(+)
                   and p11.SHIFTNUM = jh1.SHIFTNUM(+)
                   and p10.routeid = dc.routeid(+)
                   and p10.busid = dc.busid(+)
                   and p10.driverid = dc.driverid(+)
                   and p10.rundatadate = dc.BIZDATE(+)
                   and p10.routeid = IC.routeid(+)
                   and p10.busid = IC.busid(+)
                   and p10.driverid = IC.EMPID(+)
                   and p10.rundatadate = IC.RUNDATE(+)
                   and p10.routeid = p11.routeid(+)
                   and p10.busid = p11.busid(+)
                   and p10.driverid = p11.driverid(+)
                   and p10.rundatadate = p11.rundatadate(+)
                  ) t
         group by  t.routeid) p,
       mcrouteinfogs route
 where  route.routeid = p.routeid
 order by  routename
