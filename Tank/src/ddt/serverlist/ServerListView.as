package ddt.serverlist
{
	import flash.events.MouseEvent;
	
	import road.comm.PackageIn;
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HAlertDialog;
	import road.ui.manager.TipManager;
	import road.ui.manager.UIManager;
	
	import ddt.data.PathInfo;
	import ddt.data.player.SelfInfo;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.manager.BossBoxManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MapManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.ServerManager;
	import ddt.manager.SocketManager;
	import ddt.manager.StateManager;
	import ddt.manager.TimeManager;
	import ddt.manager.UserGuideManager;
	import ddt.request.LoadServerListAction;
	import ddt.states.BaseStateView;
	import ddt.states.StateType;
	import tank.view.ServerLoadingAsset;
	import ddt.view.common.BellowStripViewII;
	import ddt.view.common.WaitingView;
	
	public class ServerListView extends BaseStateView
	{
		private var _strips:Array;
		
		private var _asset:ServerListPosView;
		
		private var _connectGameSocket:Boolean;
		private var _needLoginConsortia:Boolean;
		private var _waiting:WaitingView;
		
		private var _loading:ServerLoadingAsset;
		//		private var _isFirst:Boolean;
		public static var showContinuation:Boolean=false;
		public function ServerListView()
		{
			super();
		}
		
		override public function prepare():void
		{
			_strips = new Array();
			super.prepare();
			//			_isFirst = true;
		}
		
		override public function addedToStage():void
		{
			super.addedToStage();			
		}
		
		override public function getType():String
		{
			return StateType.SERVER_LIST;
		}
		
		override public function fadingComplete():void
		{
			super.fadingComplete();
			//			_asset.f11Cartoon();
		}
		
		override public function enter(prev:BaseStateView,data:Object = null):void
		{			
			super.enter(prev,data);
			//global.traceStr("enterServerlistView")
			UIManager.clear();
			
			TipManager.clearTipLayer();
			if(_strips.length == 0)
			{
				_loading = new ServerLoadingAsset();			
				_loading.x = 709;
				_loading.y = 260;
				addChild(_loading);
			}
			_asset = new ServerListPosView();
			addChildAt(_asset,0);
			_asset.enter();
			
			
			//*******************************************************************************************
			SoundManager.Instance.playMusic("062");
			BellowStripViewII.Instance.show();
			BellowStripViewII.Instance.enabled = false;
			_needLoginConsortia = PlayerManager.Instance.Self.ConsortiaID == 0;
			setStrip();
			new LoadServerListAction().loadSync(__complete,6);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOGIN,onLoginComplete);
			//			if(_isFirst)
			//			{
			//				_isFirst = false;
			//				if(LoaderManager.cacheAble == false)
			//				{
			//					new SaveFileWindow().show();
			//				}
			//			}
			//			StatisticManager.Instance().startAction(StatisticManager.LOGINSERVER,"yes");
			
			if(PlayerManager.Instance.hasTempStyle)
			{
				PlayerManager.Instance.readAllTempStyleEvent();
			}
			
			//PlayerManager.Instance.Self.OvertimeListByBody = PlayerManager.Instance.Self.Bag.findOvertimeItemsByBody();
		}
		
		override public function leaving(next:BaseStateView):void
		{
			super.leaving(next);
			BellowStripViewII.Instance.hide();
			_asset.leaving();
			WaitingView.instance.hide();
			
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LOGIN,onLoginComplete);					
			_connectGameSocket = false;
			if(_asset.parent)
			{
				removeChild(_asset);
			}
			_asset = null;
			removeStrip();	
			removeLoading();
		}
		
		private function removeLoading():void
		{
			if(_loading && _loading.parent)
			{
				removeChild(_loading);
			}
			_loading = null;			
		}
		
		override public function getBackType():String
		{
			return StateType.LOGIN;
		}
		
		
		private var _stripArray:Array;
		private function setStrip():void
		{
			_stripArray = new Array();
			_asset.box.clearItems();
			for(var i:int = 0; i < _strips.length; i ++)
			{
				if(i < PathInfo.SERVER_NUMBER) {
					var strip:ServerStrip = new ServerStrip(_strips[i],(i+1));
					_stripArray.push(strip);
					strip.addEventListener(MouseEvent.CLICK,__click);
					_asset.box.appendItem(strip);
					if(ServerManager.Instance.current == strip.info)
					{
						_asset.box.selectedItem = strip;
					}
				}
			}
		}
		
		
		private function removeStrip():void
		{
			for(var i:uint = 0; i < _stripArray.length; i ++)
			{
				if(i < PathInfo.SERVER_NUMBER) {
					var strip:ServerStrip = _stripArray[i];
					strip.removeEventListener(MouseEvent.CLICK,__click);
				}
			}
			_stripArray = new Array();
		}
		
		private function __click(event:MouseEvent):void
		{
			var item:ServerStrip = event.currentTarget as ServerStrip;
			if(item.selected)
			{
				_asset.tryLoginServer();
			}
			else
			{
				_asset.box.selectedItem =  item;
			}
			SoundManager.Instance.play("047");
		}
		
		private function __complete(loader:LoadServerListAction):void
		{
			if(loader.isSuccess)
			{
				_strips = ServerManager.Instance.list;
				setStrip();
			}
			removeLoading();
		}
		
		public static function onLoginComplete(event:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = event.pkg;
			
			var self:SelfInfo = PlayerManager.Instance.Self;
			if(pkg.readByte() == 0)
			{
				PlayerManager.Instance.Self.beginChanges();
				SocketManager.Instance.isLogin = true;
				PlayerManager.Instance.Self.ZoneID = pkg.readInt();
				PlayerManager.Instance.Self.Attack = pkg.readInt();
				PlayerManager.Instance.Self.Defence = pkg.readInt();
				PlayerManager.Instance.Self.Agility = pkg.readInt();
				PlayerManager.Instance.Self.Luck = pkg.readInt();
				PlayerManager.Instance.Self.GP = pkg.readInt();
				PlayerManager.Instance.Self.Repute = pkg.readInt();
				PlayerManager.Instance.Self.Gold = pkg.readInt();
				PlayerManager.Instance.Self.Money = pkg.readInt();
				PlayerManager.Instance.Self.Hide = pkg.readInt();
				PlayerManager.Instance.Self.FightPower = pkg.readInt();
				PlayerManager.Instance.Self.AchievementPoint = pkg.readInt();
				PlayerManager.Instance.Self.honor = pkg.readUTF();
				PlayerManager.Instance.Self.VIPLevel = pkg.readInt();
				PlayerManager.Instance.Self.ChargedMoney = pkg.readInt();
				
				TimeManager.Instance.totalGameTime = pkg.readInt();//通过 LOGIN 读取socket文件
				PlayerManager.Instance.Self.Sex = pkg.readBoolean();
				var styleAndSkin:String = pkg.readUTF();
				var t:Array = styleAndSkin.split("&");
				PlayerManager.Instance.Self.Style = t[0];
				PlayerManager.Instance.Self.Colors = t[1];
				PlayerManager.Instance.Self.Skin = pkg.readUTF();
				PlayerManager.Instance.Self.ConsortiaID = pkg.readInt();
				PlayerManager.Instance.Self.ConsortiaName = pkg.readUTF();
				PlayerManager.Instance.Self.DutyLevel = pkg.readInt();
				PlayerManager.Instance.Self.DutyName = pkg.readUTF();
				PlayerManager.Instance.Self.Right = pkg.readInt();
				PlayerManager.Instance.Self.CharManName = pkg.readUTF();
				PlayerManager.Instance.Self.ConsortiaHonor = pkg.readInt();
				PlayerManager.Instance.Self.ConsortiaRiches = pkg.readInt();
				var locked : Boolean = pkg.readBoolean();/**是否有锁**/
				PlayerManager.Instance.Self.bagPwdState = locked;
				PlayerManager.Instance.Self.bagLocked = locked;/**锁的初始状态**/
				
				PlayerManager.Instance.Self.questionOne = pkg.readUTF();   /**密码保护问题一**/
				PlayerManager.Instance.Self.questionTwo = pkg.readUTF();   /**密码保护问题二**/
				PlayerManager.Instance.Self.leftTimes = pkg.readInt();     /**二级密码剩余操作次数**/
				PlayerManager.Instance.Self.LoginName = pkg.readUTF();
				PlayerManager.Instance.Self.Nimbus    = pkg.readInt();
				
				/**TODO  需要找welly**/
				var questHistory:String = pkg.readUTF();
				//TaskManager.loadQuestLog(questHistory);
				PlayerManager.Instance.Self.PvePermission = pkg.readUTF();
				PlayerManager.Instance.Self.fightLibMission = pkg.readUTF();
				
				PlayerManager.Instance.Self.AnswerSite     = pkg.readInt();
				
				BossBoxManager.instance.receiebox = pkg.readInt();
				BossBoxManager.instance.receieGrade = pkg.readInt();
				BossBoxManager.instance.needGetBoxTime = pkg.readInt();
				BossBoxManager.instance.currentGrade = PlayerManager.Instance.Self.Grade;
				BossBoxManager.instance.startGradeChangeEvent();
				BossBoxManager.instance.startDelayTime();
				
				PlayerManager.Instance.Self.LastSpaDate=pkg.readDate();//最后退出温泉房间的时间
				
				PlayerManager.Instance.Self.commitChanges();
				MapManager.buildMap();
				PlayerManager.Instance.Self.loadRelatedPlayersInfo();
				
				//进入主界面
				StateManager.setState(StateType.MAIN);
				checkContinuation();
				
				if(PlayerManager.Instance.Self.ConsortiaID != 0)
				{
					PlayerManager.Instance.Self.sendGetMyConsortiaData();
					PlayerManager.Instance.Self.loadMyConsortiaEventList(1,10000,-1,PlayerManager.Instance.Self.ConsortiaID);
				}
				UserGuideManager.Instance.setup();
				
			}
			else
			{
				HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.serverlist.ServerListView.login"),true,null,"stage");
				//AlertDialog.show("提示","登录游戏服务器失败");
				WaitingView.instance.hide();
			}
		}
		/**
		 * 检查是否弹续费框 
		 * 
		 */		
		private static function checkContinuation():void
		{
			if(PlayerManager.Instance.Self.OvertimeListByBody.length > 0)
			{
				showContinuation=true;
			}
		}
	}
}