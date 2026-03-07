# PowerShell-NamedPipe
Windows PowerShell Library for IPC Named Pipe Client

This PowerShell script functions as an includable library to add functions related to Named Pipe operations. 
At the moment, this is for a "Pull" type pipe, where the client asks the server for data, and then waits for a response before submitting more data.

Includes a helper function Convert-ToAsciiSafe, which removes diacritics and non-printable ASCII.

## Example Code
1. To run the example, place a version of NamedPipe_Client_v#.#.ps1 into the same directory as the example scripts.
2. Open up two separate PowerShell windows in the directory.
3. Run the EchoServer in one window first, then the Client in the other window, second.
4. Don't forget to use the format 'powershell -ExecutionPolicy Bypass -File ####.ps1' for each one if you have problems starting.

## Pipe Communications Variables
 - $Global:NamedPipe_Server_Name (default: 'PipeName') : This will be set to the name of the Pipe named in the Named Pipe Server
 - $Global:NamedPipe_Server_Process (default: 'Process.exe') : This is the name of the application hosting the Named Pipe Server
 - $Global:NamedPipe_Server_ResponseDelay (default 57ms) : This is how long the Pull command will wait after a Write to Read a response
## Additional functional global variables
 - $Global:NamedPipe_Server_Data : ASCII single-line string data received from Server by Client (typical, optional)
 - $Global:NamedPipe_Server_Data_available : Boolean flag indicating a successful read. Resets manually or automatically at beginning of Read (optional)
 - $Global:NamedPipe_Client_Data : ASCII single-line string data from Client to Server (typical, optional)
 - $Global:NamedPipe_Client_Debug : set to $true to enable debugging text in console

## Functions
 - NamedPipe_Client_PeekAtServer : Returns current byte count from data read buffer (-1 Error, 0 None, >0 Data Available)
 - NamedPipe_Client_ReadFromServer : Returns ASCII single-line string data from Server. Loads current read buffer data, Trims it, and removes 'r and `n characters. 
 - NamedPipe_Client_WriteToServer : Strips unprintable characters from Input Parameter -ClientDataString and writes to named pipe. 
 - NamedPipe_Client_PullServerData : Enhanced version of WritePipe. Performs a ReadPipe after waiting for a response from the named pipe server.
 - NamedPipe_Client_CloseServerConnection : Closes Pipe Connection, disposes of StreamReader and StreamWriter
 - NamedPipe_Client_ConnectToServer : Begins the NamedPipeClient stream for the pipe named in $Global:NamedPipe_Server_Name. Returns boolean status of connection.
 - NamedPipe_Client_Startup : Checks if the Process named in $Global:NamedPipe_Server_Process is running, opens Pipe.
 - NamedPipe_Client_loaded : Performs a simple Write-Host indicating that the library is loaded successfully. Used to validate proper dot-includes.

## Future Planned Changes
 - Verification for PipeClosed

## Known Bugs / Issues
 - Haven't rigorously tested reconnects

## Versioning
 - v1.1 - Changed names, made functions return values

## Example
 - The example files include a sample Named Pipe Echo-server that pairs with the Client program.
 - Put the library in the same folder as the Client and Server scripts.
 - Execute the Server in a different Powershell window than the client.
 - The Client can open the named pipe, and the server will send back any data sent to it.
