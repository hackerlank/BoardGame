using UnityEngine;
using System.Collections.Generic;
using System.Collections;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using UnityEngine.Events;
using System;
using DG.Tweening;



[SLua.CustomLuaClass]
[RequireComponent(typeof(RectTransform))]
public class SlotScrollRect : UIBehaviour, IInitializePotentialDragHandler, IScrollHandler, ICanvasElement, ISelectHandler
{


    [System.Serializable]
    [SLua.CustomLuaClass]
    public class FFocusedItem : UnityEvent<Transform> { public FFocusedItem() { } }

    [SerializeField]
    [SLua.DoNotToLua]
    private FFocusedItem m_onStopScroll = new FFocusedItem();
    public FFocusedItem onStopScroll { get { return m_onStopScroll; } set { m_onStopScroll = value; } }

    [System.Serializable]
    [SLua.CustomLuaClass]
    public class FResetShowItem : UnityEvent<bool> { public FResetShowItem() { } }
    [SerializeField]
    private FResetShowItem m_onResetShowItem = new FResetShowItem();
    public FResetShowItem onResetShowItemCompleted { get { return m_onResetShowItem; } set { m_onResetShowItem = value; } }         

    public enum EScrollState
    {
        ESS_Scroll=0,
        ESS_Decelerate=1,
        ESS_Ended =2,
        ESS_EndedAnim=3,
        ESS_MAX=4,
    }
    #region custom

    //[SerializeField]
    [SLua.DoNotToLua]
    [SerializeField]
    private int triggerHideEventLimit = 1;

    /// <summary>
    /// reset show item jump amount
    /// </summary>
    public int jumpNum = 1;

    /// <summary>
    /// reset show items jump power
    /// </summary>
    public float jumpPower = 8.0f;

    /// <summary>
    /// the jump action last time
    /// </summary>
    public float jumpElapsedTime = 0.1f;

    [SLua.DoNotToLua]
    private GridLayoutGroup layout = null;

    [SLua.DoNotToLua]
    private bool bRunLateUpdated = false;

    [SLua.DoNotToLua]
    protected List<object> _listItems = new List<object>();

    [SLua.DoNotToLua]
    public GridLayoutGroup getLayOut { get { return layout; } }

    [SLua.DoNotToLua]
    private float cellInternal = 0.0f;

    [SLua.DoNotToLua]
    private EScrollState _scrollState = EScrollState.ESS_MAX;

    [SLua.DoNotToLua]
    private bool bIsDealing = false;

    [SLua.DoNotToLua]
    private bool bMoveToEnd = true;

    //scroll end speed limit
    [SLua.DoNotToLua]
    [SerializeField]
    private float m_fEndSpeed = 100;

    //scroll end offest, help us make ending animation
    [SLua.DoNotToLua]
    private float m_fScrollEndOffest = 30.0f;

    //ending animation speed.
    [SLua.DoNotToLua]
    private float m_fEndingAnimSpeed = 6.0f;

    [SLua.DoNotToLua]
    private List<Transform> _disabledTrans = new List<Transform>();

    [SLua.DoNotToLua]
    private List<Transform> _visibleItems = new List<Transform>();
    public List<Transform>  visibleItems
    {
        get
        {
            return _visibleItems;
        }
    }

    [SLua.DoNotToLua]
    private Transform _seletedTrans = null;

    [SLua.DoNotToLua]
    protected bool isMoveToEnd { get { return bMoveToEnd; } }

    [SLua.DoNotToLua]
    protected int cachedStart = 0;

    [SerializeField]
    [Tooltip("How many column or raw need to be rendered at least")]
    protected int minColumnOrRaw = 0;
    public int SetMinColumnOrRaw { set { minColumnOrRaw = value; } }

    [SerializeField]
    [SLua.DoNotToLua]
    protected GameObject listItemPrefab = null;

    [SLua.DoNotToLua]
    protected int listLen;


    [SLua.DoNotToLua]
    private Dictionary<Transform, int> siblingIndex = new Dictionary<Transform, int>();

    [SLua.DoNotToLua]
    private Dictionary<int, Vector3> _defaultLocalPosition = new Dictionary<int, Vector3>();
      
    [SLua.DoNotToLua]
    private Transform _curFocuesdTrans = null;
    public Transform curFocusedTrans
    {
        get
        {
            return _curFocuesdTrans;
        }
    }
    #endregion


    [SLua.DoNotToLua]
    public enum MovementType
    {
        Unrestricted, // Unrestricted movement -- can scroll forever
        Elastic, // Restricted but flexible -- can go past the edges, but springs back in place
        Clamped, // Restricted movement where it's not possible to go past the edges
    }

    [System.Serializable]
    [SLua.DoNotToLua]
    public class ScrollRectEvent : UnityEvent<Vector2> { }

    [SerializeField]
    [SLua.DoNotToLua]
    private RectTransform m_Content;
    public RectTransform content { get { return m_Content; } set { m_Content = value; } }

    [SerializeField]
    [SLua.DoNotToLua]
    private bool m_Horizontal = true;
    [SLua.DoNotToLua]
    public bool horizontal { get { return m_Horizontal; } set { m_Horizontal = value; } }

