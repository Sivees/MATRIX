$listen_port = Read-Host -Prompt 'Nr portu'
$listen_process_ids = (Get-NetTCPConnection -State Listen | Where-Object {$_.LocalPort -eq $listen_port}).OwningProcess
$listen_process_names = (Get-Process | Where-Object {$_.Id -eq $listen_process_ids[0]}).ProcessName
foreach ($proc_name in $listen_process_names) {
    Write-Output ($listen_port + ' - ' + $proc_name)
}