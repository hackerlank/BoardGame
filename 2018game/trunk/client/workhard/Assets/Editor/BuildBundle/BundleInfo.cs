using UnityEngine;
using System.Collections.Generic;

//namespace CustomTool
//{
    public class BundleInfo : ScriptableObject
    {
        public List<Element> ListOfBundles = new List<Element>();

        public bool bToStreamingAsset = false;

        public int gameType = 0; //0 means common bundles

        [System.Serializable]
        public enum BundleMode : int
        {
            SeparateSubFile = 0,
            SeparateSubFolder = 1,
            AllInOne = 2,
            SingleFile = 3,
            SceneBundle = 4,
        }

        [System.Serializable]
        public class Element
        {
            public string Name = null;
            public BundleMode Mode = BundleMode.AllInOne;
            public string Path = null;
            public bool bEncrypt = false;
            public bool bCopy = false;
            public string gameName = "Common";
        }

    }
//}
