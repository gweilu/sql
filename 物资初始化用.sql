--1、库存初始化
create table mm_stockbillgd_bak20160205 as select * from mm_stockbillgd  --对库存交易单进行备份
create table mm_stockbilldetailgd_bak0205 as select * from mm_stockbilldetailgd  --对库存交易单明细进行备份
create table mm_realtimestockgd_bak20160205 as select * from mm_realtimestockgd  --对实时库存进行备份
create table mm_whmonthlyclosingdlgd_bak as select * from mm_whmonthlyclosingdeatailgd  --对库存月结明细表进行备份
create table mm_whmonthlyclosinggd_bak as select * from mm_whmonthlyclosingmnggd  --对库存月结表进行备份
--2、删除清空数据
delete from mm_stockbillgd;
delete from mm_stockbilldetailgd;
delete from mm_realtimestockgd;
delete from mm_whmonthlyclosingdeatailgd;
delete from mm_whmonthlyclosingmnggd;
--3、手动通过ERP新建入库单，有几个仓库就对应新建几个入库单，做一个测试物资即可，入库单日期需要时上个月的时间
--4、将整理的数据倒入库存交易单明细表
--新建倒入数据用的中间表
create table mm_input_temp
(
stockbillid varchar2(20),--库存交易单id，导入那个库房的数据就将之前新建的对应的入库单id填入
materialid varchar2(20), --物资编码，需要和物资档案完全统一，倒入前检查是否有重复 ***所需原始数据***
price      varchar2(20), --单价，一般为含税单价，目前基本都用含税单价***所需原始数据***
counts     varchar2(20), --数量，上月仓库盘库结存数量***所需原始数据***
totalsum   varchar2(20), --总金额***所需原始数据***
unit       varchar2(20), --单位，使用MM_MEASUREUNITGD表进行更新
batchno    varchar2(20), --批次号，按照一定规则递增，一种物资一个
planprice  varchar2(20), --计划价，与单价相同
invoicestatus varchar2(20),  --发票情况，置为1
taxprice      varchar2(20), --含税单价，与单价相同
taxsum        varchar2(20), --税额，置为0
taxtotalsum   varchar2(20), --税价合计，与总金额相同
taxpricerate  varchar2(20), --税率种类，置为4，17%
sellprice     varchar2(20), --销售价格，与单价同
selltotalsum  varchar2(20), --销售总额，与总金额相同
realprice     varchar2(20), --实际价格，与单价同
realtotalsum  varchar2(20), --实际金额，与总金额相同
supplierid    varchar2(20), --供应商id，此处需要公交给出，可能给出的是编码或名称，更新为id，如果分不清供应商可建议使用统一未知供应商即可
noinvoicecount varchar2(20), --未开发票数量，如果有则填写0，一般为零库存物资 ***所需原始数据***
invoicetype    varchar2(20), --发票类型，根据字典项invoicetype选择实际发票类型，此处为专票2
whid             varchar2(20)  --仓库信息、填写仓库的id或者其他可区分标识信息 ***所需原始数据*** 可能为名称需要对照仓库表进行更新
)
----倒入数据,按照仓库分别倒入
select * from mm_input_temp where stockbillid is null for update;
delete from mm_input_temp t where t.price is null;
select s.stockbillid,w.warehouseid,w.warehousename from mm_stockbillgd s,mm_warehousegd w where s.acceptwarehouse=w.warehouseid(+);
update mm_input_temp t set t.stockbillid='55160214133810889334' where t.stockbillid is null;
--按仓库重复执行以上步骤
update mm_input_temp t set t.materialid=replace(t.materialid,' ','-');--更新物资编码，物资编码格式不一样可以稍作调整，如果一样可不执行此步骤
---原始数据导入后可进行进一步的数据更新
update mm_input_temp t set t.planprice=t.price,t.taxprice=t.price,t.sellprice=t.price,t.realprice=t.price,--更新所有单价
                           t.taxtotalsum=t.totalsum,t.selltotalsum=t.totalsum,t.realtotalsum=t.totalsum,--更新所有金额
                           t.unit=(select m.unit from mm_materialgd m where m.materialid=t.materialid),--更新单位
                           t.taxsum=0,--更新税额
                           t.taxpricerate=4,--更新税率
                           t.invoicestatus=1,--更新发票情况
                           t.noinvoicecount=0,--更新未开发票数量
                           t.invoicetype=2,--更新发票类型
                          /* t.supplierid=(select p.supplierid from MM_PURCHASINGPRICEGD p 
                           where p.materialid=t.materialid and p.verifystatus=2 and p.startdate<date('2016/2/1') 
                           and p.enddate>date('2016/2/1'))--更新供应商信息*/
                           t.supplierid='55151023171700228073'--未知供应商    
---将数据插入表mm_stockbilldetailgd
insert into mm_stockbilldetailgd sd (sd.stockbilldetailid,sd.stockbillid,sd.materialid,sd.price,sd.count,sd.totalsum,sd.unit,
sd.planprice,sd.invoicestatus,sd.taxprice,sd.taxsum,sd.taxtotalsum,sd.taxpricerate,sd.sellprice,sd.selltotalsum,
sd.realprice,sd.realtotalsum,sd.supplierid,sd.noinvoicecount,sd.invoicetype) 
select pzh_seq.nextval,t.stockbillid,t.materialid,t.price,t.counts,t.totalsum,t.unit,
t.planprice,t.invoicestatus,t.taxprice,t.taxsum,t.taxtotalsum,t.taxpricerate,t.sellprice,t.selltotalsum,
t.realprice,t.realtotalsum,t.supplierid,t.noinvoicecount,t.invoicetype from mm_input_temp t       
------使用游标更新批次号
declare
varid varchar(20);
c varchar(20);
cursor mycur is select sd.stockbilldetailid from mm_stockbilldetailgd sd;
begin 
  c:='201501310001';
  open mycur;
  loop
    fetch mycur into varid;
    exit when mycur%notfound;
    update mm_stockbilldetailgd sd1 set sd1.batchno=c where sd1.stockbilldetailid=varid;
    c:=c+1;
    end loop;
    close mycur;
    end;
-------
/*注意：1、做完以上步骤后可以审核入库单，然后做月结即可。
		2、记得在月结之前将测试物资的相关数据删除。
		3、如果系统提示类似“剩余库存不足…………”，需要检查数据中是否包含为负数的物资*/

