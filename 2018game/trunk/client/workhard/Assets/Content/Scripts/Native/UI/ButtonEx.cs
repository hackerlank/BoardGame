using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;
using UnityEngine.EventSystems;

[SLua.CustomLuaClass]
public enum EDragState
{
    EDS_Begin=0,
    EDS_Draging=1,
    EDS_Ended=2,
    EDS_Max=3,
}

[AddComponentMenu("UI/ButtonEx", 30)]
[SLua.CustomLuaClass]
[RequireComponent(typeof(Transform))]
public class ButtonEx : UIBehaviour, IBeginDragHandler, IEndDragHandler, IDragHandler, IPointerClickHandler, ISubmitHandler, IPointerUpHandler
{

    [SLua.DoNotToLua]
    protected EDragState m_DragState = EDragState.EDS_Max;

    public bool interactable = true;

    public bool dragable = true;

    [SLua.DoNotToLua]
    protected FDragData m_BeginDragData = new FDragData();

    [SLua.DoNotToLua]
    protected FDragData m_DragingData = new FDragData();

    [SLua.DoNotToLua]
    protected FDragData m_EndDragData = new FDragData();


    [SLua.DoNotToLua]
    protected ButtonClickedEvent _onClick = new ButtonClickedEvent();

    //
    // 摘要:
    //     ///
    //     UnityEvent that is triggered when the button is pressed.
    //     ///
    public ButtonClickedEvent onClick { get { return _onClick; } }

    [SLua.DoNotToLua]
    protected DragEvent _onDrag = new DragEvent();
    public DragEvent onDrag { get { return _onDrag; } }

    [SLua.CustomLuaClass]
    public class FDragData
    {
        public EDragState state;
        public PointerEventData eventData;
    }

    [SLua.CustomLuaClass]
    public class DragEvent : UnityEvent<FDragData>
    {
        public DragEvent(){}
     }


    //
    // 摘要:
    //     ///
    //     Registered IPointerClickHandler callback.
    //     ///
    //
    // 参数:
    //   eventData:
    //     Data passed in (Typically by the event system).
    [SLua.DoNotToLua]
    public virtual void OnPointerClick(PointerEventData eventData)
    {
        
    }

    [SLua.DoNotToLua]
    public virtual void OnPointerUp(PointerEventData eventData)
    {
        if(m_DragState != EDragState.EDS_Max)
        {
            m_DragState = EDragState.EDS_Max;
        }
        else
        {
            if(interactable)
            {
                if(onClick != null)
                {
                    onClick.Invoke();
                }
            }
        }
    }

    //
    // 摘要:
    //     ///
    //     Registered ISubmitHandler callback.
    //     ///
    //
    // 参数:
    //   eventData:
    //     Data passed in (Typically by the event system).
    [SLua.DoNotToLua]
    public virtual void OnSubmit(BaseEventData eventData)
    {

    }

    //
    // 摘要:
    //     ///
    //     Function definition for a button click event.
    //     ///
    [SLua.CustomLuaClass]
    public class ButtonClickedEvent : UnityEvent
    {
        public ButtonClickedEvent()
        {

        }
    }
    
    /// <summary>
    /// 
    /// </summary>
    /// <param name="eventData"></param>
    [SLua.DoNotToLua]
    public virtual void OnBeginDrag(PointerEventData eventData)
    {
        if (!dragable)
            return;

        m_DragState = EDragState.EDS_Begin;
        m_BeginDragData.state = m_DragState;
        m_BeginDragData.eventData = eventData;

        if(onDrag != null)
        {
            onDrag.Invoke(m_BeginDragData);
        }
       
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="eventData"></param>
    [SLua.DoNotToLua]
    public virtual void OnEndDrag(PointerEventData eventData)
    {
        if (!dragable)
            return;

        m_DragState = EDragState.EDS_Ended;
        m_EndDragData.state = m_DragState;
        m_EndDragData.eventData = eventData;

        if (onDrag != null)
        {
            onDrag.Invoke(m_EndDragData);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="eventData"></param>
    [SLua.DoNotToLua]
    public virtual void OnDrag(PointerEventData eventData)
    {
        if (!dragable)
            return;

        m_DragState = EDragState.EDS_Draging;
        m_DragingData.state = m_DragState;
        m_DragingData.eventData = eventData;

        if (onDrag != null)
        {
            onDrag.Invoke(m_DragingData);
        }
    }
}