    [SerializeField]
    [SLua.DoNotToLua]
    private bool m_Vertical = true;
    [SLua.DoNotToLua]
    public bool vertical { get { return m_Vertical; } set { m_Vertical = value; } }

    [SerializeField]
    [SLua.DoNotToLua]
    private MovementType m_MovementType = MovementType.Elastic;
    [SLua.DoNotToLua]
    public MovementType movementType { get { return m_MovementType; } set { m_MovementType = value; } }

    [SerializeField]
    [SLua.DoNotToLua]
    private float m_Elasticity = 0.1f; // Only used for MovementType.Elastic
    [SLua.DoNotToLua]
    public float elasticity { get { return m_Elasticity; } set { m_Elasticity = value; } }

    [SerializeField]
    [SLua.DoNotToLua]
    private bool m_Inertia = true;
    [SLua.DoNotToLua]
    public bool inertia { get { return m_Inertia; } set { m_Inertia = value; } }

    [SerializeField]
    [SLua.DoNotToLua]
    private float m_DecelerationRate = 0.135f; // Only used when inertia is enabled
    [SLua.DoNotToLua]
    public float decelerationRate { get { return m_DecelerationRate; } set { m_DecelerationRate = value; } }

    [SerializeField]
    [SLua.DoNotToLua]
    private float m_ScrollSensitivity = 1.0f;
    [SLua.DoNotToLua]
    public float scrollSensitivity { get { return m_ScrollSensitivity; } set { m_ScrollSensitivity = value; } }


    [SerializeField]
    [SLua.DoNotToLua]
    private Scrollbar m_HorizontalScrollbar;
    [SLua.DoNotToLua]
    public Scrollbar horizontalScrollbar
    {
        get
        {
            return m_HorizontalScrollbar;
        }
        set
        {
            if (m_HorizontalScrollbar)
                m_HorizontalScrollbar.onValueChanged.RemoveListener(SetHorizontalNormalizedPosition);
            m_HorizontalScrollbar = value;
            if (m_HorizontalScrollbar)
                m_HorizontalScrollbar.onValueChanged.AddListener(SetHorizontalNormalizedPosition);
        }
    }

    [SerializeField]
    [SLua.DoNotToLua]
    private Scrollbar m_VerticalScrollbar;
    [SLua.DoNotToLua]
    public Scrollbar verticalScrollbar
    {
        get
        {
            return m_VerticalScrollbar;
        }
        set
        {
            if (m_VerticalScrollbar)
                m_VerticalScrollbar.onValueChanged.RemoveListener(SetVerticalNormalizedPosition);
            m_VerticalScrollbar = value;
            if (m_VerticalScrollbar)
                m_VerticalScrollbar.onValueChanged.AddListener(SetVerticalNormalizedPosition);
        }
    }

    [SerializeField]
    private ScrollRectEvent m_OnValueChanged = new ScrollRectEvent();
    public ScrollRectEvent onValueChanged { get { return m_OnValueChanged; } set { m_OnValueChanged = value; } }


    [SLua.DoNotToLua]
    private RectTransform m_ViewRect;

    [SLua.DoNotToLua]
    protected RectTransform viewRect
    {
        get
        {
            if (m_ViewRect == null)
                m_ViewRect = (RectTransform)transform;
            return m_ViewRect;
        }
    }

    [SLua.DoNotToLua]
    private Bounds m_ContentBounds;
    [SLua.DoNotToLua]
    private Bounds m_ViewBounds;

    [SLua.DoNotToLua]
    private Vector2 m_Velocity;
    [SLua.DoNotToLua]
    public Vector2 velocity
    {
        get
        {
            return m_Velocity;
        }
        protected set
        {
            m_Velocity = value;
        }
    }

    [SLua.DoNotToLua]
    private Vector2 m_PrevPosition = Vector2.zero;
    [SLua.DoNotToLua]
    private Bounds m_PrevContentBounds;
    [SLua.DoNotToLua]
    private Bounds m_PrevViewBounds;
    [System.NonSerialized]
    [SLua.DoNotToLua]
    private bool m_HasRebuiltLayout = false;


    [SLua.DoNotToLua]
    private float cachedDefaultLocation = 0.0f;

    [SLua.DoNotToLua]
    protected SlotScrollRect()
    { }

    [SLua.DoNotToLua]
    protected override void Start()
    {
        base.Start();

        _disabledTrans.Clear();

    }

    [SLua.DoNotToLua]
    public virtual void Rebuild(CanvasUpdate executing)
    {
        if (executing != CanvasUpdate.PostLayout)
            return;

        UpdateBounds();
        UpdateScrollbars(Vector2.zero);
        UpdatePrevData();
        m_HasRebuiltLayout = true;
    }

