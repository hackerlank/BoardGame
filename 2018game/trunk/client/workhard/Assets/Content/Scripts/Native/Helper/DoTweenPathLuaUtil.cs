using DG.Tweening;
using System;
using UnityEngine;
using UnityEngine.UI;

[SLua.CustomLuaClass]
public class DoTweenPathLuaUtil
{
    public delegate void onWayPointChanged(int idx);

    static public DG.Tweening.Core.TweenerCore<Vector3, DG.Tweening.Plugins.Core.PathCore.Path, DG.Tweening.Plugins.Options.PathOptions> DOPath(Transform trans, Vector3[] waypoints, float speed, PathType pathType, PathMode pathMode, int resolution = 10, Color? gizmoColor = default(Color?))
    {
        return trans.DOPath(waypoints, speed, pathType, pathMode, resolution, gizmoColor);
    }
    static public void SetEase(DG.Tweening.Core.TweenerCore<Vector3, DG.Tweening.Plugins.Core.PathCore.Path, DG.Tweening.Plugins.Options.PathOptions> tween, Ease ease)
    {
        //Ease ea = (Ease)ease;
        tween.SetEase(ease);
    }

    static public Tweener DOScaleX(Transform trans, float endValue, float duration)
    {
        if (trans == null)
            return null;
        return trans.DOScaleX(endValue, duration);
    }

    static public Tweener DOMove(Transform trans, Vector3 endPos, float duration)
    {
        if (trans == null)
            return null;
        return trans.DOMove(endPos, duration);
    }

    static public Tweener DoRotation(Transform trans, float x, float y, float z, float duration, RotateMode mode)
    {
        if (trans == null)
            return null;
        Vector3 endRotation = new Vector3(x, y, z);
        return trans.DORotate(endRotation, duration, mode);
    }

    static public Tweener DoLocalRotation(Transform trans, float x, float y, float z, float duration)
    {
        if (trans == null)
            return null;
        Vector3 endRotation = new Vector3(x, y, z);
        return trans.DOLocalRotate(endRotation, duration);
    }

    static public Tweener DoScale(Transform trans, float x, float y, float z, float duration)
    {
        if (trans == null)
            return null;
        Vector3 endValue = new Vector3(x, y, z);
        return trans.DOScale(endValue, duration);
    }

    static public Tweener DOMoveX(Transform trans, float endValue, float duration)
    {
        if (trans == null)
            return null;

        return trans.DOMoveX( endValue, duration);

    }

    static public Tweener DOLocalMove(Transform trans, Vector3 endPos, float duration)
    {
        if (trans == null)
            return null;

        return trans.DOLocalMove(endPos, duration);

    }

    static public Tweener DOLocalMoveY(Transform trans, float endValue, float duration)
    {
        if (trans == null)
            return null;
        return trans.DOLocalMoveY(endValue, duration).SetEase(Ease.Linear);
    }

    static public void SetRelative(DG.Tweening.Core.TweenerCore<Vector3, DG.Tweening.Plugins.Core.PathCore.Path, DG.Tweening.Plugins.Options.PathOptions> tween)
    {
        if(tween != null)
            tween.SetRelative();
    }

    static public Tweener DOLocalMoveX(Transform trans, float endValue, float duration)
    {
        if (trans == null)
            return null;
        return trans.DOLocalMoveX(endValue, duration).SetEase(Ease.Linear);
    }
    static public void SetLookAt(DG.Tweening.Core.TweenerCore<Vector3, DG.Tweening.Plugins.Core.PathCore.Path, DG.Tweening.Plugins.Options.PathOptions> tween, float lookAhead, Vector3? forwardDirection = default(Vector3?), Vector3? up = default(Vector3?))
    {
        tween.SetLookAt(lookAhead, forwardDirection, up);
    }

    static public void SetLookAtPosition(DG.Tweening.Core.TweenerCore<Vector3, DG.Tweening.Plugins.Core.PathCore.Path, DG.Tweening.Plugins.Options.PathOptions> tween, float x, float y, float z, Vector3? forwardDirection = default(Vector3?), Vector3? up = default(Vector3?))
    {

        tween.SetLookAt(new Vector3(x, y, z), forwardDirection, up);
    }

    static public void SetSpeedBased(Tween tween, bool isSpeedBased)
    {
        tween.SetSpeedBased(isSpeedBased);
    }
    static public void SetAutoKill(Tween tween, bool autoKillOnCompletion)
    {
        tween.SetAutoKill(autoKillOnCompletion);
    }
    static public void SetRecyclable(Tween tween, bool bRecyclable)
    {
        if (tween != null)
        {
            tween.SetRecyclable(bRecyclable);
        }
    }

    static public void Kill(Tween tween, bool complete)
    {
        tween.Kill(complete);
    }

    static public bool IsActive(Tween tween)
    {
        return tween.IsActive();
    }

    static public bool IsPlaying(Tween tween)
    {
        return tween.IsPlaying();
    }

    static public void DOPause(Transform trans)
    {
        trans.DOPause();
    }

