using UnityEngine;
using UnityEngine.Events;
using System.Collections.Generic;
using System.Collections;
using System.IO;
using System.Text;

namespace CustomTool
{

    [SLua.CustomLuaClass]
	public class FileSystem
    {

        private static string _dirctoryPath = null;
        public static string directoryPath 
        {
            get
            {
                if(_dirctoryPath != null)
                {
                    return _dirctoryPath;
                }


                if (string.IsNullOrEmpty(Application.persistentDataPath) == false)
                {
                    _dirctoryPath = Application.persistentDataPath;
                    return _dirctoryPath;
                }
                else if(string.IsNullOrEmpty(Application.temporaryCachePath) == false)
                {
                    _dirctoryPath = Application.temporaryCachePath;
                    return _dirctoryPath;
                }
                Debug.LogError("[CustomTool]:: Can not find the save directory");
                _dirctoryPath = "";
                return _dirctoryPath;
            }
            set
            {

            }
        }

        /// <summary>
        /// local bundle path. readonly
        /// </summary>
        public static string bundleLocalPath
        {
            get
            {
                string localBundlePath = directoryPath + "/Assets";
                if(Directory.Exists(localBundlePath) == false)
                {
                    Directory.CreateDirectory(localBundlePath);
                }

                return localBundlePath;
            }
        }

        /// <summary>
        /// screenshot file directory
        /// </summary>
        public static string screenshotPath
        {
            get
            {
                string path = directoryPath + "/screen";
                if (Directory.Exists(path) == false)
                {
                    Directory.CreateDirectory(path);
                }

                return path;
            }
        }
       
        public static string logPath
        {
            get
            {
                string path = directoryPath + "/logs";
                if (Directory.Exists(path) == false)
                {
                    Directory.CreateDirectory(path);
                }

                return path;
            }
        }
        /// <summary>
        /// head icon path. readonly
        /// </summary>
        public static string headIconPath
        {
            get
            {
                string headIconPath = directoryPath + "/icons";
                if (Directory.Exists(headIconPath) == false)
                {
                    Directory.CreateDirectory(headIconPath);
                }
                return headIconPath;
            }
        }

		/// @Brief	: 递归创建目录结构
		/// @Param	: InDir	最终的目录结构
		/// @Return	: NONE
		public static void CreatePath(string InDir)
        {
			DirectoryInfo CurDir = new DirectoryInfo(InDir);
			if (CurDir.Exists) return;
			if (!CurDir.Parent.Exists)
                CreatePath(CurDir.Parent.FullName);
			CurDir.Create();
		}

		/// @Brief	: 清空目录下的所有文件/文件夹
		/// @Param	: InDir			指定的目录
		/// @Param	: InDeleteSelf	是否删除自己（目录本身）
		/// @Param	: NONE
		public static void ClearPath(string InDir, bool InDeleteSelf)
        {
			DirectoryInfo TargetDir	= new DirectoryInfo(InDir);
			DirectoryInfo[] SubDirs	= TargetDir.GetDirectories();
			FileInfo[] SubFiles		= TargetDir.GetFiles(); 

			foreach(var SubDir in SubDirs) ClearPath(SubDir.FullName, true);
            foreach (var SubFile in SubFiles)  SubFile.Delete();

			if (InDeleteSelf) TargetDir.Delete();
		}

        public static void ClearFilesSkipExtend(string inDir, string extend)
        {
            DirectoryInfo TargetDir = new DirectoryInfo(inDir);
            DirectoryInfo[] SubDirs = TargetDir.GetDirectories();
            FileInfo[] SubFiles = TargetDir.GetFiles();

            foreach (var SubDir in SubDirs)
            {
                ClearPath(SubDir.FullName, true);
            }
            foreach (var SubFile in SubFiles)
            {
                if (SubFile.Name.EndsWith(extend))
                    continue;
                SubFile.Delete();
            }
        }

        /// @Brief	: 得到不同平台下StreamingAssets的路径
        /// @Param	: NONE
        /// @Return	: 绝对路径
        public static string GetStreamingPath() {
			if (Application.platform == RuntimePlatform.Android)
            {
				return "jar:file://" + Application.dataPath + "!/assets/";
			}
            else if (Application.platform == RuntimePlatform.IPhonePlayer)
            {
				return "file://" + Application.dataPath + "/Raw/";
			}
            else
            {
				return "file://" + Application.dataPath + "/StreamingAssets/";
			}
		}

		/// @Brief	: 得到不同平台下的Data数据文件存放位置
		/// @Param	: NONE
		/// @Return	: 返回数据存放路径
		public static string GetDataPath()
        {
			if (Application.platform == RuntimePlatform.WindowsEditor || Application.platform == RuntimePlatform.OSXEditor)
				return Application.dataPath + "/";

			return Application.persistentDataPath + "/";
		}