    [SLua.DoNotToLua]
    protected override void OnEnable()
    {
        base.OnEnable();
        if (m_Content == null)
        {
            throw new Exception("please pointed to the content panel");
        }

        if (layout == null)
            layout = m_Content.GetComponentInParent<GridLayoutGroup>();

        if (layout.constraint == GridLayoutGroup.Constraint.Flexible)
        {
            throw new Exception("currently can not support flexible with dynamic list");
        }

        if (m_HorizontalScrollbar)
            m_HorizontalScrollbar.onValueChanged.AddListener(SetHorizontalNormalizedPosition);
        if (m_VerticalScrollbar)
            m_VerticalScrollbar.onValueChanged.AddListener(SetVerticalNormalizedPosition);

        CanvasUpdateRegistry.RegisterCanvasElementForLayoutRebuild(this);

    }

    [SLua.DoNotToLua]
    protected override void OnDestroy()
    {

    }

    [SLua.DoNotToLua]
    protected override void OnDisable()
    {
        CanvasUpdateRegistry.UnRegisterCanvasElementForRebuild(this);

        if (m_HorizontalScrollbar)
            m_HorizontalScrollbar.onValueChanged.RemoveListener(SetHorizontalNormalizedPosition);
        if (m_VerticalScrollbar)
            m_VerticalScrollbar.onValueChanged.RemoveListener(SetVerticalNormalizedPosition);

        m_HasRebuiltLayout = false;
        bRunLateUpdated = false;
        base.OnDisable();
    }

    [SLua.DoNotToLua]
    public override bool IsActive()
    {
        return base.IsActive() && m_Content != null;
    }

    [SLua.DoNotToLua]
    private void EnsureLayoutHasRebuilt()
    {
        if (!m_HasRebuiltLayout && !CanvasUpdateRegistry.IsRebuildingLayout())
            Canvas.ForceUpdateCanvases();
    }

    public virtual void StopMovement()
    {
        m_Velocity = Vector2.zero;
        //m_Content.anchoredPosition = startAnchorPos;

        ////if (horizontal)
        ////{
        ////    m_Content.anchoredPosition = new Vector2(cachedDefaultLocation, m_Content.anchoredPosition.y);
        ////}
        ////else
        ////{
        ////    m_Content.anchoredPosition = new Vector2(m_Content.anchoredPosition.x, cachedDefaultLocation);
        ////}

        //bDecelerate = false;
    }

    public void SetSelectedTrans(Transform trans)
    {
        if (trans == null)
            return;
        _seletedTrans = trans;
        _scrollState = EScrollState.ESS_Decelerate;
    }

    [SLua.DoNotToLua]
    private float CalculateMoveDistance()
    {
        float totalDis = 0.0f;

        if (_seletedTrans != null)
        {
            float diffPos = Mathf.Abs(m_Content.anchoredPosition.y);

            int movedCount = (int)(diffPos / cellInternal);

            for (int idx = 0; idx < movedCount; ++idx)
            {
                m_Content.GetChild(0).SetAsLastSibling();
            }
            m_Content.anchoredPosition = new Vector2(0, m_Content.anchoredPosition.y - movedCount * cellInternal);

            SlotGridLayout tmplayout = layout as SlotGridLayout;
            if (tmplayout)
            {
                tmplayout.ForceLayout();
            }
            UpdateBounds();

            int sidx = _seletedTrans.GetSiblingIndex();


            if (sidx == 0 )
            {
                totalDis = m_Content.childCount * cellInternal - m_Content.anchoredPosition.y;
                totalDis += layout.spacing.y *  1;
            }
            else
            {
                totalDis = sidx * cellInternal - m_Content.anchoredPosition.y + layout.spacing.y;
            }

            //Debug.Log(transform.name + " TotoalDis=" + totalDis + " sidx=" + sidx + "m_Content.anchoredPosition.y=" + m_Content.anchoredPosition.y + " value=" + _seletedTrans.Find("Text").GetComponent<Text>().text);

        }
        else
        {
            Debug.LogError("selected is null");
        }

        return totalDis;
    }

    [SLua.DoNotToLua]
    public virtual void OnScroll(PointerEventData data)
    {
        if (!IsActive())
            return;


        EnsureLayoutHasRebuilt();
        UpdateBounds();

        Vector2 delta = data.scrollDelta;
        // Down is positive for scroll events, while in UI system up is positive.
        delta.y *= -1;
        if (vertical && !horizontal)
        {
            if (Mathf.Abs(delta.x) > Mathf.Abs(delta.y))
                delta.y = delta.x;
            delta.x = 0;
        }
        if (horizontal && !vertical)
        {
            if (Mathf.Abs(delta.y) > Mathf.Abs(delta.x))
                delta.x = delta.y;
            delta.y = 0;
        }

        //  transform.set
        Vector2 position = m_Content.anchoredPosition;
        position += delta * m_ScrollSensitivity;
        if (m_MovementType == MovementType.Clamped)
            position += CalculateOffset(position - m_Content.anchoredPosition);

        Debug.Log("onscroll " + delta.ToString());
        SetContentAnchoredPosition(position);

    }

    [SLua.DoNotToLua]
    public virtual void OnInitializePotentialDrag(PointerEventData eventData)
    {
        m_Velocity = Vector2.zero;
    }


