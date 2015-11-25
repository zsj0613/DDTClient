package ddt.manager
{
	import ddt.data.EquipType;
	import ddt.data.PathInfo;
	import ddt.view.sceneCharacter.SceneCharacterLoaderPath;
	

	public class PathManager 
	{
		private static var info:PathInfo;
		public static var SITE_MAIN:String = "";
		public static function setup(i:PathInfo):void
		{
			info = i;
			SITE_MAIN = info.SITE;
		}
		public static function solvePhpPath() : String
		{
			return info.PHP_PATH;
		}
		
		public static function solveLanguagePath():String
		{
			return SITE_MAIN+"language.txt";
		}
		public static function solveSWFPath():String
		{
			return info.SWF_PATH;
		}
		public static function solveXMLPath():String
		{
			return info.XML_PATH;
		}
		
		
		/**
		 * 游戏官网
		 * */
		public static function solveOfficialSitePath():String
		{
			info.OFFICIAL_SITE = info.OFFICIAL_SITE.replace("{uid}",PlayerManager.Instance.Self.ID);
			return info.OFFICIAL_SITE;
		}
		
		/**
		 * 游戏论坛
		 * */
		public static function solveGameForum():String
		{
			info.GAME_FORUM = info.GAME_FORUM.replace("{uid}",PlayerManager.Instance.Self.ID);
			return info.GAME_FORUM;
		}
		/**
		 * 加为社区好友
		 */
		public static function get solveCommunityFriend() : String
		{
			var path : String = info.COMMUNITY_FRIEND_PATH;
			return path;
		}
		public static function solveWebPlayerInfoPath(uid:String,code:String="",key:String="") : String
		{
		    var url : String = info.WEB_PLAYER_INFO_PATH.replace("{uid}",uid);
		    url = url.replace("{code}",code);
		    url = url.replace("{key}",key);
			return url; 
		}
		public static function solveFlvSound(id:String):String
		{
			return info.SITE + "sound/" + id + ".flv";
		}
		
		public static function solveFirstPage():String
		{
			return info.FIRSTPAGE;
		}
		
		public static function solveRegister():String
		{
			return info.REGISTER;
		}
		/**
		 * 返回登录页
		 */
		public static function solveLogin():String
		{
			info.LOGIN_PATH = info.LOGIN_PATH.replace("{nickName}",PlayerManager.Instance.Self.NickName);
			info.LOGIN_PATH = info.LOGIN_PATH.replace("{uid}",PlayerManager.Instance.Self.ID);
			return info.LOGIN_PATH;
		}
		public static function solveConfigSite() : String
		{
			return info.SITEII;
		}
		
		public static function solveFillPage():String
		{
			info.FILL_PATH = info.FILL_PATH.replace("{nickName}",PlayerManager.Instance.Self.NickName);
			info.FILL_PATH = info.FILL_PATH.replace("{uid}",PlayerManager.Instance.Self.ID);
			return info.FILL_PATH;
		}
		/**
		 *客户端下载
		 * 
		 */
		public static function solveClienDownLoading():String
		{
			if(info.CLIENT_DOWNLOAD == null)info.CLIENT_DOWNLOAD = "";
		 	return info.CLIENT_DOWNLOAD;
		}
		
		public static function hasClientDownland():Boolean
		{
			return (info.CLIENT_DOWNLOAD != null && info.CLIENT_DOWNLOAD != "");
		}
				
		public static function solveLoginPHP($loginName : String) : String
		{
			return info.PHP_PATH.replace("{id}",$loginName);
			
		}
		public static function checkOpenPHP() : Boolean
		{
			return info.PHP_IMAGE_LINK;
		}
		public static function solveTrainerPage():String
		{
			return info.TRAINER_PATH;
		}
		
		/**
		 * 
		 * @param path 套图名
		 * @param type 图片类型("back"背景图  “fore”前景图  "small"预览图)
		 * @return 
		 * 
		 */		
		public static function solveMapPath(id:int,name:String,type:String):String
		{
			return info.SITE + "image/map/" + id.toString() + "/" + name + "." + type;
		}
		
		public static function solveMapSmallView(id:int):String
		{
			return info.SITE + "image/map/"+id.toString()+"/small.png";
		}
		
//		public static function solveMapIcon(id:int):String
//		{
//			return info.SITE + "image/map/"+id.toString()+"/icon.png";
//		}
		
		
		public static function solveRequestPath(path:String):String
		{
			return info.REQUEST_PATH + path;
		}
		public static function solvePropPath(path:String):String
		{
			return info.SITE + "image/tool/" + path + ".png";
		}
		
		/**
		 * 获取地图图标地址
		 * tollgate : 第几关
		 *   */
		 public static  function solveMapIconPath(id:int,type:int,missionPic:String="show1.jpg"):String
		 {
		 	var path:String = "";
		 	if(type == 0)
		 	{
		 		path = info.SITE + "image/map/"+id.toString()+"/icon.png";
		 	}else if(type == 1)
		 	{
		 		path = info.SITE + "image/map/"+id.toString()+"/samll_map.png";
		 	}else if(type == 2)
		 	{
		 		path = info.SITE + "image/map/"+id.toString()+"/"+missionPic;
		 	}
		 	else if(type == 3)
		 	{
		 		path = info.SITE + "image/map/"+id.toString()+"/samll_map_s.jpg";
		 	}
		 	
		 	return path;
		 }
		 
		 public static function solveEffortIconPath(iconUrl:String):String
		 {
			 var path:String = "";
			 path = info.SITE + "image/effort/" + iconUrl + "/icon.png";
			 return path;
		 }
		
		
		/***************************
		 * 统计新手查看,本地保存等次数
		 * 
		 * ************************/
		public static function solveCountPath() : String
		{
			return info.COUNT_PATH;
		}
		public static function solveParterId() : String
		{
			return info.PARTER_ID;
		}
		
		public static function solveStylePath(sex:Boolean,type:String,path:String):String
		{
			return info.SITE + info.STYLE_PATH + (sex?"m":"f") + "/" + type + "/" + path + ".png";
		}
		public static function solveArmPath(type:String,path:String):String
		{
			return info.SITE + info.STYLE_PATH + String(type) + "/" + path + ".png";
		}
		
		/**
		 * 
		 * @param category----唯一，物品类型，6为武器，<10能穿在身上，为装备，其余是道具
		 * @param path----物品名
		 * @param sex---性别，装备需要性别
		 * @param pictype----图片类型(icon_1,icon_2...,show,consortia,game)
		 * @param isBack----武器是否后面(针对武器)
		 * @param dressHat---是否带帽子(针对发型，0为不带帽，1带)
		 * @param secondLayer---物品第二层(针对衣服)
		 * @param level---等级，针对武器。不同级别图片不一样。
		 * @param proptype---非战斗道具类型，1：合成石，2：强化石，3：幸运符，4：小喇叭，5：大喇叭(针对非战斗道具)
		 * @return 
		 * 
		 */		
		public static function solveGoodsPath(category:Number,path:String,sex:Boolean = true,pictype:String = "show",dressHat:String = "A",secondLayer:String = "1",level:int = 1,isBack:Boolean = false,propType:int = 0):String
		{
			var type:String = "";
			var sext:String = "";
			var equiptype:String = "";
			var back:String = "";
			var dresshat:String = "";
			var secondlayer:String = "";
			var levelt:String = "";
			var file:String = pictype + ".png";
			if(category == EquipType.ARM)
			{
				levelt = "/" + 1; 
				type = "arm/";
				if(pictype.indexOf("icon") == -1)	
					back = isBack ? "/1" : "/0";
				return info.SITE + "image/arm/" + path + levelt + back +"/"+ file;	
			}
			else if(category == EquipType.UNFRIGHTPROP)
			{
				return info.SITE + "image/unfrightprop/" + path + "/" + file;
			}
			else if(category == EquipType.TASK)
			{
				return info.SITE + "image/task/" +path+ "/icon.png";
			}else if(category == EquipType.CHATBALL)
			{
				return info.SITE + "image/specialprop/chatBall/" +path+ "/icon.png";
			}
			else if(category < 10 || category == EquipType.SUITS || category == EquipType.NECKLACE)
			{
				if(category == EquipType.HAIR)
				{
					if(pictype.indexOf("icon") == -1)
					{
						dresshat = "/" + dressHat;
					}
				}
				type = "equip/";
				equiptype = EquipType.TYPES[category]+"/";
				sext = sex ? "m/" : "f/";
				if(category != EquipType.ARMLET && category != EquipType.RING && category != EquipType.NECKLACE)
				{
					if(pictype == "icon")
					{
						pictype = "icon_" + secondLayer;
						secondLayer = "";
					}
					else
					{
						secondlayer = "/" + secondLayer;
					}
				}
				else
				{
					sext = "";
				}
				file = pictype + ".png";
				return info.SITE + "image/" + type + sext + equiptype + path + secondlayer + dresshat + levelt + back + "/" + file;
			}else if(category == EquipType.WING)
			{
				return info.SITE + "image/equip/wing/"+path+"/"+file;
			}else if(category == EquipType.OFFHAND)
			{
				return info.SITE + "image/equip/offhand/"+path+"/icon.png";
			}
			else if(category == EquipType.PET)
			{
				return info.SITE + "image/equip/pet/" + path + "/icon.png";
			}
			else if(category == EquipType.ShenQi1||category == EquipType.ShenQi2)
			{
				return info.SITE + "image/equip/shenqi/" + path + "/icon.png";
			}
			else
			{
				return info.SITE + "image/prop/" + path + "/" + file;
			}
		}
		
		public static function soloveWingPath(path:String):String
		{
			return info.SITE + "image/equip/wing/" + path +"/wings.swf";
		}
			
		public static function soloveSinpleLightPath(path : String) : String
		{
			return info.SITE +"image/equip/sinplelight/" + path + ".swf"
		}
		public static function soloveCircleLightPath(path : String) : String
		{
			return info.SITE + "image/equip/circlelight/"+ path + ".swf"
		}
		
		public static function solveConsortiaIconPath(path:String):String
		{
			return info.SITE + "image/consortiaicon/" + path + ".png";
		}
		
		public static function solveConsortiaMapPath(path:String):String
		{
			return info.SITE + "image/consortiamap/" + path + ".png";
		}
		
		public static function solveChurchCharacterPath(categoryID:Number,path:String,sex:Boolean = true,secondLayer:String = "1",isFront:Boolean =false,isAdmin:Boolean = false):String
		{
			var type:String;
			
			switch(categoryID)
			{
				case EquipType.HAIR:
				type = "hair";
				break;
//				case EquipType.HEAD:
//				type = "head";
				break;
				case EquipType.EFF:
				type = "eff";
				break;
				case EquipType.FACE:
				type = "face";
				break;
				case EquipType.CLOTH:
				type = isFront?"clothF":"cloth";
				path = isAdmin?"default":"cloth1";
				break;
			}
			
			return info.SITE + "image/church/" + (sex?"M":"F")+ "/" + type+ "/" + path + "/" + "wedding_" + secondLayer + ".png";
		}
		
		public static function solveChurchMapPath(path:String):String
		{
			//TODO
//			return info.SITE + "image/church/" + 
			return "";
		}
		
		/**
		 *取得温泉系统中玩家形象路径 
		 * @param categoryID 物品(形象)类型
		 * @param path 形象目录路径
		 * @param sex 性别
		 * @param secondLayer 
		 * @param direction 方向：1=正面;2=背面
		 * @param characterPath 形象图片路径
		 */		
		public static function solveSceneCharacterPath(categoryID:Number,path:String,sex:Boolean = true,secondLayer:String = "1",direction:int=1,sceneCharacterLoaderPath:SceneCharacterLoaderPath=null):String
		{
			var type:String;
			
			switch(categoryID)
			{
				case EquipType.HAIR:
					type = "hair";
					break;
				break;
				case EquipType.EFF:
					type = "eff";
					break;
				case EquipType.FACE:
					type = "face";
					break;
				case EquipType.CLOTH:
					type = direction==1 ? "clothF" : direction==2 ? "cloth" : "clothF";
					if(sceneCharacterLoaderPath)
					{
						path=sceneCharacterLoaderPath.clothPath;
					}
					else
					{
						path="default";
					}
					
					break;
			}
			
			return info.SITE + "image/virtual/" + (sex?"M":"F")+ "/" + type+ "/" + path + "/" + secondLayer + ".png";
		}
		
		/**
		 *取得中玩家形象路径 
		 * @param categoryID 物品(形象)类型
		 * @param path 形象目录路径
		 * @param playerSex 玩家性别
		 * @param sex 服装性别
		 * @param secondLayer 
		 * @param direction 方向：1=正面;2=背面
		 * @param sceneCharacterLoaderPath 形象图片路径
		 */		
		public static function solveSceneCharacterLoaderPath(categoryID:Number,path:String, playerSex:Boolean = true, sex:Boolean=true,secondLayer:String = "1",direction:int=1,sceneCharacterLoaderPath:SceneCharacterLoaderPath=null):String
		{
			var type:String;
			
			switch(categoryID)
			{
				case EquipType.HAIR:
					type = "hair";
					return info.SITE + "image/virtual/" + (sex?"M":"F")+ "/" + type+ "/" + path + "/" + secondLayer + ".png";
					break;
				break;
				case EquipType.EFF:
					type = "eff";
					return info.SITE + "image/virtual/" + (sex?"M":"F")+ "/" + type+ "/" + path + "/" + secondLayer + ".png";
					break;
				case EquipType.FACE:
					type = "face";
					return info.SITE + "image/virtual/" + (sex?"M":"F")+ "/" + type+ "/" + path + "/" + secondLayer + ".png";
					break;
				case EquipType.CLOTH:
					type = direction==1 ? "clothF" : direction==2 ? "cloth" : "clothF";
					if(sceneCharacterLoaderPath)
					{
						path=sceneCharacterLoaderPath.clothPath;
					}
					else
					{
						path="default";
					}
					return info.SITE + "image/virtual/" + (playerSex?"M":"F")+ "/" + type+ "/" + path + "/" + secondLayer + ".png";
					break;
			}
			
			return info.SITE + "image/virtual/" + (sex?"M":"F")+ "/" + type+ "/" + path + "/" + secondLayer + ".png";
		}
		
		public static function solveBlastPath(path:String):String
		{
			return info.SITE + "swf/blast.swf";
		}
		
		public static function solveStyleFullPath(sex:Boolean,hair:String,body:String,face:String):String
		{
			return info.SITE + info.STYLE_PATH + (sex ? "M":"F")+"/"+ hair+"/"+ body + face +"/all.png";
		}
		
		public static function solveStyleHeadPath(sex:Boolean,type:String,style:String):String
		{
			return info.SITE + info.STYLE_PATH + (sex ? "M":"F")+"/"+ type+"/"+ style+"/head.png";
		}
		
		public static function solveStylePreviewPath(sex:Boolean,type:String,style:String):String
		{
			return info.SITE + info.STYLE_PATH + (sex ? "M":"F")+"/"+ type+"/"+ style+"/pre.png";
		}
		
		public static function solvePath(path:String):String
		{
			return info.SITE + path;
		}
		
		public static function solveBombSwf(bombId:int):String
		{
			return info.SITE+"bombs/"+bombId+".swf";
		}
		
		public static function solveChurchSceneSourcePath(path:String):String
		{
			return info.SITE+"image/church/scene/"+path+".swf";
		}
		
		public static function solveGameLivingPath(path:String):String
		{
			var classToPath:String = path.split(".").join("/");
			return info.SITE+"image/"+classToPath+".swf";
		}
		
		public static function CommunityInvite():String
		{
			return info.COMMUNITY_INVITE_PATH;
		}
		
		public static function CommunityFriendList():String
		{
			return info.COMMUNITY_FRIEND_LIST_PATH;
		}
		
		public static function CommunityExist():Boolean
		{
			return info.COMMUNITY_EXIST;
		}
		
		public static function solveAllowPopupFavorite():Boolean
		{
			return info.ALLOW_POPUP_FAVORITE;
		}
		
		public static function solveFillJSCommandEnable():Boolean
		{
			return info.FILL_JS_COMMAND_ENABLE;
		}
		
		public static function solveFillJSCommandValue():String
		{
			return info.FILL_JS_COMMAND_VALUE;
		}
		
		public static function solveServerListIndex():int
		{
			return info.SERVERLISTINDEX;
		}
		
		/**
		 *香港易游的特殊需求，在把游戏里的某些事件广播到游戏外 
		 */		
		public static function solveExternalInterfacePath():String
		{
			return info.EXTERNAL_INTERFACE_PATH;
		}
		
		public static function solveExternalInterfaceEnabel():Boolean
		{
			return info.EXTERNAL_INTERFACE_ENABLE;
		}
		
		/**
		 *投诉反馈功能是否开启
		 */		
		public static function solveFeedbackEnable():Boolean
		{
			return info.FEEDBACK_ENABLE;
		}
		
		/**
		 *投诉反馈中客服电话 
		 */		
		public static function solveFeedbackServiceTel():String
		{
			return info.FEEDBACK_SERVICE_TEL;
		}
		
		/**
		 *投诉反馈中客服网址 
		 */		
		public static function solveFeedbackServiceUrl():String
		{
			return info.FEEDBACK_SERVICE_URL;
		}
	}
}
