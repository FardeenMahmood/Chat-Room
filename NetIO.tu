unit
module NetIO

export sendMessage,
       receiveMessage 

const NET_CONNECTION_REQUEST_TIMEOUT : int := 5000 
const NET_RECEIVE_TIMEOUT : int := 5000
const NETWORK_OK : int := 0
const NETWORK_FAIL : int := -1
const NETWORK_PORT : int := 5000

function myIPAddress : string  
    result Net.LocalAddress 
end myIPAddress

function openConnectionWithTimeout(receiverIPAddress : string,
				    port : int) : int
    var netStream  : int := 0
    var beforeLoop : int := Time.Elapsed
    
    loop 
	exit when netStream > 0 or 
		(Time.Elapsed - beforeLoop) > NET_CONNECTION_REQUEST_TIMEOUT
	netStream := Net.OpenConnection(receiverIPAddress, port)   
    end loop
    
    result netStream
end openConnectionWithTimeout

procedure sendMessage(message : string, receiverIPAddress : string,
			var errorCode : int)
    errorCode := NETWORK_OK
    var netStream : int := openConnectionWithTimeout(receiverIPAddress,
							NETWORK_PORT)
    if netStream > 0 then
	put : netStream, message
	Net.CloseConnection(netStream)
    else
	errorCode := NETWORK_FAIL
    end if
end sendMessage                                          

procedure receiveMessage(var message : string, var senderAddress : string,
			    var errorCode : int)
    var netStream  := Net.WaitForConnection(NETWORK_PORT, senderAddress)
    
    if netStream > 0 then 
	var beforeLoop := Time.Elapsed
	loop 
	    exit when Net.LineAvailable(netStream) or
			(Time.Elapsed - beforeLoop) > NET_RECEIVE_TIMEOUT
	end loop
	
	if Net.LineAvailable(netStream) then 
	    get : netStream, message : *
	else 
	    errorCode := NETWORK_FAIL
	end if
	Net.CloseConnection(netStream)
    else
	errorCode := NETWORK_FAIL
    end if
end receiveMessage   

end NetIO                         

