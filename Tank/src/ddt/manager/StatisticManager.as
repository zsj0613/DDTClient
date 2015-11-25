package ddt.manager
{
	//import ddt.request.StatAction;
	/**统计管理**/
	public class StatisticManager
	{
		public static var StatisticPage   : String = "ddt_game/List_BI_Click.ashx";//统计地址
		public static var siteName        : String = "";
		public static var loginRoomListNum    : int    = 0;//进入房间列表的次数 
		public static const LOADING       : String = "loading";
		public static const CHECKSEX      : String = "checkSex";
		public static const LOGINSERVER   : String = "loginServer";
		public static const LOGINHALL     : String = "loginHall";
		public static const LOGINROOMLIST : String = "loginRoomList";
		public static const LOGINROOM     : String = "loginRoom";
		public static const GAME          : String = "game";
		public static const MAPLOADING    : String = "mapLoading";
		public static const GAMEOVER      : String = "gameOver";
		public static const SAVEFILE      : String = "saveFile";
		public static const NEWBOOK       : String = "newBook";
		public static const USERGUIDE	  : String = "userGuide";
		public static const REGISTERCHARACTER:String = "registerCharacter";//注册统计
		
		//新手I统计
//		public static const TRAINERENTERTIP  : String = "trainerEntertip";//新手引导提示
//		public static const TRAINERLOADING   : String = "trainerLoading";//loading新手战斗
		public static const TRAINER1OVER     : String = "tra1Over";//新手战斗1完成
		public static const TRAINER1ENTERTIP : String = "tra1EnterTip";//新手I进入提示
		public static const TRAINER1LOADING  : String = "tra1Loading";//新手ILoading
		public static const TRAINER1QUESTION1 : String = "tra1Question1";//新手问答1；
		public static const TRAINER1QUESTION2 : String = "tra1Question2";//新手问答2；

		
		public var isStatistic     : Boolean = true;/**是否统计**/
		public var IsNovice        : Boolean = false;/**本次登陆是不是新手**/
		private var _loginServer   : Boolean = true;/**是否进入频道*/
		private var _loginHall     : Boolean = true;/**进入大厅*/
		private var _loginRoomList : Boolean = true;/**进入游戏大厅*/
		private var _loginRoom     : Boolean = true;/**进入房间*/
		private var _gameOver      : Boolean = true;/**第一次游戏完成*/
		private var _game          : Boolean = true;/**第一次游戏**/
		private var _gameNum       : int  = 0;/**进行游戏的次数**/
		private var _saveFile      : Boolean = true;/**本地保存**/
		private var _newbook       : Boolean = true;/**新手教程**/
		private var _checkSex      : Boolean = true;/**性别确定**/
		private var _loading       : Boolean = true;/**加载完成**/
		private var _mapLoading    : Boolean = true;/**进入游戏加载地图**/
		public  var gameNumII      : Number  = 0;/**A区别上面，在不统计时**/
		
		
		/** 新人统计 2010-2-24
		注册；
		Loading			loading_yes
		新手引导提示		
		loading新手战斗	
		新手战斗1完成；
		新手问答1			
		新手问答			
		新手战斗2完成		
		新手问答2			
		新手引导提示；          trainerEntertip
		loading新手战斗；     trainerLoading
		新手战斗1完成；        trainer1Over
		新手I问答1；            trainer1Question1
		新手I问答2；            trainer1Question2	
			
		游戏大厅			loginHall_yes
		进入房间列表	 	loginRoomList_yes
		进入房间			loginRoom_yes
		进入游戏			game_yes
		完成PVP1场		gameOver1_yes
		完成PVP3场		gameOver3_yes
		完成PVP5场		gameOver5_yes
		完成PVP10场		gameOver10_yes
		*/
		
		
		public function startAction(type : String,status:String) : void
		{
			
			if(isStatistic)
			{
			 	var data : Object = new Object();
			 	data.appid = "1";//游戏编号//弹弹疼为1
			 	data.style = type+"_"+status;
			 	data.subid = ServerManager.Instance.AgentID;//代理商编号
			  //  new StatAction(StatisticPage,data).loadSync(__result);
			}
		}
	//	public function __result(action : StatAction) : void
	//	{
	//		
	//	}
		
		public function  get gameNum():int
		{
			return _gameNum;
		}
		
		
		private static var _instance  : StatisticManager;
		public static function Instance() : StatisticManager
		{
			if(_instance == null)
			{
				_instance = new StatisticManager();
			}
			return _instance;
		}
	}
}