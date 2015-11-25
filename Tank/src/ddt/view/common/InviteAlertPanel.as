package ddt.view.common
{
	import fl.controls.Button;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import game.crazyTank.view.invite.InviteAlertAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.ui.manager.TipManager;
	import road.ui.manager.UIManager;
	
	import ddt.manager.GameManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MapManager;
	import ddt.manager.SocketManager;

	public class InviteAlertPanel extends HConfirmFrame
	{
		private var _roomid:int;
		private var _nick:String;
		private var _password:String;
		private var _timer:Timer;
		private var _remainSecond:int = 15;
		private var _asset:InviteAlertAsset;
		private var _ok:Button;
		private var _cancel:Button;
		private var _barrierNum:int;
		
		private var _gameMode:int;
		public function InviteAlertPanel()
		{
			super();
			blackGound = false;
			alphaGound = false;
			fireEvent = false;
			showCancel = true;
			titleText = LanguageMgr.GetTranslation("ddt.invite.InviteView.request");
			okFunction = __okClick;
			cancelFunction = __cancelClick;
		
			setContentSize(405,165);
			configUI();
		}
		private function configUI():void
		{
			_timer = new Timer(1000,16);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE,__timerComplete);
			_timer.addEventListener(TimerEvent.TIMER,__timer);
			
			addEventListener(Event.CLOSE,__close);
			_asset = new InviteAlertAsset();
			addContent(_asset);
			_asset.title_txt.autoSize = "left";
			_asset.title_txt.text = "";
		}
		override protected function __closeClick(evt : MouseEvent) : void
		{
			super.__closeClick(evt);
			dispose();
		}
		
		private function __timerComplete(evt:TimerEvent):void
		{
			dispose();
		}
		
		private function __timer(evt:TimerEvent):void
		{
			_asset.second_txt.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.ruguo",String(_remainSecond));
			_remainSecond --;
		}
		
		
		private function __okClick(evt:MouseEvent = null):void
		{
			SoundManager.instance.play("008");
			GameManager.Instance.setup();
			if(_gameMode >2)//远征码头
			{
				SocketManager.Instance.out.sendGameLogin(2,-1,_roomid,_password,true);
			}else
			{
				SocketManager.Instance.out.sendGameLogin(1,-1,_roomid,_password,true);
			}
			dispose();
		}
		
		private function __close(evt:Event):void
		{
			SoundManager.instance.play("008");
			dispose();
		}
		
		private function __cancelClick(evt:MouseEvent = null):void
		{
			SoundManager.instance.play("008");
			dispose();
		}
		
		override public function dispose():void
		{
			super.dispose();
			_roomid = -1;
			_nick = "";
			if(_timer)
			{
				_timer.removeEventListener(TimerEvent.TIMER,__timer);
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,__timerComplete);
				_timer.stop();
				_timer = null;
			}
			if(parent)parent.removeChild(this);
		}

		
		public function set info(value:Object):void
		{
			_asset.title_txt.text = "";
			var playerid:int = value["playerid"];
			_roomid = value["roomid"];
			var mapid:int = value["mapid"];
			var secondType:int = value["secondType"];
			var gameMode:int = value["gameMode"];
			var hardLevel:int = value["hardLevel"];
			var levelLimits:int = value["levelLimits"];
			var o:Object = value["info"];
			_gameMode = gameMode;
//			mapid = getMapId(mapid,gameMode);
			_nick = o["NN"];
			_password = o["PW"];
			_barrierNum = o["BN"];
//			
			_asset.title_txt.autoSize = "left";
			_asset.title_txt.text = "“" + nick + "”" + LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.yaoqingni");
			//_asset.title_txt.text = "“" + nick + "”" + "邀请您加入他的游戏房间";
			//bret 09.6.8 *****************************************
			var time:int = 1;
			if(secondType == 1)time = 5;
			if(secondType == 2)time = 7;
			if(secondType == 3)time = 10;
			//*****************************************************
			if(gameMode < 2)
			{
				_asset.gameMode_mc.gotoAndStop(gameMode+1);
				_asset.right_txt.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.huihetime");
				_asset.rightInfo_txt.text = time + LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.second");
				_asset.left_txt.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.map");
				_asset.leftInfo_txt.text = String(MapManager.getMapName(mapid));
			}
			if(gameMode ==2)
			{
				_asset.gameMode_mc.gotoAndStop(gameMode+1);
				_asset.right_txt.text = LanguageMgr.GetTranslation("ddt.view.common.levelRange");
				_asset.rightInfo_txt.text  = getLevelLimits(levelLimits);
				_asset.left_txt.text = LanguageMgr.GetTranslation("ddt.view.common.roomLevel"); 
				_asset.leftInfo_txt.text = getRoomHardLevel(hardLevel);;
			}
			if(_barrierNum == -1 || gameMode <2)
			{
				_asset.pass_txt.visible = _asset.passValue_txt.visible = false;
			}else
			{
				_asset.pass_txt.text = LanguageMgr.GetTranslation("ddt.view.common.InviteAlertPanel.pass");
				_asset.passValue_txt.text = String(_barrierNum<= 0 ? 1 : _barrierNum);
			}
			if(gameMode >2 )
			{
				_asset.gameMode_mc.gotoAndStop(gameMode+1);
				_asset.left_txt.text = LanguageMgr.GetTranslation("ddt.view.common.duplicateName");
				_asset.leftInfo_txt.text = String(MapManager.getMapName(mapid));

				_asset.right_txt.text = LanguageMgr.GetTranslation("ddt.view.common.gameLevel");
				_asset.rightInfo_txt.text = getRoomHardLevel(hardLevel);
				
				if(_asset.leftInfo_txt.text == "")
				{
					_asset.passValue_txt.text = "未选";
					_asset.leftInfo_txt.text = "未选";
					_asset.rightInfo_txt.text = "未选"
				}
				
			}
			
			
			_timer.reset();
			_timer.start();	
			
			UIManager.setChildCenter(this);
			show();
			centerText();
		}
		
		override public function show():void
		{
			if(_timer && _timer.running)
			TipManager.AddTippanel(this,false,true);
		}
		
		private function getLevelLimits(levelLimits:int):String
		{
			var result:String = "";
			switch(levelLimits)
			{
				case 1:
					result = "1-10";
					break;
				case 2:
					result = "11-20";
					break;
				case 3:
					result = "20-30";
					break;
				case 4:
					result = "30-40";
					break;
				default:
					result = "";
					break;
			}
			return result + LanguageMgr.GetTranslation("grade");
		}
		
		private function getRoomHardLevel(HardLevel:int):String
		{
			switch(HardLevel)
			{
				case 0:
					return LanguageMgr.GetTranslation("ddt.room.difficulty.simple");
				break;
				case 1:
					return LanguageMgr.GetTranslation("ddt.room.difficulty.normal");
				break;
				case 2:
					return LanguageMgr.GetTranslation("ddt.room.difficulty.hard");
				break;
				case 3:
					return LanguageMgr.GetTranslation("ddt.room.difficulty.hero");
				break;
			}
			return "";
		}
		
		private function getRommTypeName(gameMode : int) : String
		{	
			var roomTypeName : String = "";
			if(gameMode == 0 || gameMode == 2)
			{
				roomTypeName = LanguageMgr.GetTranslation("ddt.view.common.freeFight");
			}
			else if(gameMode == 1)
			{
				roomTypeName = LanguageMgr.GetTranslation("ddt.view.common.guildFight");
			}
			else if(gameMode == 5)
			{
				roomTypeName = LanguageMgr.GetTranslation("ddt.view.common.exploreFight");
			}
			else if(gameMode == 6)
			{
				roomTypeName = LanguageMgr.GetTranslation("ddt.view.common.bossFight");
			}
			else if(gameMode == 7)
			{
				roomTypeName = LanguageMgr.GetTranslation("ddt.view.common.duplicateFight");
			}
			return roomTypeName;
		}
		
		private function centerText():void
		{
			_asset.title_txt.x = (400 - _asset.title_txt.width) /2;
		}
		
		public function get nick():String
		{
			return _nick;
		}
		
		public function get roomId():int
		{
			return _roomid;
		}
	}
}