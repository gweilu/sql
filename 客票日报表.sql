select a.tkclasscode,
       case
         when substr(a.tkclassname, 0, 1) = 'A' then
          'A'
         when substr(a.tkclassname, 0, 1) = 'B' then
          'B'
         else
          null
       end tclass,
       a.tkclassname,
       a.faceamount,
       a.yn,
       a.ym,
       a.tn,
       a.tm,
       b.cn,
       b.cm,
       b.sn,
       b.sm,
       b.rn,
       b.rm
  from (select bc.tkclasscode,
               bc.tkclassname,
               bc.faceamount,
               sum(t.yn) yn,
               sum(t.ym) ym,
               sum(t.tn) tn,
               sum(t.tm) tm,
               t.orgid,
               t.orgname
          from BFARETKCLASS bc,
               (select ts.tkclasscod,
                       case
                         when ts.recdate = date '&dates' - 1 then
                          ts.curpicenum
                         else
                          0
                       end yn,
                       case
                         when ts.recdate = date '&dates' - 1 then
                          ts.curmoney
                         else
                          0
                       end ym,
                       case
                         when ts.recdate = date '&dates' then
                          ts.curpicenum
                         else
                          0
                       end tn,
                       case
                         when ts.recdate = date '&dates' then
                          ts.curmoney
                         else
                          0
                       end tm,
                       ts.orgid,
                       o.orgname
                  from pzh_ticketstock ts, mcorginfogs o
                 where ts.orgid = o.orgid(+)
                   and ts.orgid in (&orgid)) t
         where bc.tkclasscode = t.tkclasscod(+)
         group by bc.tkclassname,
                  bc.faceamount,
                  t.orgid,
                  t.orgname,
                  bc.tkclasscode) a,
       (select t.bizdate,
               t.gs,
               t.tkclasscode,
               t.tkclassname,
               sum(t.cn) cn,
               sum(t.cm) cm,
               sum(t.sn) sn,
               sum(t.sm) sm,
               sum(t.rn) rn,
               sum(t.rm) rm
          from (select b.bizdate,
                       case
                         when e.orgid in
                              (select o.orgid
                                 from mcorginfogs o
                                start with o.parentorgid =
                                           '55150203175953844320'
                               connect by o.orgid = o.parentorgid) then
                          '55150203175953844320'
                         when e.orgid in
                              (select o.orgid
                                 from mcorginfogs o
                                start with o.parentorgid =
                                           '55150213092542050000'
                               connect by o.orgid = o.parentorgid) then
                          '55150213092542050000'
                         when e.orgid in
                              (select o.orgid
                                 from mcorginfogs o
                                start with o.parentorgid =
                                           '55150213092857160000'
                               connect by o.orgid = o.parentorgid) then
                          '55150213092857160000'
                         when e.orgid in
                              (select o.orgid
                                 from mcorginfogs o
                                start with o.parentorgid =
                                           '55150213092919062000'
                               connect by o.orgid = o.parentorgid) then
                          '55150213092919062000'
                         else
                          null
                       end gs,
                       bt.tkclasscode,
                       bt.tkclassname,
                       case
                         when b.biztype = 'C1' then
                          bt.piecenum
                         else
                          0
                       end cn,
                       case
                         when b.biztype = 'C1' then
                          bt.money
                         else
                          0
                       end cm,
                       case
                         when b.biztype = 'P1' then
                          bt.piecenum
                         else
                          0
                       end rn,
                       case
                         when b.biztype = 'P1' then
                          bt.money
                         else
                          0
                       end rm,
                       case
                         when b.biztype = 'J1' then
                          bt.piecenum
                         else
                          0
                       end sn,
                       case
                         when b.biztype = 'J1' then
                          bt.money
                         else
                          0
                       end sm
                  from BFARETKACNT       b,
                       BFARETKACNTDETAIL bt,
                       mcemployeeinfogs  e
                 where bt.tkacntid = b.tkacntid(+)
                   and b.operator = e.empid(+)
                   and b.bizdate = date '&dates') t
         where t.gs in (&orgid)
         group by t.bizdate, t.gs, t.tkclasscode, t.tkclassname) b
 where a.tkclassname = b.tkclassname(+)
   and a.orgid = b.gs(+)
 order by a.tkclasscode
