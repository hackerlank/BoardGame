using UnityEngine;
using UnityEngine.UI;
using System.Collections.Generic;
public class SlotGridLayout : GridLayoutGroup
{

    public List<RectTransform> getRectTransforms { get { return rectChildren; } }

    public void ForceLayout()
    {
        SetDirty();
    }
}
