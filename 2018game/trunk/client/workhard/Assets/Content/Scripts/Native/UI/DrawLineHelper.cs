using UnityEngine;
using System.Collections.Generic;

[SLua.CustomLuaClass]
public class DrawLineHelper
{
    public static void SetPositions(LineRenderer lr, List<Vector3> positions)
    {
        if (lr == null)
            return;
        Vector3[] tmps = new Vector3[positions.Count];
        for(int idx=0; idx < positions.Count; ++idx)
        {
            tmps[idx] = positions[idx];
        }

        lr.SetPositions(tmps);
    }
    
}
