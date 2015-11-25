package ddt.view.im
{
	import flash.utils.Dictionary;
	
	import road.comm.PackageIn;
	import road.data.DictionaryData;
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HAlertDialog;
	import road.ui.controls.hframe.HConfirmDialog;
	
	import ddt.data.player.PlayerInfo;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.manager.ChatManager;
	import ddt.manager.GameManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SharedManager;
	import ddt.manager.SocketManager;
	import ddt.manager.StateManager;
	import ddt.states.StateType;
	import ddt.view.common.InviteAlertPanel;

	public class IMController
	{
		private var _imview:IMView;
		private var _currentPlayer:PlayerInfo;
		private var _panels:Dictionary;
		
		public function IMController()
		{
		}

		public function setup():void
		{
			_tempList = new Array();
			_panels = new Dictionary();
			PlayerManager.Instance.addEventListener(IMEvent.ADDNEW_FRIEND,__addNewFriend);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FRIEND_RESPONSE,__friendResponse);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_INVITE,__receiveInvite);
		}
	
		private function __addNewFriend(evt:IMEvent):void
		{
			_currentPlayer = evt.data as PlayerInfo;
			MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.im.IMController.success"));
		}
		
		private var _tempList:Array;
		private function __friendResponse(evt:CrazyTankSocketEvent):void
		{
			var id:int = evt.pkg.clientId;
			var idtemp:int = evt.pkg.readInt();
			var _nick:String = evt.pkg.readUTF();
			ChatManager.Instance.sysChatYellow("["+_nick+"]"+LanguageMgr.GetTranslation("ddt.view.im.IMController.friend"));
		}
		
		private function confirmCallback():void
		{
			IMController.Instance.addFriend(_tempList.pop());
		}
		
		//可以接受邀请的模块
		private function getInviteState() : Boolean
		{
			switch(StateManager.currentStateType)
			{
				case StateType.MAIN:
				case StateType.ROOM_LIST:
				case StateType.DUNGEON:
					return true;
				default :
					return false;			
			}
			return false;
		}
	
		private function __receiveInvite(evt:CrazyTankSocketEvent):void
		{
			
			if(getInviteState())
			{
				if(PlayerManager.Instance.Self.Grade<4){
					return;
				}//4级以下玩家不接受邀请（新手引导）welly 10-3-2
				if(SharedManager.Instance.showInvateWindow)
				{
					var pkg:PackageIn = evt.pkg;
					var o:Object = new Object();
					o["playerid"] = pkg.readInt();
					var _roomid:int = o["roomid"] = pkg.readInt();
					o["mapid"] = pkg.readInt();
					o["secondType"] = pkg.readByte();
					o["gameMode"] = pkg.readByte();
//					o["teamType"] = pkg.readByte();
					o["hardLevel"]   = pkg.readByte();
					o["levelLimits"] = pkg.readByte();	
					var _info:Object = new Object();
					o["info"] = _info;
					_info.NN = pkg.readUTF();
					_info.RN = pkg.readUTF();
					_info.PW =  pkg.readUTF();
					_info.BN =  pkg.readInt();
					var nick:String = o["info"]["NN"];
					
//					if(EnterTutorialFrame.tutorialState)return;/**新手教程学习中**/
					if(o["gameMode"] > 2 && PlayerManager.Instance.Self.Grade < GameManager.MinLevelDuplicate)
					{
						//副本等级限制
						return;
					}
					if(_panels[nick] == null || _panels[nick].nick == "")
					{
						SoundManager.instance.play("018");
						_panels[nick] = new InviteAlertPanel();
						_panels[nick].info = o;
					}
				}
			}
		}
		
		private function privateChat():void
		{
			if(_currentPlayer != null )
			{
				ChatManager.Instance.privateChatTo(_currentPlayer.NickName,_currentPlayer.ID);
			}
		}
		
		
		public function hide():void
		{
			if(_imview && _imview.parent)
			{
				_imview.dispose();
			}
			_imview = null;
		}
		public function show():void
		{
			if(_imview == null)
			{
				_imview = new IMView(this);
			}
			_imview.show();
		}
		
		public function switchVisible():void
		{
			if(_imview && _imview.parent)
			{
				hide();
			}
			else
			{
				show();
			}
		}
		
		public function getX():Number
		{
			return _imview.x;
		}
		
		public function getY():Number
		{
			return _imview.y;
		}
		
		public function getWidth():Number
		{
			return _imview.width;
		}
		
		public function getHeight():Number
		{
			return _imview.height;
		}

		public function setState(state:int):void
		{
		}
		
		private var _name:String;
		public function addFriend(name:String):void
		{
			if(PlayerManager.Instance.friendList.length >= 200)
			{
				HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.im.IMController.addFriend"));
				return;
			}
			_name = name;
			if(!checkFriendExist(name))
			{
				
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.im.IMController.shifou"),true,___addFriend,playSound);
			}
		}
		
		public function addBlackList(name:String):void
		{
			if(PlayerManager.Instance.blackList.length >= 100)
			{
				HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.im.IMController.addBlackList"));
				return;
			}
			_name = name;
			if(!checkBlackListExit(name))
			{
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.im.IMController.issure"),true,___addBlack,playSound);
			}
		}
		
		private function ___addBlack():void
		{
			SoundManager.instance.play("008");
			SocketManager.Instance.out.sendAddFriend(_name,1);
			_name = "";
		}
		
		private function ___addFriend():void
		{
			
			SoundManager.instance.play("008");
			SocketManager.Instance.out.sendAddFriend(_name,0);
			_name = "";
		}
		
		private function playSound():void
		{
			SoundManager.instance.play("008");
			_name = "";
		}
		
		private function checkBlackListExit(s:String):Boolean
		{
			if(s == PlayerManager.Instance.Self.NickName)
			{
				
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.im.IMController.cannot"));
				//MessageTipManager.getInstance().show("不能添加自己为好友");
				return true;
			}
			
			
			
			
			var f:DictionaryData = PlayerManager.Instance.blackList;
			for each(var i:PlayerInfo in f)
			{
				if(i.NickName == s)
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.im.IMController.thisplayer"));
					//MessageTipManager.getInstance().show("不能重复添加好友");
					return true;
				}
			}
			return false;
		}
		
		private function checkFriendExist(s:String):Boolean
		{
			if(!s)return  true;
			if(s.toLowerCase() == PlayerManager.Instance.Self.NickName.toLowerCase())
			{
				
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.im.IMController.cannotAddSelfFriend"));
				return true;
			}
			var f:DictionaryData = PlayerManager.Instance.friendList;
			for each(var i:PlayerInfo in f)
			{
				if(i.NickName == s)
				{
					
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.im.IMController.chongfu"));
					return true;
				}
			}
			var b:DictionaryData = PlayerManager.Instance.blackList;
			for each(var j:PlayerInfo in b)
			{
				if(j.NickName == s)
				{
					_name = s;
					HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.im.IMController.thisone"),true,___addFriend,null);
					return true;
				}
			}
			
			return false;
		}
		
		public function exitConsortia():void
		{
		}
		
		public function showConsortiaInfo():void
		{
		}
		
		public function inviteConsortia():void
		{
		}
		
		private static var _instance:IMController;
		public static function get Instance():IMController
		{
			if(_instance == null)
			{
				_instance = new IMController();
			}
			return _instance;
		}
		
	}
}