using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_SlotScrollRect : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int StopMovement(IntPtr l) {
		try {
			SlotScrollRect self=(SlotScrollRect)checkSelf(l);
			self.StopMovement();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int SetSelectedTrans(IntPtr l) {
		try {
			SlotScrollRect self=(SlotScrollRect)checkSelf(l);
			UnityEngine.Transform a1;
			checkType(l,2,out a1);
			self.SetSelectedTrans(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int SetVelocity(IntPtr l) {
		try {
			SlotScrollRect self=(SlotScrollRect)checkSelf(l);
			System.Single a1;
			checkType(l,2,out a1);
			System.Single a2;
			checkType(l,3,out a2);
			self.SetVelocity(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int StartScroll(IntPtr l) {
		try {
			SlotScrollRect self=(SlotScrollRect)checkSelf(l);
			self.StartScroll();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int SetListInfos(IntPtr l) {
		try {
			SlotScrollRect self=(SlotScrollRect)checkSelf(l);
			System.Collections.Generic.List<SLua.LuaTable> a1;
			checkType(l,2,out a1);
			self.SetListInfos(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int SetColumn(IntPtr l) {
		try {
			SlotScrollRect self=(SlotScrollRect)checkSelf(l);
			System.Int32 a1;
			checkType(l,2,out a1);
			self.SetColumn(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int ResetShowItems(IntPtr l) {
		try {
			SlotScrollRect self=(SlotScrollRect)checkSelf(l);
			System.Collections.Generic.List<System.Int32> a1;
			checkType(l,2,out a1);
			System.Single a2;
			checkType(l,3,out a2);
			self.ResetShowItems(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int LayoutComplete(IntPtr l) {
		try {
			SlotScrollRect self=(SlotScrollRect)checkSelf(l);
			self.LayoutComplete();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int GraphicUpdateComplete(IntPtr l) {
		try {
			SlotScrollRect self=(SlotScrollRect)checkSelf(l);
			self.GraphicUpdateComplete();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int OnClose(IntPtr l) {
		try {
			SlotScrollRect self=(SlotScrollRect)checkSelf(l);
			self.OnClose();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_jumpNum(IntPtr l) {
		try {
			SlotScrollRect self=(SlotScrollRect)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.jumpNum);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_jumpNum(IntPtr l) {
		try {
			SlotScrollRect self=(SlotScrollRect)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.jumpNum=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_jumpPower(IntPtr l) {
		try {
			SlotScrollRect self=(SlotScrollRect)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.jumpPower);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_jumpPower(IntPtr l) {
		try {
			SlotScrollRect self=(SlotScrollRect)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.jumpPower=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_jumpElapsedTime(IntPtr l) {
		try {
			SlotScrollRect self=(SlotScrollRect)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.jumpElapsedTime);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_jumpElapsedTime(IntPtr l) {
		try {
			SlotScrollRect self=(SlotScrollRect)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.jumpElapsedTime=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_onStopScroll(IntPtr l) {
		try {
			SlotScrollRect self=(SlotScrollRect)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onStopScroll);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_onStopScroll(IntPtr l) {
		try {
			SlotScrollRect self=(SlotScrollRect)checkSelf(l);
			SlotScrollRect.FFocusedItem v;
			checkType(l,2,out v);
			self.onStopScroll=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_onResetShowItemCompleted(IntPtr l) {
		try {
			SlotScrollRect self=(SlotScrollRect)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onResetShowItemCompleted);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_onResetShowItemCompleted(IntPtr l) {
		try {
			SlotScrollRect self=(SlotScrollRect)checkSelf(l);
			SlotScrollRect.FResetShowItem v;
			checkType(l,2,out v);
			self.onResetShowItemCompleted=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_visibleItems(IntPtr l) {
		try {
			SlotScrollRect self=(SlotScrollRect)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.visibleItems);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_SetMinColumnOrRaw(IntPtr l) {
		try {
			SlotScrollRect self=(SlotScrollRect)checkSelf(l);
			int v;
			checkType(l,2,out v);
			self.SetMinColumnOrRaw=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_curFocusedTrans(IntPtr l) {
		try {
			SlotScrollRect self=(SlotScrollRect)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.curFocusedTrans);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_content(IntPtr l) {
		try {
			SlotScrollRect self=(SlotScrollRect)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.content);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_content(IntPtr l) {
		try {
			SlotScrollRect self=(SlotScrollRect)checkSelf(l);
			UnityEngine.RectTransform v;
			checkType(l,2,out v);
			self.content=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_onValueChanged(IntPtr l) {
		try {
			SlotScrollRect self=(SlotScrollRect)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onValueChanged);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_onValueChanged(IntPtr l) {
		try {
			SlotScrollRect self=(SlotScrollRect)checkSelf(l);
			SlotScrollRect.ScrollRectEvent v;
			checkType(l,2,out v);
			self.onValueChanged=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_normalizedPosition(IntPtr l) {
		try {
			SlotScrollRect self=(SlotScrollRect)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.normalizedPosition);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_normalizedPosition(IntPtr l) {
		try {
			SlotScrollRect self=(SlotScrollRect)checkSelf(l);
			UnityEngine.Vector2 v;
			checkType(l,2,out v);
			self.normalizedPosition=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"SlotScrollRect");
		addMember(l,StopMovement);
		addMember(l,SetSelectedTrans);
		addMember(l,SetVelocity);
		addMember(l,StartScroll);
		addMember(l,SetListInfos);
		addMember(l,SetColumn);
		addMember(l,ResetShowItems);
		addMember(l,LayoutComplete);
		addMember(l,GraphicUpdateComplete);
		addMember(l,OnClose);
		addMember(l,"jumpNum",get_jumpNum,set_jumpNum,true);
		addMember(l,"jumpPower",get_jumpPower,set_jumpPower,true);
		addMember(l,"jumpElapsedTime",get_jumpElapsedTime,set_jumpElapsedTime,true);
		addMember(l,"onStopScroll",get_onStopScroll,set_onStopScroll,true);
		addMember(l,"onResetShowItemCompleted",get_onResetShowItemCompleted,set_onResetShowItemCompleted,true);
		addMember(l,"visibleItems",get_visibleItems,null,true);
		addMember(l,"SetMinColumnOrRaw",null,set_SetMinColumnOrRaw,true);
		addMember(l,"curFocusedTrans",get_curFocusedTrans,null,true);
		addMember(l,"content",get_content,set_content,true);
		addMember(l,"onValueChanged",get_onValueChanged,set_onValueChanged,true);
		addMember(l,"normalizedPosition",get_normalizedPosition,set_normalizedPosition,true);
		createTypeMetatable(l,null, typeof(SlotScrollRect),typeof(UnityEngine.EventSystems.UIBehaviour));
	}
}
