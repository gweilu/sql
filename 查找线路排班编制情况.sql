select * from ASGNARRANGESEQGD;
-----每条线路在时间段内具体的排班情况
select o.orgname,r.routename,a.execdate from ASGNARRANGEGD a,mcrouteinfogs r,mcorginfogs o 
where a.routeid=r.routeid(+) and a.orgid=o.orgid(+) and a.execdate between date'2016-5-3' and date'2016-5-9' and a.status='d'
order by o.orgname,r.routename,a.execdate;
------时间段内没有按时间排班的线路，包括没有做排班和做的天数不够的
select o1.orgname,o.orgname,r.routename from ASGNARRANGEGD a,mcrouteinfogs r,mcorginfogs o,mcorginfogs o1
where a.routeid=r.routeid(+) and a.orgid=o.orgid(+) and o.parentorgid=o1.orgid(+) and
 a.execdate between date'2016-5-3' and date'2016-5-9' and a.status='d'
group by o1.orgname,r.routename,o.orgname having count(r.routename)<7 order by o1.orgname,o.orgname,r.routename;
