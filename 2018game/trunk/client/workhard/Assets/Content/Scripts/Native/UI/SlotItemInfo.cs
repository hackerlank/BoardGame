using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using UnityEngine.Events;

public class SlotItemInfo : MonoBehaviour
{

    private object _info = null;

    public object info
    {
        get
        {
            return _info;
        }

        set
        {
            _info = value;
            if(m_onValueChanged != null)
            {
                m_onValueChanged.Invoke(_info);
            }
        }
    }

    [SLua.CustomLuaClass]
    public class FOnValueChanged : UnityEvent<object> { public FOnValueChanged() { } }

    [SerializeField]
    [SLua.DoNotToLua]
    private FOnValueChanged m_onValueChanged = new FOnValueChanged();

    public FOnValueChanged onValueChanged { get { return m_onValueChanged; } set { m_onValueChanged = value; } }
}
