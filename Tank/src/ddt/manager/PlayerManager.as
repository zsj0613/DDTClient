package ddt.manager
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	import game.crazyTank.view.NickNameAsset;
	
	import road.BitmapUtil.BitmapReader;
	import road.comm.PackageIn;
	import road.data.DictionaryData;
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HAlertDialog;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.manager.TipManager;
	import road.ui.manager.UIManager;
	import road.utils.StringHelper;
	
	import ddt.data.AccountInfo;
	import ddt.data.BuffInfo;
	import ddt.data.CheckCodeData;
	import ddt.data.ChurchRoomInfo;
	import ddt.data.ConsortiaInfo;
	import ddt.data.EquipType;
	import ddt.data.PathInfo;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.player.BagInfo;
	import ddt.data.player.ConsortiaPlayerInfo;
	import ddt.data.player.FriendListPlayer;
	import ddt.data.player.PlayerInfo;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.data.player.RoomPlayerInfo;
	import ddt.data.player.SelfInfo;
	import ddt.data.quest.QuestInfo;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.request.AddCommunityFriend;
	import ddt.states.StateType;
	import ddt.view.bagII.BagEvent;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;
	import ddt.view.cells.BagCell;
	import ddt.view.chatsystem.ChatData;
	import ddt.view.chatsystem.ChatInputView;
	import ddt.view.common.BellowStripViewII;
	import ddt.view.common.CheckCodePanel;
	import ddt.view.common.church.DialogueAgreePropose;
	import ddt.view.common.church.DialogueRejectPropose;
	import ddt.view.common.church.DialogueUnmarried;
	import ddt.view.common.church.InvitePanelForChurch;
	import ddt.view.common.church.MarryApplySuccess;
	import ddt.view.common.church.ProposeFrame;
	import ddt.view.common.church.ProposeResponseFrame;
	import ddt.view.common.hotSpring.HotSpringRoomInviteView;
	import ddt.view.dailyconduct.DailyConductFrame;
	import ddt.view.im.IMEvent;
	import ddt.view.taskII.TaskMainFrame;
	
	/**
	 * 
	 * @author SYC
	 * 2008-07-14
	 * 人物控制器
	 */
	public class PlayerManager extends EventDispatcher
	{
		public static const FRIEND_STATE_CHANGED:String = "friendStateChanged";
		public static const CONSORTIAMEMBER_STATE_CHANGED:String = "consortiaMemberStateChanged";
		public static const CONSORTIAMEMBER_INFO_CHANGE:String = "consortiaMemberInfoChange";
		
		public static const FRIENDLIST_COMPLETE:String = "friendListComplete";
		public static const SELF_CONSORTIA_COMPLETE:String = "selfConsortiaComplete";
		public static const CONSORTIA_CHANNGE:String = "consortiaChannge";
		public static const CONSORTIA_PLACARD_UPDATE : String = "consortiaPlacardUpadte";
		
		public static const CIVIL_PLAYER_INFO_MODIFY : String = "civilplayerinfomodify";
		
		public static const CIVIL_SELFINFO_CHANGE:String = "civilselfinfochange";
		
		private var _account:AccountInfo;
		public static var registerSucceed : Boolean = false;
		public static var isShowPHP : Boolean = false;/***是否显示个人主页***/
		public function get Account():AccountInfo
		{
			return _account;
		}
		
		private var _self:SelfInfo;
		public function get Self():SelfInfo
		{
			return _self;
		}
		public function get DeputyWeapon():InventoryItemInfo
		{
			var arr:Array = _self.Bag.findBodyThingByCategory(EquipType.OFFHAND);
			
			if(arr.length > 0)
				return arr[0] as InventoryItemInfo;//取得副武器
			return null;
		}
		
		public var SelfConsortia:ConsortiaInfo = new ConsortiaInfo();
		
//		public static var selfFightingPlayer:FightingPlayerInfo;
		public static var selfRoomPlayerInfo:RoomPlayerInfo;
		
		/**
		 * 游戏结束面板跳转的界面 
		 */		
		public static var gotoState:String = StateType.ROOM;
		
		/**
		 * 自己在公会中的引用
		 */		
		private static var _selfConsortiaPlayer:ConsortiaPlayerInfo;
		
		public static function set SelfConsortiaPlayer(info:ConsortiaPlayerInfo):void
		{
			_selfConsortiaPlayer = info;
		}
		
		public static function get SelfConsortiaPlayer():ConsortiaPlayerInfo
		{
			return _selfConsortiaPlayer;
		}

		private static var _instance:PlayerManager;
		
		public static function get Instance():PlayerManager
		{
			if(_instance == null)
			{
				_instance = new PlayerManager();
			}
			return _instance;
		}
		
		public function get checkEnterDungeon() : Boolean
		{
			if(Instance.Self.Grade < GameManager.MinLevelDuplicate)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.PlayerManager.gradeLow",GameManager.MinLevelDuplicate));
				return false;
			}
			return true;
		}
		
		/**
		 * 公会人物列表
		 */		
		private var _clubPlays:DictionaryData;
		
		/**
		 * 好友列表
		 */		
		private var _friendList:DictionaryData;
		
		/**
		 * IM公会成员列表
		 */
		private var _consortiaMemberList:DictionaryData;
		
		/**
		 * 社区好友列表
		 */
		private var _cmFriendList:DictionaryData;
		
		
		/**
		 * IM 黑名单列表  
		 * */
		 private var _blackList:DictionaryData;
		 
		 
		private var _tempList:DictionaryData;
		
		public function get consortiaPlayerList():DictionaryData
		{
			if(_clubPlays[_self.ZoneID] == null) _clubPlays[_self.ZoneID] = new DictionaryData();
			return _clubPlays[_self.ZoneID];
		}
		
		public function set friendList(value:DictionaryData):void
		{
			_friendList[_self.ZoneID] = value;
			dispatchEvent(new Event(FRIENDLIST_COMPLETE));
		}
		
		public function set blackList(value:DictionaryData):void
		{
			_blackList[_self.ZoneID] = value;
		}
		public function get blackList():DictionaryData
		{
			return _blackList[_self.ZoneID];
		}
		
		public function get friendList():DictionaryData
		{
			if(_friendList[_self.ZoneID] == null) _friendList[PlayerManager.Instance.Self.ZoneID] = new DictionaryData();
			return _friendList[_self.ZoneID];
		}
		
		public function get CMFriendList():DictionaryData
		{
			return _cmFriendList;
		}
		
		public function set CMFriendList(value:DictionaryData):void
		{
			_cmFriendList = value;
		}
		
		public function get PlayCMFriendList():Array
		{
			return _cmFriendList.filter("IsExist",true);
		}
		
		public function get UnPlayCMFriendList():Array
		{
			return _cmFriendList.filter("IsExist",false);
		}
		
		public function set consortiaMemberList(value:DictionaryData):void
		{
			_consortiaMemberList.setData(value);
			dispatchEvent(new Event(SELF_CONSORTIA_COMPLETE));
		}
		
		public function get consortiaMemberList():DictionaryData
		{
			return _consortiaMemberList;
		}
		
		public function get consortiaMemberCount() : int
		{
			var count : int = 0;
			for each(var i:* in _consortiaMemberList)
			{
				if(i)count += 1;
			}
			return count;
		}
		
		
		public function get onlineFriendList():Array
		{
			return friendList.filter("State",1);
		}
		
		public function get offlineFriendList():Array
		{
			return friendList.filter("State",0);
		}
		
		public function get onlineConsortiaMemberList():Array
		{
			return _consortiaMemberList.filter("State",1);
		}
		
		public function get offlineConsortiaMemberList():Array
		{
			return _consortiaMemberList.filter("State",0);
		}
		
		public function PlayerManager()
		{
			_clubPlays = new DictionaryData();
			_friendList = new DictionaryData();
			_blackList = new DictionaryData();
			_consortiaMemberList = new DictionaryData();
			_tempList = new DictionaryData();
			SelfConsortia = new ConsortiaInfo();
			

			_self = new SelfInfo();
			
			BossBoxManager.instance.setup();
		}
		
		public function Setup(account:AccountInfo):void
		{
			_account = account;
			initEvent();
		}
		
		private function initEvent():void
		{
			//人物信息
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_PRIVATE_INFO,__updatePrivateInfo);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_PLAYER_INFO,__updatePlayerInfo);

			//背包
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GRID_GOODS,__updateInventorySlot);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BAG_LOCKED, __bagLockedHandler);
			
			//好友
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FRIEND_ADD,__friendAdd);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FRIEND_REMOVE,__friendRemove);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FRIEND_STATE,__playerState);

			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_EQUIP,__itemEquip);
			Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__selfPopChange);
			
			//公会
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_CREATE,__consortiaCreate);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_PLACARD_UPDATE,__consortiaPlacardUpdate);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_DISBAND,__consortiaDisband);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_INVITE_PASS,__consortiaInvitePass);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_INVITE,__consortiaInvate);			
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_RESPONSE,__consortiaResponse);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_BANCHAT_UPDATE,__banChatUpdate);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_USER_GRADE_UPDATE,__consortiaUserUpGrade);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_MAIL_MESSAGE, _consortiaMailMessage);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHECK_CODE,__checkCodePopup);	
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUFF_OBTAIN,__buffObtain);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUFF_ADD,__buffAdd);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUFF_UPDATE,__buffUpdate);
			/* 结婚 */
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_STATUS,__showPropose);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_APPLY,__marryApply);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_APPLY_REPLY,__marryApplyReply);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DIVORCE_APPLY,__divorceApply);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.INVITE,__churchInvite);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRYPROP_GET,__marryPropGet);
			
			//民政中心
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.AMARRYINFO_REFRESH,__upCivilPlayerView);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRYINFO_GET,__getMarryInfo);
			
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DAILY_AWARD, __dailyAwardHandler);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USER_ANSWER, __userAnswerHandler);
			
			
			//温泉
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_INVITE,__hotSpringRoomInvite);//温泉房间邀请
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.VIP_UPDATE,__UpdateVIP);
		}
		private function __UpdateVIP(e:CrazyTankSocketEvent):void
		{
			_self.beginChanges();
			_self.ChargedMoney = e.pkg.readInt();
			_self.VIPLevel = e.pkg.readInt();
			//global.traceStr("ChargedMoney"+_self.ChargedMoney.toString()+"VIPLevel"+_self.VIPLevel.toString());
			_self.commitChanges();
		}
		
		private function __userAnswerHandler(evt : CrazyTankSocketEvent) : void
		{
			_self.AnswerSite = evt.pkg.readInt();
		}
		private function __dailyAwardHandler(evt : CrazyTankSocketEvent) : void
		{
			var bool : Boolean = evt.pkg.readBoolean();
			var getWay:int = evt.pkg.readInt();
			
			if(getWay == 0)
			{
				DailyConductFrame.isDayGet = bool;
			}
			else if(getWay == 1)
			{
				DailyConductFrame.isClientGet = bool;
			}
		}
		private function __updatePrivateInfo(e:CrazyTankSocketEvent):void
		{
			_self.beginChanges();
			_self.Money = e.pkg.readInt();
			_self.Gold = e.pkg.readInt();
			_self.Gift = e.pkg.readInt();
			_self.commitChanges();
		}
		
		private function __updatePlayerInfo(evt:CrazyTankSocketEvent):void
		{
			var info:PlayerInfo = findPlayer(evt.pkg.clientId);
			if(info)
			{
				info.beginChanges();
				try
				{
					var pkg:PackageIn = evt.pkg;
					
					info.GP = pkg.readInt(); 
//					info.Grade = pkg.readInt();
					info.Offer = pkg.readInt();
					info.RichesOffer = pkg.readInt();
					info.RichesRob = pkg.readInt();
					info.WinCount = pkg.readInt();
					info.TotalCount = pkg.readInt();
					info.EscapeCount = pkg.readInt();
					
					info.Attack = pkg.readInt();
					info.Defence = pkg.readInt();
					info.Agility = pkg.readInt();
					info.Luck = pkg.readInt();
					info.Hide = pkg.readInt();
					var style:String = pkg.readUTF();
					info.Style = style;
					var arm:String = style.split(",")[6];
					if(arm == "-1" || arm == "0")
					{
						info.WeaponID = -1;
					}
					else
					{
						info.WeaponID = int(arm);
					} 
					
					info.Colors = pkg.readUTF();
					info.Skin = pkg.readUTF();
					
					info.ConsortiaID = pkg.readInt();
					info.ConsortiaName = pkg.readUTF();
					info.ConsortiaLevel = pkg.readInt();
					info.ConsortiaRepute = pkg.readInt();
					info.Nimbus          = pkg.readInt();
					info.PvePermission = pkg.readUTF();
					info.fightLibMission = pkg.readUTF();
					info.FightPower    = pkg.readInt();
					
	     			info.AchievementPoint = pkg.readInt();
					info.honor = pkg.readUTF();
					info.VIPLevel = pkg.readInt();
					info.LastSpaDate=pkg.readDate();
//					info.DeputyWeaponID = pkg.readInt();
//					info.AnswerSite    = pkg.readInt();
				}
				finally
				{
					info.commitChanges();
				}
			}
		}
		
		/**
		 *  战斗中临时换装 
		 */		
		private var tempStyle:Array = [];
		public function get hasTempStyle():Boolean
		{
			return  tempStyle.length > 0;
		}
		public function setStyleTemply(tempPlayerStyle:Object):void
		{
			var player:PlayerInfo = findPlayer(tempPlayerStyle.ID);
			if(player)
			{
				storeTempStyle(player);
				player.beginChanges();
				player.Sex = tempPlayerStyle.Sex;
				player.Hide = tempPlayerStyle.Hide;
				player.Style = tempPlayerStyle.Style;
				player.Colors = tempPlayerStyle.Colors;
				player.Skin = tempPlayerStyle.Skin;
				player.commitChanges();
			}
		}
		private function storeTempStyle(player:PlayerInfo):void
		{
			var o:Object = new Object();
			o.Style = player.getPrivateStyle();
			o.Hide = player.Hide;
			o.Sex = player.Sex;
			o.Skin = player.Skin;
			o.Colors = player.Colors;
			o.ID = player.ID;
			tempStyle.push(o);
		}
		public function readAllTempStyleEvent():void
		{
			for(var i:int = 0;i<tempStyle.length;i++)
			{
				var player:PlayerInfo = findPlayer(tempStyle[i].ID);
				if(player)
				{
					player.beginChanges();
					player.Sex = tempStyle[i].Sex;
					player.Hide = tempStyle[i].Hide;
					player.Style = tempStyle[i].Style;
					player.Colors = tempStyle[i].Colors;
					player.Skin = tempStyle[i].Skin;
					player.commitChanges();
				}
			}
			tempStyle = [];
		}
		
		/**
		 * 背包 
		 */		
		private function __updateInventorySlot(evt:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = evt.pkg as PackageIn;
			var bagType:int = pkg.readInt();
			var len:int = pkg.readInt();
			var bag:BagInfo = _self.getBag(bagType);
//			trace("背包类型："+bagType + "  增加"+len+"个物品，开始");
			bag.beginChanges();
			try
			{
				for(var i:int = 0; i < len;i ++)
				{
					var slot:int = pkg.readInt();
					var isUpdate:Boolean = pkg.readBoolean();
					if(isUpdate)
					{
						var item:InventoryItemInfo = bag.getItemAt(slot);
						if(item == null)
						{
							item = new InventoryItemInfo();
							item.Place = slot;
						}
						item.UserID = pkg.readInt();
						item.ItemID = pkg.readInt();
						item.Count = pkg.readInt();
						item.Place = pkg.readInt();
						item.TemplateID = pkg.readInt();
						item.AttackCompose = pkg.readInt();
						item.DefendCompose = pkg.readInt();
						item.AgilityCompose = pkg.readInt();
						item.LuckCompose = pkg.readInt();
						item.StrengthenLevel = pkg.readInt();
						item.IsBinds = pkg.readBoolean();
						item.IsJudge = pkg.readBoolean();
						item.BeginDate = pkg.readDateString();
						item.ValidDate = pkg.readInt();
						item.Color = pkg.readUTF();
						item.Skin = pkg.readUTF();
						item.IsUsed = pkg.readBoolean();
						item.Hole1 = pkg.readInt();
						item.Hole2 = pkg.readInt();
						item.Hole3 = pkg.readInt();
						item.Hole4 = pkg.readInt();
						item.Hole5 = pkg.readInt();
						item.Hole6 = pkg.readInt();
						ItemManager.fill(item);
//						trace("协议时添加的物品信息：" + item.Name);
						bag.addItem(item);
						if(item.Place == 15 && bagType == 0 && item.UserID == Self.ID)
						{
							_self.DeputyWeaponID = item.TemplateID;
						}
						//发送给香港易游的数据
						if(PathManager.solveExternalInterfaceEnabel() && bagType == BagInfo.STOREBAG && item.StrengthenLevel>=7)
						{
							ExternalInterfaceManager.sendToAgent(3,Self.ID,Self.NickName,ServerManager.Instance.zoneName,item.StrengthenLevel);
						}
					}
					else
					{
						bag.removeItemAt(slot);
//						if(slot == 6 && bagType == 0)
//						{
//							_self.WeaponID = 0;
//						}
					}
				}
//				trace("背包类型："+bagType + "  增加"+len+"个物品,结束");
			}
			finally
			{
				bag.commiteChanges();
			}		
		}		
		
		private function __bagLockedHandler(evt : CrazyTankSocketEvent) : void
		{
			var userId : int = evt.pkg.readInt();
			var type   : int = evt.pkg.readInt();
			var isSussect : Boolean = evt.pkg.readBoolean();
			var boo:Boolean = evt.pkg.readBoolean();
			var msg : String = evt.pkg.readUTF();
			var count:int = evt.pkg.readInt();
			var questionOne:String = evt.pkg.readUTF();
			var questionTwo:String = evt.pkg.readUTF();
			MessageTipManager.getInstance().show(msg);
			if(isSussect)
			{
				switch(type)
				{
					case 1:
					_self.bagPwdState = true;
					_self.bagLocked = true;
					_self.onReceiveTypes(BagEvent.CHANGEPSW);
					break;
					//set
					case 2://get
					_self.bagPwdState = true;
					_self.bagLocked = false;
					_self.onReceiveTypes(BagEvent.CLEAR);
					break;
					case 3://update
					_self.onReceiveTypes(BagEvent.UPDATE_SUCCESS);
					break;
					case 4://delete
					_self.bagPwdState = false;
					_self.bagLocked = false;
					_self.onReceiveTypes(BagEvent.AFTERDEL);	
					break;
					case 5:
					_self.bagPwdState = true;
					_self.bagLocked = true;
					break;
					case 6:
					break;
				}
				
			}
		}
		
		/**
		 * 好友
		 */		
		private function __friendAdd(evt:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = evt.pkg;
			var info:FriendListPlayer = new FriendListPlayer();
			info.beginChanges();
			info.ID = pkg.readInt();
			info.NickName = pkg.readUTF();
			info.Sex = pkg.readBoolean();
			info.Style = pkg.readUTF();
			
			info.Colors = pkg.readUTF();
			info.Skin = pkg.readUTF();
			info.State = pkg.readInt();
			info.Grade = pkg.readInt();
			info.Hide = pkg.readInt();
			info.ConsortiaName = pkg.readUTF();
			info.TotalCount = pkg.readInt();
			info.EscapeCount = pkg.readInt();
			info.WinCount = pkg.readInt();
			info.Offer = pkg.readInt();
			info.Repute = pkg.readInt();
			info.Relation = pkg.readInt();
			/**人人网补丁加的**/
			info.LoginName = pkg.readUTF();
			info.Nimbus = pkg.readInt();
			info.FightPower = pkg.readInt();
			info.AchievementPoint = pkg.readInt();
			info.honor = pkg.readUTF();
			info.commitChanges();
			if(info.Relation == 0)
			{
				addFriend(info);
				if(PathInfo.isUserAddFriend)new AddCommunityFriend(info.LoginName,info.NickName);
			}else
			{
				addBlackList(info);
			}
			dispatchEvent(new IMEvent(IMEvent.ADDNEW_FRIEND,info));
		}
		
		private function __friendRemove(evt:CrazyTankSocketEvent):void
		{
			removeFriend(evt.pkg.clientId);
		}
		
		private function __playerState(evt:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = evt.pkg;
			if(pkg.clientId != _self.ID)
			{
				playerStateChange(pkg.clientId,pkg.readByte());
			}
		}
		
		/**
		 * 工会 
		 */		
		private function __consortiaCreate(evt:CrazyTankSocketEvent):void
		{
			var n:String = evt.pkg.readUTF();
			var isSucuess:Boolean = evt.pkg.readBoolean()
			var id:int = evt.pkg.readInt();
			var cName:String = evt.pkg.readUTF();
			var msg:String  = evt.pkg.readUTF();
			MessageTipManager.getInstance().show(msg);
			var level:int = evt.pkg.readInt();
			var dutyName:String = evt.pkg.readUTF();
			var right:int = evt.pkg.readInt();
			if(isSucuess)
			{
				setPlayerConsortia(id,n);
				Self.DutyLevel = level;
				Self.DutyName = dutyName;
				Self.Right = right;
				Self.ConsortiaLevel = 1;
				_self.refreshConsortiaRelateList();
				Self.sendGetMyConsortiaData();/**更新公会数据**/
				TaskManager.requestClubTask();//加载任务模板
				if(PathManager.solveExternalInterfaceEnabel())
				{
					ExternalInterfaceManager.sendToAgent(4,Self.ID,Self.NickName,ServerManager.Instance.zoneName,-1,cName);
				}	
				dispatchEvent(new Event(CONSORTIA_CHANNGE));
			}
		}
		
		private function __consortiaPlacardUpdate(evt:CrazyTankSocketEvent):void
		{
			SelfConsortia.Placard = evt.pkg.readUTF();
			var isSuccess:Boolean = evt.pkg.readBoolean();
			var msg:String = evt.pkg.readUTF();
			MessageTipManager.getInstance().show(msg);
			dispatchEvent(new Event(CONSORTIA_PLACARD_UPDATE));
		}

		private function __consortiaDisband(evt:CrazyTankSocketEvent):void
		{
			if(evt.pkg.readBoolean())
			{
				if(evt.pkg.readInt() == _self.ID)
				{
					_self.ConsortiaLevel = 0;
					_self.ConsortiaRepute = 0;
					_self.ConsortiaName = "";
					_self.ConsortiaHonor = 0;
					_self.ConsortiaRiches = 0;
					_self.DutyLevel       = 0;
					_self.DutyName        = "";
					setPlayerConsortia();
					
					_self.refreshConsortiaRelateList();
					if(StateManager.currentStateType == StateType.CONSORTIA)
					{
						StateManager.back();
					}
					
					ChatManager.Instance.sysChatRed(LanguageMgr.GetTranslation("ddt.manager.PlayerManager.msg"));
					MessageTipManager.getInstance().show(evt.pkg.readUTF());
				}
			}
			else
			{
				var id : int = evt.pkg.readInt();
				var msgii : String = evt.pkg.readUTF();
				MessageTipManager.getInstance().show(msgii);
			}
		}
		
		private function __consortiaInvitePass(evt:CrazyTankSocketEvent):void
		{
			evt.pkg.readInt();
			var success:Boolean = evt.pkg.readBoolean();
			var id:int = evt.pkg.readInt();
			var name:String = evt.pkg.readUTF();
			
			MessageTipManager.getInstance().show(evt.pkg.readUTF());
			if(success)
			{
				setPlayerConsortia(id,name);
				
				if(StateManager.currentStateType == StateType.CONSORTIA)
				{
//					StateManager.back();
					dispatchEvent(new Event(CONSORTIAMEMBER_STATE_CHANGED));
				}
				_self.refreshConsortiaRelateList();
				dispatchEvent(new Event(CONSORTIAMEMBER_STATE_CHANGED));
			}
			
		}

		
		private function __itemEquip(evt:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = evt.pkg;
			pkg.depack();
			var _id:int = pkg.readInt();
			var info:PlayerInfo = findPlayer(_id);
			
			var cMemberInfo:ConsortiaPlayerInfo = getConsortiaMemberInfo(_id);
			if(info != null)
			{
				info.beginChanges();
				info.Agility = pkg.readInt();
				info.Attack = pkg.readInt();
				if(!PlayerManager.Instance.hasTempStyle)
				{
					info.Colors = pkg.readUTF();
					info.Skin = pkg.readUTF();
				}else
				{
					pkg.readUTF();
					pkg.readUTF();
				}
				info.Defence = pkg.readInt();
				info.GP = pkg.readInt();
				info.Grade = pkg.readInt();
				info.Luck = pkg.readInt();
				if(!PlayerManager.Instance.hasTempStyle)
				{
					info.Hide = pkg.readInt();
				}else
				{
					pkg.readInt();
				}
				info.Repute = pkg.readInt();
				if(!PlayerManager.Instance.hasTempStyle)
				{
					info.Sex = pkg.readBoolean();
					info.Style = pkg.readUTF();
				}else
				{
					pkg.readBoolean();
					pkg.readUTF();
				}
				info.Offer = pkg.readInt();
				info.NickName = pkg.readUTF();
				info.WinCount = pkg.readInt();
				info.TotalCount = pkg.readInt();
				info.EscapeCount = pkg.readInt();
				info.ConsortiaID = pkg.readInt();
				info.ConsortiaName = pkg.readUTF();
				info.RichesOffer = pkg.readInt();
				info.RichesRob = pkg.readInt();
				info.IsMarried = pkg.readBoolean();
				info.SpouseID = pkg.readInt();
				info.SpouseName = pkg.readUTF();
				info.DutyName   = pkg.readUTF();
				info.Nimbus = pkg.readInt();
				info.FightPower = pkg.readInt();
				info.AchievementPoint = pkg.readInt();
				info.honor = pkg.readUTF();
				info.VIPLevel = pkg.readInt();
				info.commitChanges();
				var _itemNum:int = pkg.readInt();
				info.Bag.beginChanges();
				for(var i:uint = 0;i<_itemNum;i++){
					var item:InventoryItemInfo = new InventoryItemInfo();
					
					item.BagType = pkg.readByte();
					item.UserID = pkg.readInt();
					item.ItemID = pkg.readInt();
					item.Count = pkg.readInt();
					item.Place = pkg.readInt();
					item.TemplateID = pkg.readInt();
					item.AttackCompose = pkg.readInt();
					item.DefendCompose = pkg.readInt();
					item.AgilityCompose = pkg.readInt();
					item.LuckCompose = pkg.readInt();
					item.StrengthenLevel = pkg.readInt();
					item.IsBinds = pkg.readBoolean();
					item.IsJudge = pkg.readBoolean();
					item.BeginDate = pkg.readDateString();
					
					item.ValidDate = pkg.readInt();
					item.Color = pkg.readUTF();
					item.Skin = pkg.readUTF();
					item.IsUsed = pkg.readBoolean();
					
					ItemManager.fill(item);
					
					item.Hole1 = pkg.readInt();
					item.Hole2 = pkg.readInt();
					item.Hole3 = pkg.readInt();
					item.Hole4 = pkg.readInt();
					item.Hole5 = pkg.readInt();
					item.Hole6 = pkg.readInt();
					
					info.Bag.addItem(item);
				}
				info.Bag.commiteChanges();
				if(	cMemberInfo)
				{			
					cMemberInfo.info.beginChanges();
					cMemberInfo.Offer = cMemberInfo.info.Offer = info.Offer;
					cMemberInfo.info.WinCount = info.WinCount;
					cMemberInfo.info.TotalCount = info.TotalCount;
					cMemberInfo.info.EscapeCount = info.EscapeCount;
					cMemberInfo.info.Repute = info.Repute;
					cMemberInfo.info.Grade = info.Grade;
					cMemberInfo.RichesOffer = cMemberInfo.info.RichesOffer = info.RichesOffer;
					cMemberInfo.RichesRob = cMemberInfo.info.RichesRob = info.RichesRob;
					cMemberInfo.info.commitChanges();
					consortiaMemberList.add(cMemberInfo.ID,cMemberInfo);
				}
				
			}
		}

		private function readStyleEvent(event:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = event.pkg;
			var player:PlayerInfo = findPlayer(pkg.clientId);
			if(player != null)
			{
				player.beginChanges();
				player.setAttackDefenseValues(pkg.readInt(),pkg.readInt(),pkg.readInt(),pkg.readInt());
				player.Hide = pkg.readInt();
				var s:Array = pkg.readUTF().split("&");
				player.Skin = pkg.readUTF();
				player.Style = s[0];
				player.Colors = s[1];
				var arm:String = player.getPrivateStyle().split(",")[6];
				if(arm == "-1" || arm == "0")player.WeaponID = -1;
				else player.WeaponID = int(arm);
				player.GP =  pkg.readInt();
				player.ConsortiaID = pkg.readInt();
				player.ConsortiaName = pkg.readUTF();
				player.ConsortiaLevel = pkg.readInt();
				player.ConsortiaRiches = pkg.readInt();	
				player.Nimbus = pkg.readInt();
				player.commitChanges();
			}
		}
		
		
		public function playerStateChange(id:int,state:int):void
		{
			var info:PlayerInfo = findPlayer(id,-1);
			if(info.NickName == null)
			{
				if(!getConsortiaMemberInfo(id))return;
				info = getConsortiaMemberInfo(id).info;
				var _clube_member_info:ConsortiaPlayerInfo = getConsortiaMemberInfo(info.ID);
				if(_clube_member_info)
				{
					_clube_member_info.State = state;
					_consortiaMemberList.add(_clube_member_info.ID,_clube_member_info);
				}
				return;
			}
			if(info)
			{
				if(info.State != state)
				{
					info.State = state;
					friendList.add(id,info);
					if(SharedManager.Instance.showOL){
						var strII:String = "";//好友
						if(state == 1){
							strII = LanguageMgr.GetTranslation("ddt.game.ToolStripView.friend")+"["+info.NickName+"]"+LanguageMgr.GetTranslation("ddt.manager.PlayerManger.friendOnline");
						}else{
							strII = LanguageMgr.GetTranslation("ddt.game.ToolStripView.friend")+"["+info.NickName+"]"+LanguageMgr.GetTranslation("ddt.manager.PlayerManger.friendOffline");
						}
						ChatManager.Instance.sysChatYellow(strII);
					}
				}
				var _clube_member_infoII:ConsortiaPlayerInfo = getConsortiaMemberInfo(info.ID);
				if(_clube_member_infoII)
				{
					_clube_member_infoII.State = state;
					_consortiaMemberList.add(_clube_member_infoII.ID,_clube_member_infoII);
				}
			}
		}
		
		/*
		 * 添加到好友列表 
		 */
		public function addFriend(player:PlayerInfo):void
		{
			blackList.remove(player.ID);
			friendList.add(player.ID,player);
		}
		/*
		 * 添加到黑名单
		 */
		public function addBlackList(player:FriendListPlayer):void
		{
			friendList.remove(player.ID);
			blackList.add(player.ID,player);
		}
		
		public function removeFriend(id:int):void
		{
			friendList.remove(id);
			blackList.remove(id);
		}
		
		public function addConsortiaPlayer(info:ConsortiaPlayerInfo):void
		{
			_clubPlays[_self.ZoneID].add(info.ID,info);
		}
		
		public function removeConsortiaPlayer(id:int):void
		{
			_clubPlays[_self.ZoneID].remove(id);
		}

		public function findPlayer(id:int,zoneID:int=-1):PlayerInfo
		{
			if(zoneID == -1 || zoneID == _self.ZoneID)
			{
				if(_friendList[_self.ZoneID] == null)
				{
					_friendList[_self.ZoneID] = new DictionaryData();
				}
				if(_clubPlays[_self.ZoneID] == null)
				{
					_clubPlays[_self.ZoneID] = new DictionaryData();
				}
				if(_tempList[_self.ZoneID] == null)
				{
					_tempList[_self.ZoneID] = new DictionaryData();
				}
				
				if(id == _self.ID)
				{
					return _self;
				}
				else if(_friendList[_self.ZoneID][id])
				{
					return _friendList[_self.ZoneID][id];
				}
				else if(_clubPlays[_self.ZoneID][id])
				{
					return _clubPlays[_self.ZoneID][id];
				}
				else if(_tempList[_self.ZoneID][id])
				{
					return _tempList[_self.ZoneID][id];
				}
				else
				{
					var player:PlayerInfo = new PlayerInfo();
					player.ID = id;
					player.ZoneID = _self.ZoneID;
					_tempList[_self.ZoneID][id] = player;
					return player;
				}
			}else
			{
				if(_friendList[zoneID] && _friendList[zoneID][id])
				{
					return _friendList[zoneID][id];
				}
				else if(_clubPlays[zoneID] && _clubPlays[zoneID][id])
				{
					return _clubPlays[zoneID][id];
				}
				else if(_tempList[zoneID] && _tempList[zoneID][id])
				{
					return _tempList[zoneID][id];
				}
				else
				{
					var player1:PlayerInfo = new PlayerInfo();
					player1.ID = id;
					player1.ZoneID = zoneID;
					if(_tempList[zoneID] == null)
					{
						_tempList[zoneID] = new DictionaryData();
					}
					_tempList[zoneID][id] = player1;
					return player1;
				}
			}
		}
		
		public function findPlayerTempList(id:int):PlayerInfo
		{
			return _tempList[_self.ZoneID][id];
		}
		
		public function hasInTempList(id:int):Boolean {
			if(_tempList[_self.ZoneID] == null)
			{
				_tempList[_self.ZoneID] = new DictionaryData();
			}
			if(_tempList[_self.ZoneID][id]) {
				return true;
			}
			else {
				return false;
			}
		}
		
		public function hasInFriendList(id:int):Boolean {
			if(_friendList[_self.ZoneID] == null)
			{
				_friendList[_self.ZoneID] = new DictionaryData();
			}
			if(_friendList[_self.ZoneID][id]) {
				return true;
			}
			else {
				return false;
			}
		}
		
		public function hasInClubPlays(id:int):Boolean {
			if(_clubPlays[_self.ZoneID] == null)
			{
				_clubPlays[_self.ZoneID] = new DictionaryData();
			}
			if(_clubPlays[_self.ZoneID][id]) {
				return true;
			}
			else {
				return false;
			}
		}
		
		private var str:String;
		private function __consortiaResponse(event:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = event.pkg;
			var type:int = pkg.readByte();
			
			var id:int;
			var name:String;
			
			switch(type)
			{
				/**
				 * 申请通过  & 通过邀请
				 */
				case 1:
				var ID:int = pkg.readInt();
				var isInvent:Boolean = pkg.readBoolean();
				var memberInfo:ConsortiaPlayerInfo;
				var player:PlayerInfo = new PlayerInfo();
				memberInfo = new ConsortiaPlayerInfo(player);

				memberInfo.ID = ID;
				memberInfo.info.ConsortiaID = memberInfo.ConsortiaID = pkg.readInt();
				var cName:String = pkg.readUTF();
				memberInfo.info.ConsortiaName = cName;
				memberInfo.info.ID = memberInfo.UserId = pkg.readInt();
				memberInfo.info.NickName = memberInfo.NickName = pkg.readUTF();
				var inventID:int = pkg.readInt();
				var inventName:String = pkg.readUTF();
				memberInfo.DutyID = pkg.readInt();
				memberInfo.info.DutyName = memberInfo.DutyName = pkg.readUTF();
				memberInfo.info.Offer = memberInfo.Offer = pkg.readInt();
				memberInfo.info.RichesOffer = memberInfo.RichesOffer = pkg.readInt();
				memberInfo.info.RichesRob = memberInfo.RichesRob = pkg.readInt();
				memberInfo.LastDate = pkg.readDateString();
				memberInfo.Grade = memberInfo.info.Grade = pkg.readInt();
				memberInfo.info.DutyLevel = memberInfo.Level = pkg.readInt();
				memberInfo.State = pkg.readInt();
				memberInfo.Sex = memberInfo.info.Sex = pkg.readBoolean();
				memberInfo.info.Right = pkg.readInt();
				memberInfo.info.WinCount = pkg.readInt();
				memberInfo.info.TotalCount = pkg.readInt();
				memberInfo.info.EscapeCount = pkg.readInt();
				memberInfo.info.Repute = pkg.readInt();
				var loginName : String = pkg.readUTF();
				memberInfo.info.LoginName = loginName;
				memberInfo.info.FightPower =  pkg.readInt();
				memberInfo.info.AchievementPoint = pkg.readInt();
				memberInfo.info.honor = pkg.readUTF();
				if(isInvent && memberInfo.info.ID == Self.ID)
				{
					/*  邀请通过*/
//					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.PlayerManager.invite"));
					//MessageTipManager.getInstance().show("邀请通过！");
				}else
				{
					/*  申请通过*/
		
					if(memberInfo.info.ID == Self.ID)
					{
						MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.PlayerManager.one",memberInfo.info.ConsortiaName));
					}
//						MessageTipManager.getInstance().show("玩家["+memberInfo.info.NickName+"]已经加入公会");
				}
				var msgTxt1:String = "";
				if(memberInfo.UserId == PlayerManager.Instance.Self.ID)
				{
					setPlayerConsortia(memberInfo.info.ConsortiaID,memberInfo.info.ConsortiaName);
					_self.refreshConsortiaRelateList();
					Self.Right = memberInfo.info.Right;
					Self.DutyName = memberInfo.info.DutyName;
					dispatchEvent(new Event(CONSORTIAMEMBER_INFO_CHANGE));
					if(isInvent)
					{
//						msg.msg = LanguageMgr.GetTranslation("ddt.manager.PlayerManager.success",memberInfo.info.ConsortiaName);
						msgTxt1 = LanguageMgr.GetTranslation("ddt.manager.PlayerManager.isInvent.msg",memberInfo.info.ConsortiaName);
						//msg.msg = "你成功加入<"+memberInfo.info.ConsortiaName+">公会";
					}else
					{
						msgTxt1 = LanguageMgr.GetTranslation("ddt.manager.PlayerManager.pass",memberInfo.info.ConsortiaName);
						//msg.msg = "<"+memberInfo.info.ConsortiaName+">批准了您的公会申请";
					}
					Self.sendGetMyConsortiaData();/**更新公会数据**/
					if(StateManager.currentStateType == StateType.CONSORTIA)
					{
//						StateManager.back();
						dispatchEvent(new Event(CONSORTIAMEMBER_STATE_CHANGED));
					}
					
					TaskManager.requestClubTask();//加载任务模板
					//发送给香港易游的数据
					if(PathManager.solveExternalInterfaceEnabel())
					{
						ExternalInterfaceManager.sendToAgent(5,Self.ID,Self.NickName,ServerManager.Instance.zoneName,-1,cName);
					}
				}else
				{
					consortiaMemberList.add(memberInfo.ID,memberInfo);
					msgTxt1 = LanguageMgr.GetTranslation("ddt.manager.PlayerManager.player",memberInfo.NickName);
					
				}
				msgTxt1 = StringHelper.rePlaceHtmlTextField(msgTxt1);
				ChatManager.Instance.sysChatYellow(msgTxt1);
				break;
				/**
				 * 公会解散
				 */
				case 2:
				id = pkg.readInt();
				Self.ConsortiaLevel = 0;
				setPlayerConsortia();
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.PlayerManager.your"));
				_self.refreshConsortiaRelateList();
				dispatchEvent(new Event(CONSORTIAMEMBER_STATE_CHANGED));
				ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("ddt.manager.PlayerManager.disband"));
				
				if(StateManager.currentStateType == StateType.CONSORTIA)
				{
					StateManager.back();
				}
				
				break;
				/**
				 * 踢出公会
				 */
				case 3:
				//被踢者ID
				id = pkg.readInt();
				//公会ID
				var consortiaID:int = pkg.readInt();
				//踢 or 自动退会
				var isKick:Boolean = pkg.readBoolean();
				//被踢者昵称
				name = pkg.readUTF();
				//踢人者昵称
				var kickName:String = pkg.readUTF();
				
				if(Instance.Self.ID == id)
				{
					setPlayerConsortia();
					Self.refreshConsortiaRelateList();
					var msgTxt5:String = "";
					if(isKick)
					{
						
						msgTxt5 = LanguageMgr.GetTranslation("ddt.manager.PlayerManager.delect",kickName);
						//msg5.msg = "你已经被<"+kickName+">移除出公会";
						MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.PlayerManager.hit"));
					}else
					{
						msgTxt5 = LanguageMgr.GetTranslation("ddt.manager.PlayerManager.leave");
						//msg5.msg = "你已离开公会";
					}
					
					if(PlayerManager.Instance.Self.ID == id)
					{
						if(StateManager.currentStateType == StateType.CONSORTIA)
						{
							StateManager.back();
						}
					}
					
					msgTxt5 = StringHelper.rePlaceHtmlTextField(msgTxt5);
					ChatManager.Instance.sysChatRed(msgTxt5);
				}else
				{
					removeConsortiaMember(id,isKick,kickName);
				}
				
				break;
				
				case 4:
				/**
				 * 邀请进入公会
				 */
				id = pkg.readInt();
				
				
	            pkg.readInt();
	           	pkg.readUTF();
		       	pkg.readInt();
		        var intviteName:String = pkg.readUTF();
		        pkg.readInt();
		        var consortiaName:String = pkg.readUTF();
		        
		        
		        /* 公会邀请开关 *//*/**新手教程学习中***/
//		        if(SharedManager.Instance.showCI && !EnterTutorialFrame.tutorialState)
		        if(SharedManager.Instance.showCI){
		        	
		        	if(str != intviteName)
		        	{
						SoundManager.Instance.play("018");
		        		var context : String = intviteName + LanguageMgr.GetTranslation("ddt.manager.PlayerManager.come",consortiaName);
		        		context = StringHelper.rePlaceHtmlTextField(context);
		        		HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.manager.PlayerManager.request"),context,true,accpetConsortiaInvent,rejectConsortiaInvent,true,LanguageMgr.GetTranslation("ddt.manager.PlayerManager.sure"),LanguageMgr.GetTranslation("ddt.manager.PlayerManager.refuse"),380);
		        		str = intviteName;
		        	}
		        	
		        }
		        
		        //ConfirmDialog.show("公会邀请：",intviteName+" 邀请你进入  <"+consortiaName+">公会",true,accpetConsortiaInvent,rejectConsortiaInvent,true,"确认加入","拒绝加入");
//		        MessageTipManager.getInstance().show(intviteName+" 邀请你进入  <"+consortiaName+">公会");
		       
		        break;
		        /*****
		        * 禁言
		        */
		        case 5:
		        var isBan:Boolean = pkg.readBoolean();
		        id = pkg.readInt();
		        name = pkg.readUTF();
		        var id2:int = pkg.readInt();
		        var name2:String = pkg.readUTF();
		        if(id == Self.ID)
		        {
//					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.PlayerManager.forbid",name2));        
		        }else
		        {
//		        	MessageTipManager.getInstance().show(name2+LanguageMgr.GetTranslation("ddt.manager.PlayerManager.forbid"));
		        	//MessageTipManager.getInstance().show(name2+"已经被禁言");
		        }
		        // MessageTipManager.getInstance().show("你已经被"+name2+"禁言");
		        
		        break;
		        /**
		        * 公会升级
		        * */
		        
		        
		        case 6:
		        var myid:int = pkg.readInt();
		        var myname:String = pkg.readUTF();
		        var myLevel:int = pkg.readInt();
		        if(PlayerManager.Instance.Self.ConsortiaID == myid)
		        {
		        	PlayerManager.Instance.Self.ConsortiaLevel  = myLevel;
		        	ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("ddt.manager.PlayerManager.upgrade",myLevel,ConsortiaLevelUpManager.Instance.getLevelData(myLevel).Count));
		        	TaskManager.requestClubTask();//加载任务模板
		        	SoundManager.Instance.play("1001");
		        	Self.sendGetMyConsortiaData();/**更新公会数据**/
		        //	TaskManager.onGuildUpdate();
		        }
		       
		        
		        break;
		        /**
		        * 关系改变
		        * */
		        
		        case 7:
