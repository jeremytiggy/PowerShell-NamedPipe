# Include library for pipe communication functions and variables
. WindowsIPCNamedPipeClient.ps1
WindowsIPCNamedPipeClient_loaded

# Pipe Client Startup -------------------------------
$Global:pipeName = 'PipeName'
function NamedPipeClientStartup {
    Write-Host "[Named Pipe Client Startup]: Pipe: $Global:pipeName" -ForegroundColor Cyan
    Write-Host "[Named Pipe Client Startup]: Connected: $Global:PipeConnected" -ForegroundColor Cyan
    $ProcessName = "ProcessNameHere"
    if (Get-Process -Name $ProcessName -ErrorAction SilentlyContinue)
    {
        Write-Host "[Named Pipe Client Startup]: $ProcessName is running" -ForegroundColor Green
        if ($Global:PipeConnected -ne $true) {
            Write-Host "[Named Pipe Client Startup]: Would you like to open the pipe, or work offline?"
        }
    }
    else
    {
        Write-Host "[Named Pipe Client Startup]: $ProcessName is not running" -ForegroundColor Red
        if ($Global:PipeConnected -ne $true) {
            Write-Host "[Named Pipe Client Startup]: Would you like to attempt to open the pipe, or work offline?"
        }
        
    }
    if ($Global:PipeConnected -ne $true) {
        Write-Host -NoNewLine "[Enter Command (open|offline|exit)]: "
        $cmd = Read-Host
        if ($cmd -eq '') { exit 1 }
        if ($cmd -ne '') {
	        if ($cmd -eq 'exit') { exit 1 }
	        elseif ($cmd -eq 'open') { 
                # Open Pipe Connection
                try {
                    OpenPipe
                    $Global:PipeConnected = $true
                } catch {
                    Write-Host "[Named Pipe Client Startup]: ERROR. Failed to connect to pipe: $($_.Exception.Message)" -ForegroundColor Red
                    exit 1
                }        
            }
            elseif ($cmd -eq 'offline') { 
                Write-Host "[Named Pipe Client Startup]: Continuing in offline mode. No Named Pipe Communications initiated." -ForegroundColor Yellow
            }
	        else { 
                Write-Host '[Named Pipe Client Startup]: Exiting...' 
                exit 1
            }
        }
    }

}
# Pipe Client Startup ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Write-Host "`n[Startup]: Starting communications..." -ForegroundColor Green
$Global:PipeConnected = $false
$Global:pipeName = 'PipeName'
NamedPipeClientStartup
# Communication Status After Startups
if ($Global:PipeConnected) {
    Write-Host "[Startup]: Named Pipe Client connected to Server." -ForegroundColor Green
} else {
    Write-Host "[Startup]: Named Pipe Client not connected to Server." -ForegroundColor Yellow
}
Write-Host "`n[Startup]: Starting main loop..." -ForegroundColor Green
try {
    while ($true) {
		$userCommandPromptString = "[Main Loop]: Enter Command (exit|"
		if ($Global:PipeConnected -ne $true) {
			Write-Host "[Main Loop]: The Pipe connection isn't made, but you can 'open' it at any time." -ForegroundColor Yellow
			$userCommandPromptString += "open)> "
			
		} else {
			Write-Host "[Main Loop]: Since the Pipe is Open, you can initiate a PULL from the named pipe server." -ForegroundColor Green
			$userCommandPromptString += "peek|read|pull|close)> "
		}
		Write-Host -NoNewline $userCommandPromptString
		$cmd = Read-Host
		if ($cmd -ne '') {
			if ($cmd -eq 'exit') { exit 1 }
			elseif ($cmd -eq 'open') { NamedPipeClientStartup }
			elseif ($cmd -eq 'peek') { PeekPipe }
			elseif ($cmd -eq 'read') { ReadPipe }
			elseif ($cmd -eq 'pull') {
				Write-Host -NoNewLine "[Pipe Pull WriteData]: Enter string to send to named pipe server> "
				$Global:writeData = Read-Host
				PullPipe
			}
			elseif ($cmd -eq 'close') { 
				if ($writer -ne $null) { 
					try { $Global:writer.Dispose() } 
					catch { } 
				}
				if ($pipe -ne $null) { 
					try { $Global:pipe.Dispose() } 
					catch { }
				}
				$Global:PipeConnected = $false				
			}
			
		}
	}
}
catch {
	Write-Host "SERVER ERROR: $($_.Exception.Message)" -ForegroundColor Red
} finally {
    # Terminate Pipe
    if ($writer -ne $null) { 
        try { $Global:writer.Dispose() } catch { }
    }
    if ($pipe -ne $null) { 
        try { $Global:pipe.Dispose() } catch { }
    }
    Write-Host "[Shutdown]: Pipe Disconnected"
}

			
