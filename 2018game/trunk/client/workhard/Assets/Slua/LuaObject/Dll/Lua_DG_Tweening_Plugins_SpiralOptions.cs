using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_DG_Tweening_Plugins_SpiralOptions : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			DG.Tweening.Plugins.SpiralOptions o;
			o=new DG.Tweening.Plugins.SpiralOptions();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_depth(IntPtr l) {
		try {
			DG.Tweening.Plugins.SpiralOptions self;
			checkValueType(l,1,out self);
			pushValue(l,true);
			pushValue(l,self.depth);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_depth(IntPtr l) {
		try {
			DG.Tweening.Plugins.SpiralOptions self;
			checkValueType(l,1,out self);
			System.Single v;
			checkType(l,2,out v);
			self.depth=v;
			setBack(l,self);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_frequency(IntPtr l) {
		try {
			DG.Tweening.Plugins.SpiralOptions self;
			checkValueType(l,1,out self);
			pushValue(l,true);
			pushValue(l,self.frequency);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_frequency(IntPtr l) {
		try {
			DG.Tweening.Plugins.SpiralOptions self;
			checkValueType(l,1,out self);
			System.Single v;
			checkType(l,2,out v);
			self.frequency=v;
			setBack(l,self);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_speed(IntPtr l) {
		try {
			DG.Tweening.Plugins.SpiralOptions self;
			checkValueType(l,1,out self);
			pushValue(l,true);
			pushValue(l,self.speed);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_speed(IntPtr l) {
		try {
			DG.Tweening.Plugins.SpiralOptions self;
			checkValueType(l,1,out self);
			System.Single v;
			checkType(l,2,out v);
			self.speed=v;
			setBack(l,self);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_mode(IntPtr l) {
		try {
			DG.Tweening.Plugins.SpiralOptions self;
			checkValueType(l,1,out self);
			pushValue(l,true);
			pushEnum(l,(int)self.mode);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_mode(IntPtr l) {
		try {
			DG.Tweening.Plugins.SpiralOptions self;
			checkValueType(l,1,out self);
			DG.Tweening.SpiralMode v;
			checkEnum(l,2,out v);
			self.mode=v;
			setBack(l,self);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_snapping(IntPtr l) {
		try {
			DG.Tweening.Plugins.SpiralOptions self;
			checkValueType(l,1,out self);
			pushValue(l,true);
			pushValue(l,self.snapping);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_snapping(IntPtr l) {
		try {
			DG.Tweening.Plugins.SpiralOptions self;
			checkValueType(l,1,out self);
			System.Boolean v;
			checkType(l,2,out v);
			self.snapping=v;
			setBack(l,self);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"DG.Tweening.Plugins.SpiralOptions");
		addMember(l,"depth",get_depth,set_depth,true);
		addMember(l,"frequency",get_frequency,set_frequency,true);
		addMember(l,"speed",get_speed,set_speed,true);
		addMember(l,"mode",get_mode,set_mode,true);
		addMember(l,"snapping",get_snapping,set_snapping,true);
		createTypeMetatable(l,constructor, typeof(DG.Tweening.Plugins.SpiralOptions),typeof(System.ValueType));
	}
}
