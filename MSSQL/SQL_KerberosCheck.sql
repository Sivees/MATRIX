SELECT S.login_name, C.auth_scheme, s.host_name
FROM sys.dm_exec_connections AS C
JOIN sys.dm_exec_sessions AS S ON C.session_id = S.session_id;