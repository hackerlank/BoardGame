using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using System.Collections.Generic;
using DG.Tweening;
using System;


[SLua.CustomLuaClass]
[AddComponentMenu("UI/CardRoundSecectorEx")]
public class CardRoundSelectorEx : MonoBehaviour, IDragHandler, IEndDragHandler, IPointerClickHandler
{
    public enum Mode
    {
        Horizontal,
        Vertical
    }

    [SerializeField]
    [SLua.DoNotToLua]
    private GameObject cardTemplate = null;

 
    [SerializeField]
    public bool clickBringup = false;

    public Transform container = null;
    public RectTransform centerPos = null;
    public float moveSpeed = 0.1f;
    public float radius = 100.0f;
    public float aspectRatio = 1.0f;
    public float scale = 0.5f;
    public bool disableDrag = false;
    public Mode touchMode = Mode.Horizontal;
    private float _curDegree = 0.0f;
    private float _nxtDegree = 0.0f;
    private float _prvDegree = 0.0f;
    private float _perDegree = 0.0f;
    private Vector2 _centerAnc = Vector2.zero;
    private bool _bDraging = false;

    public Transform parent = null;

    private List<RectTransform> _cards = new List<RectTransform>();

    void Awake()
    {
        _centerAnc = (centerPos == null ? Vector2.zero : centerPos.anchoredPosition);
        Init();
    }

    [SerializeField]
    private bool isReset = false;
    void Update()
    {
        if (isReset)
        {
            isReset = false;
            Init();
        }
    }

    private void Init()
    {
        if (container == null)
        {
            Debug.LogError("Container can NOT be unset!");
            return;
        }

        _cards.Clear();
        int cardNum = 0;
        for (int index = 0; index < container.childCount; ++index)
        {
            Transform child = container.GetChild(index);
            if (!child.gameObject.activeSelf)
                continue;
            RectTransform rt = child as RectTransform;
            _cards.Add(rt);
            ++cardNum;
            Button btn = child.GetComponent<Button>();
            if (btn) btn.enabled = false;
        }
        _curDegree = -90.0f;
        _perDegree = container.childCount == 0 ? 360.0f : 360.0f / (cardNum > 0 ? cardNum : 1);
        if (Mathf.Abs(_perDegree - 360.0f) < Mathf.Epsilon)
        {
            _perDegree = 0;
        }
        _nxtDegree = _curDegree + _perDegree;
        _prvDegree = _curDegree - _perDegree;

        UpdateCardAll(false);
    }


    /// <summary>
    /// Spawn card item
    /// </summary>
    /// <returns>item gameObject</returns>    public GameObject Spawn()    {        if (cardTemplate == null || parent == null)            return null;        GameObject card = Instantiate(cardTemplate);        card.transform.SetParent(parent);        card.transform.localPosition = Vector3.zero;        card.transform.localScale = cardTemplate.transform.localScale;        card.transform.localRotation = cardTemplate.transform.rotation;        card.SetActive(true);        _cards.Add(card.GetComponent<RectTransform>());        return card;    }

    public void Reset()
    {
        _curDegree = -90;
        for (int index = 0; index < _cards.Count; ++index)
        {
            UpdateCardSingle(_cards[index], _curDegree, false);
        }
        Init();
    }

    public void BringUp(string child)
    {
        RectTransform trans = null;
        int curIdx = -1;

        for (int index = 0; index < container.childCount; ++index)
        {
            RectTransform finder = container.GetChild(index) as RectTransform;
            if (finder.name == child)
            {
                trans = finder;
                curIdx = index;
                break;
            }
        }

        if (trans == null || curIdx == _cards.Count - 1) return;

        int diff = _cards.Count - 1 - curIdx;
        int multi = 0;

        if (diff % 2 == 0)
        {
            multi = -1 * diff / 2;
        }
        else
        {
            multi = (diff + 1) / 2;
        }

        float final = _curDegree + _perDegree * multi;
        DOTween
            .To(x => _curDegree = x, _curDegree, final, 0.2f)
            .OnUpdate(UpdateCardAll)
            .OnComplete(UpdateTarget);
    }

    public void OnDrag(PointerEventData data)
    {
        if (disableDrag)
            return;
        if (_perDegree == 0)
            return;

        if (touchMode == Mode.Horizontal)
            _curDegree += moveSpeed * data.delta.x;
        else
            _curDegree += moveSpeed * data.delta.y;

        UpdateCardAll();
        _bDraging = true;
    }

    public void OnEndDrag(PointerEventData data)
    {
        //	UpdateTarget();
        if (_perDegree == 0)
            return;

        float orignalDegree = (_nxtDegree + _prvDegree) / 2.0f;
        float finalDegree = 0;

        if (_curDegree > orignalDegree)
        {
            float disFromOrignal = _curDegree - orignalDegree;
            finalDegree = (disFromOrignal > _perDegree / 4 ? _nxtDegree : orignalDegree);
        }
        else if (_curDegree < orignalDegree)
        {
            float disFromOrignal = orignalDegree - _curDegree;
            finalDegree = (disFromOrignal > _perDegree / 4 ? _prvDegree : orignalDegree);
        }
        else
        {
            return;
        }

        DOTween
            .To(x => _curDegree = x, _curDegree, finalDegree, 0.2f)
            .OnUpdate(UpdateCardAll)
            .OnComplete(UpdateTarget);

        _bDraging = false;
    }