		/// @Brief	: 格式化一个地址
		/// @Param	: InPath	指定地址
		/// @Return	: 返回格式化的Url
		public static string FormatUrl(string InPath)
        {
			System.Uri Holder = null;

			if (Directory.Exists(InPath) || File.Exists(InPath))
            {
				Holder = new System.Uri(Path.GetFullPath(InPath));
			}
            else
            {
				try
                {
					Holder = new System.Uri(InPath);
				}
                catch
                {
					return InPath;
				}
			}

			return Holder.AbsoluteUri;
		}

		/// @Brief	: 异步加载一个文件
		/// @Param	: InPath	加载文件的路径或URL
		/// @Param	: OnLoaded	加载完成回调
		/// @Return	: NONE
		public static IEnumerator FetchFile(string InPath, UnityAction<WWW> OnLoaded)
        {
			if (Application.platform == RuntimePlatform.WindowsEditor && !InPath.Contains("://"))
				InPath = "file://" + InPath;

			WWW Content = new WWW(InPath);
			yield return Content;

			if (OnLoaded != null)
                OnLoaded.Invoke(Content);
			Content.Dispose();
		}

        public static void ReplaceFileBytes(string inPath, byte[] inContent)
        {
            FileStream Writer = new FileStream(inPath, FileMode.Create);
            Writer.Write(inContent, 0, inContent.Length);
            Writer.Flush();
            Writer.Close();
        }

		/// @Brief	: 覆盖一个文件的内容，或创建一个新的文件
		/// @Param	: InPath	文件路径
		/// @Param	: InContent	文件内容
		/// @Return	: NONE
		public static void ReplaceFile(string InPath, string InContent)
        {
			FileStream Writer = new FileStream(InPath, FileMode.Create);
			byte[] Content = Encoding.UTF8.GetBytes(InContent);
			Writer.Write(Content, 0, Content.Length);
			Writer.Flush();
			Writer.Close();
		}

		/// @Brief	: 得到平台的名称
		/// @Param	: NONE
		/// @Return	: 返回平台的名称
		public static string CurrentPlatform()
        {
            BuildPlatform CurPlatform;

            if (Application.platform == RuntimePlatform.WindowsPlayer || Application.platform == RuntimePlatform.OSXPlayer)
            {
                CurPlatform = BuildPlatform.Standalones;
            }
            else if (Application.platform == RuntimePlatform.IPhonePlayer)
            {
                CurPlatform = BuildPlatform.IOS;
            }
            else if (Application.platform == RuntimePlatform.Android)
            {
                CurPlatform = BuildPlatform.Android;
            }
            else
            {
                CurPlatform = BuildPlatform.Standalones;
            }

            return CurPlatform.ToString();
		}

        /// <summary>
        /// 得到指定目录下的子文件
        /// </summary>
        /// <returns>子文件列表</returns>
        /// <param name="InRootPath">指定的目录路径</param>
        public static List<string> GetSubFiles(string InRootPath)
        {
            List<string> Result = new List<string>();
            if (!Directory.Exists(InRootPath)) return Result;

            DirectoryInfo RootInfo = new DirectoryInfo(InRootPath);
            DirectoryInfo[] SubInfos = RootInfo.GetDirectories();
            FileInfo[] SubFiles = RootInfo.GetFiles();

            foreach (var Info in SubFiles)
            {
                if (Info.Extension.EndsWith("meta")) continue;
                string PathOf = Info.FullName.Replace("\\", "/");
                string RootOf = Path.GetFullPath(InRootPath).Replace("\\", "/");
                Result.Add(PathOf.Substring(RootOf.Length + 1));
            }

            foreach (var Info in SubInfos)
            {
                List<string> SubFilesInSubDir = GetSubFiles(Info.FullName);
                foreach (var SubFileName in SubFilesInSubDir)
                    Result.Add(Info.Name + "/" + SubFileName);
            }

            return Result;
        }

        /// <summary>
        /// 得到指定目录下的一级子文件夹
        /// </summary>
        /// <returns>一级子文件夹列表</returns>
        /// <param name="InRootPath">指定的目录路径</param>
        public static List<string> GetSubFolders(string InRootPath)
        {
            List<string> Result = new List<string>();
            if (!Directory.Exists(InRootPath)) return Result;

            DirectoryInfo RootInfo = new DirectoryInfo(InRootPath);
            DirectoryInfo[] SubInfos = RootInfo.GetDirectories();

            foreach (var Info in SubInfos) Result.Add(Info.Name);

            return Result;
        }

        /// <summary>
        /// 文件是否存在
        /// </summary>
        /// <param name="path"></param>
        /// <returns></returns>
        public static bool Exist(string path)
        {
            return File.Exists(path);
        }

        public static bool CopyFile(string inPath, string outPath)
        {
            bool bSuccess = false;
            if (string.IsNullOrEmpty(inPath) || string.IsNullOrEmpty(outPath))
            {
                return bSuccess;
            }

            if(File.Exists(inPath))
            {
                byte[] btes = File.ReadAllBytes(inPath);
                ReplaceFileBytes(outPath, btes);
                File.Delete(inPath);
                bSuccess = true;
            }
            return bSuccess;
        }

    }

}
