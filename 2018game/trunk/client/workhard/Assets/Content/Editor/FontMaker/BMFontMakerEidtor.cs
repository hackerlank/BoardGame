using UnityEngine;
using UnityEditor;
using UnityEditor.Animations;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;

/// <summary>
/// 字体
/// </summary>
public class BMFontMakeEditor
{
    /// <summary>
    /// 生成自定义字体
    /// </summary>

    [MenuItem("CustomTool/Font/MakeFont")]
    public static void GenCustom()
    {
        string root_path = "Assets/Content/ArtWork/Fonts";
        List<string> pathArr_ = CustomTool.FileSystem.GetSubFiles(root_path);
        List<string> pathArr = new List<string>();
        foreach(string path in pathArr_)
        {
            string extend = path.Substring(path.LastIndexOf("."), path.Length - path.LastIndexOf("."));

            if (extend == ".fnt")
            {
                pathArr.Add(string.Format("{0}/{1}", root_path, path));
               
            }
        }

        foreach (string fntPath in pathArr)
        {
            string path = fntPath.Substring(0, fntPath.LastIndexOf("."));
            string name = fntPath.Substring(fntPath.LastIndexOf("/") + 1, fntPath.LastIndexOf(".") - fntPath.LastIndexOf("/") - 1);
            Debug.Log("building font " + path);
            // 创建材质
            Texture fontTex = AssetDatabase.LoadAssetAtPath<Texture>(path + "_0.png");
            if (fontTex == null)
                return;

            Material fontMtl = new Material(Shader.Find("GUI/Text Shader"));
            fontMtl.SetTexture("_MainTex", fontTex);

            AssetDatabase.CreateAsset(fontMtl, path + ".mat");

            // 加载字符信息
            List<CharacterInfo> charList = new List<CharacterInfo>();

            StreamReader sr = new StreamReader(new FileStream(fntPath, FileMode.Open));

            Regex reg1 = new Regex(@"char id=(?<id>\d+)\s+x=(?<x>\d+)\s+y=(?<y>\d+)\s+width=(?<width>\d+)\s+height=(?<height>\d+)\s+xoffset=(?<xoffset>\d+)\s+yoffset=(?<yoffset>\d+)\s+xadvance=(?<xadvance>\d+)\s+");
            Regex reg2 = new Regex(@"common lineHeight=(?<lineHeight>\d+)\s+.*scaleW=(?<scaleW>\d+)\s+scaleH=(?<scaleH>\d+)");
            int texWidth = 1;
            int texHeight = 1;
            string strLine = sr.ReadLine();
            while (strLine != null)
            {
                if (strLine.Contains("char id="))
                {
                    Match match = reg1.Match(strLine);
                    if (match != Match.Empty)
                    {
                        var id = System.Convert.ToInt32(match.Groups["id"].Value);
                        var x = System.Convert.ToInt32(match.Groups["x"].Value);
                        var y = System.Convert.ToInt32(match.Groups["y"].Value);
                        var width = System.Convert.ToInt32(match.Groups["width"].Value);
                        var height = System.Convert.ToInt32(match.Groups["height"].Value);
                        var xoffset = System.Convert.ToInt32(match.Groups["xoffset"].Value);
                        var yoffset = System.Convert.ToInt32(match.Groups["yoffset"].Value);
                        var xadvance = System.Convert.ToInt32(match.Groups["xadvance"].Value);

                        float uvx = 1f * x / texWidth;
                        float uvy = 1 - (1f * y / texHeight);
                        float uvw = 1f * width / texWidth;
                        float uvh = -1f * height / texHeight;

                        CharacterInfo info = new CharacterInfo();
                        info.index = id;
                        info.uvBottomLeft = new Vector2(uvx, uvy);
                        info.uvBottomRight = new Vector2(uvx + uvw, uvy);
                        info.uvTopLeft = new Vector2(uvx, uvy + uvh);
                        info.uvTopRight = new Vector2(uvx + uvw, uvy + uvh);
                        info.minX = xoffset;
                        info.minY = yoffset + height / 2;
                        info.glyphWidth = width;
                        info.glyphHeight = -height;
                        info.advance = xadvance;

                        charList.Add(info);
                    }
                }
                else if (strLine.Contains("scaleW="))
                {
                    Match match = reg2.Match(strLine);
                    if (match != Match.Empty)
                    {
                        //lineHeight = System.Convert.ToInt32(match.Groups["lineHeight"].Value);
                        texWidth = System.Convert.ToInt32(match.Groups["scaleW"].Value);
                        texHeight = System.Convert.ToInt32(match.Groups["scaleH"].Value);
                    }
                }

                strLine = sr.ReadLine();
            }


            // 创建字体
            Font font = AssetDatabase.LoadAssetAtPath<Font>(path + ".fontsettings");
            if (font == null)
            {
                font = new Font(name);
                font.material = AssetDatabase.LoadAssetAtPath<Material>(path + ".mat");
                font.characterInfo = charList.ToArray();
                AssetDatabase.CreateAsset(font, path + ".fontsettings");
                AssetDatabase.SaveAssets();
            }
            else
            {
                font.material = AssetDatabase.LoadAssetAtPath<Material>(path + ".mat");
                font.characterInfo = charList.ToArray();
                AssetDatabase.ImportAsset(path + ".fontsettings", ImportAssetOptions.ForceUpdate);
                AssetDatabase.SaveAssets();
            }
        }

        AssetDatabase.Refresh();

        Debug.Log("EditorFont -> GenCustomFont done!");
    }
}