using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[SLua.CustomLuaClass]
public class EmojiImage : Image {

    private bool m_bIsSttic = true;

    private List<string> _tags = new List<string>();

    private string emoji_path = "";

    public void UpdateEmoji(bool bStatic, string path, List<object> tags)
    {
        m_bIsSttic = bStatic;
        emoji_path = path;
        _tags.Clear();

        if(tags == null)
        {
            return;
        }
        foreach(var obj in tags)
        {
            _tags.Add(obj.ToString());
        }

        if(m_bIsSttic)
        {
          //  sprite = 
        }
    }
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
