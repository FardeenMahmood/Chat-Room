import NetIO 

procedure chatSend
    var errorCode : int := 0
    var message   : string := ""
    var address   : string := ""
    
    loop
	put "Message: "..
	get message : * 
	
	put "Address: "..
	get address
	
	NetIO.sendMessage(message, address, errorCode)
    end loop
end chatSend

put "This machine ip-Address is ", Net.LocalAddress
chatSend