    [SLua.DoNotToLua]
    protected virtual void SetContentAnchoredPosition(Vector2 position)
    {
        if (!m_Horizontal)
            position.x = m_Content.anchoredPosition.x;
        if (!m_Vertical)
            position.y = m_Content.anchoredPosition.y;

        if (position != m_Content.anchoredPosition)
        {


            bMoveToEnd = true;

            if (horizontal && (m_Content.anchoredPosition.x <= position.x))
            {
                bMoveToEnd = false;
            }
            else if (vertical && (m_Content.anchoredPosition.y > position.y))
            {
                bMoveToEnd = false;
            }

            if (IsDealHiddenItem())
                CheckHiddenItems();
            else
            {
                m_Content.anchoredPosition = position;
            }

            UpdateBounds();
        }
    }

    /// <summary>
    /// whether we can deal events
    /// </summary>
    /// <returns>return true if we can</returns>
    [SLua.DoNotToLua]
    private bool IsDealHiddenItem()
    {

        if (layout == null)
            layout = m_Content.GetComponent<GridLayoutGroup>();

        bool bHidden = false;

        float cacheDiff = triggerHideEventLimit * cellInternal;

        if (bMoveToEnd)
        {
            if (horizontal)
            {
                bHidden = Mathf.Abs(m_Content.anchoredPosition.x) >= cacheDiff + cachedDefaultLocation;
            }
            else if (vertical)
            {
                bHidden = m_Content.anchoredPosition.y >= cacheDiff + cachedDefaultLocation;
            }
        }
        else
        {
            if (horizontal)
            {
                bHidden = m_Content.anchoredPosition.x >= cachedDefaultLocation;
            }
            else if (vertical)
            {
                bHidden = m_Content.anchoredPosition.y <= cachedDefaultLocation;
            }
        }

        if (isNotUpdateValue)
        {
            bHidden = false;
        }

        bool bResult = bHidden && !bIsDealing;
        return bResult;
    }

    /// <summary>
    /// whether we can reset item detail information
    /// </summary>
    [SLua.DoNotToLua]
    protected bool isNotUpdateValue
    {
        get
        {
            bool bResult = false;// (currentStartLine + column_max == scrollColumnCount && bMoveToEnd) || (currentStartLine == 0 && bMoveToEnd == false);

            return bResult;
        }
    }

    /// <summary>
    /// adjust the rendering sort of items, also we need manually update anchor position of content game objects
    /// </summary>
    [SLua.DoNotToLua]
    private void CheckHiddenItems()
    {
        if (isNotUpdateValue)
        {
            return;
        }

        bIsDealing = true;

        int childs = m_Content.childCount;
        Vector2 pos = m_Content.anchoredPosition;

        int idx = 0;
        int movedLine = 0;
        if (bMoveToEnd)
        {
            //calculate the begin idx       
            for (int i = 0; i < triggerHideEventLimit; ++i)
            {
                for (idx = 0; idx < layout.constraintCount; ++idx)
                {
                    m_Content.GetChild(0).SetAsLastSibling();
                }
                movedLine++;       
            }

            if (horizontal)
            {
                pos.x += cellInternal * movedLine;
            }
            else
            {
                pos.y -= cellInternal * movedLine;
            }

        }
        else
        {
            for (int i = 0; i < triggerHideEventLimit; ++i)
            {
             
                    for (idx = layout.constraintCount - 1; idx >= 0; --idx)
                    {
                        Transform trans = m_Content.GetChild(childs - 1);
                        trans.SetAsFirstSibling();
                    }
                    movedLine++;
                
            }
            if (horizontal)
            {
                pos.x -= cellInternal * movedLine;
            }
            else if (vertical)
            {
                pos.y += cellInternal * movedLine;
            }
        }
        m_PrevPosition = pos;
        m_Content.anchoredPosition = pos;

        SlotGridLayout tmpLayout = layout as SlotGridLayout;
        if (tmpLayout != null)
        {
            tmpLayout.ForceLayout();
        }
        bIsDealing = false;
    }

    

    public void SetVelocity(float x, float y)
    {
        m_Velocity = new Vector2(x, y);
    }

    public void StartScroll()
    {
       
        _scrollState = EScrollState.ESS_Scroll;
        bRunLateUpdated = true;
        //resort child sibling
        foreach (var obj in siblingIndex)
        {
            obj.Key.SetSiblingIndex(obj.Value);
        }
    }

