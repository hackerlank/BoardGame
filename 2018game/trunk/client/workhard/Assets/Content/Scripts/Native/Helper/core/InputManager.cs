using UnityEngine;
using UnityEngine.Events;
using SLua;
using UnityEngine.EventSystems;

/// <summary>
/// Input manager class
/// </summary>
[CustomLuaClass]
public class InputManager : MonoBehaviour
{
    [DoNotToLua]
    private static InputManager _GInstance = null;
    public static InputManager GInstance { get { return _GInstance; } }

    [DoNotToLua]
    public TouchEvent _onTouchBegan = new TouchEvent();

    /// <summary>
    /// touch began event
    /// </summary>
    public TouchEvent onTouchBegan { get { return _onTouchBegan; } }

    [DoNotToLua]
    public TouchEvent _onTouchMoved = new TouchEvent();

    /// <summary>
    /// touch moved event
    /// </summary>
    public TouchEvent onTouchMoved { get { return _onTouchMoved; } }

    [DoNotToLua]
    public TouchEvent _onTouchEnded = new TouchEvent();

    /// <summary>
    /// touch ended event
    /// </summary>
    public TouchEvent onTouchEnded { get { return _onTouchEnded; } }

    [DoNotToLua]
    private TouchEvent _onTouchCancel = new TouchEvent();

    /// <summary>
    /// touch canceled event
    /// </summary>
    public TouchEvent onTouchCancel { get { return _onTouchCancel; } }


    void Awake()
    {
        if(_GInstance == null)
        {
            _GInstance = transform.GetComponent<InputManager>();
        }

        DontDestroyOnLoad(this.gameObject);
    }

	
	// Update is called once per frame
	void Update ()
    {
        //if touched game object. do not send events to lua
        if (EventSystem.current != null && EventSystem.current.IsPointerOverGameObject())
        {
            return;
        }
        Vector3 pos = new Vector3(0.0f, 0.0f, 0.0f);
#if UNITY_EDITOR
        
        if (Input.GetMouseButtonDown(0))
        {
            pos = Input.mousePosition;
            if(_onTouchBegan != null)
            {
                _onTouchBegan.Invoke(pos);
            }
        }
        else if (Input.GetMouseButton(0))
        {
            pos = Input.mousePosition;
            if (_onTouchMoved != null)
            {
                _onTouchMoved.Invoke(pos);
            }
        }
        else if (Input.GetMouseButtonUp(0))
        {
            pos = Input.mousePosition;
            if (_onTouchEnded != null)
            {
                _onTouchEnded.Invoke(pos);
            }
        }
#else
        if(Input.touchCount == 1)
		{
			if(Input.GetTouch(0).phase == TouchPhase.Began)
			{
				pos = Input.GetTouch(0).position;
                if(_onTouchBegan != null)
                {
                    _onTouchBegan.Invoke(pos);
                }
			}
			else if(Input.GetTouch(0).phase == TouchPhase.Moved)
			{
                pos = Input.GetTouch(0).position;
                if(_onTouchMoved != null)
                {
                    _onTouchMoved.Invoke(pos);
                }
			}
			else if(Input.GetTouch(0).phase == TouchPhase.Ended)
			{
				pos = Input.GetTouch(0).position;
                if(_onTouchEnded != null)
                {
                    _onTouchEnded.Invoke(pos);
                }
			}
			else if(Input.GetTouch(0).phase == TouchPhase.Canceled)
			{
                pos = Input.GetTouch(0).position;
                if(_onTouchCancel != null)
                {
                    _onTouchCancel.Invoke(pos);
                }
			}
		}
#endif
    }

    /// <summary>
    /// clear all listeners, and release self
    /// </summary>
    public void ClearAll()
    {
        if (_GInstance)
        {
            if (_onTouchCancel != null)
            {
                _onTouchCancel.RemoveAllListeners();
            }

            if (_onTouchBegan != null)
            {
                _onTouchBegan.RemoveAllListeners();
            }

            if (_onTouchEnded != null)
            {
                _onTouchEnded.RemoveAllListeners();
            }

            if (_onTouchMoved != null)
            {
                _onTouchMoved.RemoveAllListeners();
            }
        }

        _GInstance = null;
    }

    [CustomLuaClass]
    public class TouchEvent : UnityEvent<Vector3> { public TouchEvent() { } }
}
