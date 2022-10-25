$wsl_ip = (wsl hostname -I).trim()
Write-Host "WSL Machine IP: ""$wsl_ip"""
netsh interface portproxy add v4tov4 listenport=22 connectport=22 connectaddress=$wsl_ip
netsh interface portproxy add v4tov4 listenport=80 connectport=80 connectaddress=$wsl_ip
netsh interface portproxy add v4tov4 listenport=3000 connectport=3000 connectaddress=$wsl_ip
netsh interface portproxy add v4tov4 listenport=9001 connectport=3000 connectaddress=$wsl_ip