    [SLua.DoNotToLua]
    protected virtual void LateUpdate()
    {
        if (!m_Content || !bRunLateUpdated)
            return;


        EnsureLayoutHasRebuilt();
        UpdateBounds();
        float deltaTime = Time.smoothDeltaTime;
        Vector2 offset = CalculateOffset(Vector2.zero);

       
        if ((offset != Vector2.zero || m_Velocity != Vector2.zero) && ( _scrollState == EScrollState.ESS_Scroll || _scrollState == EScrollState.ESS_Decelerate))
        {
            Vector2 position = m_Content.anchoredPosition;
            for (int axis = 0; axis < 2; axis++)
            {
                // Apply spring physics if movement is elastic and content has an offset from the view.
                if (m_MovementType == MovementType.Elastic && offset[axis] != 0)
                {
                    float speed = m_Velocity[axis];
                    position[axis] = Mathf.SmoothDamp(m_Content.anchoredPosition[axis], m_Content.anchoredPosition[axis] + offset[axis], ref speed, m_Elasticity, Mathf.Infinity, deltaTime);
                    if (_scrollState == EScrollState.ESS_Decelerate)
                        m_Velocity[axis] = speed;
                }
                // Else move content according to velocity with deceleration applied.
                else if (m_Inertia)
                {
                    if (_scrollState == EScrollState.ESS_Decelerate)
                    {
                        m_Velocity[axis] *= Mathf.Pow(m_DecelerationRate, deltaTime);
                        if (Mathf.Abs(m_Velocity[axis]) < 1)
                            m_Velocity[axis] = 0;
                    }
                    position[axis] += m_Velocity[axis] * deltaTime;
                }
                // If we have neither elaticity or friction, there shouldn't be any velocity.
                else
                {
                    if (_scrollState == EScrollState.ESS_Decelerate)
                        m_Velocity[axis] = 0;
                }
            }

            if (m_Velocity != Vector2.zero)
            {
                if (m_MovementType == MovementType.Clamped)
                {
                    offset = CalculateOffset(position - m_Content.anchoredPosition);
                    position += offset;
                }
                SetContentAnchoredPosition(position);
            }
        }

        //scroll ending animation
        if (_scrollState == EScrollState.ESS_EndedAnim && m_Content.anchoredPosition.y > 0)
        {
            float rest = m_Content.anchoredPosition.y - m_fEndingAnimSpeed;
            if (rest <= 0)
            {
                rest = 0;
                _scrollState = EScrollState.ESS_MAX;
                if (m_onStopScroll != null)
                {
                    bRunLateUpdated = false;
                    m_onStopScroll.Invoke(_curFocuesdTrans);
                }
            }
            Vector2 position = new Vector2(0, rest);
            SetContentAnchoredPosition(position);          
        }

        //scroll ending
        if (_scrollState == EScrollState.ESS_Ended)
        {
            PostScroll();
            _scrollState = EScrollState.ESS_EndedAnim;
        }

        //decelerating
        if (_scrollState == EScrollState.ESS_Decelerate && m_Velocity.y <= m_fEndSpeed)
        {
            _scrollState = EScrollState.ESS_Ended;
           float totalDis = CalculateMoveDistance();

            Vector2 position = m_Content.anchoredPosition;
            position.y += totalDis;
            _scrollState = EScrollState.ESS_Ended;
            m_Velocity = new Vector2(0, 0);
            SetContentAnchoredPosition(position);
        }


        if (m_ViewBounds != m_PrevViewBounds || m_ContentBounds != m_PrevContentBounds || m_Content.anchoredPosition != m_PrevPosition)
        {
           // UpdateScrollbars(offset);
            m_OnValueChanged.Invoke(normalizedPosition);
            UpdatePrevData();
        }
    }

    [SLua.DoNotToLua]
    private void PostScroll()
    {
        _curFocuesdTrans = _seletedTrans;

        float diffPos = Mathf.Abs(m_Content.anchoredPosition.y);

        int movedCount = (int)(diffPos / cellInternal);

        for(int idx=0; idx < movedCount; ++idx)
        {
            m_Content.GetChild(0).SetAsLastSibling();
        }

        _visibleItems.Clear();
        for(int i=0; i< minColumnOrRaw; ++i)
        {
            _visibleItems.Add(m_Content.GetChild(i));
        }

        m_Content.anchoredPosition = new Vector2(0, m_fScrollEndOffest);
    }

    [SLua.DoNotToLua]
    private void UpdatePrevData()
    {
        if (m_Content == null)
            m_PrevPosition = Vector2.zero;
        else
            m_PrevPosition = m_Content.anchoredPosition;
        m_PrevViewBounds = m_ViewBounds;
        m_PrevContentBounds = m_ContentBounds;
    }

    [SLua.DoNotToLua]
    private void UpdateScrollbars(Vector2 offset)
    {
        if (m_HorizontalScrollbar)
        {
            if (m_ContentBounds.size.x > 0)
                m_HorizontalScrollbar.size = Mathf.Clamp01((m_ViewBounds.size.x - Mathf.Abs(offset.x)) / m_ContentBounds.size.x);
            else
                m_HorizontalScrollbar.size = 1;

            m_HorizontalScrollbar.value = horizontalNormalizedPosition;
        }

        if (m_VerticalScrollbar)
        {
            if (m_ContentBounds.size.y > 0)
                m_VerticalScrollbar.size = Mathf.Clamp01((m_ViewBounds.size.y - Mathf.Abs(offset.y)) / m_ContentBounds.size.y);
            else
                m_VerticalScrollbar.size = 1;

            m_VerticalScrollbar.value = verticalNormalizedPosition;
        }
    }


    public Vector2 normalizedPosition
    {
        get
        {
            return new Vector2(horizontalNormalizedPosition, verticalNormalizedPosition);
        }
        set
        {
            SetNormalizedPosition(value.x, 0);
            SetNormalizedPosition(value.y, 1);
        }
    }

