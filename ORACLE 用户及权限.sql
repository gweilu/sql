select * from dba_users u where u.username like '%%';  --��ѯ�û�
select * from dba_role_privs;  --��ѯ�û�����ЩȨ��
select * from dba_sys_privs;  --��ѯϵͳ��ɫ
select * from role_sys_privs;
select * from dba_tab_privs t where t.grantee='GUEST1'  --��ѯ�û��е�Ȩ��
