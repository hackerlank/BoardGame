using UnityEngine;
using UnityEngine.Events;
using SLua;
using UnityEngine.Internal;
/// <summary>
/// 2d collision helper class
/// </summary>
[CustomLuaClass]
public class Collider2DHelper : MonoBehaviour
{

    /// <summary>
    /// for 2d collider
    /// </summary>
    private UnityAction<Collider2D> triggerEnter2D = null;

    /// <summary>
    /// add trigger enter listener
    /// </summary>
    /// <param name="callback">call back function</param>
    public void AddTriggerEnterListener(UnityAction<Collider2D> callback)
    {
        triggerEnter2D = callback;
    }

    /// <summary>
    /// unbind function
    /// </summary>
    public void Clear()
    {
        triggerEnter2D = null;
    }

    #region enter events
    void OnTriggerEnter2D(Collider2D other)
    {
        if (triggerEnter2D != null)
        {
            triggerEnter2D.Invoke(other);
        }
    }
    #endregion

    static public string[] OverlapCircleAll(Vector2 point, float radius)
    {
        Collider2D[] colls =  Physics2D.OverlapCircleAll(point, radius);
        string[] names = new string[colls.Length];
        for (int i = 0; i < colls.Length; i++)
            names[i] = colls[i].name;
        return names;
    } 
}
