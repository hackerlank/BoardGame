using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using UnityEngine.Events;
using System;
using DG.Tweening;


[SLua.CustomLuaClass]
[RequireComponent(typeof(RectTransform))]
public class GameScrollRect : UIBehaviour, IInitializePotentialDragHandler, IBeginDragHandler, IEndDragHandler, IDragHandler, IScrollHandler, ICanvasElement, ISelectHandler
{

    //[SerializeField]
    [SLua.DoNotToLua]
    [SerializeField]
    private int triggerHideEventLimit = 1;

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
    private bool bIsDealing = false;

    [SerializeField]
    [SLua.DoNotToLua]
    protected bool bHideBlankItem = true;

    [SLua.DoNotToLua]
    private bool bMoveToEnd = true;

    [SLua.DoNotToLua]
    private bool m_Dragging;

    [SLua.DoNotToLua]
    private List<Transform> _disabledTrans = new List<Transform>();

    [SLua.DoNotToLua]
    private Transform _seletedTrans = null;

    [SLua.DoNotToLua]
    protected bool isMoveToEnd { get { return bMoveToEnd; } }

    [SLua.DoNotToLua]
    protected int currentStartLine = 0;

    [SLua.DoNotToLua]
    protected int currentEndLine = 0;

    [SLua.DoNotToLua]
    protected int cachedStart = 0;

    [SerializeField]
    [Tooltip("How many column or raw need to be rendered at least")]
    protected int minColumnOrRaw = 0;
    public int SetMinColumnOrRaw { set { minColumnOrRaw = value; } }

    [SerializeField]
    protected int column_max = 10;

    [SLua.DoNotToLua]
    protected int scrollColumnCount = 0;

    [SerializeField]
    [SLua.DoNotToLua]
    protected GameObject listItemPrefab = null;

    [SLua.DoNotToLua]
    protected int listLen;

    [SerializeField]
    [SLua.DoNotToLua]
    protected bool isDynamic = true;


    [SLua.DoNotToLua]
    private Dictionary<Transform, int> siblingIndex = new Dictionary<Transform, int>();

    [SLua.DoNotToLua]
    private Dictionary<int, Vector3> _defaultLocalPosition = new Dictionary<int, Vector3>();


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

    // The offset from handle position to mouse down position
    private Vector2 m_PointerStartLocalCursor = Vector2.zero;
    private Vector2 m_ContentStartPosition = Vector2.zero;

    [SLua.DoNotToLua]
    private Dictionary<int, List<object>> m_pages = new Dictionary<int, List<object>>();

    [SerializeField]
    private RectTransform m_Viewport;
    public RectTransform viewport { get { return m_Viewport; } set { m_Viewport = value; } }

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
    protected GameScrollRect()
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

