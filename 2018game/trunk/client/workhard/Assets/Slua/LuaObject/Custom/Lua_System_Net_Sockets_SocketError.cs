using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_System_Net_Sockets_SocketError : LuaObject {
	static public void reg(IntPtr l) {
		getEnumTable(l,"System.Net.Sockets.SocketError");
		addMember(l,0,"Success");
		addMember(l,995,"OperationAborted");
		addMember(l,997,"IOPending");
		addMember(l,10004,"Interrupted");
		addMember(l,10013,"AccessDenied");
		addMember(l,10014,"Fault");
		addMember(l,10022,"InvalidArgument");
		addMember(l,10024,"TooManyOpenSockets");
		addMember(l,10035,"WouldBlock");
		addMember(l,10036,"InProgress");
		addMember(l,10037,"AlreadyInProgress");
		addMember(l,10038,"NotSocket");
		addMember(l,10039,"DestinationAddressRequired");
		addMember(l,10040,"MessageSize");
		addMember(l,10041,"ProtocolType");
		addMember(l,10042,"ProtocolOption");
		addMember(l,10043,"ProtocolNotSupported");
		addMember(l,10044,"SocketNotSupported");
		addMember(l,10045,"OperationNotSupported");
		addMember(l,10046,"ProtocolFamilyNotSupported");
		addMember(l,10047,"AddressFamilyNotSupported");
		addMember(l,10048,"AddressAlreadyInUse");
		addMember(l,10049,"AddressNotAvailable");
		addMember(l,10050,"NetworkDown");
		addMember(l,10051,"NetworkUnreachable");
		addMember(l,10052,"NetworkReset");
		addMember(l,10053,"ConnectionAborted");
		addMember(l,10054,"ConnectionReset");
		addMember(l,10055,"NoBufferSpaceAvailable");
		addMember(l,10056,"IsConnected");
		addMember(l,10057,"NotConnected");
		addMember(l,10058,"Shutdown");
		addMember(l,10060,"TimedOut");
		addMember(l,10061,"ConnectionRefused");
		addMember(l,10064,"HostDown");
		addMember(l,10065,"HostUnreachable");
		addMember(l,10067,"ProcessLimit");
		addMember(l,10091,"SystemNotReady");
		addMember(l,10092,"VersionNotSupported");
		addMember(l,10093,"NotInitialized");
		addMember(l,10101,"Disconnecting");
		addMember(l,10109,"TypeNotFound");
		addMember(l,11001,"HostNotFound");
		addMember(l,11002,"TryAgain");
		addMember(l,11003,"NoRecovery");
		addMember(l,11004,"NoData");
		addMember(l,-1,"SocketError");
		LuaDLL.lua_pop(l, 1);
	}
}
