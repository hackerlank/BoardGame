using UnityEngine;
using System.Collections.Generic;
using System;
using UnityEngine.UI;

/// <summary>
/// this class includes many public functions for setting the properties of transform. the execution speed is more fast than
/// directly set properties of transform from lua script
/// </summary>

[SLua.CustomLuaClass]
public class TransformLuaUtil
{

    /// <summary>
    /// whether transform is at one point
    /// </summary>
    /// <param name="trans"></param>
    /// <param name="x"></param>
    /// <param name="y"></param>
    /// <param name="z"></param>
    /// <returns></returns>
    public static bool IsTransAt(Transform trans, float x, float y, float z)
    {
        if (trans == null)
            return false;

       if(trans.position == new Vector3(x, y, z))
        {
            return true;
        }

        return false;
    }
    /// <summary>
    /// set the position property of transform
    /// </summary>
    /// <param name="trans">the targets</param>
    /// <param name="x">the x value in the world</param>
    /// <param name="y">the y value in the world</param>
    /// <param name="z">the z value in the world</param>
    public static void SetTransformPos(Transform trans, float x, float y, float z)
    {
        if(trans)
        {
            trans.localPosition = new Vector3(x, y, z);
            //trans.position = new Vector3(x, y, z);
        }
        else
        {
            Debug.LogError("transform is null");
        }
    }


    /// <summary>
    /// set the position property of transform
    /// </summary>
    /// <param name="trans">the targets</param>
    /// <param name="x">the x value in the world</param>
    /// <param name="y">the y value in the world</param>
    /// <param name="z">the z value in the world</param>
    public static void GetTransformPos(Transform trans, out float x,out float y,out float z)
    {
        x = 0;
        y = 0;
        z = 0;
        if (trans)
        {
            x = trans.position.x;
            y = trans.position.y;
            z = trans.position.z;
        }
        else
        {
            Debug.LogError("transform is null");
        }
    }
    /// <summary>
    /// set the local position property of transform
    /// </summary>
    /// <param name="trans">the targets</param>
    /// <param name="x">the x value in the world</param>
    /// <param name="y">the y value in the world</param>
    /// <param name="z">the z value in the world</param>
    public static void SetTransformLocalPos(Transform trans, float x, float y, float z)
    {
        if(trans)
        {
            trans.localPosition = new Vector3(x, y, z);
        }
        else
        {
            Debug.LogError("transform is null");
        }
    }

    /// <summary>
    /// set transform rotation
    /// </summary>
    /// <param name="trans"></param>
    /// <param name="x"></param>
    /// <param name="y"></param>
    /// <param name="z"></param>
    /// <param name="w"></param>
    public static void SetTransformRotation(Transform trans, float x, float y, float z, float w)
    {
        if(trans)
        {
            trans.rotation = new Quaternion(x, y, z, w);
        }
    }

    /// <summary>
    /// set transform local rotation
    /// </summary>
    /// <param name="trans"></param>
    /// <param name="x"></param>
    /// <param name="y"></param>
    /// <param name="z"></param>
    /// <param name="w"></param>
    public static void SetTransformLocalRotation(Transform trans, float x, float y, float z, float w)
    {
        if (trans)
        {
            //trans.localRotation = new Quaternion(x, y, z, w);
            trans.localEulerAngles = new Quaternion(x, y, z, w).eulerAngles;

        }
    }

    public static void UpdateLocalRotationZ(Transform trans, float x, float y, float z, float w)
    {
        Vector3 old = trans.localEulerAngles;
        Vector3 new_rot = new Quaternion(x, y, z, w).eulerAngles;
        
        old.z = new_rot.z;

        trans.localEulerAngles = old;

    }


    /// <summary>
    /// Get the euler angles of transform
    /// </summary>
    /// <param name="trans">the transform target</param>
    /// <param name="x">the x value of euler angles</param>
    /// <param name="y">the y value of euler angles</param>
    /// <param name="z">the z value of euler angles</param>
    public static void GetTransformEulerAngles(Transform trans, out float x, out float y, out float z)
    {
        if(trans)
        {
            Vector3 tmp = trans.eulerAngles;
            x = tmp.x;
            y = tmp.y;
            z = tmp.z;
        }
        else
        {
            x = 0.0f;
            y = 0.0f;
            z = 0.0f;
            Debug.LogError("transform is null");
        }
    }

    /// <summary>
    /// Set the enlerAngles property of transform
    /// </summary>
    /// <param name="trans">the transform target</param>
    /// <param name="x">the x value of eulerAngles</param>
    /// <param name="y">the y value of eulerAngles</param>
    /// <param name="z">the z value of eulerAngles</param>
    public static void SetTransformEulerAngles(Transform trans, float x, float y, float z)
    {
        if(trans)
        {
            trans.eulerAngles = new Vector3(x, y, z);
        }
        else
        {
            Debug.LogError("transform is null");
        }
    }

    /// <summary>
    /// Get the forward property of transform
    /// </summary>
    /// <param name="trans">then target transform</param>
    /// <param name="x">the x value of forward </param>
    /// <param name="y">the y value of forward</param>
    /// <param name="z">the z value of forward</param>
    public static void GetTransformForward(Transform trans, out float x, out float y, out float z)
    {
        if (trans)
        {
            x = trans.forward.x;
            y = trans.forward.y;
            z = trans.forward.z;
        }
        else
        {
            x = 0.0f;
            y = 0.0f;
            z = 0.0f;
            Debug.LogError("transform is null");
        }
    }

    /// <summary>
    /// Set the forward property of transform
    /// </summary>
    /// <param name="trans">then target transform</param>
    /// <param name="x">the x value of forward </param>
    /// <param name="y">the y value of forward</param>
    /// <param name="z">the z value of forward</param>
    public static void SetTransformForward(Transform trans, float x, float y, float z)
    {
        if(trans)
        {
            trans.forward = new Vector3(x, y, z);
        }
        else
        {
            Debug.LogError("transform is null");
        }
    }

    /// <summary>
    /// Set the localScale property of transform
    /// </summary>
    /// <param name="trans">then target transform</param>
    /// <param name="x">the x value of forward </param>
    /// <param name="y">the y value of forward</param>
    /// <param name="z">the z value of forward</param>
    public static void SetTransformLocalScale(Transform trans, float x, float y, float z)
    {
        if (trans)
        {
            trans.localScale = new Vector3(x, y, z);
        }
        else
        {
            Debug.LogError("transform is null");
        }
    }

    /// <summary>
    /// Get the localScale property of transform
    /// </summary>
    /// <param name="trans">then target transform</param>
    /// <param name="x">the x value of forward </param>
    /// <param name="y">the y value of forward</param>
    /// <param name="z">the z value of forward</param>
    public static void GetTransformLocalScale(Transform trans, out float x, out float y, out float z)
    {
        if (trans)
        {
            x = trans.localScale.x;
            y = trans.localScale.y;
            z = trans.localScale.z;
        }
        else
        {
            x = 0.0f;
            y = 0.0f;
            z = 0.0f;
            Debug.LogError("transform is null");
        }
    }

    /// <summary>
    /// Get the parent of transform
    /// </summary>
    /// <param name="trans">the target transform</param>
    /// <param name="parent">the parent of target transform</param>
    public static void GetTransformParent(Transform trans, out Transform parent)
    {
        if(trans)
        {
            parent = trans.parent;
        }
        else
        {
            parent = null;
            Debug.LogError("transform is null");
        }
    }


    /// <summary>
    /// Set the parent of transform
    /// </summary>
    /// <param name="trans">the target transform</param>
    /// <param name="newParent">the parent of target transform</param>
    public static void SetTransformParent(Transform trans, Transform newParent)
    {
        if(trans)
        {
            if(newParent == null)
            {
                Debug.LogError("the parent is null");
            }
            trans.parent = newParent;
        }
        else
        {
            Debug.LogError("transform is null");
        }
    }

