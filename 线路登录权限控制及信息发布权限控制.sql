----登录权限控制参数
SELECT T.* FROM CONFIGS T WHERE SECTION = 'JudgeLoginConfict' FOR UPDATE;
----信息发布权限控制参数，适用于G20等重要政治会议
SELECT T.* FROM CONFIGS T WHERE SECTION = 'SendMsgUsePassword' FOR UPDATE;
