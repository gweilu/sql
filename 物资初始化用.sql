--1������ʼ��
create table mm_stockbillgd_bak20160205 as select * from mm_stockbillgd  --�Կ�潻�׵����б���
create table mm_stockbilldetailgd_bak0205 as select * from mm_stockbilldetailgd  --�Կ�潻�׵���ϸ���б���
create table mm_realtimestockgd_bak20160205 as select * from mm_realtimestockgd  --��ʵʱ�����б���
create table mm_whmonthlyclosingdlgd_bak as select * from mm_whmonthlyclosingdeatailgd  --�Կ���½���ϸ����б���
create table mm_whmonthlyclosinggd_bak as select * from mm_whmonthlyclosingmnggd  --�Կ���½����б���
--2��ɾ���������
delete from mm_stockbillgd;
delete from mm_stockbilldetailgd;
delete from mm_realtimestockgd;
delete from mm_whmonthlyclosingdeatailgd;
delete from mm_whmonthlyclosingmnggd;
--3���ֶ�ͨ��ERP�½���ⵥ���м����ֿ�Ͷ�Ӧ�½�������ⵥ����һ���������ʼ��ɣ���ⵥ������Ҫʱ�ϸ��µ�ʱ��
--4������������ݵ����潻�׵���ϸ��
--�½����������õ��м��
create table mm_input_temp
(
stockbillid varchar2(20),--��潻�׵�id�������Ǹ��ⷿ�����ݾͽ�֮ǰ�½��Ķ�Ӧ����ⵥid����
materialid varchar2(20), --���ʱ��룬��Ҫ�����ʵ�����ȫͳһ������ǰ����Ƿ����ظ� ***����ԭʼ����***
price      varchar2(20), --���ۣ�һ��Ϊ��˰���ۣ�Ŀǰ�������ú�˰����***����ԭʼ����***
counts     varchar2(20), --���������²ֿ��̿�������***����ԭʼ����***
totalsum   varchar2(20), --�ܽ��***����ԭʼ����***
unit       varchar2(20), --��λ��ʹ��MM_MEASUREUNITGD����и���
batchno    varchar2(20), --���κţ�����һ�����������һ������һ��
planprice  varchar2(20), --�ƻ��ۣ��뵥����ͬ
invoicestatus varchar2(20),  --��Ʊ�������Ϊ1
taxprice      varchar2(20), --��˰���ۣ��뵥����ͬ
taxsum        varchar2(20), --˰���Ϊ0
taxtotalsum   varchar2(20), --˰�ۺϼƣ����ܽ����ͬ
taxpricerate  varchar2(20), --˰�����࣬��Ϊ4��17%
sellprice     varchar2(20), --���ۼ۸��뵥��ͬ
selltotalsum  varchar2(20), --�����ܶ���ܽ����ͬ
realprice     varchar2(20), --ʵ�ʼ۸��뵥��ͬ
realtotalsum  varchar2(20), --ʵ�ʽ����ܽ����ͬ
supplierid    varchar2(20), --��Ӧ��id���˴���Ҫ�������������ܸ������Ǳ�������ƣ�����Ϊid������ֲ��幩Ӧ�̿ɽ���ʹ��ͳһδ֪��Ӧ�̼���
noinvoicecount varchar2(20), --δ����Ʊ���������������д0��һ��Ϊ�������� ***����ԭʼ����***
invoicetype    varchar2(20), --��Ʊ���ͣ������ֵ���invoicetypeѡ��ʵ�ʷ�Ʊ���ͣ��˴�ΪרƱ2
whid             varchar2(20)  --�ֿ���Ϣ����д�ֿ��id�������������ֱ�ʶ��Ϣ ***����ԭʼ����*** ����Ϊ������Ҫ���ղֿ����и���
)
----��������,���ղֿ�ֱ���
select * from mm_input_temp where stockbillid is null for update;
delete from mm_input_temp t where t.price is null;
select s.stockbillid,w.warehouseid,w.warehousename from mm_stockbillgd s,mm_warehousegd w where s.acceptwarehouse=w.warehouseid(+);
update mm_input_temp t set t.stockbillid='55160214133810889334' where t.stockbillid is null;
--���ֿ��ظ�ִ�����ϲ���
update mm_input_temp t set t.materialid=replace(t.materialid,' ','-');--�������ʱ��룬���ʱ����ʽ��һ�������������������һ���ɲ�ִ�д˲���
---ԭʼ���ݵ����ɽ��н�һ�������ݸ���
update mm_input_temp t set t.planprice=t.price,t.taxprice=t.price,t.sellprice=t.price,t.realprice=t.price,--�������е���
                           t.taxtotalsum=t.totalsum,t.selltotalsum=t.totalsum,t.realtotalsum=t.totalsum,--�������н��
                           t.unit=(select m.unit from mm_materialgd m where m.materialid=t.materialid),--���µ�λ
                           t.taxsum=0,--����˰��
                           t.taxpricerate=4,--����˰��
                           t.invoicestatus=1,--���·�Ʊ���
                           t.noinvoicecount=0,--����δ����Ʊ����
                           t.invoicetype=2,--���·�Ʊ����
                          /* t.supplierid=(select p.supplierid from MM_PURCHASINGPRICEGD p 
                           where p.materialid=t.materialid and p.verifystatus=2 and p.startdate<date('2016/2/1') 
                           and p.enddate>date('2016/2/1'))--���¹�Ӧ����Ϣ*/
                           t.supplierid='55151023171700228073'--δ֪��Ӧ��    
---�����ݲ����mm_stockbilldetailgd
insert into mm_stockbilldetailgd sd (sd.stockbilldetailid,sd.stockbillid,sd.materialid,sd.price,sd.count,sd.totalsum,sd.unit,
sd.planprice,sd.invoicestatus,sd.taxprice,sd.taxsum,sd.taxtotalsum,sd.taxpricerate,sd.sellprice,sd.selltotalsum,
sd.realprice,sd.realtotalsum,sd.supplierid,sd.noinvoicecount,sd.invoicetype) 
select pzh_seq.nextval,t.stockbillid,t.materialid,t.price,t.counts,t.totalsum,t.unit,
t.planprice,t.invoicestatus,t.taxprice,t.taxsum,t.taxtotalsum,t.taxpricerate,t.sellprice,t.selltotalsum,
t.realprice,t.realtotalsum,t.supplierid,t.noinvoicecount,t.invoicetype from mm_input_temp t       
------ʹ���α�������κ�
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
/*ע�⣺1���������ϲ������������ⵥ��Ȼ�����½ἴ�ɡ�
		2���ǵ����½�֮ǰ���������ʵ��������ɾ����
		3�����ϵͳ��ʾ���ơ�ʣ���治�㡭������������Ҫ����������Ƿ����Ϊ����������*/