    /// <summary>
    /// set transform look at one transform
    /// </summary>
    /// <param name="trans">self </param>
    /// <param name="target">the target transform</param>
    public static void TransformLookAt(Transform trans, Transform target)
    {
        if(trans == null)
        {
            Debug.LogError("self is null");
            return;
        }

        if(target == null)
        {
            Debug.LogError("Can not look at anything");
            return;
        }

        trans.LookAt(target);
    }

    /// <summary>
    /// set transform look at any direction
    /// </summary>
    /// <param name="trans">self</param>
    /// <param name="x">the x value of direction</param>
    /// <param name="y">the y value of direction</param>
    /// <param name="z">the z value of direction</param>
    public static void TransformLookAtVector(Transform trans, float x, float y, float z)
    {
        if(trans == null)
        {
            Debug.LogError("has self been destoried??");
            return;
        }

        trans.LookAt(new Vector3(x, y, z));
    }

    /// <summary>
    /// Rotate the transform with euler angles
    /// </summary>
    /// <param name="trans">the transform</param>
    /// <param name="x">the x value of eulerAngles</param>
    /// <param name="y">the y value of eulerAngles</param>
    /// <param name="z">the z value of eulerAngles</param>
    public static void TransformRotateWithAngles(Transform trans, float x, float y, float z)
    {
        if(trans)
        {
            trans.Rotate(new Vector3(x, y, z));
        }
        else
        {
            Debug.LogError("transform is null");
        }
    }

    /// <summary>
    /// Rotate the transform with axis and angles
    /// </summary>
    /// <param name="trans">the trans</param>
    /// <param name="axisX">the x value of axis</param>
    /// <param name="axisY">the y value of axis</param>
    /// <param name="axisZ">the z value of axis</param>
    /// <param name="angles">the rotate angles</param>
    public static void TransformRotateWithAxis(Transform trans, float axisX, float axisY, float axisZ, float angles)
    {
        if(trans)
        {
            trans.Rotate(new Vector3(axisX, axisY, axisZ), angles);
        }
        else
        {
            Debug.LogError("transform is null");
        }
    }

    /// <summary>
    /// directly roate the transform
    /// </summary>
    /// <param name="trans">the transform</param>
    /// <param name="x">the x value of the angles</param>
    /// <param name="y">the y value of the angles</param>
    /// <param name="z">the z value of the angles</param>
    public static void TransformRotateDirect(Transform trans, float x, float y, float z)
    {
        if (trans)
        {
            trans.Rotate(x, y, z);
        }
        else
        {
            Debug.LogError("transform is null");
        }
    }

    /// <summary>
    /// Translate the transform with vector3
    /// </summary>
    /// <param name="trans">the transform need to be translated</param>
    /// <param name="x">the x value of translatation vector</param>
    /// <param name="y">the y value of translatation vector</param>
    /// <param name="z">the z value of translatation vector</param>
    public static void TransformTranslateWithVector(Transform trans, float x, float y, float z)
    {
        if(trans)
        {
            trans.Translate(new Vector3(x, y, z));
        }
        else
        {
            Debug.LogError("the transform is null");
        }
    }

    /// <summary>
    /// get transform normalized direction when set the world direction
    /// </summary>
    /// <param name="trans"></param>
    /// <param name="x"></param>
    /// <param name="y"></param>
    /// <param name="z"></param>
    /// <param name="dirX"></param>
    /// <param name="dirY"></param>
    /// <param name="dirZ"></param>
    public static void TransformDirection(Transform trans, float x, float y, float z, out float dirX, out float dirY, out float dirZ)
    {
        if(trans)
        {
            Vector3 tmp =  trans.TransformDirection(new Vector3(x, y, z));
            dirX = tmp.x;
            dirY = tmp.y;
            dirZ = tmp.z;
        }
        else
        {
            dirX = 0;
            dirY = 1;
            dirZ = 0;
            Debug.LogError("the transform is null");
        }
    }
    
