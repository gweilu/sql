select o.*,
level --��ʾ��μ���
from mcorginfogs o 
start with o.orgid='55160105150509083556' connect by prior o.orgid=o.parentorgid --�ݹ麯���������￪ʼ�ݹ飬�������������ֶζ�Ӧ
 