    [SLua.DoNotToLua]
    public float horizontalNormalizedPosition
    {
        get
        {
            UpdateBounds();
            if (m_ContentBounds.size.x <= m_ViewBounds.size.x)
                return (m_ViewBounds.min.x > m_ContentBounds.min.x) ? 1 : 0;
            return (m_ViewBounds.min.x - m_ContentBounds.min.x) / (m_ContentBounds.size.x - m_ViewBounds.size.x);
        }
        set
        {
            SetNormalizedPosition(value, 0);
        }
    }

    [SLua.DoNotToLua]
    public float verticalNormalizedPosition
    {
        get
        {
            UpdateBounds();
            if (m_ContentBounds.size.y <= m_ViewBounds.size.y)
                return (m_ViewBounds.min.y > m_ContentBounds.min.y) ? 1 : 0;

            return (m_ViewBounds.min.y - m_ContentBounds.min.y) / (m_ContentBounds.size.y - m_ViewBounds.size.y);
        }
        set
        {
            SetNormalizedPosition(value, 1);
        }
    }

    [SLua.DoNotToLua]
    private void SetHorizontalNormalizedPosition(float value) { SetNormalizedPosition(value, 0); }
    [SLua.DoNotToLua]
    private void SetVerticalNormalizedPosition(float value) { SetNormalizedPosition(value, 1); }

    [SLua.DoNotToLua]
    private void SetNormalizedPosition(float value, int axis)
    {
        EnsureLayoutHasRebuilt();
        UpdateBounds();
        // How much the content is larger than the view.
        float hiddenLength = m_ContentBounds.size[axis] - m_ViewBounds.size[axis];
        // Where the position of the lower left corner of the content bounds should be, in the space of the view.
        float contentBoundsMinPosition = m_ViewBounds.min[axis] - value * hiddenLength;
        // The new content localPosition, in the space of the view.
        float newLocalPosition = m_Content.localPosition[axis] + contentBoundsMinPosition - m_ContentBounds.min[axis];

        Vector3 localPosition = m_Content.localPosition;
        if (Mathf.Abs(localPosition[axis] - newLocalPosition) > 0.01f)
        {
            localPosition[axis] = newLocalPosition;
            m_Content.localPosition = localPosition;
            m_Velocity[axis] = 0;
            UpdateBounds();
        }
    }

    [SLua.DoNotToLua]
    private static float RubberDelta(float overStretching, float viewSize)
    {
        return (1 - (1 / ((Mathf.Abs(overStretching) * 0.55f / viewSize) + 1))) * viewSize * Mathf.Sign(overStretching);
    }

    [SLua.DoNotToLua]
    private void UpdateBounds()
    {
        m_ViewBounds = new Bounds(viewRect.rect.center, viewRect.rect.size);
        m_ContentBounds = GetBounds();

        if (m_Content == null)
            return;

        // Make sure content bounds are at least as large as view by adding padding if not.
        // One might think at first that if the content is smaller than the view, scrolling should be allowed.
        // However, that's not how scroll views normally work.
        // Scrolling is *only* possible when content is *larger* than view.
        // We use the pivot of the content rect to decide in which directions the content bounds should be expanded.
        // E.g. if pivot is at top, bounds are expanded downwards.
        // This also works nicely when ContentSizeFitter is used on the content.
        Vector3 contentSize = m_ContentBounds.size;
        Vector3 contentPos = m_ContentBounds.center;
        Vector3 excess = m_ViewBounds.size - contentSize;
        if (excess.x > 0)
        {
            contentPos.x -= excess.x * (m_Content.pivot.x - 0.5f);
            contentSize.x = m_ViewBounds.size.x;
        }
        if (excess.y > 0)
        {
            contentPos.y -= excess.y * (m_Content.pivot.y - 0.5f);
            contentSize.y = m_ViewBounds.size.y;
        }

        m_ContentBounds.size = contentSize;
        m_ContentBounds.center = contentPos;
    }

    [SLua.DoNotToLua]
    private readonly Vector3[] m_Corners = new Vector3[4];
    [SLua.DoNotToLua]
    private Bounds GetBounds()
    {
        if (m_Content == null)
            return new Bounds();

        var vMin = new Vector3(float.MaxValue, float.MaxValue, float.MaxValue);
        var vMax = new Vector3(float.MinValue, float.MinValue, float.MinValue);

        var toLocal = viewRect.worldToLocalMatrix;
        m_Content.GetWorldCorners(m_Corners);
        for (int j = 0; j < 4; j++)
        {
            Vector3 v = toLocal.MultiplyPoint3x4(m_Corners[j]);
            vMin = Vector3.Min(v, vMin);
            vMax = Vector3.Max(v, vMax);
        }

        var bounds = new Bounds(vMin, Vector3.zero);
        bounds.Encapsulate(vMax);
        return bounds;
    }

