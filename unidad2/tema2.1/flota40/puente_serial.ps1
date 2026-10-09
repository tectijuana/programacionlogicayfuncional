# Puente serial para Windows: COMx <-> stdin/stdout (lo lanza semi_serial.erl).
#   stdout = lineas que manda el micro:bit
#   stdin  = lineas que manda Erlang hacia el micro:bit
# Prueba manual:  powershell -NoProfile -ExecutionPolicy Bypass -File .\puente_serial.ps1 COM3
param([Parameter(Mandatory = $true)][string]$Puerto)

$sp = New-Object System.IO.Ports.SerialPort $Puerto, 115200
$sp.NewLine = "`n"
$sp.ReadTimeout = 100
try { $sp.Open() }
catch {
    [Console]::Error.WriteLine("No se pudo abrir $Puerto")
    Start-Sleep -Seconds 2          # evita agotar los reinicios del supervisor
    exit 1
}

$entrada = [Console]::In.ReadLineAsync()
try {
    while ($sp.IsOpen) {
        if ($sp.BytesToRead -gt 0) {
            try { [Console]::Out.WriteLine($sp.ReadLine()) } catch [TimeoutException] { }
        } else {
            Start-Sleep -Milliseconds 20
        }
        if ($entrada.IsCompleted) {
            if ($null -eq $entrada.Result) { break }     # Erlang cerro el port
            $sp.WriteLine($entrada.Result)
            $entrada = [Console]::In.ReadLineAsync()
        }
    }
}
finally { if ($sp.IsOpen) { $sp.Close() } }