//		        var id1:int = pkg.readInt();
//		        var id3:int = pkg.readInt();
//		        var state:int = pkg.readInt();
//		        
//		        var info:ConsortiaInfo;
//		        if(PlayerManager.Instance.Self.ConsortiaID == id1)
//		        {
//		        	if(PlayerManager.Instance.Self.ConsortiaAllyList[id3])
//		        	{
//		        		PlayerManager.Instance.Self.ConsortiaAllyList[id3].State = state;
//		        	}else
//		        	{
//		        		info = new ConsortiaInfo();
//		        		info.ConsortiaID = id3;
//		        		info.State = state;
//		        		PlayerManager.Instance.Self.ConsortiaAllyList.add(id3,info);
//		        	}
//		        }else if(PlayerManager.Instance.Self.ConsortiaID == id3)
//		        {
//		        	if(PlayerManager.Instance.Self.ConsortiaAllyList[id1])
//		        	{
//		        		PlayerManager.Instance.Self.ConsortiaAllyList[id1].State = state;
//		        	}else
//		        	{
//		        		info = new ConsortiaInfo();
//		        		info.ConsortiaID = id1;
//		        		info.State = state;
//		        		PlayerManager.Instance.Self.ConsortiaAllyList.add(id1,info);
//		        	}
//		        }
		        break;
		        
		        case 8:
		        //updateType：1.添加责务，2.更改责务，3.职务升级，4.职务降级，5.个人改变。 6成员升级  7 成员降级 8.会长转让,9.升会长的人。


		        var subType:int = pkg.readByte();
		        var consortiaId:int = pkg.readInt();
		        var playerId:int = pkg.readInt();
		        var playerName:String = pkg.readUTF();
		        var dutyLeve:int = pkg.readInt();
		        var dName:String = pkg.readUTF();
		        var rights:int = pkg.readInt();
		        var handleID:int = pkg.readInt();
		        var handleName:String = pkg.readUTF();
		        if(subType == 1)
		        {
		        	
		        }
		        else if(subType == 2)
		        {
		        	updateDutyInfo(dutyLeve,dName,rights);
		        }
		        else if(subType == 3 )
		        {
		        	upDateSelfDutyInfo(dutyLeve,dName,rights);
		        	
		        	
		        }else if(subType == 4 )
		        {
		        	upDateSelfDutyInfo(dutyLeve,dName,rights);
		        }else if(subType == 5 )
		        {
		        	upDateSelfDutyInfo(dutyLeve,dName,rights);
		        }else if(subType == 6 )
		        {
		        	updateConsortiaMemberDuty(playerId,dutyLeve,dName,rights);
		        	var msgTxt6:String = "";
		        	if(playerId == Self.ID)
		        	{
		        		msgTxt6 = LanguageMgr.GetTranslation("ddt.manager.PlayerManager.youUpgrade",handleName,dName);
		        		//msg6.msg = "你被<"+handleName+">提升为<"+dName+">";
		        	}
		        	else
		        	{
		        		if(playerId == handleID)
		        		{
		        			msgTxt6 = LanguageMgr.GetTranslation("ddt.manager.PlayerManager.upgradeSelf",playerName,dName);
		        			//msg6.msg = "你将<"+Self.NickName+">提升为<"+dName+">";
		        		}
		        		else
		        		{
		        			msgTxt6 = LanguageMgr.GetTranslation("ddt.manager.PlayerManager.upgradeOther",handleName,playerName,dName);
		        			//msg6.msg = "<"+handleName +">将<"+Self.NickName+">提升为<"+dName+">";
		        		}
		        		
		        	}
		        	msgTxt6 = StringHelper.rePlaceHtmlTextField(msgTxt6);
		        	ChatManager.Instance.sysChatYellow(msgTxt6);
		        }else if(subType == 7 )
		        {
		        	updateConsortiaMemberDuty(playerId,dutyLeve,dName,rights);
		        	var msgTxt7:String = "";
		        	if(playerId == Self.ID)
		        	{
		        		msgTxt7 = LanguageMgr.GetTranslation("ddt.manager.PlayerManager.youDemotion",handleName,dName);
		        		//msg7.msg = "你被<"+handleName+">降职官阶为<"+dName+">";
		        	}
		        	else
		        	{
		        		if(playerId == handleID)
		        		{
		        			msgTxt7 = LanguageMgr.GetTranslation("ddt.manager.PlayerManager.demotionSelf",playerName,dName);
		        			//msg7.msg = "你将<"+Self.NickName+">降职为<"+dName+">";
		        		}
		        		else
		        		{
		        			msgTxt7 = LanguageMgr.GetTranslation("ddt.manager.PlayerManager.demotionOther",handleName,playerName,dName);
		        			//msg7.msg = "<"+handleName +">将<"+Self.NickName+">降职为<"+dName+">";
		        		}
		        		
		        	}
		        	msgTxt7 = StringHelper.rePlaceHtmlTextField(msgTxt7);
		        	ChatManager.Instance.sysChatYellow(msgTxt7);
		        }else if(subType == 8 )
		        {
		        	updateConsortiaMemberDuty(playerId,dutyLeve,dName,rights);
		        	SoundManager.Instance.play("1001");
		        }else if(subType == 9 )
		        {
		        	updateConsortiaMemberDuty(playerId,dutyLeve,dName,rights);
		        	Self.CharManName = playerName;
		        	var msgTxt9:String = "<"+playerName+">"+ LanguageMgr.GetTranslation("ddt.manager.PlayerManager.up")+dName;
		        	//msg9.msg = playerName+ "升级成为"+dName;
		        	msgTxt9 = StringHelper.rePlaceHtmlTextField(msgTxt9);
		        	ChatManager.Instance.sysChatYellow(msgTxt9);
		        	SoundManager.Instance.play("1001");
		        }

		        break;
		        case 9:
		        /**
		        * 财富捐献
		        */
		        var consortiaId9 : int = pkg.readInt();
		        var playerId9    : int = pkg.readInt();
		        var playerName9  : String = pkg.readUTF();
		        var riches      : int    = pkg.readInt();
		        if(consortiaId9 != Self.ConsortiaID)return;
		        var msgTxt10:String = "";
		        if(Self.ID == playerId9)
		        {
		        	msgTxt10 = LanguageMgr.GetTranslation("ddt.manager.PlayerManager.contributionSelf",riches);
		        	//msg.msg = "你向公会捐款"+riches+"点财富";
		        }
		        else
		        {
		        	msgTxt10 = LanguageMgr.GetTranslation("ddt.manager.PlayerManager.contributionOther",playerName9,riches);
		        	//msg.msg = playerName+ "向公会捐款"+riches+"点财富";
		        }
		        ChatManager.Instance.sysChatYellow(msgTxt10);
		        break;
		        case 10:
		        /**公会商城升级**/
		        __consortiaIIUpLevel(10,pkg.readInt(),pkg.readUTF(),pkg.readInt());
		         
		        break;
		        case 11:
		        /**公会铁匠铺升级**/
		        __consortiaIIUpLevel(11,pkg.readInt(),pkg.readUTF(),pkg.readInt());
		        break;
		        case 12:
		        /**公会银行升级**/
		       __consortiaIIUpLevel(12,pkg.readInt(),pkg.readUTF(),pkg.readInt());
		        break;

			}