    [SLua.DoNotToLua]
    private Vector2 CalculateOffset(Vector2 delta)
    {
        Vector2 offset = Vector2.zero;
        if (m_MovementType == MovementType.Unrestricted)
            return offset;

        Vector2 min = m_ContentBounds.min;
        Vector2 max = m_ContentBounds.max;

        if (m_Horizontal)
        {
            min.x += delta.x;
            max.x += delta.x;
            if (min.x > m_ViewBounds.min.x)
                offset.x = m_ViewBounds.min.x - min.x;
            else if (max.x < m_ViewBounds.max.x)
                offset.x = m_ViewBounds.max.x - max.x;
        }

        if (m_Vertical)
        {
            min.y += delta.y;
            max.y += delta.y;
            if (max.y < m_ViewBounds.max.y)
                offset.y = m_ViewBounds.max.y - max.y;
            else if (min.y > m_ViewBounds.min.y)
                offset.y = m_ViewBounds.min.y - min.y;
        }

        return offset;
    }

    #region pointer events
    /// <summary>
    /// mouse click events on computer platform
    /// </summary>
    /// <param name="eventData">event data</param>
    [SLua.DoNotToLua]
    public virtual void OnPointerClick(PointerEventData eventData)
    {
        //PostPointedItem(eventData);
        if (eventData.pointerPress != null)
            Debug.Log("OnPointerClick pointerPress=" + eventData.pointerPress.name);
        if (eventData.pointerEnter != null)
            Debug.Log("OnPointerClick pointerEnter=" + eventData.pointerEnter.name);

        if (eventData.selectedObject != null)
            Debug.Log("OnPointerClick pointerPress=" + eventData.selectedObject.name);
    }

    [SLua.DoNotToLua]
    public virtual void OnSelect(BaseEventData eventData)
    {
        Debug.Log("eventData" + eventData.ToString());
    }
    #endregion

    //[SLua.DoNotToLua]
    public void SetListInfos(List<SLua.LuaTable> inItems)
    {

        bRunLateUpdated = true;
        velocity = Vector2.zero;
        m_Content.anchoredPosition = Vector2.zero;
        m_PrevPosition = Vector2.zero;
        _listItems.Clear();
        if (inItems != null)
            listLen = inItems.Count;
        foreach(var obj in inItems)
        {
            _listItems.Add(obj);
        }
        //_listItems.AddRange(inItems);
        FreshScrollRect(inItems);
    }

    public void SetColumn(int column)
    {
        siblingIndex.Clear();
        _defaultLocalPosition.Clear();

        int diff = m_Content.childCount - column;
        int idx = 0;
        if (diff == 0)
        {

        }
        else if(diff > 0)
        {
            int count = Mathf.Abs(diff);
            while(count > 0)
            {
                Transform trans = m_Content.GetChild(m_Content.childCount - 1);
                trans.gameObject.SetActive(false);
                trans.SetParent(null);

                _disabledTrans.Add(trans);
            }
        }
        else
        {
            diff = Mathf.Abs(diff);
            if (_disabledTrans.Count > 0)
            {
                while (_disabledTrans.Count > 0 && diff > 0)
                {
                    Transform trans = _disabledTrans[0];
                    trans.SetParent(m_Content.transform);
                    trans.gameObject.SetActive(true);
                    trans.SetAsLastSibling();

                    _disabledTrans.RemoveAt(0);
                    --diff;
                }
            }

            for(idx=0; idx < diff; ++idx)
            {
                GameObject go = null;

                go = Instantiate(listItemPrefab) as GameObject;
                go.transform.SetParent(m_Content.transform, false);
                go.transform.localPosition = new Vector3(0.0f, 0.0f, 0.0f);
                go.transform.localScale = new Vector3(1.0f, 1.0f, 1.0f);
                go.name = string.Format("listItem{0}", m_Content.childCount);
                go.SetActive(true);
                go.transform.SetAsLastSibling();
                //siblingIndex.Add(go.transform, go.transform.GetSiblingIndex());
            }
            
        }
        for(idx=0;idx < m_Content.childCount; ++idx)
        {
            siblingIndex.Add(m_Content.GetChild(idx), idx);
            _defaultLocalPosition.Add(idx, m_Content.GetChild(idx).localPosition);
        }

    }

    [SLua.DoNotToLua]
    private List<int> _indexs = new List<int>();
    [SLua.DoNotToLua]
    private int m_ITweenDoneCount = 0;
    [SLua.DoNotToLua]
    Dictionary<Transform, float> trans_position = new Dictionary<Transform, float>();

    [SLua.DoNotToLua]
    private List<Transform> oldAwardTrans = new List<Transform>();

