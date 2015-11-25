package ddt.manager
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import road.comm.PackageIn;
	import road.data.DictionaryData;
	import road.ui.controls.hframe.HConfirmDialog;
	
	import ddt.data.BuffInfo;
	import ddt.data.RoomInfo;
	import ddt.data.player.PlayerInfo;
	import ddt.data.player.RoomPlayerInfo;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.states.StateType;
	import ddt.utils.LeavePage;
	import ddt.view.common.WaitingView;
	public class RoomManager extends EventDispatcher
	{
		public static const PAYMENT_TAKE_CARD:String = "PaymentCard";
		
		private var _current:RoomInfo;
		public var _removeRoomMsg:String = "";
		public function get current():RoomInfo
		{
			return _current;
		}
		
		public function set current(value:RoomInfo):void
		{
			if(_current)
			{
				_current.dispose();
			}
			_current = value;
		}
		
		public function setRoomDefyInfo(value:Array):void
		{
			if(_current)
			{
				_current.defyInfo = value;
			}
		}
		
		public function setup():void
		{
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE,__createRoom);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE,__settingRoom);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_UPDATE_PLACE,__updateRoomPlaces);//
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_LOGIN,__loginRoomResult);
			
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_PLAYER_ENTER,__addPlayerInRoom);//
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_PLAYER_EXIT,__removePlayerInRoom);//
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_PLAYER_STATE_CHANGE,__playerStateChange);//
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GMAE_STYLE_RECV, __updateGameStyle);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_TEAM,__setPlayerTeam);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.NETWORK,__netWork);//
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUFF_OBTAIN,__buffObtain);//
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUFF_UPDATE,__buffUpdate);//
			
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_WAIT_FAILED, __waitGameFailed);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_WAIT_RECV, __waitGameRecv);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_AWIT_CANCEL, __waitCancel);
			
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.INSUFFICIENT_MONEY, __paymentFailed);
		}
		
		private function __paymentFailed(e:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = e.pkg;
			var type:int = pkg.readByte();// 0:boss战游戏开始点券不足, 1:付费翻牌点券不足, 2:再玩一次点券不足
			var payment:Boolean = pkg.readBoolean();
			if(type == 0)
			{
				if(!payment)
				{
					RoomManager.Instance.current.roomState = RoomInfo.STATE_READY;
					HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.room.RoomIIView2.notenoughmoney.title"),
					LanguageMgr.GetTranslation("ddt.room.RoomIIView2.notenoughmoney.content"),true, 
					LeavePage.leaveToFill);
					//					HConfirmDialog.show("提示","您的点券不足，是否立即充值？",true, __toPaymentHandler);
				}
			}
			else if(type == 1)
			{
				if(!payment)
				{
					dispatchEvent(new Event(PAYMENT_TAKE_CARD));// TODO listen this event in the SpoilCrampView.as file
					
					HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.room.RoomIIView2.notenoughmoney.title"),
					LanguageMgr.GetTranslation("ddt.room.RoomIIView2.notenoughmoney.content"),true, 
					LeavePage.leaveToFill);
					//					MessageTipManager.getInstance().show("您的点券不足,无法进行翻牌");
					ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("ddt.gameover.NotEnoughPayToTakeCard"));
				}
			}
			else if(type == 2)
			{
				if(!payment)
				{
					HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.room.RoomIIView2.notenoughmoney.title"),
						LanguageMgr.GetTranslation("ddt.room.RoomIIView2.notenoughmoney.content"),true, 
						__toPaymentTryagainHandler, 
						__cancelPaymenttryagainHandler,
						true,null,null,0,false);
					//					HConfirmDialog.show("提示","您的点券不足，是否立即充值？",true, __toPaymentHandler);
				}
			}
		}
		
		private function __toPaymentTryagainHandler():void
		{
			LeavePage.leaveToFill();
			//TODO: 弹出再玩一次提示框
			GameManager.Instance.dispatchPaymentConfirm();//发出事件，通知再次弹出再玩一次的提示框
		}
		
		private function __cancelPaymenttryagainHandler():void
		{
			//TODO: 返回房间
			GameManager.Instance.dispatchLeaveMission();
		}
		
		private function __createRoom(evt:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = evt.pkg;
			var info:RoomInfo = new RoomInfo();
			info.ID = pkg.readInt();
			info.roomType = pkg.readByte();
			info.hardLevel = pkg.readByte();
			info.timeType = pkg.readByte();
			info.totalPlayer = pkg.readByte();
			info.placeCount = pkg.readByte();
			info.IsLocked = pkg.readBoolean();
			info.mapId = pkg.readInt();
			info.isPlaying = pkg.readBoolean();
			info.Name = pkg.readUTF();
			info.gameMode = pkg.readByte();	
			info.levelLimits = pkg.readInt();
			info.allowCrossZone = pkg.readBoolean();
			info.players = new DictionaryData();
			current = info;
		}
		
		private function __settingRoom(evt:CrazyTankSocketEvent):void
		{
			if(_current)
			{
				_current.mapId     = evt.pkg.readInt();
				_current.roomType   = evt.pkg.readByte();
				_current.timeType   = evt.pkg.readByte();
				_current.hardLevel = evt.pkg.readByte();
				_current.levelLimits= evt.pkg.readInt();
				_current.allowCrossZone = evt.pkg.readBoolean();
			}
		}
		
		private function __updateRoomPlaces(evt:CrazyTankSocketEvent):void
		{
			if(_current)
			{
				var states:Array = new Array();
				for(var i:int = 0; i < 8 ;i++)
				{
					states[i] = evt.pkg.readInt();
				}
				_current.updatePlaceState(states);
			}
		}
		
		private var _tempInventPlayerID:int = -1;
		public function set tempInventPlayerID(id:int):void
		{
			_tempInventPlayerID = id;
		}
		
		public function get tempInventPlayerID():int
		{
			return _tempInventPlayerID;
		}
		
		public function haveTempInventPlayer():Boolean
		{
			return _tempInventPlayerID != -1;
		}
		
		private function __loginRoomResult(evt:CrazyTankSocketEvent):void
		{
			if(evt.pkg.readBoolean() == false)
			{
				WaitingView.instance.hide();
				//	MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.RoomManager.type"));
			} 
		}
		
		
		
		private function __addPlayerInRoom(evt:CrazyTankSocketEvent):void
		{
			
			if(_current)
			{
				var pkg:PackageIn 		= evt.pkg;
				var id:int			 	= pkg.clientId;
				var isInGame:Boolean    = pkg.readBoolean();
				var pos:int 			= pkg.readByte();
				var team:int 			= pkg.readByte();
				var level:int 			= pkg.readInt();
				var offer:int			= pkg.readInt();
				var hide:int 			= pkg.readInt();
				var repute:int		    = pkg.readInt();
				var speed:int 			= pkg.readInt();
				var zoneID:int          = pkg.readInt();
				
				var info:PlayerInfo;
				if(id != PlayerManager.Instance.Self.ID)
				{
					info = PlayerManager.Instance.findPlayer(id);
					info.beginChanges();
					info.ID            = pkg.readInt();
					info.NickName      = pkg.readUTF();
					info.Sex           = pkg.readBoolean();
					info.Style         = pkg.readUTF();
					info.Colors        = pkg.readUTF();
					info.Skin          = pkg.readUTF();
					info.WeaponID      = pkg.readInt();
					info.DeputyWeaponID= pkg.readInt();
					info.Repute        = repute;
					info.Grade         = level;
					info.Offer		   = offer;
					info.Hide          = hide;
					info.ConsortiaID   = pkg.readInt();
					info.ConsortiaName = pkg.readUTF();
					info.WinCount = pkg.readInt();
					info.TotalCount = pkg.readInt();
					info.EscapeCount = pkg.readInt();
					info.ConsortiaLevel = pkg.readInt();
					info.ConsortiaRepute = pkg.readInt();
					info.IsMarried = pkg.readBoolean();
					if(info.IsMarried)
					{
						info.SpouseID = pkg.readInt();
						info.SpouseName = pkg.readUTF();
					}
					info.LoginName = pkg.readUTF();
					info.Nimbus    = pkg.readInt();
					info.FightPower= pkg.readInt();
					info.VIPLevel  = pkg.readInt();
					info.commitChanges();
				}
				else
				{
					info = PlayerManager.Instance.Self;
					if(PlayerManager.Instance.DeputyWeapon)
					{
						info.DeputyWeaponID = PlayerManager.Instance.DeputyWeapon.TemplateID;
					}
					else
					{
						info.DeputyWeaponID = 0;
					}
					
				}
				info.ZoneID = zoneID;
				
				var fpInfo:RoomPlayerInfo = new RoomPlayerInfo(info);
				fpInfo.roomPos = pos;
				fpInfo.team = team;
				fpInfo.webSpeedInfo.delay = speed;
				if(fpInfo.isSelf)
				{
					PlayerManager.selfRoomPlayerInfo = fpInfo;
					if(_current&&_current.roomType == 5 ||_current&&_current.roomType == 6)
					{
						//						StateManager.setState(StateType.MISSION_RESULT);
					}
					else
					{
						StateManager.setState(StateType.ROOM);
					}
				}	
				_current.addPlayer(fpInfo);
			}
		}
		
		/**
		 * 玩家退出房间 
		 * @param evt
		 * 
		 */		
		private function __removePlayerInRoom(evt:CrazyTankSocketEvent):void
		{
			if(_current)
			{
				var id : int = evt.pkg.clientId;
				var zoneID:int = evt.pkg.readInt();
				var info:RoomPlayerInfo = _current.removePlayer(zoneID,id);
				_current.updatePlaceState(_current.placesState);
				if(GameManager.Instance.Current)GameManager.Instance.Current.removeGamePlayerByPlayerID(zoneID,id);
				if(info && info.isSelf)
				{
					if(StateManager.currentStateType == StateType.ROOM_LIST || StateManager.currentStateType == StateType.DUNGEON)
					{
						return;
					}
					
					if(StateManager.currentStateType == StateType.ROOM || StateManager.currentStateType == StateType.MISSION_RESULT || StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)
					{
						//关闭战斗服务器时的处理
						if(current.roomType == 5)
						{
							_current = null;
							StateManager.setState(StateType.FIGHT_LIB);
						}else{
							StateManager.setState(current.backRoomListType);
						}					
					}
					
					if(StateManager.currentStateType == StateType.FIGHTING_RESULT)
					{
						PlayerManager.gotoState = RoomManager.Instance.current.backRoomListType;
					}
					
					PlayerManager.Instance.Self.unlockAllBag();
					GameManager.Instance.reset();
					if(info)info.dispose();
				}else
				{
					if(GameManager.Instance.Current)GameManager.Instance.Current.removeRoomPlayer(zoneID,id);
					if(info)info.dispose();
				}
			}
		}
		
		
		
		private function __playerStateChange(evt:CrazyTankSocketEvent):void
		{
			if(_current)
			{
				var states:Array = new Array();
				for(var i:int = 0; i < 8 ;i++)
				{
					states[i] = evt.pkg.readByte();
				}
				_current.updatePlayerState(states);
			}
		}
		
		//撮合失败
		private function __waitGameFailed(evt:CrazyTankSocketEvent):void
		{
			if(_current)
			{
				_current.pickupFailed();
			}	
		}
		
		//撮合返回
		private function __waitGameRecv(evt:CrazyTankSocketEvent):void
		{
			if(_current)
			{
				_current.startPickup();
			}	
		}
		
		//撮合取消
		private function __waitCancel(evt:CrazyTankSocketEvent):void
		{
			if(_current)
			{
				_current.cancelPickup();
			}	
			
		}
		
		//返回游戏类型
		private function __updateGameStyle(evt:CrazyTankSocketEvent):void
		{
			if(_current)
			{
				var gameStyle : int = evt.pkg.readByte();
				_current.gameMode = evt.pkg.readInt();
				_current.gameStyle = gameStyle;
				if(_current.gameStyle == 2)
				{
					ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("ddt.room.UpdateGameStyle"));
				}
			}
		}
		
		private function __setPlayerTeam(evt:CrazyTankSocketEvent):void
		{
			if(_current )
			{
				_current.updatePlayerTeam(evt.pkg.clientId,evt.pkg.readByte(),evt.pkg.readByte());
			}
		}
		
		
		private function __buffObtain(evt:CrazyTankSocketEvent):void
		{
			if(_current)
			{
				var pkg:PackageIn = evt.pkg;
				if(pkg.clientId == PlayerManager.Instance.Self.ID)
				{
					return;
				}else if(_current.players[pkg.clientId]!=null)
				{
					var lth:int = pkg.readInt();
					for(var i:int=0;i<lth;i++)
					{
						var type:int = pkg.readInt();
						var isExist:Boolean = pkg.readBoolean();
						var beginData:Date = pkg.readDate();
						var validDate:int = pkg.readInt();
						var value:int = pkg.readInt();
						var buff:BuffInfo = new BuffInfo(type,isExist,beginData,validDate,value);
						_current.players[pkg.clientId].info.buffInfo.add(buff.Type,buff);
					}
					evt.stopImmediatePropagation();
				}
			}
		}
		
		private function __buffUpdate(evt:CrazyTankSocketEvent):void
		{
			if(_current)
			{
				var pkg:PackageIn = evt.pkg;
				if(pkg.clientId == PlayerManager.Instance.Self.ID)
				{
					return;
				}else if(_current.players[pkg.clientId]!=null)
				{
					var _type:int = pkg.readInt();
					var _isExist:Boolean = pkg.readBoolean();
					var _beginData:Date = pkg.readDate();
					var _validDate:int = pkg.readInt();
					var _value:int = pkg.readInt();
					var _buff:BuffInfo = new BuffInfo(_type,_isExist,_beginData,_validDate,_value);
					if(_isExist)
					{
						_current.players[pkg.clientId].info.buffInfo.add(_buff.Type,_buff);
					}else
					{
						_current.players[pkg.clientId].info.buffInfo.remove(_buff.Type);
					}
					evt.stopImmediatePropagation();
				}
			}
		}
		
		private function __netWork(event:CrazyTankSocketEvent):void
		{
			if(_current && _current.players)
			{
				var info:RoomPlayerInfo = _current.players[event.pkg.clientId];
				if(info)
				{
					info.info.webSpeed = event.pkg.readInt();
					if(info.webSpeedInfo)
					{
						info.webSpeedInfo.delay = info.info.webSpeed;
					}
				}
			}
			else
			{
				event.pkg.readInt();
			}
		}
		
		
		public function findRoomPlayer(id:int):RoomPlayerInfo
		{
			if(_current)
			{
				return _current.players[id] as RoomPlayerInfo;
			}
			else
			{
				return null;
			}
		}
		
		private static var _instance:RoomManager;
		public static function get Instance():RoomManager
		{
			if(_instance == null)
			{
				_instance = new RoomManager();
			}
			return _instance;
		}
		
		public static function isRemovePlayerInRoomAndGame(type:String):Boolean
		{
			return type != StateType.FIGHTING && 
				type != StateType.FIGHTING_RESULT && 
				type != StateType.ROOM && 
				type != StateType.GAME_LOADING && 
				type != StateType.MISSION_RESULT &&
				type != StateType.FIGHT_LIB;
		}
		
		public function removeAndDisposeAllPlayer():void
		{
			if(_current)
			{
				for each(var player:RoomPlayerInfo in _current.players)
				{
					player.dispose();
				}
				_current.players = null;
			}
		}
		
	}
}