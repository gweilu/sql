--����ά��ͳ��--------------------------------
select * from typeentry t where t.typename='REPORTCATEGORY';
select ogp.orgname,sum(case when r.rptcategory=0 then 1 else null end) xx, --С��
sum(case when r.rptcategory=1 then 1 else null end) zhby,--�ߺϱ���
sum(case when r.rptcategory=2 then 1 else null end) yb,--һ��
sum(case when r.rptcategory=3 then 1 else null end) qhyb,--ǿ��һ��
sum(case when r.rptcategory=4 then 1 else null end) eb,--����
sum(case when r.rptcategory=5 then 1 else null end) qheb,--ǿ������
sum(case when r.rptcategory=6 then 1 else null end) sqgb,--����߱�p
sum(case when r.rptcategory=7 then 1 else null end) ns,--����
sum(case when r.rptcategory=8 then 1 else null end) sg,--�¹�
sum(case when r.rptcategory=13 then 1 else null end) wx--����
from BM_WORKREPORTGD r,mcorginfogs ogp
where r.orgid=ogp.parentorgid(+) group by ogp.orgname; 

select p.orgid,count(p.busnumber) busnum,count(p.planpbrq)planrq from pzhdrb p group by p.orgid