    /// <summary>
    /// transform point
    /// </summary>
    /// <param name="trans"></param>
    /// <param name="x"></param>
    /// <param name="y"></param>
    /// <param name="z"></param>
    /// <param name="outX"></param>
    /// <param name="outY"></param>
    /// <param name="outZ"></param>
    public static void TransformPoint(Transform trans, float x, float y, float z, out float outX, out float outY, out float outZ)
    {
        if(trans)
        {
            Vector3 tmp = trans.TransformPoint(new Vector3(x, y, z));
            outX = tmp.x;
            outY = tmp.y;
            outZ = tmp.z;
        }
        else
        {
            outX = 0.0f;
            outY = 0.0f;
            outZ = 0.0f;
            Debug.LogError("Transform is null");
        }
    }

    /// <summary>
    /// Transform vector
    /// </summary>
    /// <param name="trans"></param>
    /// <param name="x"></param>
    /// <param name="y"></param>
    /// <param name="z"></param>
    /// <param name="outX"></param>
    /// <param name="outY"></param>
    /// <param name="outZ"></param>
    public static void TransformVector(Transform trans, float x, float y, float z, out float outX, out float outY, out float outZ)
    {
        if(trans)
        {
            Vector3 tmp = trans.TransformVector(new Vector3(x, y, z));
            outX = tmp.x;
            outY = tmp.y;
            outZ = tmp.z;
        }
        else
        {
            outX = 0.0f;
            outY = 0.0f;
            outZ = 0.0f;
            Debug.LogError("Transform is null");
        }
    }

    /// <summary>
    /// 获取唯一ID
    /// </summary>
    /// <returns></returns>
    public static string GetGuid()
    {
        return Guid.NewGuid().ToString();
    }

    public static Rect NewRect(float x, float y, float width, float height)
    {
        Rect rect = new Rect();
        rect.x = x;
        rect.y = y;
        rect.width = width;
        rect.height = height;
        return rect;
    }

    public static Component GetComponentInChildren(Transform trans,string type)
    {
        //Type t = Type.GetType("UnityEngine.SkinnedMeshRenderer, UnityEngine");
        return trans.GetComponentInChildren(Type.GetType(type));        
    }

    public static void GetComponentsInChildren(Transform trans, string type, out List<Component> components)
    {
        components = null;

        if (trans != null)
        {
           Component[] tmp = trans.GetComponentsInChildren (Type.GetType(type));
            if(tmp != null )
            {
                components = new List<Component>(tmp);
            }
        }
    }

    public static float GetEulerAngle(float axis_x, float axis_y,float axis_z, float dir_x, float dir_y, float dir_z, int angleOf)
    {
        Vector3 axis = new Vector3(axis_x, axis_y, axis_z);
        Vector3 dir = new Vector3(dir_x, dir_y, dir_z);
        Vector3 eulerAngles = Quaternion.LookRotation(axis, dir).eulerAngles;
        float value = 0;
        if (angleOf == 0)
        {
            value = eulerAngles.x;
        }
        else if(angleOf == 1)
        {
            value = eulerAngles.y;
        }
        else if(angleOf == 2)
        {
            value = eulerAngles.z;
        }
        return Mathf.PI / 180 * value;
    }

    public static void SetTransformLocalEulerAngle(Transform trans, float axis_x, float axis_y, float axis_z, float dir_x, float dir_y, float dir_z)
    {
        if (trans == null)
        {
            return;
        }

        Vector3 axis = new Vector3(axis_x, axis_y, axis_z);
        Vector3 dir = new Vector3(dir_x, dir_y, dir_z);
        trans.rotation = Quaternion.LookRotation(axis, dir);
    }

    public static void SetTransformSize(Transform trans, float width, float height)
    {
        if (trans == null)
        {
            return;
        }

        RectTransform rt = trans.GetComponent<RectTransform>();
        if (rt == null)
        {
            return;
        }

       rt.sizeDelta = new Vector2(width, height);

    }

    public static void SetImageColor(Image img, float r, float g, float b, float a)
    {
        if (img == null)
            return;

        img.color = new Color(r, g, b, a);
    }

}
