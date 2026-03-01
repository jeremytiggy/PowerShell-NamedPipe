# PowerShell-NamedPipe
Windows PowerShell Library for IPC Named Pipe Client

This PowerShell script functions as an includable library to add functions related to Named Pipe operations. 
At the moment, this is for a "Pull" type pipe, where the client asks the server for data, and then waits for a response before submitting more data.

Includes a helper function Convert-ToAsciiSafe, which removes diacritics and non-printable ASCII.

## Pipe Communications Variables
 - $Global:pipeName (default: 'PipeName') : This will be set to the name of the Pipe named in the Named Pipe Server
## Additional functional global variables
 - $Global:readData = ''
 - $Global:readData_available = $false
 - $Global:writeData = ''
 - $Global:peekBytes = -1

## Functions
 - PeekPipe: Writes current byte count from data read buffer into $Global:peekBytes. Returns a string for Write-Host status.
 - ReadPipe: Loads current read buffer data into $Global:readData, Trims it, and removes 'r and `n characters. Returns a string for Write-Host status.
 - WritePipe: Strips unprintable characters from $Global:writeData and writes to named pipe. Waits 57ms for response (PeekPipe > 0). Returns Write-Host status string.
 - PullPipe: Enhanced version of WritePipe. Performs a ReadPipe after waiting for a response from the named pipe server.
 - OpenPipe: Begins the NamedPipeClient stream for the pipe named in $Global:pipeName. Returns Write-Host status string.
 - WindowsIPCNamedPipeClient_loaded: Performs a simple Write-Host indicating that the library is loaded successfully. Used to validate proper dot-includes.

## Future Planned Changes
 - Add a PipeClose function
 - Make the delay for WritePipe and PullPipe variable based on a global variable

## Known Bugs / Issues
 - OpenPipe doesn't have a try...catch statement behaviour

## Example
 - The example files include a sample Named Pipe Echo-server that pairs with the Client program.
 - Put the library in the same folder as the Client and Server scripts.
 - Execute the Server in a different Powershell window than the client.
 - The Client can open the named pipe, and the server will send back any data sent to it.
