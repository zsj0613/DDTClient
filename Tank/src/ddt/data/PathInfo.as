package ddt.data
{
	public class PathInfo
	{
		public var SITE:String = "res/";
		public var REQUEST_PATH:String = "";
		public var RES_PATH:String = "";
		public var MAP_PATH:String = "";
		public var STYLE_PATH:String = "style/";
		public var RTMP_PATH:String = "";
		public var LOGIN_PATH:String = "";
		public var XML_PATH:String ="";
		public var SWF_PATH:String ="";
		public static var GAME_BOXPIC : int; 
		
		public static var ISTOPDERIICT : Boolean = false;//是否顶部跳转
		public static var isUserAddFriend : Boolean = false;//是否使用加社区好友
		
		public static var SERVER_NUMBER:int = 4;//频道列表个数
		/**
		 * 首页 
		 */		
		public var FIRSTPAGE:String;
		/**
		 * 注册页 
		 */		
		public var REGISTER:String;
		/**
		 * 充值页
		 */		
		public var FILL_PATH:String;
		/**
		 * 客户端下载
		 */
		public var CLIENT_DOWNLOAD:String;		
		/**
		 * 新手教程页面 
		 */		
		public var TRAINER_PATH:String;
		
		/**
		 * 统计数据,如新手帮助,本地保存
		 */
		 public var COUNT_PATH:String;
		 
		 /**
		 *   代理商编号
		 */
		 public var PARTER_ID : String;
		 
		/*****
		 * 不同服务的参数,如37wan同服
		 */
		 public var SITEII : String;
		 
		 
		 /******
		 * 代理商地址需要的地址
		 * 如人人网个人主页
		 */
		 public var PHP_PATH : String;
		 
		 /**
		  *图片上是否可以打开键接 
		  */		 
		 public var PHP_IMAGE_LINK : Boolean = true;
		 
		 /******
		 * 玩家在代理商网站信息的请求地址
		 */
		 public var WEB_PLAYER_INFO_PATH : String;
		 
		 /**
		 * 游戏官网（频道列表里面用到）
		 * */
		 public var OFFICIAL_SITE : String;
		 
		 /**
		 * 游戏论坛（频道列表里面用到）
		 * */
		 public var GAME_FORUM :String;
		/**
		 * 加为社区好友
		 */
		 public var COMMUNITY_FRIEND_PATH : String;
		 
		 /**
		 * 邀请社区好友加入弹弹堂
		 */
		 public var COMMUNITY_INVITE_PATH : String;
		 
		 /**
		 * 社区好友列表获取接口地址
		 */
		 public var COMMUNITY_FRIEND_LIST_PATH:String;
		 
		 /**
		 * 是否开通社区好友功能
		 */
		 public var COMMUNITY_EXIST:Boolean;
		 
		 /**
		 * 退出时是否允许弹出收藏夹
		 * */
		 public var ALLOW_POPUP_FAVORITE:Boolean;
		 
		 /**
		 * 弹出充值的时候是否调用自定义的JS
		 * */
		 public var FILL_JS_COMMAND_ENABLE:Boolean;
		 public var FILL_JS_COMMAND_VALUE:String;
		 
		 public var SERVERLISTINDEX:int=-1;
		 
		 /**
		  *香港易游的特殊需求，在把游戏里的某些事件广播到游戏外 
		  */		 
		 public var EXTERNAL_INTERFACE_PATH:String;
		 public var EXTERNAL_INTERFACE_ENABLE:Boolean;
		 
		 /**
		  *投诉反馈功能是否开启
		  */
		 public var FEEDBACK_ENABLE:Boolean;		 
		 
		 /**
		  *投诉反馈中客户电话 
		  */		 
		 public var FEEDBACK_SERVICE_TEL:String;
		 
		 /**
		  * 投诉反馈中客服网址
		  */		 
		 public var FEEDBACK_SERVICE_URL:String;
	}
}