import ddt.manager.ConsortiaQuitTipManager;
import ddt.manager.ExternalInterfaceManager;
import ddt.view.common.church.DialogueRejectPropose;

			function accpetConsortiaInvent():void
			{
				SocketManager.Instance.out.sendConsortiaInvatePass(id);
				str = "";
			}
			function rejectConsortiaInvent():void
			{
				SocketManager.Instance.out.sendConsortiaInvateDelete(id);
				str = "";
			}
			//任务检查
			TaskManager.onGuildUpdate();
		}
		/**公会中商城,铁匠,保管箱升级后的响应**/
		private function __consortiaIIUpLevel(type : int,id:int,name:String,level:int) : void
		{
			if(id != Self.ConsortiaID)return;
			SoundManager.Instance.play("1001");
			var tipText:String = "";
		    if(type == 10)
		    {
		    	if(Self.DutyLevel == 1)tipText = LanguageMgr.GetTranslation("ddt.manager.PlayerManager.consortiaShop",level);
		    	//if(Self.DutyLevel == 1)msg.msg = "您将公会商城升级到"+level+"级";
		    	else tipText = LanguageMgr.GetTranslation("ddt.manager.PlayerManager.consortiaShop2",level);
		    	//else msg.msg = "你所在的公会商城升级到"+level+"级";
		    	Self.ShopLevel = level;
		    }
		    else if(type == 11)
		    {
		    	if(Self.DutyLevel == 1)tipText = LanguageMgr.GetTranslation("ddt.manager.PlayerManager.consortiaStore",level);
		    	//if(Self.DutyLevel == 1)msg.msg = "您将公会铁匠铺升级到"+level+"级";
		    	else tipText = LanguageMgr.GetTranslation("ddt.manager.PlayerManager.consortiaStore2",level);
		    	//else msg.msg = "你所在的公会铁匠铺升级到"+level+"级";
		    	Self.SmithLevel = level;
		    }
		    else
		    {
		    	if(Self.DutyLevel == 1)tipText = LanguageMgr.GetTranslation("ddt.manager.PlayerManager.consortiaSmith",level);
		    	//if(Self.DutyLevel == 1)msg.msg = "您将公会保管箱升级到"+level+"级";
		    	else tipText = LanguageMgr.GetTranslation("ddt.manager.PlayerManager.consortiaSmith2",level);
		    	//else msg.msg = "你所在的公会保管箱升级到"+level+"级";
		    	Self.StoreLevel = level;
		    } 
		    ChatManager.Instance.sysChatYellow(tipText);
		    Self.sendGetMyConsortiaData();/**更新公会数据**/
		    TaskManager.onGuildUpdate();
		}
		/* 禁言操作返回 */
		private function __banChatUpdate(evt:CrazyTankSocketEvent):void
		{
			var id:int = evt.pkg.readInt();
			var isBandChat:Boolean = evt.pkg.readBoolean();
			var isSuccess:Boolean = evt.pkg.readBoolean();
			var msg:String = evt.pkg.readUTF();
			if(isSuccess)
			{
				var cp:ConsortiaPlayerInfo = getConsortiaMemberInfo(id);
				cp.info.IsBandChat = isBandChat;
			}
			
			MessageTipManager.getInstance().show(msg);
		}
		
		/*  升级降级操作返回*/
		private function __consortiaUserUpGrade(e:CrazyTankSocketEvent):void
		{
			var id:int = e.pkg.readInt();
			var isUpGrade:Boolean = e.pkg.readBoolean();
			var isSuccess:Boolean = e.pkg.readBoolean();
			var msg:String = e.pkg.readUTF();
			if(isUpGrade)
			{
				if(isSuccess)
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.PlayerManager.upsuccess"));
					//MessageTipManager.getInstance().show("升级成员成功！");
				}else
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.PlayerManager.upfalse"));
					//MessageTipManager.getInstance().show("升级成员失败！");
				}
			}else
			{
				if(isSuccess)
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.PlayerManager.downsuccess"));
					//MessageTipManager.getInstance().show("降级成员成功！");
				}else
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.PlayerManager.downfalse"));
					//MessageTipManager.getInstance().show("降级成员失败！");
				}
			}
			
		}
		
		private function _consortiaMailMessage(evt:CrazyTankSocketEvent):void
		{
			ConsortiaQuitTipManager.Instance.message = evt.pkg.readUTF();
			ConsortiaQuitTipManager.Instance.isQuitMessage = true;
		}
		
		public function removeConsortiaMember(id:int,isKick:Boolean,kickName:String):void
		{
			for each (var i:ConsortiaPlayerInfo in consortiaMemberList)
			{
				if(i.info.ID == id)
				{
					var msgTxt:String = "";
					if(isKick)
					{

						msgTxt = LanguageMgr.GetTranslation("ddt.manager.PlayerManager.consortia",kickName,i.NickName);
						//msg.msg = kickName+"将 <"+i.NickName+"> 移除公会";

					}else
					{
						msgTxt = LanguageMgr.GetTranslation("ddt.manager.PlayerManager.leaveconsortia",i.NickName);
						//msg.msg = "<"+i.NickName+"> 离开公会";
					}
					msgTxt = StringHelper.rePlaceHtmlTextField(msgTxt);
					ChatManager.Instance.sysChatYellow(msgTxt);
					consortiaMemberList.remove(i.ID);
				}
			}
		}
		
		public function updateConsortiaMemberDuty(playerId:int,dutyLevel:int,dutyName:String,right:int):void
		{
			for each (var i:ConsortiaPlayerInfo in consortiaMemberList)
			{
				
				if(i.info.ID == playerId)
				{
					i.info.beginChanges();
					i.info.DutyLevel = dutyLevel;
					i.DutyName = i.info.DutyName = dutyName;
					i.info.Right = right;
					if(i.info.ID == Self.ID)
					{
						Self.beginChanges();
						Self.DutyLevel = dutyLevel;
						Self.DutyName = dutyName;
						Self.Right = right;
						Self.ConsortiaLevel = (Self.ConsortiaLevel == 0 ? 1 : Self.ConsortiaLevel);
						Self.commitChanges();
					}
					i.info.commitChanges();
					consortiaMemberList.add(i.ID,i);
				}
			}
		}
			
		public function updateDutyInfo(dutyLevel:int,dutyName:String,right:int):void
		{
			for each (var i:ConsortiaPlayerInfo in consortiaMemberList)
			{
				if(i.info.DutyLevel == dutyLevel)
				{
					i.info.DutyLevel == dutyLevel;
					i.DutyName = i.info.DutyName = dutyName;
					i.info.Right = right;
					consortiaMemberList.add(i.ID,i);
				}
			}
		}
		
		public function upDateSelfDutyInfo(dutyLevel:int,dutyName:String,right:int):void
		{
			for each (var i:ConsortiaPlayerInfo in consortiaMemberList)
			{
				if(i.info.ID == PlayerManager.Instance.Self.ID)
				{
					i.info.DutyLevel == dutyLevel;
					i.DutyName = i.info.DutyName = dutyName;
					i.info.Right == right;
					consortiaMemberList.add(i.ID,i);
					PlayerManager.Instance.Self.DutyLevel == dutyLevel;
					PlayerManager.Instance.Self.DutyName == dutyName;
					PlayerManager.Instance.Self.Right == right;
				}
			}
		}
		
		private function __consortiaInvate(evt:CrazyTankSocketEvent):void
		{
			var name:String = evt.pkg.readUTF();
			var isSuccess:Boolean = evt.pkg.readBoolean();
			var msg:String = evt.pkg.readUTF();
			MessageTipManager.getInstance().show(msg);
		}
		
		private function setPlayerConsortia(id:uint = 0,name:String = ""):void
		{
			if(Instance.Self.ConsortiaID == id) return;
			if(Instance.SelfConsortia)
			{
				Instance.SelfConsortia.ConsortiaID = id;
				Instance.SelfConsortia.ConsortiaName = name;
			}
			Instance.Self.ConsortiaName = name;
			Instance.Self.ConsortiaID = id;
			if(id == 0)Instance.Self.ConsortiaLevel = 0;
			
			dispatchEvent(new Event(CONSORTIA_CHANNGE));
		}
		
		private var _isFinishedTraner:Boolean
		public function finishTrainer():void
		{
			_isFinishedTraner = true;
			//完成新手任务
			var info:QuestInfo = TaskManager.getQuestByID(109);
			if(info && !info.isAchieved)
			{
				if(info.isCompleted)
				{
					//SocketManager.Instance.out.sendQuestCheck(info.id);
					if(!TaskMainFrame.Instance.parent)BellowStripViewII.Instance.showTaskHightLight();
				}
			}
		}
		
		public function addConsortiaMemberInfo(memberInfo:ConsortiaPlayerInfo):void
		{
			_consortiaMemberList[memberInfo.ID] = memberInfo;
			
		}
		public function getConsortiaMemberInfo(id:int):ConsortiaPlayerInfo
		{
			for each (var i:ConsortiaPlayerInfo in _consortiaMemberList)
			{
				if(i.info.ID == id)
					return i;
			}
			return null;
		}
		
		public function get trainerFinished():Boolean
		{
			return _isFinishedTraner;
		}
		
		public function set trainerFinished(b:Boolean):void
		{
			_isFinishedTraner = b;
		}
		
		public function __checkCodePopup(e:CrazyTankSocketEvent):void
		{
			var checkCodeState:int = e.pkg.readByte();
			var backType:Boolean = e.pkg.readBoolean();
			
			if(checkCodeState == 1)
			{
				SoundManager.Instance.play("058");
			}else if(checkCodeState == 2)
			{
				SoundManager.Instance.play("057");
			}
			
			if(backType)
			{
				var msg:String = e.pkg.readUTF();
				CheckCodePanel.Instance.tip=msg;
				var checkCodeData:CheckCodeData = new CheckCodeData();
			
//				var ba:ByteArray = e.pkg.readByteArray();
				var ba:ByteArray = new ByteArray;
				e.pkg.readBytes(ba,0,e.pkg.bytesAvailable);
				var bitmapReader:BitmapReader = new BitmapReader();
				bitmapReader.addEventListener(Event.COMPLETE,readComplete);
				bitmapReader.readByteArray(ba);
				CheckCodePanel.Instance.isShowed = false;
			}else
			{
				CheckCodePanel.Instance.close();
				return;
			}
			
			
			function readComplete(e:Event):void
			{
				checkCodeData.pic = bitmapReader.bitmap;
				CheckCodePanel.Instance.data = checkCodeData;
			}
			if(!(StateManager.currentStateType == StateType.FIGHTING))
			{
				CheckCodePanel.Instance.show();
			}
			
		}
		
		/* 民政中心 */
		private function __upCivilPlayerView(e:CrazyTankSocketEvent):void
		{
			_self.MarryInfoID = e.pkg.readInt();
			var note:Boolean = e.pkg.readBoolean();
			if(note)
			{
				_self.ID = e.pkg.readInt();
				_self.IsPublishEquit = e.pkg.readBoolean();
				_self.Introduction = e.pkg.readUTF();
			}
			dispatchEvent(new Event(CIVIL_PLAYER_INFO_MODIFY));
		}
		private function __getMarryInfo(e:CrazyTankSocketEvent):void
		{
			_self.Introduction = e.pkg.readUTF();
			_self.IsPublishEquit = e.pkg.readBoolean();
			dispatchEvent(new Event(CIVIL_SELFINFO_CHANGE));
		}
		
		
		
		
		private function __selfPopChange(e:PlayerPropertyEvent):void
		{
			if(e.changedProperties["TotalCount"]){
				switch(PlayerManager.Instance.Self.TotalCount){
					case 1:
						StatisticManager.Instance().startAction("gameOver1","yes");
						break;
					case 3:
						StatisticManager.Instance().startAction("gameOver3","yes");
						break;
					case 5:
						StatisticManager.Instance().startAction("gameOver5","yes");
						break;
					case 10:
						StatisticManager.Instance().startAction("gameOver10","yes");
						break;
					default:
						break;
				}
				
			}
			if(e.changedProperties["RichesRob"] || e.changedProperties["RichesOffer"] || e.changedProperties["Offer"])
			{
				var selfMemberInfo:ConsortiaPlayerInfo = getConsortiaMemberInfo(Self.ID);
				if(selfMemberInfo)
				{
					selfMemberInfo.info.RichesRob = selfMemberInfo.RichesRob = Self.RichesRob;
					selfMemberInfo.info.RichesOffer = selfMemberInfo.RichesOffer = Self.RichesOffer;
					selfMemberInfo.info.Offer = selfMemberInfo.Offer = Self.Offer;
				}
			}
			if(e.changedProperties["Grade"]){
				TaskManager.requestCanAcceptTask();
			}
		}
		
		private function __buffAdd(evt:CrazyTankSocketEvent):void
		{
			
		}
		
		private function __buffObtain(evt:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = evt.pkg;
			if(pkg.clientId!=_self.ID)
			{
				return;
			}
			_self.clearBuff();
			var lth:int = pkg.readInt();
			for(var i:int=0;i<lth;i++)
			{
				var type:int = pkg.readInt();
		        var isExist:Boolean = pkg.readBoolean();
	        	var beginData:Date = pkg.readDate();
		        var validDate:int = pkg.readInt();
		        var value:int = pkg.readInt();
		        var buff:BuffInfo = new BuffInfo(type,isExist,beginData,validDate,value);
		        _self.addBuff(buff);
			}
			evt.stopImmediatePropagation();
		}
		
		private function __buffUpdate(evt:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = evt.pkg;
			if(pkg.clientId!=_self.ID)
			{
				return;
			}
			var len:int = pkg.readInt();
			for(var i:uint = 0; i < len; i++)
			{
				var type:int = pkg.readInt();
			    var isExist:Boolean = pkg.readBoolean();
		       	var beginData:Date = pkg.readDate();
		        var validDate:int = pkg.readInt();
		        var value:int = pkg.readInt();
		        var buff:BuffInfo = new BuffInfo(type,isExist,beginData,validDate,value);
		        if(isExist)
		        {
		        	_self.addBuff(buff);
		        }else
		        {
		        	_self.buffInfo.remove(buff.Type);
		        }
			}
		    evt.stopImmediatePropagation();
		}
		
		/**********************************************结婚相关*********************************************************/			
		public function sendValidateMarry(info:PlayerInfo):void
		{
			if(Self.bagLocked)
			{
				new BagLockedGetFrame().show();
				return;
			}
			
			if(Self.IsMarried)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.PlayerManager.IsMarried"));
			}
			else if(Self.Sex == info.Sex)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.PlayerManager.notAllow"));
			}
			else
			{
				SocketManager.Instance.out.sendValidateMarry(info.ID);
			}
		}
	
		public function __showPropose(event:CrazyTankSocketEvent):void
		{
			var spouseID:int = event.pkg.readInt();
			var isMarried:Boolean = event.pkg.readBoolean();

			if(isMarried)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.PlayerManager.married"));
			}
			else if(Self.IsMarried)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.PlayerManager.youMarried"));
			}
			else
			{
				var proposeFrame:ProposeFrame = new ProposeFrame(spouseID);
				TipManager.AddToLayerNoClear(proposeFrame,true);
			}
		}
		private var marryApplyList : Array = new Array();
		private function __marryApply(event:CrazyTankSocketEvent):void
		{
			/* 求婚者的信息 */
			var spouseID:int = event.pkg.readInt();
			var spouseName:String = event.pkg.readUTF();
			var str:String = event.pkg.readUTF();
			var answerId : int = event.pkg.readInt();
			if(spouseID == Self.ID)
			{
				var success : MarryApplySuccess = new MarryApplySuccess();
				TipManager.AddTippanel(success,true);
				return;
			}
			if(checkMarryApplyList(answerId))return;
			marryApplyList.push(answerId);
			SoundManager.Instance.play("018");
			var proposeResposeFrame:ProposeResponseFrame = new ProposeResponseFrame(spouseID,spouseName,answerId,str);
			
			UIManager.AddDialog(proposeResposeFrame,true);
		}
		private function checkMarryApplyList(id : int) : Boolean
		{
			for(var i : int =0 ;i < marryApplyList.length;i++)
			{
				if(id == marryApplyList[i])
				{
					return true;
				}
			}
			return false;
		}
		private var dialogueRejectPropose:DialogueRejectPropose;
		private function __marryApplyReply(event:CrazyTankSocketEvent):void
		{
			/* 对方的信息 */
			var spouseID:int = event.pkg.readInt();
			var result:Boolean = event.pkg.readBoolean(); 
			var spouseName:String = event.pkg.readUTF();
			/* 是否求婚方 */
			var isApplicant:Boolean = event.pkg.readBoolean();
			
			
			if(result)
			{
				Self.IsMarried = true;
				Self.SpouseID = spouseID;
				Self.SpouseName = spouseName;
				TaskManager.onMarriaged();//查看结婚任务
				TaskManager.requestCanAcceptTask();/**找结婚后可以接的任务**/
				//发送给香港易游的数据
				if(PathManager.solveExternalInterfaceEnabel())
				{
					ExternalInterfaceManager.sendToAgent(7,Self.ID,Self.NickName,ServerManager.Instance.zoneName,-1,"",spouseName);
				}
			}
			
			if(isApplicant)
			{
				var msg : ChatData = new ChatData();
				var msgTxt:String = "";
				if(result)
				{
					msg.channel = ChatInputView.SYS_NOTICE;
					msgTxt = "<"+spouseName+">"+LanguageMgr.GetTranslation("ddt.manager.PlayerManager.isApplicant");
					DialogueAgreePropose.Instance.info = spouseName;
					if(StateManager.currentStateType!=StateType.FIGHTING)
					{
						DialogueAgreePropose.Instance.show();
					}
				}else
				{
					msg.channel = ChatInputView.SYS_TIP;
					msgTxt = "<"+spouseName+">"+LanguageMgr.GetTranslation("ddt.manager.PlayerManager.refuseMarry");
					if(dialogueRejectPropose)
					{
						dialogueRejectPropose.hide();
						dialogueRejectPropose.dispose();
						dialogueRejectPropose = null;
					}
					dialogueRejectPropose = new DialogueRejectPropose();
					dialogueRejectPropose.info = spouseName;
				}
				msg.msg = StringHelper.rePlaceHtmlTextField(msgTxt);
				ChatManager.Instance.chat(msg);
			}else
			{
				if(result)
				{
					HAlertDialog.show(LanguageMgr.GetTranslation("ddt.view.task.TaskCatalogContentView.tip"),LanguageMgr.GetTranslation("ddt.manager.PlayerManager.youAndOtherMarried",spouseName));				}
			}
		}
		
		private function __divorceApply(event:CrazyTankSocketEvent):void
		{
			var result:Boolean = event.pkg.readBoolean();
			var isActive:Boolean = event.pkg.readBoolean();
			
			if(!result)
			{
				return;
			}else
			{
				PlayerManager.Instance.Self.IsMarried = false;
				PlayerManager.Instance.Self.SpouseID = 0;
				PlayerManager.Instance.Self.SpouseName = "";
				ChurchRoomManager.instance.selfRoom = null;
				
				if(!isActive)
				{
					SoundManager.Instance.play("018");
					var dialogueUnmarried:DialogueUnmarried = new DialogueUnmarried();
					TipManager.AddTippanel(dialogueUnmarried,true);
				}else
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.PlayerManager.divorce"));
				}
				if(StateManager.currentStateType == StateType.CHURCH_SCENE)
				{
					StateManager.setState(StateType.CHURCH_ROOMLIST);
				}
			}
		}

		private function __churchInvite(event:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = event.pkg;
			
			var obj:Object = new Object();
			obj["inviteID"] = pkg.readInt();
			obj["inviteName"] = pkg.readUTF();
			obj["roomID"] = pkg.readInt();
			obj["roomName"] = pkg.readUTF();
			obj["pwd"] = pkg.readUTF();
			obj["sceneIndex"] = pkg.readInt();
			
//			if(EnterTutorialFrame.tutorialState)return;/**新手教程学习中**/
			
			var invitePanel:InvitePanelForChurch = new InvitePanelForChurch();
			invitePanel.info = obj;
			SoundManager.Instance.play("018");
		}
		
		private function __marryPropGet(event:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = event.pkg;
			Self.IsMarried = pkg.readBoolean();
			Self.SpouseID = pkg.readInt();
			Self.SpouseName = pkg.readUTF();
			
			var isCreatedMarryRoom:Boolean = pkg.readBoolean();
			var roomID:int = pkg.readInt();
			var isGotRing:Boolean = pkg.readBoolean();
			
			if(isCreatedMarryRoom)
			{
				if(!ChurchRoomManager.instance.selfRoom)
				{
					var room:ChurchRoomInfo = new ChurchRoomInfo();
					room.id = roomID;
					
					ChurchRoomManager.instance.selfRoom = room;	
				}
			}else
			{
				ChurchRoomManager.instance.selfRoom = null;
			}
		}
		
		public function getDressEquipPlace(info:InventoryItemInfo):int
		{
			/**
			* 结婚戒指
			*/					
			if(EquipType.isWeddingRing(info) && Self.Bag.getItemAt(16) == null)
			{
				return 16;
			}
			
			var toPlaces:Array = EquipType.CategeryIdToPlace(info.CategoryID);
			var toPlace:int;
			if(toPlaces.length == 1)
			{
				toPlace = toPlaces[0];
			}else
			{
				var j:int = 0;
				for(var i:int = 0;i<toPlaces.length;i++)
				{
					if(PlayerManager.Instance.Self.Bag.getItemAt(toPlaces[i]) == null)
					{
						toPlace = toPlaces[i];
						break;
					}else
					{
						j++;
						if(j == toPlaces.length)
						{
							toPlace = toPlaces[0];
						}
					}
				}
			}
			return toPlace;
		}
		
		/**
		 * 温泉房间邀请接受
		 */		
		private function __hotSpringRoomInvite(event:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = event.pkg;
			
			var obj:Object = new Object();
			obj["playerID"] = pkg.readInt();//邀请者ID
			obj["nickName"] = pkg.readUTF();//邀请者昵称
			obj["roomID"] = pkg.readInt();//房间ID
			obj["roomName"] = pkg.readUTF();//房间名称
			obj["roomPassword"] = pkg.readUTF();//房间密码
			
			var hotSpringRoomInviteView:HotSpringRoomInviteView = new HotSpringRoomInviteView(obj);
			hotSpringRoomInviteView.show();
			SoundManager.Instance.play("018");
		}	
		
		/**
		 * 取得使用副武器时用于显示的大小图标
		 * type = 0 返回大图标
		 * type = 1 返回小图标
		 * @return 
		 * 
		 */		
		public function getDeputyWeaponIcon(deputyWeapon:InventoryItemInfo,type:int = 0):DisplayObject
		{
			if(deputyWeapon)
			{
				var cell:BagCell = new BagCell(deputyWeapon.Place,deputyWeapon);
				if(type == 0)
				{
					return cell.getContent();
				}else if(type == 1)
				{
					return cell.getSmallContent();
				}
			}
			return null;
		}
	}
}