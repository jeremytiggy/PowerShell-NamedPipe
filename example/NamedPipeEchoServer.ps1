# =====================================================================
# Windows IPC Named Pipe Echo Server
# Pipe Name: GZD
# =====================================================================

Write-Host "[GZD Server] Starting Named Pipe Server..." -ForegroundColor Cyan

$pipeName = "GZD"

while ($true) {

    try {
        Write-Host "[GZD Server] Waiting for client connection..." -ForegroundColor Yellow

        # Create pipe instance (byte mode works fine with ASCII client)
        $pipe = New-Object System.IO.Pipes.NamedPipeServerStream(
            $pipeName,
            [System.IO.Pipes.PipeDirection]::InOut,
            1,
            [System.IO.Pipes.PipeTransmissionMode]::Byte,
            [System.IO.Pipes.PipeOptions]::None
        )

        $pipe.WaitForConnection()

        Write-Host "[GZD Server] Client connected!" -ForegroundColor Green

        $reader = New-Object System.IO.StreamReader($pipe, [System.Text.Encoding]::ASCII)
        $writer = New-Object System.IO.StreamWriter($pipe, [System.Text.Encoding]::ASCII)
        $writer.AutoFlush = $true

        while ($pipe.IsConnected) {

            # ReadLine blocks until newline (your client uses WriteLine)
            $incoming = $reader.ReadLine()

            if ($incoming -ne $null) {

                $cleanIncoming = $incoming.Trim()

                Write-Host "[GZD Server] Received: $cleanIncoming" -ForegroundColor White

                # Echo back exactly what was received
                $writer.WriteLine($cleanIncoming)

                Write-Host "[GZD Server] Echoed back: $cleanIncoming" -ForegroundColor DarkGray
            }
            else {
                break
            }
        }

        Write-Host "[GZD Server] Client disconnected." -ForegroundColor Yellow

        $reader.Close()
        $writer.Close()
        $pipe.Dispose()
    }
    catch {
        Write-Host "[GZD Server ERROR]: $_" -ForegroundColor Red
    }

    Start-Sleep -Milliseconds 100
}