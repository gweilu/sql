select * from ASGNARRANGESEQGD;
-----ÿ����·��ʱ����ھ�����Ű����
select o.orgname,r.routename,a.execdate from ASGNARRANGEGD a,mcrouteinfogs r,mcorginfogs o 
where a.routeid=r.routeid(+) and a.orgid=o.orgid(+) and a.execdate between date'2016-5-3' and date'2016-5-9' and a.status='d'
order by o.orgname,r.routename,a.execdate;
------ʱ�����û�а�ʱ���Ű����·������û�����Ű����������������
select o1.orgname,o.orgname,r.routename from ASGNARRANGEGD a,mcrouteinfogs r,mcorginfogs o,mcorginfogs o1
where a.routeid=r.routeid(+) and a.orgid=o.orgid(+) and o.parentorgid=o1.orgid(+) and
 a.execdate between date'2016-5-3' and date'2016-5-9' and a.status='d'
group by o1.orgname,r.routename,o.orgname having count(r.routename)<7 order by o1.orgname,o.orgname,r.routename;