        SetContentAnchoredPosition(position);
        UpdateBounds();

    }

    [SLua.DoNotToLua]
    public virtual void OnInitializePotentialDrag(PointerEventData eventData)
    {
        m_Velocity = Vector2.zero;
    }

    [SLua.DoNotToLua]
    public virtual void OnBeginDrag(PointerEventData eventData)
    {
        if (eventData.button != PointerEventData.InputButton.Left)
            return;

        if (!IsActive())
            return;

        UpdateBounds();

        m_PointerStartLocalCursor = Vector2.zero;
        RectTransformUtility.ScreenPointToLocalPointInRectangle(viewRect, eventData.position, eventData.pressEventCamera, out m_PointerStartLocalCursor);
        m_ContentStartPosition = m_Content.anchoredPosition;

        m_Dragging = true;
    }

    [SLua.DoNotToLua]
    public virtual void OnEndDrag(PointerEventData eventData)
    {
        if (eventData.button != PointerEventData.InputButton.Left)
            return;

        m_Dragging = false;
    }

    [SLua.DoNotToLua]
    public virtual void OnDrag(PointerEventData eventData)
    {
        if (eventData.button != PointerEventData.InputButton.Left)
            return;

        if (!IsActive())
            return;

        Vector2 localCursor;
        if (!RectTransformUtility.ScreenPointToLocalPointInRectangle(viewRect, eventData.position, eventData.pressEventCamera, out localCursor))
            return;

        bRunLateUpdated = true;

        UpdateBounds();

        var pointerDelta = localCursor - m_PointerStartLocalCursor;
        Vector2 position = m_ContentStartPosition + pointerDelta;

        // Offset to get content into place in the view.
        Vector2 offset = CalculateOffset(position - m_Content.anchoredPosition);
        position += offset;
        if (m_MovementType == MovementType.Elastic)
        {
            if (offset.x != 0)
                position.x = position.x - RubberDelta(offset.x, m_ViewBounds.size.x);
            if (offset.y != 0)
                position.y = position.y - RubberDelta(offset.y, m_ViewBounds.size.y);
        }

        if (IsDealHiddenItem())
            RectTransformUtility.ScreenPointToLocalPointInRectangle(viewRect, eventData.position, eventData.pressEventCamera, out m_PointerStartLocalCursor);
        SetContentAnchoredPosition(position);
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

            if (isDynamic)
            {
                if (horizontal && (m_Content.anchoredPosition.x <= position.x))
                {
                    bMoveToEnd = false;
                }
                else if (vertical && (m_Content.anchoredPosition.y > position.y))
                {
                    bMoveToEnd = false;
                }
            }

            if (isDynamic && IsDealHiddenItem())
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

        if (!isDynamic)
            return false;
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

    [SLua.DoNotToLua]
    private bool m_bIsRegister = false;

    /// <summary>
    /// whether we can reset item detail information
    /// </summary>
    [SLua.DoNotToLua]
    protected bool isNotUpdateValue
    {
        get
        {
            bool bResult = (currentEndLine >= (m_pages.Count - 1) && bMoveToEnd) || (currentStartLine == 0 && bMoveToEnd == false);
            
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

                if (currentEndLine + 1 < m_pages.Count)
                {
                    currentEndLine++;
                    currentStartLine++;
                    List<object> data = m_pages[currentEndLine];
                    for (idx = 0; idx < layout.constraintCount; ++idx)
                    {
                        Transform trans = m_Content.GetChild(0);
                        
                        if (idx < data.Count)
                        {
                            trans.gameObject.SetActive(true);
                            trans.GetComponent<SlotItemInfo>().info = data[idx];              
                        }
                        else
                        {
                            if(bHideBlankItem)
                            {
                                trans.gameObject.SetActive(false);
                            }
                            else
                            {
                                trans.gameObject.SetActive(true);
                                trans.GetComponent<SlotItemInfo>().info = null;
                            }
                        }
                        trans.SetAsLastSibling();

                    }

                    movedLine++;
                }
               
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

                if (currentStartLine - 1 >= 0)
                {
                    currentStartLine -= 1;
                    currentEndLine -= 1;
                    List<object> data = m_pages[currentStartLine];
                    for (idx = layout.constraintCount - 1; idx >= 0; --idx)
                    {   
                        Transform trans = m_Content.GetChild(childs - 1);
                        if(idx >= data.Count)
                        {
                            if (bHideBlankItem == true)
                            {
                                trans.gameObject.SetActive(false);
                            }
                            else
                            {
                                trans.GetComponent<SlotItemInfo>().info = null;
                            }
                        }
                        else
                        {
                            trans.gameObject.SetActive(true);
                            trans.GetComponent<SlotItemInfo>().info = m_pages[currentStartLine][idx];
                        }
                        trans.SetAsFirstSibling();
                    }
                    movedLine++;
                }

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
        UpdateBounds();
        UpdatePrevData();

        /**SlotGridLayout tmpLayout = layout as SlotGridLayout;
        if (tmpLayout != null)
        {
            tmpLayout.ForceLayout();
        }*/
        bIsDealing = false;
    }

    [SLua.DoNotToLua]
    protected virtual void LateUpdate()
    {
        if (!m_Content || !bRunLateUpdated)
            return;

        EnsureLayoutHasRebuilt();
       // UpdateScrollbarVisibility();
        UpdateBounds();
        float deltaTime = Time.unscaledDeltaTime;
        Vector2 offset = CalculateOffset(Vector2.zero);
        if (!m_Dragging && (offset != Vector2.zero || m_Velocity != Vector2.zero))
        {
            Vector2 position = m_Content.anchoredPosition;
            for (int axis = 0; axis < 2; axis++)
            {
                // Apply spring physics if movement is elastic and content has an offset from the view.
                if (m_MovementType == MovementType.Elastic && offset[axis] != 0)
                {
                    float speed = m_Velocity[axis];
                    position[axis] = Mathf.SmoothDamp(m_Content.anchoredPosition[axis], m_Content.anchoredPosition[axis] + offset[axis], ref speed, m_Elasticity, Mathf.Infinity, deltaTime);
                    m_Velocity[axis] = speed;

                    if (Mathf.Abs(m_Velocity[axis]) < 1)
                        m_Velocity[axis] = 0;

                }
                // Else move content according to velocity with deceleration applied.
                else if (m_Inertia)
                {
                    m_Velocity[axis] *= Mathf.Pow(m_DecelerationRate, deltaTime);
                    if (Mathf.Abs(m_Velocity[axis]) < 1)
                        m_Velocity[axis] = 0;
                    position[axis] += m_Velocity[axis] * deltaTime;
                }
                // If we have neither elaticity or friction, there shouldn't be any velocity.
                else
                {
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

        if (m_Dragging && m_Inertia)
        {
            Vector3 newVelocity = (m_Content.anchoredPosition - m_PrevPosition) / deltaTime;
            m_Velocity = Vector3.Lerp(m_Velocity, newVelocity, deltaTime * 10);
        }

        if (m_ViewBounds != m_PrevViewBounds || m_ContentBounds != m_PrevContentBounds || m_Content.anchoredPosition != m_PrevPosition)
        {
            UpdateScrollbars(offset);
            m_OnValueChanged.Invoke(normalizedPosition);
            UpdatePrevData();
        }
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
    public void SetListInfos(List<object> inItems, bool bResetPos = false)
    {

        bRunLateUpdated = false;
        velocity = Vector2.zero;
        m_Content.anchoredPosition = Vector2.zero;
        m_PrevPosition = Vector2.zero;
        _listItems.Clear();
        if (inItems != null)
        {
            listLen = inItems.Count;
            foreach (var obj in inItems)
            {
                _listItems.Add(obj);
            }
        }
        else
        {
            listLen = 0;

        }
        //_listItems.AddRange(inItems);
        FreshScrollRect(inItems, bResetPos);
        bRunLateUpdated = true;
    }

    
    public void RegisterItem(object item, bool bFocus = true)
    {
        if (item == null)
            return;
        m_bIsRegister = true;
        _listItems.Add(item);
        listLen = _listItems.Count;
        bool m_bNewLine = false;
        if (m_pages.Count <= 0)
        {

            m_bNewLine = true;
            List<object> new_page = new List<object>();
            new_page.Add(item);
            m_pages.Add(m_pages.Count, new_page);
        }
        else
        {
            int page = m_pages.Count - 1;
            
            if (m_pages[page].Count < layout.constraintCount)
            {
                m_pages[page].Add(item);
            }
            else
            {
                page++;
                List<object> new_page = new List<object>();
                new_page.Add(item);
                m_pages.Add(page, new_page);
                m_bNewLine = true;
            }
        }

        if(m_Dragging || m_Velocity.y != Vector2.zero.y )
        {
            return;
        }

        m_Velocity = Vector2.zero;

        if(bFocus)
        {
         
            int end_idx = column_max * layout.constraintCount - 1;
            int start_idx = end_idx - layout.constraintCount;
            for(int idx=start_idx; idx <= end_idx; ++idx)
            {
                SlotItemInfo trans = m_Content.GetChild(idx).GetComponent<SlotItemInfo>();
                if( (idx - start_idx) < m_pages[currentEndLine].Count )
                {
                    trans.gameObject.SetActive(true);
                    trans.info = m_pages[currentEndLine][idx - start_idx];
                }
                else
                {
                    if(bHideBlankItem)
                    {
                        trans.gameObject.SetActive(false);
                    }
                    trans.info = null;
                }
            }
            
        }
    }

    public void SetColumn(int column)
    {
        column_max = column;
        siblingIndex.Clear();
        _defaultLocalPosition.Clear();

        int diff = m_Content.childCount - column;
        int idx = 0;
        if (diff == 0)
        {

        }
        else if (diff > 0)
        {
            int count = Mathf.Abs(diff);
            while (count > 0)
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

            for (idx = 0; idx < diff; ++idx)
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
        for (idx = 0; idx < m_Content.childCount; ++idx)
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

    [SLua.DoNotToLua]
    private void MapToPage()
    {
        int len = _listItems.Count;
        m_pages.Clear();
        if (len > 0)
        {
            int line = len / layout.constraintCount;
            int rest = len % layout.constraintCount;
            if (rest > 0)
            {
                line++;
            }

            int realIdx = 0;
            for (int i = 0; i < line; ++i)
            {
                List<object> list = new List<object>();
                for (int j = 0; j < layout.constraintCount; ++j)
                {
                    realIdx = i * layout.constraintCount + j;

                    if (realIdx < len)
                        list.Add(_listItems[realIdx]);
                }

                m_pages.Add(i, list);
            }
        }
    }

    /// <summary>
    /// update list 
    /// </summary>
    [SLua.DoNotToLua]
    private void FreshScrollRect(List<object> inItems, bool  bResetPos = false)
    {
        if (layout == null)
            layout = content.GetComponent<GridLayoutGroup>();

        if (horizontal)
            cellInternal = layout.cellSize.x + layout.spacing.x;
        else
            cellInternal = layout.cellSize.y + layout.spacing.y;

        MapToPage();

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

        if(bResetPos)
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

        int line_count = m_pages.Count;
        

        int real_idx = 0;
        currentStartLine = 0;
        if (line_count > column_max)
        {
            line_count = column_max;
        }
        currentEndLine = line_count - 1;
       

        int renderLine = 0;
        for (int idx = currentStartLine; idx <= currentEndLine; ++idx)
        {
            int loop = layout.constraintCount;
            if (loop > m_pages[idx].Count)
            {
                loop = m_pages[idx].Count;
            }
            for(int i=0;i < loop; ++i)
            {
                real_idx = idx * layout.constraintCount + i;
                Transform item = m_Content.GetChild(real_idx);

                SlotItemInfo infoComp = item.gameObject.GetComponent<SlotItemInfo>();

                if (infoComp == null)
                    continue;
                infoComp.info = m_pages[idx][i];
                if (item.gameObject.activeSelf == false)
                {
                    item.gameObject.SetActive(true);
                }
                renderCount++;
            }
            renderLine++;
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
        if (_disabledTrans.Count > 0)
        {
            for (int idx = 0; idx < _disabledTrans.Count; ++idx)
            {
                SlotItemInfo info = _disabledTrans[idx].GetComponent<SlotItemInfo>();
                if (info != null)
                {
                    info.onValueChanged.RemoveAllListeners();
                }
            }
        }
    }
}