update  /*a.knowledgeitemid,a.knowledgeitemname,a.parentitemid,*/
 bm_maintainknowledgeitemgd a set a.itemkind=1 
where a.itemkind=0 and length(a.parentitemid)<3 
and a.knowledgeitemid in
(select distinct parentitemid from bm_maintainknowledgeitemgd
where itemkind=0 and length(parentitemid)>2)
