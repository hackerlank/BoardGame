using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using System.IO;

[SLua.CustomLuaClass]
public class ScreenShot : MonoBehaviour {
	private static ScreenShot _inst = null;
	void Awake()
	{
		_inst = this;
	}

	public static ScreenShot Instance{get{return _inst;}}

	public void TakeShot(string sz_path, System.Action<Texture2D> onComplete, int mode) 
	{
		if(sz_path == null || sz_path == "") 
		{
			if (onComplete != null) onComplete.Invoke(null);
			return ;
		}
		if(File.Exists(sz_path) == true )
		{
			File.Delete(sz_path);
		}
		StartCoroutine(TakeShotAsync(sz_path, onComplete, mode));
	}
	
	private IEnumerator TakeShotAsync(string sz_path, System.Action<Texture2D> onComplete, int mode)
	 {
		yield return new WaitForEndOfFrame();
		
		Texture2D tex = new Texture2D(Screen.width, Screen.height, TextureFormat.RGB24, false);
		tex.ReadPixels(new Rect(0, 0, Screen.width, Screen.height), 0, 0, true);
		tex.Apply();

		if (mode == 1) 
		{
			Texture2D inv = new Texture2D(Screen.height, Screen.width, TextureFormat.RGB24, false);
			for (int i = 0; i < tex.height; ++i) 
			{
				for (int j = 0; j < tex.width; ++j) 
					inv.SetPixel(i, inv.height - j - 1, tex.GetPixel(j, i)); 
			}
			inv.Apply();
			File.WriteAllBytes(sz_path, inv.EncodeToPNG());
			DestroyImmediate(inv);
		}
		else 
		{
			File.WriteAllBytes(sz_path, tex.EncodeToPNG());
		}
		
		if (onComplete != null) onComplete.Invoke(tex);
	}
}