    /// <summary>
    /// public interface to reset the renderer items
    /// </summary>
    /// <param name="indexs">all item's sibling index in list</param>
    /// <param name="deltaTime"></param>
    public void ResetShowItems(List<int> indexs, float deltaTime)
    {
        _indexs.Clear();

        if (indexs == null || indexs.Count <= 0)
            return;

        _indexs.AddRange(indexs);

        int minStartPos = indexs[0];
        int idx = 0;
        for (idx=1; idx < indexs.Count; ++idx)
        {
            if(minStartPos <= indexs[idx])
            {
                minStartPos = indexs[idx];
            }
        }

        List<int> used = new List<int>();

        
        trans_position.Clear();
        int siblingIdx = 0;
        oldAwardTrans.Clear();
        for (idx=0; idx < indexs.Count; ++idx)
        {
            Transform oldTras = m_Content.GetChild(indexs[idx]);
            oldAwardTrans.Add(oldTras);

            //get next render item
            siblingIdx = indexs[idx];
            Transform newTrans = null;

            for(int i=siblingIdx+1; i < m_Content.childCount; ++i)
            {
                if(indexs.Contains(i) == false && used.Contains(i) == false )
                {
                    newTrans = m_Content.GetChild(i);
                    used.Add(i);
                    trans_position.Add(newTrans, oldTras.localPosition.y);
                    break;
                }
            }
        }
        idx = minColumnOrRaw - indexs.Count;
        if(used.Count  <= 0 )
        {
            Debug.LogError("" + transform.name + " indexs=" + indexs.Count + " coent=" + indexs.ToString());
        }
        siblingIdx = used[used.Count - 1];

        while(idx > 0)
        {
            float endValue = m_Content.GetChild(siblingIdx).localPosition.y;

            ++siblingIdx;

            trans_position.Add(m_Content.GetChild(siblingIdx), endValue);

            --idx;
        }

        foreach(var obj in trans_position)
        { 
            Tweener tween = DoTweenPathLuaUtil.DOLocalMoveY(obj.Key, obj.Value, deltaTime);
            DoTweenPathLuaUtil.OnComplete(tween, this.onTweenCompleted);
        }
        m_ITweenDoneCount = 0;
    }

    /// <summary>
    /// check if the all tween has been killed
    /// </summary>
    [SLua.DoNotToLua]
    public void onTweenCompleted()
    {
        m_ITweenDoneCount++;

        if(m_ITweenDoneCount >= trans_position.Count)
        {
            ResetSibiling();
            m_ITweenDoneCount = 0;
        }
    }

    /// <summary>
    /// will be invoked when jump done
    /// </summary>
    [SLua.DoNotToLua]
    private void ResetSibiling()
    {
       
        foreach(var obj in oldAwardTrans)
        {
            obj.SetAsLastSibling();
        }

        for (int idx = 0; idx < m_Content.childCount; ++idx)
        {
            if (_defaultLocalPosition.ContainsKey(idx))
            {
                m_Content.GetChild(idx).localPosition = _defaultLocalPosition[idx];
            }
        }

        //do jump 
        Transform trans = m_Content.GetChild(minColumnOrRaw - 1);
        Sequence sequence =  trans.DOJump(trans.position, jumpPower, jumpNum, jumpElapsedTime);
        sequence.OnComplete(() =>
        {
            trans_position.Clear();
            oldAwardTrans.Clear();
            _indexs.Clear();
           
            if (m_onResetShowItem != null)
            {
                m_onResetShowItem.Invoke(true);
            } 
        });
    }

    /// <summary>
    /// update list 
    /// </summary>
    [SLua.DoNotToLua]
    private void FreshScrollRect(List<SLua.LuaTable> inItems)
    {
        if (layout == null)
            layout = content.GetComponent<GridLayoutGroup>();

        if (horizontal)
            cellInternal = layout.cellSize.x + layout.spacing.x;
        else
            cellInternal = layout.cellSize.y + layout.spacing.y;

        EnsureLayoutHasRebuilt();
        UpdateBounds();

        Vector2 offest = CalculateOffset(Vector2.zero);
        m_Content.anchoredPosition = offest;
        if (horizontal)
        {
            cachedDefaultLocation = offest.x;
        }
        else
        {
            cachedDefaultLocation = offest.y;
        }
        Vector2 pos = m_Content.anchoredPosition;


        ActualSetItemInfo();
        m_PrevPosition = pos;
        m_Content.anchoredPosition = pos;

    }

    /// <summary>
    /// Update item info, need to be override in subclass
    /// </summary>
    [SLua.DoNotToLua]
    protected virtual void ActualSetItemInfo(int mLoop, int showItemCount)
    {

    }

    [SLua.DoNotToLua]
    protected virtual void ActualSetItemInfo()
    {
        int renderCount = 0;

        for (int idx = 0; idx < _listItems.Count; ++idx)
        {
            Transform item = m_Content.GetChild(idx);

            SlotItemInfo infoComp = item.gameObject.GetComponent<SlotItemInfo>();

            if (infoComp == null)
                continue;
            infoComp.info = _listItems[idx];
            if(item.gameObject.activeSelf == false )
            {
                item.gameObject.SetActive(true);
            }
            renderCount++;
        }

        if (renderCount < m_Content.childCount)
        {
            for (int idx = renderCount; idx < m_Content.childCount; ++idx)
            {
                m_Content.GetChild(idx).gameObject.SetActive(false);
            }
        }
    }

    public void LayoutComplete()
    {
    }

    public void GraphicUpdateComplete()
    {
    }

    public void OnClose()
    {
        if(_disabledTrans.Count > 0)
        {
            for(int idx=0; idx < _disabledTrans.Count; ++idx)
            {
                SlotItemInfo info = _disabledTrans[idx].GetComponent<SlotItemInfo>();
                if(info != null)
                {
                    info.onValueChanged.RemoveAllListeners();
                }
            }
        }
    }
}