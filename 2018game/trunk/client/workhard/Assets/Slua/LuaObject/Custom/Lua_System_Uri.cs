using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_System_Uri : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			System.Uri o;
			if(argc==2){
				System.String a1;
				checkType(l,2,out a1);
				o=new System.Uri(a1);
				pushValue(l,true);
				pushValue(l,o);
				return 2;
			}
			else if(matchType(l,argc,2,typeof(string),typeof(System.UriKind))){
				System.String a1;
				checkType(l,2,out a1);
				System.UriKind a2;
				checkEnum(l,3,out a2);
				o=new System.Uri(a1,a2);
				pushValue(l,true);
				pushValue(l,o);
				return 2;
			}
			else if(matchType(l,argc,2,typeof(System.Uri),typeof(System.Uri))){
				System.Uri a1;
				checkType(l,2,out a1);
				System.Uri a2;
				checkType(l,3,out a2);
				o=new System.Uri(a1,a2);
				pushValue(l,true);
				pushValue(l,o);
				return 2;
			}
			else if(matchType(l,argc,2,typeof(System.Uri),typeof(string))){
				System.Uri a1;
				checkType(l,2,out a1);
				System.String a2;
				checkType(l,3,out a2);
				o=new System.Uri(a1,a2);
				pushValue(l,true);
				pushValue(l,o);
				return 2;
			}
			return error(l,"New object failed.");
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int GetLeftPart(IntPtr l) {
		try {
			System.Uri self=(System.Uri)checkSelf(l);
			System.UriPartial a1;
			checkEnum(l,2,out a1);
			var ret=self.GetLeftPart(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int MakeRelativeUri(IntPtr l) {
		try {
			System.Uri self=(System.Uri)checkSelf(l);
			System.Uri a1;
			checkType(l,2,out a1);
			var ret=self.MakeRelativeUri(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int GetComponents(IntPtr l) {
		try {
			System.Uri self=(System.Uri)checkSelf(l);
			System.UriComponents a1;
			checkEnum(l,2,out a1);
			System.UriFormat a2;
			checkEnum(l,3,out a2);
			var ret=self.GetComponents(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int IsBaseOf(IntPtr l) {
		try {
			System.Uri self=(System.Uri)checkSelf(l);
			System.Uri a1;
			checkType(l,2,out a1);
			var ret=self.IsBaseOf(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int IsWellFormedOriginalString(IntPtr l) {
		try {
			System.Uri self=(System.Uri)checkSelf(l);
			var ret=self.IsWellFormedOriginalString();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int CheckHostName_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=System.Uri.CheckHostName(a1);
			pushValue(l,true);
			pushEnum(l,(int)ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int CheckSchemeName_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=System.Uri.CheckSchemeName(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int FromHex_s(IntPtr l) {
		try {
			System.Char a1;
			checkType(l,1,out a1);
			var ret=System.Uri.FromHex(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int HexEscape_s(IntPtr l) {
		try {
			System.Char a1;
			checkType(l,1,out a1);
			var ret=System.Uri.HexEscape(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int HexUnescape_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.Int32 a2;
			checkType(l,2,out a2);
			var ret=System.Uri.HexUnescape(a1,ref a2);
			pushValue(l,true);
			pushValue(l,ret);
			pushValue(l,a2);
			return 3;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int IsHexDigit_s(IntPtr l) {
		try {
			System.Char a1;
			checkType(l,1,out a1);
			var ret=System.Uri.IsHexDigit(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int IsHexEncoding_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.Int32 a2;
			checkType(l,2,out a2);
			var ret=System.Uri.IsHexEncoding(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int Compare_s(IntPtr l) {
		try {
			System.Uri a1;
			checkType(l,1,out a1);
			System.Uri a2;
			checkType(l,2,out a2);
			System.UriComponents a3;
			checkEnum(l,3,out a3);
			System.UriFormat a4;
			checkEnum(l,4,out a4);
			System.StringComparison a5;
			checkEnum(l,5,out a5);
			var ret=System.Uri.Compare(a1,a2,a3,a4,a5);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int EscapeDataString_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=System.Uri.EscapeDataString(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int EscapeUriString_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=System.Uri.EscapeUriString(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int IsWellFormedUriString_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.UriKind a2;
			checkEnum(l,2,out a2);
			var ret=System.Uri.IsWellFormedUriString(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int TryCreate_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(matchType(l,argc,1,typeof(System.Uri),typeof(System.Uri),typeof(LuaOut))){
				System.Uri a1;
				checkType(l,1,out a1);
				System.Uri a2;
				checkType(l,2,out a2);
				System.Uri a3;
				var ret=System.Uri.TryCreate(a1,a2,out a3);
				pushValue(l,true);
				pushValue(l,ret);
				pushValue(l,a3);
				return 3;
			}
			else if(matchType(l,argc,1,typeof(System.Uri),typeof(string),typeof(LuaOut))){
				System.Uri a1;
				checkType(l,1,out a1);
				System.String a2;
				checkType(l,2,out a2);
				System.Uri a3;
				var ret=System.Uri.TryCreate(a1,a2,out a3);
				pushValue(l,true);
				pushValue(l,ret);
				pushValue(l,a3);
				return 3;
			}
			else if(matchType(l,argc,1,typeof(string),typeof(System.UriKind),typeof(LuaOut))){
				System.String a1;
				checkType(l,1,out a1);
				System.UriKind a2;
				checkEnum(l,2,out a2);
				System.Uri a3;
				var ret=System.Uri.TryCreate(a1,a2,out a3);
				pushValue(l,true);
				pushValue(l,ret);
				pushValue(l,a3);
				return 3;
			}
			pushValue(l,false);
			LuaDLL.lua_pushstring(l,"No matched override function TryCreate to call");
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int UnescapeDataString_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=System.Uri.UnescapeDataString(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int op_Equality(IntPtr l) {
		try {
			System.Uri a1;
			checkType(l,1,out a1);
			System.Uri a2;
			checkType(l,2,out a2);
			var ret=(a1==a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int op_Inequality(IntPtr l) {
		try {
			System.Uri a1;
			checkType(l,1,out a1);
			System.Uri a2;
			checkType(l,2,out a2);
			var ret=(a1!=a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_SchemeDelimiter(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,System.Uri.SchemeDelimiter);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_UriSchemeFile(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,System.Uri.UriSchemeFile);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_UriSchemeFtp(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,System.Uri.UriSchemeFtp);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_UriSchemeGopher(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,System.Uri.UriSchemeGopher);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_UriSchemeHttp(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,System.Uri.UriSchemeHttp);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_UriSchemeHttps(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,System.Uri.UriSchemeHttps);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_UriSchemeMailto(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,System.Uri.UriSchemeMailto);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_UriSchemeNews(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,System.Uri.UriSchemeNews);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_UriSchemeNntp(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,System.Uri.UriSchemeNntp);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_UriSchemeNetPipe(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,System.Uri.UriSchemeNetPipe);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_UriSchemeNetTcp(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,System.Uri.UriSchemeNetTcp);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_AbsolutePath(IntPtr l) {
		try {
			System.Uri self=(System.Uri)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.AbsolutePath);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_AbsoluteUri(IntPtr l) {
		try {
			System.Uri self=(System.Uri)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.AbsoluteUri);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_Authority(IntPtr l) {
		try {
			System.Uri self=(System.Uri)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.Authority);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_Fragment(IntPtr l) {
		try {
			System.Uri self=(System.Uri)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.Fragment);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_Host(IntPtr l) {
		try {
			System.Uri self=(System.Uri)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.Host);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_HostNameType(IntPtr l) {
		try {
			System.Uri self=(System.Uri)checkSelf(l);
			pushValue(l,true);
			pushEnum(l,(int)self.HostNameType);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_IsDefaultPort(IntPtr l) {
		try {
			System.Uri self=(System.Uri)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.IsDefaultPort);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_IsFile(IntPtr l) {
		try {
			System.Uri self=(System.Uri)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.IsFile);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_IsLoopback(IntPtr l) {
		try {
			System.Uri self=(System.Uri)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.IsLoopback);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_IsUnc(IntPtr l) {
		try {
			System.Uri self=(System.Uri)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.IsUnc);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_LocalPath(IntPtr l) {
		try {
			System.Uri self=(System.Uri)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.LocalPath);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_PathAndQuery(IntPtr l) {
		try {
			System.Uri self=(System.Uri)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.PathAndQuery);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_Port(IntPtr l) {
		try {
			System.Uri self=(System.Uri)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.Port);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_Query(IntPtr l) {
		try {
			System.Uri self=(System.Uri)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.Query);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_Scheme(IntPtr l) {
		try {
			System.Uri self=(System.Uri)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.Scheme);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_Segments(IntPtr l) {
		try {
			System.Uri self=(System.Uri)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.Segments);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_UserEscaped(IntPtr l) {
		try {
			System.Uri self=(System.Uri)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.UserEscaped);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_UserInfo(IntPtr l) {
		try {
			System.Uri self=(System.Uri)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.UserInfo);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_DnsSafeHost(IntPtr l) {
		try {
			System.Uri self=(System.Uri)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.DnsSafeHost);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_IsAbsoluteUri(IntPtr l) {
		try {
			System.Uri self=(System.Uri)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.IsAbsoluteUri);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_OriginalString(IntPtr l) {
		try {
			System.Uri self=(System.Uri)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.OriginalString);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"Uri");
		addMember(l,GetLeftPart);
		addMember(l,MakeRelativeUri);
		addMember(l,GetComponents);
		addMember(l,IsBaseOf);
		addMember(l,IsWellFormedOriginalString);
		addMember(l,CheckHostName_s);
		addMember(l,CheckSchemeName_s);
		addMember(l,FromHex_s);
		addMember(l,HexEscape_s);
		addMember(l,HexUnescape_s);
		addMember(l,IsHexDigit_s);
		addMember(l,IsHexEncoding_s);
		addMember(l,Compare_s);
		addMember(l,EscapeDataString_s);
		addMember(l,EscapeUriString_s);
		addMember(l,IsWellFormedUriString_s);
		addMember(l,TryCreate_s);
		addMember(l,UnescapeDataString_s);
		addMember(l,op_Equality);
		addMember(l,op_Inequality);
		addMember(l,"SchemeDelimiter",get_SchemeDelimiter,null,false);
		addMember(l,"UriSchemeFile",get_UriSchemeFile,null,false);
		addMember(l,"UriSchemeFtp",get_UriSchemeFtp,null,false);
		addMember(l,"UriSchemeGopher",get_UriSchemeGopher,null,false);
		addMember(l,"UriSchemeHttp",get_UriSchemeHttp,null,false);
		addMember(l,"UriSchemeHttps",get_UriSchemeHttps,null,false);
		addMember(l,"UriSchemeMailto",get_UriSchemeMailto,null,false);
		addMember(l,"UriSchemeNews",get_UriSchemeNews,null,false);
		addMember(l,"UriSchemeNntp",get_UriSchemeNntp,null,false);
		addMember(l,"UriSchemeNetPipe",get_UriSchemeNetPipe,null,false);
		addMember(l,"UriSchemeNetTcp",get_UriSchemeNetTcp,null,false);
		addMember(l,"AbsolutePath",get_AbsolutePath,null,true);
		addMember(l,"AbsoluteUri",get_AbsoluteUri,null,true);
		addMember(l,"Authority",get_Authority,null,true);
		addMember(l,"Fragment",get_Fragment,null,true);
		addMember(l,"Host",get_Host,null,true);
		addMember(l,"HostNameType",get_HostNameType,null,true);
		addMember(l,"IsDefaultPort",get_IsDefaultPort,null,true);
		addMember(l,"IsFile",get_IsFile,null,true);
		addMember(l,"IsLoopback",get_IsLoopback,null,true);
		addMember(l,"IsUnc",get_IsUnc,null,true);
		addMember(l,"LocalPath",get_LocalPath,null,true);
		addMember(l,"PathAndQuery",get_PathAndQuery,null,true);
		addMember(l,"Port",get_Port,null,true);
		addMember(l,"Query",get_Query,null,true);
		addMember(l,"Scheme",get_Scheme,null,true);
		addMember(l,"Segments",get_Segments,null,true);
		addMember(l,"UserEscaped",get_UserEscaped,null,true);
		addMember(l,"UserInfo",get_UserInfo,null,true);
		addMember(l,"DnsSafeHost",get_DnsSafeHost,null,true);
		addMember(l,"IsAbsoluteUri",get_IsAbsoluteUri,null,true);
		addMember(l,"OriginalString",get_OriginalString,null,true);
		createTypeMetatable(l,constructor, typeof(System.Uri));
	}
}
