using UnityEngine;
using System.Collections;

[SLua.CustomLuaClass]
public class ScreenFade : MonoBehaviour
{

    /****************************************************************************************/
    AnimationCurve fadeCurve = new AnimationCurve(new Keyframe(0.0f, 1f), new Keyframe(1.0f, 0f));
    Color fadeColour = Color.black;

    public static Texture2D _texture = null;
    bool drawGUI = false;
    bool fade = false;
    float duration = 0f;

    [SerializeField]
    bool dontDestroy = true;

    void OnDestroy()
    {
        if (_texture)
        {
            DestroyImmediate(_texture);
            _texture = null;
        }
    }

    void Awake()
    {
        if (_texture == null)
        {
            _texture = new Texture2D(1, 1, TextureFormat.ARGB32, false);
        }
        if(dontDestroy)
        {
            GameObject.DontDestroyOnLoad(gameObject);
        }
    }

    void OnGUI()
    {
        if (!drawGUI)
            return;

        if (!_texture)
            return;

        if (Event.current.type.Equals(EventType.Repaint))
        {
            GL.PushMatrix();
            GL.LoadOrtho();
            Graphics.DrawTexture(new Rect(0, 0, 1, 1), _texture);
            GL.PopMatrix();
        }
    }

    void Update()
    {
        if (!drawGUI)
            return;

        if (!fade)
            return;

        if (!_texture)
            return;

        if (duration >= fadeCurve.keys[fadeCurve.length - 1].time)
        {
            DisableFade();
            return;
        }

        UpdateFade();
    }

    public void EnableFade(float delay)
    {
        enabled = true;
        
        StartCoroutine(EnableFade_(delay));
    }

    IEnumerator EnableFade_(float delay)
    {
        drawGUI = true;

        float initAlpah = fadeCurve.Evaluate(0.0f);
        _texture.SetPixel(0, 0, new Color(fadeColour.r, fadeColour.g, fadeColour.b, initAlpah));
        _texture.Apply();

        yield return new WaitForSeconds(delay);

        fade = true;
        duration = 0;
    }

    void UpdateFade()
    {
        duration += Time.unscaledDeltaTime;

        if (!_texture)
            return;

        float alpha = fadeCurve.Evaluate(duration);
        _texture.SetPixel(0, 0, new Color(fadeColour.r, fadeColour.g, fadeColour.b, alpha));
        _texture.Apply();
    }

    public void DisableFade()
    {
        drawGUI = false;
        fade = false;
        duration = 0;

        enabled = false;
    }
}
