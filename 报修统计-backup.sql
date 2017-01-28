--车辆维修统计--------------------------------
select * from typeentry t where t.typename='REPORTCATEGORY';
select ogp.orgname,sum(case when r.rptcategory=0 then 1 else null end) xx, --小修
sum(case when r.rptcategory=1 then 1 else null end) zhby,--走合保养
sum(case when r.rptcategory=2 then 1 else null end) yb,--一保
sum(case when r.rptcategory=3 then 1 else null end) qhyb,--强化一保
sum(case when r.rptcategory=4 then 1 else null end) eb,--二保
sum(case when r.rptcategory=5 then 1 else null end) qheb,--强化二保
sum(case when r.rptcategory=6 then 1 else null end) sqgb,--视情高保p
sum(case when r.rptcategory=7 then 1 else null end) ns,--年审
sum(case when r.rptcategory=8 then 1 else null end) sg,--事故
sum(case when r.rptcategory=13 then 1 else null end) wx--外修
from BM_WORKREPORTGD r,mcorginfogs ogp
where r.orgid=ogp.parentorgid(+) group by ogp.orgname; 

select p.orgid,count(p.busnumber) busnum,count(p.planpbrq)planrq from pzhdrb p group by p.orgid