    static public void SetEaseTweener(Tween tween, Ease ease)
    {
        if(tween != null)
        {
            tween.SetEase(ease);
        }
    }

    static public void OnComplete(Tween tween, System.Action fnOnComplete)
    {
        tween.OnComplete(() =>
        {
            if (fnOnComplete != null)
            {
                fnOnComplete();
            }
        });
    }

    static public void OnRewind(Tween tween, System.Action fnOnRewind)
    {
        if(tween != null)
        {
            tween.OnRewind(() =>
            {
                if (fnOnRewind != null)
                {
                    fnOnRewind();
                }
            });
        }
    }

    static public void DORewind(Transform trans)
    {
        if (trans == null)
            return;

        trans.DORewind();
    }

    static public void DOPlay(Transform trans)
    {
        trans.DOPlay();
    }

    static public void DORestart(Transform trans)
    {
        if (trans == null)
            return;
        trans.DORestart();
    }

    static public void SetLoop(Tween tween, int loopTimes, LoopType loopType)
    {
        if(tween != null )
        {
            tween.SetLoops(loopTimes, loopType); 
        }
    }

    static public void SetOptions(DG.Tweening.Core.TweenerCore<Vector3, DG.Tweening.Plugins.Core.PathCore.Path, DG.Tweening.Plugins.Options.PathOptions> tween,bool bclosepath, AxisConstraint lockPosition, AxisConstraint lockRotation)
    {
        tween.SetOptions(bclosepath,lockPosition, lockRotation);
    }

    static public void DOPlayBackwards(Transform trans)
    {
        if(trans != null)
        {
            trans.DOPlayBackwards();
        }
    }

    static public Tweener DoColor(Image img, float duration, float r, float g, float b, float a)
    {
        if(img == null)
        {
            return null;
        }

        return img.DOColor(new Color(r, g, b, a), duration);
    }


    #region PathLerp
    static public Vector3[] PathLerp(Vector3[] wps)
    {
        int wpsCount = wps.Length;
        Vector3[] nonLinearDrawWps = null;
        int gizmosSubdivisions = wpsCount * 10;
        if (nonLinearDrawWps == null || nonLinearDrawWps.Length != gizmosSubdivisions + 1)
            nonLinearDrawWps = new Vector3[gizmosSubdivisions + 1];
        for (int i = 0; i <= gizmosSubdivisions; ++i)
        {
            float perc = i / (float)gizmosSubdivisions;
            Vector3 wp = GetPoint(perc, wps);
            nonLinearDrawWps[i] = wp;
        }
        return nonLinearDrawWps;
    }
    static private Vector3 GetPoint(float perc, Vector3[] wps, bool convertToConstantPerc = false)
    {
        ControlPoint[] controlPoints = CreateControlPoint(wps);
        return decoderGetPoint(perc, wps, controlPoints);
    }

    static private Vector3 decoderGetPoint(float perc, Vector3[] wps, ControlPoint[] controlPoints)
    {
        int numSections = wps.Length - 1; // Considering also control points
        int tSec = (int)Math.Floor(perc * numSections);
        int currPt = numSections - 1;
        if (currPt > tSec) currPt = tSec;
        float u = perc * numSections - currPt;

        Vector3 a = currPt == 0 ? controlPoints[0].a : wps[currPt - 1];
        Vector3 b = wps[currPt];
        Vector3 c = wps[currPt + 1];
        Vector3 d = currPt + 2 > wps.Length - 1 ? controlPoints[1].a : wps[currPt + 2];

        return .5f * (
            (-a + 3f * b - 3f * c + d) * (u * u * u)
            + (2f * a - 5f * b + 4f * c - d) * (u * u)
            + (-a + c) * u
            + 2f * b
        );
    }

    static private ControlPoint[] CreateControlPoint(Vector3[] wps)
    {
        ControlPoint[] controlPoints = null;
        int wpsLen = wps.Length;
        if (controlPoints == null || controlPoints.Length != 2) controlPoints = new ControlPoint[2];

        controlPoints[0] = new ControlPoint(wps[1], Vector3.zero);
        Vector3 lastP = wps[wpsLen - 1];
        Vector3 diffV = lastP - wps[wpsLen - 2];
        controlPoints[1] = new ControlPoint(lastP + diffV, Vector3.zero);
        return controlPoints;
    }

    public struct ControlPoint
    {
        public Vector3 a, b;

        public ControlPoint(Vector3 a, Vector3 b)
        {
            this.a = a;
            this.b = b;
        }

        public static ControlPoint operator +(ControlPoint cp, Vector3 v)
        {
            return new ControlPoint(cp.a + v, cp.b + v);
        }
    }
    

    public static void OnWaypointChanged(DG.Tweening.Core.TweenerCore<Vector3, DG.Tweening.Plugins.Core.PathCore.Path, DG.Tweening.Plugins.Options.PathOptions> tween,System.Action<int> cb)
    {

        tween.OnWaypointChange( (idx) =>
        {
           if (cb != null)
            {
                cb(idx);
            }
        });

    }
    #endregion
}
