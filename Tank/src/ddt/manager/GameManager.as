package ddt.manager
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import game.crazyTank.view.emailII.ReadingEmailAsset;
	
	import road.comm.PackageIn;
	
	import ddt.data.BuffInfo;
	import ddt.data.GameInfo;
	import ddt.data.GameNeedMovieInfo;
	import ddt.data.MissionInfo;
	import ddt.data.RoomInfo;
	import ddt.data.game.Living;
	import ddt.data.game.LocalPlayer;
	import ddt.data.game.Player;
	import ddt.data.gameover.BaseSettleInfo;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.player.PlayerInfo;
	import ddt.data.player.RoomPlayerInfo;
	import ddt.data.player.SelfInfo;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.states.StateType;
	import ddt.view.characterII.GameCharacter;
	import ddt.view.chatsystem.ChatData;
	import ddt.view.chatsystem.ChatFormats;
	import ddt.view.chatsystem.ChatInputView;
	
	public class GameManager extends EventDispatcher
	{
		private var _current:GameInfo;
		
		public static const START_LOAD:String = "StartLoading";
		
		public static var MinLevelDuplicate : int = 1;//进主副本的等级
		/**
		 * 进入关卡结算页面
		 */		
		public static const ENTER_MISSION_RESULT:String = "EnterMissionResult";
		/**
		 * 进入房间
		 */		
		public static const ENTER_ROOM:String = "EnterRoom";
		
		/**
		 * 充值一失败点取消后发送协议事件
		 */		
		public static const LEAVE_MISSION:String = "leaveMission";
		
		/**
		 * 进入副本大厅
		 */		
		public static const ENTER_DUNGEON:String = "EnterDungeon";
		
		/**
		 * 玩家点击确定充值
		 */		
		public static const PLAYER_CLICK_PAY:String = "PlayerClickPay";
		
		public function get Current():GameInfo
		{
			return _current;
		}
		public function set trainerCurrent(c : GameInfo):void
		{
			_current = c;
		}
		
		public function setup():void
		{
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_CREATE,__createGame);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_START,__gameStart);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_LOAD,__beginLoad);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOAD,__loadprogress);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_OVER,__gameOver);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MISSION_OVE,__missionOver);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ALL_MISSION_OVER,__missionAllOver);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_TAKE_OUT,__takeOut);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SHOW_CARDS, __showAllCard);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_MISSION_INFO,__gameMissionInfo);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_MISSION_START,__gameMissionStart);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_MISSION_PREPARE,__gameMissionPrepare);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_INFO, __missionInviteRoomInfo);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAY_INFO_IN_GAME, __updatePlayInfoInGame);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_MISSION_TRY_AGAIN, __missionTryAgain);
			
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUFF_OBTAIN,__buffObtain);//
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUFF_UPDATE,__buffUpdate);//
		}
		/**
		 * 再试一次，接收服务器响应
		 * @param e
		 * 
		 */		
		private function __missionTryAgain(e:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = e.pkg;
			var playerid:int = pkg.clientId;
			var isTryAgain:Boolean = pkg.readBoolean();
			var isHost:Boolean = pkg.readBoolean();
			if(isHost)
			{
				if(isTryAgain)
				{
					_current.missionInfo.nextMissionIndex = _current.missionInfo.missionIndex;
					dispatchEvent(new Event(ENTER_MISSION_RESULT));//进入关卡结算
				}
				else
				{
					dispatchEvent(new Event(ENTER_ROOM));//进入房间
				}
			}
			else
			{
				if(PlayerManager.selfRoomPlayerInfo.info.ID == playerid)
				{
					dispatchEvent(new Event(ENTER_DUNGEON));//进入副本大厅
				}
			}
		}
		
		private function __updatePlayInfoInGame(e:CrazyTankSocketEvent):void
		{
			var room:RoomInfo = RoomManager.Instance.current;
			if(room == null)return;
			var pkg:PackageIn = e.pkg;
			var zoneID:int = pkg.readInt();
			var id:int = pkg.readInt();
			var team:int = pkg.readInt();
			var livingid:int = pkg.readInt();
			var blood:int = pkg.readInt();
			var isReady:Boolean = pkg.readBoolean();
			var fp:RoomPlayerInfo = room.findPlayer(id);
			if(zoneID != PlayerManager.Instance.Self.ZoneID || fp == null || _current == null)
			{
				return;
			}
			var player:Player;
			if(fp.isSelf)
			{
				player = new LocalPlayer(PlayerManager.Instance.Self,livingid,team,blood);
			}
			else
			{
				player = new Player(fp.info,livingid,team,blood);
			}
			player.character = fp.character;
			player.movie = fp.movie;
			player.isReady = isReady;
			
			if(player.movie)
			{
				player.movie.setDefaultAction(GameCharacter.STAND);
			}
			
			_current.addRoomPlayer(fp);
			_current.addGamePlayer(player);
			
			if(fp.isSelf)
			{
				StateManager.setState(StateType.MISSION_RESULT);
			}
		}
		
		private function __missionInviteRoomInfo(e:CrazyTankSocketEvent):void
		{
			if(RoomManager.Instance.current)
			{
				var room:RoomInfo = RoomManager.Instance.current;
				var pkg:PackageIn = e.pkg;
				var gm:GameInfo = new GameInfo();
				gm.mapIndex = pkg.readInt();
				gm.roomType = pkg.readInt();
				gm.gameType = pkg.readInt();
				gm.timeType = pkg.readInt();
				room.timeType = gm.timeType;
				var len:int = pkg.readInt();
				
				for(var i:int =0; i < len; i ++)
				{
					var id:int = pkg.readInt();
					var sp:PlayerInfo = PlayerManager.Instance.findPlayer(id);
					sp.beginChanges();
					var fp:RoomPlayerInfo = room.findPlayer(id);
					if(fp == null)
					{
						fp = new RoomPlayerInfo(sp);
						sp.ID = id;
					}
					sp.ZoneID = PlayerManager.Instance.Self.ZoneID;
					
					sp.NickName = pkg.readUTF();
					sp.Sex = pkg.readBoolean();
					sp.Hide = pkg.readInt();
					sp.Style = pkg.readUTF();
					sp.Colors = pkg.readUTF();
					sp.Skin = pkg.readUTF();
					sp.Grade = pkg.readInt();
					
					sp.Repute = pkg.readInt();
					sp.WeaponID = pkg.readInt();
					sp.DeputyWeaponID = pkg.readInt();
					sp.ConsortiaID = pkg.readInt();
					sp.ConsortiaName = pkg.readUTF();
					sp.ConsortiaLevel = pkg.readInt();
					sp.ConsortiaRepute = pkg.readInt();
					sp.commitChanges();
					fp.team = pkg.readInt();
					fp.resetCharacter();
					gm.addRoomPlayer(fp);
					var livingID:int = pkg.readInt();
					var blood:int = pkg.readInt();
					var $isReady:Boolean = pkg.readBoolean();
					var player:Player;
					if(fp.isSelf)
					{
						player = new LocalPlayer(PlayerManager.Instance.Self,livingID,fp.team,blood);
					}else
					{
						player = new Player(fp.info,livingID,fp.team,blood);
					}
					player.character = fp.character;
					player.movie = fp.movie;
					if(fp.movie)
					{
						fp.movie.setDefaultAction(GameCharacter.STAND);
					}
					player.isReady = $isReady;
					gm.addGamePlayer(player);
				}
				_current = gm;
				
				var missionInfo : MissionInfo = new MissionInfo();
	            missionInfo.name              = pkg.readUTF();
				missionInfo.pic               = pkg.readUTF();
	            missionInfo.success           = pkg.readUTF();
	            missionInfo.failure           = pkg.readUTF();
	            missionInfo.description       = pkg.readUTF();
	            missionInfo.totalMissiton     = pkg.readInt();
	            missionInfo.missionIndex      = pkg.readInt();
	            missionInfo.nextMissionIndex  = missionInfo.missionIndex + 1;
	            
	            _current.missionInfo          = missionInfo;
			}
		}
		
		private function __createGame(event:CrazyTankSocketEvent):void
		{
			if(RoomManager.Instance.current)
			{
				var room:RoomInfo = RoomManager.Instance.current;
				var pkg:PackageIn = event.pkg;
				var gm:GameInfo = new GameInfo();
				gm.roomType = pkg.readInt();
				gm.gameType = pkg.readInt();
				
				gm.timeType = pkg.readInt();
				room.timeType = gm.timeType;
				
				var len:int = pkg.readInt();
				for(var i:int =0; i < len; i ++)
				{
					var zoneID:int = pkg.readInt();
					var zoneName:String = pkg.readUTF();
					var id:int = pkg.readInt();
					var sp:PlayerInfo = PlayerManager.Instance.findPlayer(id,zoneID);
					sp.beginChanges();
					var fp:RoomPlayerInfo = room.findPlayer(id,zoneID);
					if(fp == null)fp = new RoomPlayerInfo(sp);
					sp.ID = id;
					sp.ZoneID = zoneID;
					var nickName:String = pkg.readUTF();
					if(!(fp is SelfInfo))sp.NickName = nickName;
					
					sp.Sex = pkg.readBoolean();
					sp.Hide = pkg.readInt();
					sp.Style = pkg.readUTF();
					sp.Colors = pkg.readUTF();
					sp.Skin = pkg.readUTF();
					sp.Grade = pkg.readInt();
					
					sp.Repute = pkg.readInt();
					sp.WeaponID = pkg.readInt();
					sp.DeputyWeaponID = pkg.readInt();
					sp.Nimbus = pkg.readInt();
					sp.ConsortiaID = pkg.readInt();
					sp.ConsortiaName = pkg.readUTF();
					sp.ConsortiaLevel = pkg.readInt();
					sp.ConsortiaRepute = pkg.readInt();
					sp.WinCount = pkg.readInt();
					sp.TotalCount = pkg.readInt();
					sp.FightPower = pkg.readInt();
					
					sp.AchievementPoint = pkg.readInt();
					sp.honor			= pkg.readUTF();
					
					sp.commitChanges();
					
					//2.1版本显示结婚图标需求所需数据
					fp.info.IsMarried = pkg.readBoolean();
					if(fp.info.IsMarried)
					{
						fp.info.SpouseID = pkg.readInt();
						fp.info.SpouseName = pkg.readUTF();
					}
					/* 经验，功勋，财富加成信息 */
					fp.AdditionInfo.resetAddition();
					
					fp.AdditionInfo.GMExperienceAdditionType = Number(pkg.readInt()/100);
					fp.AdditionInfo.AuncherExperienceAddition = Number(pkg.readInt()/100);
					
					fp.AdditionInfo.GMOfferAddition = Number(pkg.readInt()/100);
					fp.AdditionInfo.AuncherOfferAddition = Number(pkg.readInt()/100);
					
					fp.AdditionInfo.GMRichesAddition = Number(pkg.readInt()/100);
					fp.AdditionInfo.AuncherRichesAddition = Number(pkg.readInt()/100);
					
					fp.team = pkg.readInt();
					fp.resetCharacter();
					gm.addRoomPlayer(fp);
					var livingID:int = pkg.readInt();
					var blood:int = pkg.readInt();
					var player:Player;
					if(fp.isSelf)
					{
						player = new LocalPlayer(PlayerManager.Instance.Self,livingID,fp.team,blood);
					}else
					{
						player = new Player(fp.info,livingID,fp.team,blood);
					}
					player.character = fp.character;
					player.movie = fp.movie;
					player.zoneName = zoneName;
					if(fp.movie)
					{
						fp.movie.setDefaultAction(GameCharacter.STAND);
					}
					gm.addGamePlayer(player);
				}
				_current = gm;
				QueueManager.setLifeTime(0);
			}
		}
		
		private function __buffObtain(evt:CrazyTankSocketEvent):void
		{
			if(_current)
			{
				var pkg:PackageIn = evt.pkg;
		    	if(pkg.extend1 == _current.selfGamePlayer.LivingID)
		    	{
	    			return;
	    		}else if(_current.findPlayer(pkg.extend1) != null)
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
		                _current.findPlayer(pkg.extend1).playerInfo.buffInfo.add(buff.Type,buff);
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
    			if(pkg.extend1 == _current.selfGamePlayer.LivingID)
    			{
    	    		return;
    			}else if(_current.findPlayer(pkg.extend1) != null)
	    		{
	        		var _type:int = pkg.readInt();
	    	        var _isExist:Boolean = pkg.readBoolean();
	          	    var _beginData:Date = pkg.readDate();
    	            var _validDate:int = pkg.readInt();
	                var _value:int = pkg.readInt();
	                var _buff:BuffInfo = new BuffInfo(_type,_isExist,_beginData,_validDate,_value);
	                if(_isExist)
	                {
	             	     _current.findPlayer(pkg.extend1).playerInfo.buffInfo.add(_buff.Type,_buff);
    	            }else
	                {
	                	 _current.findPlayer(pkg.extend1).playerInfo.buffInfo.remove(_buff.Type);
	                }
	                evt.stopImmediatePropagation();
			    }
			}
		}
		
		private function __beginLoad(event:CrazyTankSocketEvent):void
		{
			//global.traceStr("beginLoad");
			if(_current)
			{
				 _current.maxTime = event.pkg.readInt();
				 _current.mapIndex = event.pkg.readInt();
				 var count:int = event.pkg.readInt();
				 for(var i:int = 1;i <= count;i++)
				 {
				 	var needMovie:GameNeedMovieInfo = new GameNeedMovieInfo();
				 	needMovie.type = event.pkg.readInt();
				 	needMovie.path = event.pkg.readUTF();
				 	needMovie.classPath = event.pkg.readUTF();
				 	_current.neededMovies.push(needMovie);
				 }
				dispatchEvent(new Event(START_LOAD));
			}
		}
		
		private function __gameMissionStart(evt : CrazyTankSocketEvent) : void
		{
			var pkg:PackageIn = evt.pkg;
			var obj:Object = new Object();
			obj.id = pkg.clientId;
			var $isReady:Boolean = pkg.readBoolean();
		}
		
		public var gameReadyStateResults:Array = [];
		
		public function dispatchAllGameReadyState(array:Array):void
		{
			for each(var e:CrazyTankSocketEvent in array)
			{
				var pkg:PackageIn = e.pkg;
				var obj:Object = new Object();
				var id:int = pkg.clientId;
				if(_current)
				{
					var player:Player = _current.findPlayerByPlayerID(id);
					player.isReady = pkg.readBoolean();
					if(!player.isSelf && player.isReady)
					{
						var roomPlayer:RoomPlayerInfo = RoomManager.Instance.current.findPlayer(id);
						roomPlayer.setRoomState(1);
					}
				}
				pkg.position = SocketManager.PACKAGE_CONTENT_START_INDEX;
			}
		}
		
		private function __gameMissionPrepare(e:CrazyTankSocketEvent):void
		{
				gameReadyStateResults.push(e);
				dispatchAllGameReadyState([e]);
		}
		
		private function __gameMissionInfo(evt : CrazyTankSocketEvent) : void
		{
			var temp:String; 
            var missionInfo : MissionInfo = new MissionInfo();
            missionInfo.name              = evt.pkg.readUTF();
            missionInfo.success           = evt.pkg.readUTF();
            missionInfo.failure           = evt.pkg.readUTF();
            missionInfo.description       = evt.pkg.readUTF();
            temp                          = evt.pkg.readUTF();
            missionInfo.totalMissiton     = evt.pkg.readInt();
            missionInfo.missionIndex      = evt.pkg.readInt();
            missionInfo.totalValue1        = evt.pkg.readInt();
            missionInfo.totalValue2         = evt.pkg.readInt();
            missionInfo.totalValue3         = evt.pkg.readInt();
            missionInfo.totalValue4         = evt.pkg.readInt();
			missionInfo.nextMissionIndex    = missionInfo.missionIndex + 1;
            missionInfo.parseString(temp);
            
            _current.missionInfo          = missionInfo;
            _current.dungeonInfo          = RoomManager.Instance.current.dungeonInfo;
		}
		
		private function __loadprogress(evt:CrazyTankSocketEvent):void
		{
			if(_current)
			{
				var progress:int = evt.pkg.readInt();
				var zoneID:int = evt.pkg.readInt();
				var id:int = evt.pkg.readInt();
				var info:RoomPlayerInfo = _current.findRoomPlayer(id,zoneID);
				if(info&&!info.isSelf)
				{
					info.loadingProgress = progress;
				}
			}
		}
		
		private function __gameStart(event:CrazyTankSocketEvent):void
		{
			if(_current)
			{
				//global.traceStr("gameStart");
				event.executed = false;
				var pkg:PackageIn = event.pkg;
				var len:int = pkg.readInt();
				for(var i:int = 1; i <= len; i ++)
				{
					var livingID:int = pkg.readInt();
					var info:Player = _current.findPlayer(livingID);
					var roomPlayer:RoomPlayerInfo;
					if(info != null)
					{
						info.reset();
						info.pos = new Point(pkg.readInt(),pkg.readInt());
						info.direction = pkg.readInt();
						var blood:int = pkg.readInt();
						info.updateBload(blood,0,0);
						info.maxBlood = blood;
						roomPlayer = _current.findRoomPlayer(info.playerInfo.ID,info.playerInfo.ZoneID);
					}
					if(roomPlayer)
					{
						info.character = roomPlayer.character;
						info.movie = roomPlayer.movie;
						info.movie.setDefaultAction(GameCharacter.STAND);
					}
				}
				_current.startEvent = event;
				
				if(RoomManager.Instance.current.roomType ==5)
				{
					StateManager.setState(StateType.FIGHT_LIB_GAMEVIEW,_current);
				}else
				{
					StateManager.setState(StateType.FIGHTING,_current);
				}
			}
		}
		
		private function __gameOver(event:CrazyTankSocketEvent):void
		{
			if(_current)
			{
				var pkg:PackageIn = event.pkg;
				var temp:Array = new Array();
				var num:int = pkg.readInt();
				for(var i:int = 0; i < num; i ++)
				{
					temp[i] = new Array();
					var id:int = pkg.readInt();
					var isWin:Boolean = pkg.readBoolean();
					var grade:int = pkg.readInt();
					var gp:int = pkg.readInt();
					var totalKill:int = pkg.readInt();
					var totalHurt:int = pkg.readInt();			
					var hitTargetCount:int = pkg.readInt();
					var shootCount:int = pkg.readInt();
					var gainGP:int = pkg.readInt();
					var marryGP:int = pkg.readInt();//额外经验
					var gainOffer:int = pkg.readInt();
					var getCardCount:int = pkg.readInt();
					
					var info:Player = _current.findPlayer(id);
					if(info)
					{
						info.isWin = isWin;
						info.CurrentGP= gp;
						info.CurrentLevel = grade;
						info.TotalKill = totalKill;
						info.TotalHurt = totalHurt;
						info.TotalHitTargetCount = hitTargetCount;
						info.TotalShootCount = shootCount;
						info.MarryGP = marryGP;
						info.GainGP = gainGP;
						info.GainOffer = gainOffer;
						info.GetCardCount = getCardCount;
					}		
				}
				
				_current.GainRiches = pkg.readInt();
				_current.PlayerCount = pkg.readInt();
				
				if(StateManager.currentStateType != StateType.FIGHTING)
				{
					event.executed = true;
					if(RoomManager.Instance.current.roomType ==5)
					{
						StateManager.setState(StateType.FIGHT_LIB,_current);
					}else
					{
						StateManager.setState(StateType.FIGHTING_RESULT,_current);
					}
				}
				else
				{
					event.executed = false;
				}
				
				for each(var j:Living in _current.livings)
				{
					if(j.character)
					{
						j.character.resetShowBitmapBig();
					}
				}
			}
		}
		
		private function __missionOver(event:CrazyTankSocketEvent):void
		{
//			关卡结束
			var pkg:PackageIn = event.pkg;
			_current.missionInfo.missionOverPlayer = [];
			_current.missionInfo.tackCardType = pkg.readInt();
			_current.hasNextMission = pkg.readBoolean();
			_current.missionInfo.pic = pkg.readUTF();
			_current.missionInfo.canEnterFinall = pkg.readBoolean();
			var playerCount:int = pkg.readInt();
			for(var i:int;i<playerCount;i++)
			{
				var playerGainInfo:BaseSettleInfo = new BaseSettleInfo();
				playerGainInfo.playerid = pkg.readInt();
				playerGainInfo.level = pkg.readInt();
				playerGainInfo.exp = pkg.readInt();
				playerGainInfo.hert = pkg.readInt();
				playerGainInfo.treatment = pkg.readInt();
				playerGainInfo.made = pkg.readInt();
				playerGainInfo.score = pkg.readInt();
				playerGainInfo.graded = pkg.readInt();
				var player:Player = _current.findPlayerByPlayerID(playerGainInfo.playerid);
				player.isWin = pkg.readBoolean();
				var cardCount:int = pkg.readInt();
				if(_current.missionInfo.tackCardType >= MissionInfo.BIG_TACK_CARD)
				{
					player.GetCardCount = cardCount;
				}else if(_current.missionInfo.tackCardType == MissionInfo.SMALL_TAKE_CARD)
				{
					player.BossCardCount = cardCount;
				}else
				{
					player.GetCardCount = cardCount;
					player.BossCardCount = cardCount;
				}
				
				if(player.playerInfo.ID == _current.selfGamePlayer.playerInfo.ID)
				{
					_current.selfGamePlayer.BossCardCount = player.BossCardCount;
				}
				_current.missionInfo.missionOverPlayer.push(playerGainInfo);
			}
			
			if(_current.selfGamePlayer.BossCardCount > 0)
			{
				var count:int = pkg.readInt();
				_current.missionInfo.missionOverNPCMovies = [];
				
				for(var j:uint = 0; j < count; j++)
				{
					_current.missionInfo.missionOverNPCMovies.push(pkg.readUTF());
				}
			}
			
			_current.missionInfo.nextMissionIndex = _current.missionInfo.missionIndex + 1;
			event.executed = false;
		}
		
		private function __missionAllOver(event:CrazyTankSocketEvent):void
		{
//			副本结束
			var pkg:PackageIn = event.pkg;
			var playerCount:int = pkg.readInt();
			for(var i:int;i<playerCount;i++)
			{
				var id:int = pkg.readInt();
				var playerGainInfo:BaseSettleInfo = _current.missionInfo.findMissionOverInfo(id);
				if(playerGainInfo)
				{
					playerGainInfo.level = pkg.readInt();
					playerGainInfo.expAll = pkg.readInt();
					playerGainInfo.hertAll = pkg.readInt();
					playerGainInfo.treatmentAll = pkg.readInt();
					playerGainInfo.madeAll = pkg.readInt();
					playerGainInfo.gradedAll = pkg.readInt();
				}
				var player:Player = _current.findPlayerByPlayerID(playerGainInfo.playerid);
				if(player)
				{
					player.isWin = pkg.readBoolean();
				}
			}
			
			//发送给香港易游的数据
			if(PathManager.solveExternalInterfaceEnabel() && _current.selfGamePlayer.isWin)
			{
				var self:SelfInfo = PlayerManager.Instance.Self;
				ExternalInterfaceManager.sendToAgent(9,self.ID,self.NickName,ServerManager.Instance.zoneName,-1,RoomManager.Instance.current.dungeonInfo.Name);
			}
			
//			gameoverNPC 动画
			_current.missionInfo.missionOverNPCMovies = [];
			var npcMovieCount:int = pkg.readInt();
			for(var j:int = 0;j<npcMovieCount;j++)
			{
				_current.missionInfo.missionOverNPCMovies.push(pkg.readUTF());
			}
			
			if(StateManager.nextState == null)
			{
				if(RoomManager.Instance.current.roomType ==5)
				{
					StateManager.setState(StateType.FIGHT_LIB,_current);
				}else
				{
					StateManager.setState(StateType.FIGHTING_RESULT, _current);
				}
			}
		}
		
		private function __takeOut(event:CrazyTankSocketEvent):void
		{
			if(_current)
			{
				_current.resultCard.push(event);
			}
		}
		
		private function __showAllCard(event:CrazyTankSocketEvent):void
		{
			if(_current)
			{
				_current.showAllCard.push(event);
			}
		}
		
		public function reset():void
		{
			if(_current)
			{
				_current.dispose();
				_current = null;
			}
		}
		
		public function startLoading():void
		{
			StateManager.setState(StateType.GAME_LOADING);
		}
		
		public function dispatchEnterRoom():void
		{
			dispatchEvent(new Event(ENTER_ROOM));
		}
		
		public function dispatchLeaveMission():void
		{
			dispatchEvent(new Event(LEAVE_MISSION));
		}
		
		public function dispatchPaymentConfirm():void
		{
			dispatchEvent(new Event(PLAYER_CLICK_PAY));
		}
		
		
		public function selfGetItemShowAndSound(list:Dictionary):Boolean
		{
			var playSound:Boolean = false;
			for each(var info:InventoryItemInfo in list){
				var data:ChatData = new ChatData();
				data.channel = ChatInputView.SYS_NOTICE;
				var msg:String=LanguageMgr.GetTranslation("ddt.data.player.FightingPlayerInfo.your");
				var channelTag:Array = ChatFormats.getTagsByChannel(data.channel);
				var goodTag:String = ChatFormats.creatGoodTag("["+info.Name+"]",ChatFormats.CLICK_GOODS,info.TemplateID,info.Quality,info.IsBinds);
				data.htmlMessage = channelTag[0]+msg+goodTag+channelTag[1]+"<BR>";
				ChatManager.Instance.chat(data,false);
				if(info.Quality >= 3)
				{
					playSound = true;
				}
			}
			
			return playSound;
		}
		
		private static var _instance:GameManager;
		
		public static function get Instance():GameManager
		{
			if(_instance == null)
			{
				_instance = new GameManager();
			}
			return _instance;
		}
	}
}