import NetIO

procedure chatReceive 
    var message : string := ""
    var sender  : string := ""
    var error   : int    := 0
    
    loop
	NetIO.receiveMessage(message, sender, error)
	put message + " from " + sender
    end loop
end chatReceive

put "This machine ip-Address is ", Net.LocalAddress
chatReceive
