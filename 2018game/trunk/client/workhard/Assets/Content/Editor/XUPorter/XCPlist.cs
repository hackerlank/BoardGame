using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;

namespace UnityEditor.XCodeEditor 
{
	public class XCPlist
	{
		string plistPath;
		bool plistModified;

		// URLTypes constant --- plist
		const string BundleUrlTypes = "CFBundleURLTypes";
		const string BundleTypeRole = "CFBundleTypeRole";
		const string BundleUrlName = "CFBundleURLName";
		const string BundleUrlSchemes = "CFBundleURLSchemes";
        const string BundleIdentifier = "CFBundleIdentifier";

		// URLTypes constant --- projmods
		const string PlistUrlType = "urltype";
		const string PlistRole = "role";
		const string PlistEditor = "Editor";
		const string PlistName = "name";
		const string PlistSchemes = "schemes";

		public XCPlist(string plistPath)
		{
			this.plistPath = plistPath;
		}

		public void Process(Hashtable plist)
		{
			if (plist == null)
				return;

			Dictionary<string, object> dict = (Dictionary<string, object>)PlistCS.Plist.readPlist(plistPath);
			foreach( DictionaryEntry entry in plist)
			{
				this.AddPlistItems((string)entry.Key, entry.Value, dict);
			}
			if (plistModified)
			{
				PlistCS.Plist.writeXml(dict, plistPath);
			}
		}

		public void OverrideBundleIdentifier(string identifier)
		{
			Dictionary<string, object> dict = (Dictionary<string, object>)PlistCS.Plist.readPlist(plistPath);

            if (dict.ContainsKey(BundleIdentifier))
            {
                dict[BundleIdentifier] = identifier;
            }
            else
            {
                dict.Add(BundleIdentifier, identifier);
            }
            PlistCS.Plist.writeXml(dict, plistPath);

            Debug.Log("Override bundle identifier.... " + identifier);
		}

        public void RegisterSinglePlistItem(string key, object value)
        {
            Dictionary<string, object> dict = (Dictionary<string, object>)PlistCS.Plist.readPlist(plistPath);

            if (dict.ContainsKey(key))
            {
                dict[BundleIdentifier] = value;
            }
            else
            {
                dict.Add(key, value);
            }
            PlistCS.Plist.writeXml(dict, plistPath);
        }

        public void AddPlistItem(string key, Dictionary<string, object> dic)
        {
            Dictionary<string, object> dict = (Dictionary<string, object>)PlistCS.Plist.readPlist(plistPath);

            if (dict.ContainsKey(key))
            {
                dict[key] = dic;
            }
            else
            {
                dict.Add(key, dic);
            }
            PlistCS.Plist.writeXml(dict, plistPath);
        }

		public void AddPlistItems(string key, object value, Dictionary<string, object> dict)
		{
			Debug.Log ("AddPlistItems: key=" + key);
			
			if (key.CompareTo(PlistUrlType) == 0)
			{
				processUrlTypes((ArrayList)value, dict);
			}
			else
			{
				Debug.LogWarning("unknown plist key : " + key);
			}
		}

		private void processUrlTypes(ArrayList urltypes, Dictionary<string, object> dict)
		{
			List<object> bundleUrlTypes;
			if (dict.ContainsKey(BundleUrlTypes))
			{
				bundleUrlTypes = (List<object>)dict[BundleUrlTypes];
			}
			else
			{
				bundleUrlTypes = new List<object>();
			}
			
			foreach(Hashtable table in urltypes)
			{
				string role = (string)table[PlistRole];
				if (string.IsNullOrEmpty(role))
				{
					role = PlistEditor;
				}
				string name = (string)table[PlistName];
				ArrayList shcemes = (ArrayList)table[PlistSchemes];
				
				// new schemes
				List<object> urlTypeSchemes = new List<object>();
				foreach(string s in shcemes)
				{
					urlTypeSchemes.Add(s);
				}
				
				Dictionary<string, object> urlTypeDict = this.findUrlTypeByName(bundleUrlTypes, name);
				if (urlTypeDict == null)
				{
					urlTypeDict = new Dictionary<string, object>();
					urlTypeDict[BundleTypeRole] = role;
					urlTypeDict[BundleUrlName] = name;
					urlTypeDict[BundleUrlSchemes] = urlTypeSchemes;
					bundleUrlTypes.Add(urlTypeDict);
				}
				else
				{
					urlTypeDict[BundleTypeRole] = role;
					urlTypeDict[BundleUrlSchemes] = urlTypeSchemes;
				}
				plistModified = true;
			}
			dict[BundleUrlTypes] = bundleUrlTypes;
		}
		
		private Dictionary<string, object> findUrlTypeByName(List<object> bundleUrlTypes, string name)
		{
			if ((bundleUrlTypes == null) || (bundleUrlTypes.Count == 0))
				return null;
			
			foreach(Dictionary<string, object> dict in bundleUrlTypes)
			{
				string _n = (string)dict[BundleUrlName];
				if (string.Compare(_n, name) == 0)
				{
					return dict;
				}
			}
			return null;
		}
	}
}
