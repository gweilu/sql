---��sysdbִ��
----��ѯ�ĸ������� ��ס id
SELECT b.owner,b.object_name,a.SESSION_ID,a.LOCKED_MODE FROM v$locked_object a,dba_objects b WHERE b.object_id=a.OBJECT_ID;
---�鿴���Ǹ�session����� �ҵ��������鵽id������
SELECT b.USERNAME,b.SID,b.SERIAL#,logon_time FROM v$locked_object a,v$session b WHERE a.SESSION_ID=b.SID ORDER BY b.LOGON_TIME;
---ɱ����Ӧ����
ALTER SYSTEM KILL SESSION '1114,37275';
--����1114Ϊsid��37275Ϊserial
