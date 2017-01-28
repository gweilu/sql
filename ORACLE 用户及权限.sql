select * from dba_users u where u.username like '%%';  --查询用户
select * from dba_role_privs;  --查询用户有哪些权限
select * from dba_sys_privs;  --查询系统角色
select * from role_sys_privs;
select * from dba_tab_privs t where t.grantee='GUEST1'  --查询用户有的权限
