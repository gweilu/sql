select o.*,
level --显示层次级别
from mcorginfogs o 
start with o.orgid='55160105150509083556' connect by prior o.orgid=o.parentorgid --递归函数，从哪里开始递归，上下由那两个字段对应
 
