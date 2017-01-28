declare
varid varchar(20);
c varchar(20);
cursor mycur is select sd.stockbilldetailid from mm_stockbilldetailgd sd;
begin 
  c:='201512300001';
  open mycur;
  loop
    fetch mycur into varid;
    exit when mycur%notfound;
    update mm_stockbilldetailgd sd1 set sd1.batchno=c where sd1.stockbilldetailid=varid;
    c:=c+1;
    end loop;
    close mycur;
    end;
