USE MATRIX
GO

SELECT S.login_name, C.net_transport, C.auth_scheme, s.host_name, s.program_name
FROM sys.dm_exec_connections AS C
JOIN sys.dm_exec_sessions AS S ON C.session_id = S.session_id;