using UnityEngine;
using UnityEngine.Events;
[SLua.CustomLuaClass]
public class ColliderTrigger:MonoBehaviour
{
    private UnityAction<Collider> triggerEnter = null;
    private UnityAction<Collider> triggerStay = null;
    private UnityAction<Collider> triggerExit = null;

   

    public void AddTriggerEnterListener(UnityAction<Collider> pCall)
    {
        triggerEnter = pCall;
    }
    public void AddTriggerStayListener(UnityAction<Collider> pCall)
    {
        triggerStay = pCall;
    }
    public void AddTriggerExitListener(UnityAction<Collider> pCall)
    {
        triggerExit = pCall;
    }

    public void Clear()
    {
        triggerEnter = null;
        triggerStay = null;
        triggerExit = null;
    }

    void OnTriggerEnter(Collider other)
    {
        if(triggerEnter != null)
            triggerEnter.Invoke(other);
    }

    void OnTriggerStay(Collider other)
    {
        if (triggerStay != null)
            triggerStay.Invoke(other);
    }

    void OnTriggerExit(Collider other)
    {
        if (triggerExit != null)
            triggerExit.Invoke(other);
    }
}