    protected virtual void CheckOnPointerClickEnter(ref RectTransform enter)
    {
        for (int i = 0; i < _cards.Count; ++i)
        {// 如果重叠的话，检测最上层？
            if (enter != null && (enter.IsChildOf(_cards[i]) || enter == _cards[i]))
            {
                enter = _cards[i];
                break;
            }
        }
    }

    public void OnPointerClick(PointerEventData data)
    {
        if (_bDraging) return;

        RectTransform enter = (data.rawPointerPress == null ? null : data.rawPointerPress.transform as RectTransform);
        CheckOnPointerClickEnter(ref enter);

        if (!_cards.Contains(enter)) return;
        int index = enter.transform.GetSiblingIndex();
        if (index == _cards.Count - 1)
        {
            Button btn = enter.GetComponent<Button>();
            if (btn)
            {
                btn.enabled = true;
                btn.OnPointerClick(data);
                btn.enabled = false;
            }
        }
        else
        {
            if (clickBringup)
            {
                float finalDegree = 0.0f;
                if (touchMode == Mode.Horizontal)
                {
                    finalDegree = _centerAnc.x > enter.anchoredPosition.x ? _nxtDegree : _prvDegree;
                }
                else
                {
                    finalDegree = _centerAnc.x > enter.anchoredPosition.y ? _nxtDegree : _prvDegree;
                }
                if (Mathf.Repeat(finalDegree - _curDegree, 360.0f) < Mathf.Epsilon)
                {
                    finalDegree = _curDegree;
                }
                DOTween
                    .To(x => _curDegree = x, _curDegree, finalDegree, 0.2f)
                    .OnUpdate(UpdateCardAll)
                    .OnComplete(UpdateTarget);
            }
        }
    }

    void UpdateCardAll()
    {
        UpdateCardAll(true);
    }

    void UpdateCardAll(bool isAllowCallback)
    {
        for (int index = 0; index < _cards.Count; ++index)
            UpdateCardSingle(_cards[index], _curDegree + index * _perDegree, isAllowCallback);
    }

    void UpdateTarget()
    {
        if (_perDegree == 360.0f)
            return;
        _curDegree = Mathf.Repeat(_curDegree, 360.0f);

        while (_curDegree >= _nxtDegree && _perDegree != 0)
        {
            _nxtDegree += _perDegree;
            _prvDegree += _perDegree;
        }

        while (_curDegree <= _prvDegree && _perDegree != 0)
        {
            _nxtDegree -= _perDegree;
            _prvDegree -= _perDegree;
        }
    }

    void UpdateCardSingle(RectTransform card, float degree, bool isAllowCallback = true)
    {
        float angle = degree * Mathf.PI / 180.0f;           // Translate degree to angle
        float delta = 0.5f + Mathf.Sin(-angle) / 2.0f;      // Make delta [0, 1]
        float index = delta * _cards.Count;                 // Make index [0, Count - 1]

        if (touchMode == Mode.Horizontal)
        {
            card.anchoredPosition = new Vector2(
                _centerAnc.x + Mathf.Cos(angle) * radius,
                _centerAnc.y + Mathf.Sin(angle) * radius * aspectRatio
            );
        }
        else
        {
            card.anchoredPosition = new Vector2(
                _centerAnc.x + Mathf.Sin(angle) * radius * aspectRatio,
                _centerAnc.y + Mathf.Cos(angle) * radius
            );
        }

        int sibling = (int)index;
        card.SetSiblingIndex(sibling);
        card.localScale = Vector3.Lerp(Vector3.one * scale, Vector3.one, delta);

        if ((1 - delta) < 0.00001f)
        {
            if (frontCallback != null && isAllowCallback)
                frontCallback(card.gameObject);
        }

        UpdateCardColor(card, delta);
    }

    protected virtual void UpdateCardColor(RectTransform card, float delta)
    {
        Color tmpColor = Color.Lerp(Color.gray, Color.white, delta);

        //ListGameObject cptsColor = card.GetComponent<ListGameObject>();
        //if (cptsColor != null && cptsColor.listObjects != null)
        //{
        //    for (int i = 0; i < cptsColor.listObjects.Count; ++i)
        //    {
        //        Graphic tmp = cptsColor.listObjects[i].GetComponent<Graphic>();
        //        if (tmp != null)
        //        {
        //            tmpColor.a = tmp.color.a;
        //            tmp.color = tmpColor;
        //        }
        //    }
        //}
        //else
        //{
        //    Graphic image = card.GetComponent<Graphic>();
        //    if (image)
        //    {
        //        tmpColor.a = image.color.a;
        //        image.color = tmpColor;
        //    }
        //}
        //else 
        {
            Graphic[] graphs = card.GetComponentsInChildren<Graphic>();
            if (graphs != null)
            {
                for (int i = 0; i < graphs.Length; ++i)
                {
                    tmpColor.a = graphs[i].color.a;
                    graphs[i].color = tmpColor;
                }
            }
        }
    }

    private Action<GameObject> frontCallback = null;
    public void SetTargetCallback(Action<GameObject> paramHandler)
    {
        frontCallback = paramHandler;
    }

    public void UpdateTargetTransform(Transform trans)
    {
        if (trans == null || container == null)
            return;
        //Debug.LogWarning("UpdateTargetTransform " + trans.gameObject.name);

        float finalDegree = 0;
        for (int index = 0; index < _cards.Count; ++index)
        {
            if (_cards[index].transform == trans)
            {
                finalDegree = -90 - index * _perDegree;
                break;
            }
        }
        DOTween
               .To(x => _curDegree = x, _curDegree, finalDegree, 0.2f)
               .OnUpdate(UpdateCardAll)
               .OnComplete(UpdateTarget);
    }

}


