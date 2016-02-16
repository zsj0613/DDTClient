package ddt.gameover
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.media.SoundTransform;
	
	import game.crazyTank.view.GameOverAsset;
	
	import road.data.DictionaryEvent;
	import road.manager.SoundManager;
	import road.utils.ClassUtils;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.manager.TipManager;
	
	import tank.commonII.asset.upgradeClewAsset;
	import ddt.data.Config;
	import ddt.data.GameInfo;
	import ddt.data.RoomInfo;
	import ddt.data.game.Living;
	import ddt.data.game.LocalPlayer;
	import ddt.data.game.Player;
	import ddt.data.player.PlayerInfo;
	import ddt.data.player.SelfInfo;
	import ddt.events.ArrayChangeEvent;
	import ddt.gameover.settlement.MissionSpoilView;
	import ddt.gameover.settlement.MissionSpoilViewII;
	import ddt.gameover.settlement.OverDuplicateSettleView;
	import ddt.gameover.settlement.SpoilCrampView;
	import ddt.gameover.torphy.TrophyController;
	import ddt.gameover.torphy.TrophyPannelView;
	import ddt.manager.ChatManager;
	import ddt.manager.GameManager;
	import ddt.manager.IMEManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.manager.RoomManager;
	import ddt.manager.SharedManager;
	import ddt.manager.StateManager;
	import ddt.manager.UserGuideManager;
	import ddt.socket.GameInSocketOut;
	import ddt.states.BaseStateView;
	import ddt.states.StateType;
	import ddt.view.background.BgView;
	import ddt.view.bagII.BagEvent;
	import ddt.view.chatsystem.ChatData;
	import ddt.view.chatsystem.ChatInputView;
	import ddt.view.common.CheckCodePanel;

	public class GameOverView extends BaseStateView
	{
		private var _asset:GameOverAsset;
		private var _experience:ExperienceView;
		private var _duplicate:OverDuplicateSettleView;
		private var _spoilcrampview:SpoilCrampView;
		private var _missionspoilview:MissionSpoilView;
		private var _winResultCartoon:WinCartoonView;
		private var _failResultCartoon:FailCartoonView;	
		private var _game:GameInfo;
		private var _self:LocalPlayer;
		private var _resuldCards:Array;
		
		private var tempTroyView:TrophyPannelView;
		private var tempTrophyController:TrophyController;
		
		/* 再试一次开关 */
		private var enableTryAgain:Boolean = false;
		
		public function GameOverView()
		{
		}
		
		override public function enter(prev:BaseStateView,data:Object = null):void
		{
			super.enter(prev,data);
			
			ChatManager.isInGame==false;
			
			UserGuideManager.Instance.beginUserGuide3();
			_game = data as GameInfo;
			_self = _game.selfGamePlayer;
			
			BgView.Instance.showBtnBg(false);
		
			_asset = new GameOverAsset();
			_asset.gotoAndStop(1);
			
			addChild(_asset);
			
			ChatManager.Instance.state = ChatManager.CHAT_GAMEOVER_STATE;
			addChild(ChatManager.Instance.view);
			
			_winResultCartoon = new WinCartoonView();
			_failResultCartoon = new FailCartoonView();
			
			if(!RoomManager.Instance.current)
			{
				//这里是在游戏完成时，点退出，会清掉房间数据
				StateManager.setState(StateType.MAIN);
				return;
			}
			
			if(RoomManager.Instance.current.roomType >= 2)
			{
				showDuplicateSettleView();
				showPVECartoonView();
				showUpgradeClew();
			}
			else
			{
				/* 显示经验信息，并设置4秒后显示战利品抽取界面（PVP模式） */
				showExperiencePanel();
				/* 显示胜利和失败动画 */
				showPVPCartoonView();
				showUpgradeClew();
			}
			
			SoundManager.Instance.play(_self.isWin ? "063" : "064");
			
			_game.addEventListener(GameInfo.REMOVE_ROOM_PLAYER,__removePlayer);
			
			addEventListener(KeyboardEvent.KEY_DOWN,__focuson);
			addEventListener(MouseEvent.CLICK,__focuson);
			addEventListener(MouseEvent.DOUBLE_CLICK,__focuson);
			SharedManager.Instance.addEventListener(Event.CHANGE, __soundChange);
			PlayerManager.Instance.Self.TempBag.addEventListener(BagEvent.UPDATE,__getTempItem);
			__soundChange(null);
			
			clearMC();
//			重置房间地图难度等选择状态
			var room:RoomInfo = RoomManager.Instance.current;
			if(room && room.roomType > 2 && room.mapId != 10000)
			{
				room.mapId = 10000;
				GameInSocketOut.sendGameRoomSetUp(room.mapId,room.roomType,room.timeType,0);
			}
		}
		
		private function __getTempItem(evt:BagEvent):void{
			
			var playSound:Boolean = GameManager.Instance.selfGetItemShowAndSound(evt.changedSlots);
			
			if(playSound)
			{
				SoundManager.Instance.play("1001");
			}
		}
		
		private function __soundChange(evt : Event) : void
		{
			var mapSound : SoundTransform = new SoundTransform();
			if(SharedManager.Instance.allowSound)
			{
				mapSound.volume = (SharedManager.Instance.soundVolumn / 100);
				this.soundTransform = mapSound;
			}
			else
			{
				mapSound.volume = 0;
				this.soundTransform = mapSound;
			}
		}
		
		override public function getType():String
		{
			return StateType.FIGHTING_RESULT;
		}
		
		override public function getBackType():String
		{
			return StateType.ROOM;
		}

		override public function leaving(next:BaseStateView):void
		{
			super.leaving(next);
			
			CheckCodePanel.Instance.removeEventListener(Event.CLOSE,__checkCodeComplete);
			
			if(_game && _game.livings)
			{
				_game.livings.removeEventListener(DictionaryEvent.REMOVE,__removePlayer);
				clearAllPlayersBuff();
			}
			
			GameManager.Instance.removeEventListener(GameManager.ENTER_MISSION_RESULT, __enterMissionResult);
			GameManager.Instance.removeEventListener(GameManager.ENTER_ROOM, __enterRoom);
			GameManager.Instance.removeEventListener(GameManager.ENTER_DUNGEON, __enterDungeon);
			
			removeEventListener(KeyboardEvent.KEY_DOWN,__focuson);
			removeEventListener(MouseEvent.CLICK,__focuson);
			removeEventListener(MouseEvent.DOUBLE_CLICK,__focuson);
			
			SharedManager.Instance.removeEventListener(Event.CHANGE, __soundChange);
			PlayerManager.Instance.Self.TempBag.removeEventListener(BagEvent.UPDATE,__getTempItem);
			
			BgView.Instance.showBtnBg(true);
			SoundManager.Instance.stop("064");
			SoundManager.Instance.stop("063");
						
			experienceDispose();
			
			winResultCartoonDispose();
			
			failResultCartoonDispose();
			
			duplicateDispose();
			
			spoilcrampviewDispose();
			
			missionspoilviewDispose();
			
			tempTrophyControllerDispose();
			
			if(RoomManager.isRemovePlayerInRoomAndGame(next.getType()))
			{
				RoomManager.Instance.removeAndDisposeAllPlayer();
				RoomManager.Instance.current = null;
			}
			
			removeChild(_asset);
			_asset = null;
			PlayerManager.Instance.Self.unlockAllBag();
			
			IMEManager.enable();
			
			_resuldCards = null;
			_game.resultCard = [];
			_game = null;
			_self = null;
			if(_upgradeClew && _upgradeClew.parent)removeChild(_upgradeClew);
			if(_upgradeClew)_upgradeClew.removeEventListener(Event.ENTER_FRAME,__cartoonFrameHandler);
			_upgradeClew = null;
		}
		
		private function clearAllPlayersBuff():void
		{
			for each(var player:Living in _game.livings)
			{
				if(player is Player && !player.isSelf)
				{
					player.playerInfo.buffInfo.clear();
				}
			}
		}
		
		private function showExperiencePanel():void
		{
			_experience = new ExperienceView(_game);
			_experience.x = 40;
			_experience.y = 70;
			_experience.addEventListener(Event.COMPLETE,__expCompleteHandler);
			_asset.addChild(_experience);
		}
		
		private function showDuplicateSettleView():void
		{
			_duplicate = new OverDuplicateSettleView(_game);
			_duplicate.x = 140;
			_duplicate.y = 70;
			_duplicate.addEventListener(Event.COMPLETE,__dupCompleteHandler);
			_asset.addChild(_duplicate);
		}
		
		private function __enterMissionResult(e:Event):void
		{
			StateManager.setState(StateType.MISSION_RESULT, GameManager.Instance.Current);
		}
		
		private function __enterRoom(e:Event):void
		{
			if(RoomManager.Instance.current && RoomManager.Instance.current.roomType > 2 && RoomManager.Instance.current.mapId != 10000)
			{
				RoomManager.Instance.current.mapId = 10000;
			}
			PlayerManager.gotoState = StateType.ROOM
			showTrophyDialog();
		}
		
		private function __enterDungeon(e:Event):void
		{
			PlayerManager.gotoState = StateType.DUNGEON;
			showTrophyDialog();
		}
		
		private function __leaveMission(e:Event):void
		{
			leaveMission();
		}
		
		private function restartMission():void
		{
			if(PlayerManager.selfRoomPlayerInfo.isHost)
			{
				// TODO Send Mission Restart,need server broadcast to all players transform into mission result
				GameInSocketOut.sendMissionTryAgain(true,true);
			}
		}
		
		private function leaveMission():void
		{
			if(PlayerManager.selfRoomPlayerInfo.isHost)
			{
				GameInSocketOut.sendMissionTryAgain(false,true);
			}
			else
			{
				StateManager.setState(StateType.DUNGEON);
			}
		}
		
		private function showPVECartoonView():void
		{
			setCartoonPos();
			
			parsePvePlayerToCartoonView(_winResultCartoon,_failResultCartoon,_game);
		}
		
		public static function parsePvePlayerToCartoonView(win:WinCartoonView,fail:FailCartoonView,$game:GameInfo):void
		{
			var winPlayers:Array = [];
			var failPlayers:Array = [];
			for each(var i:Living in $game.livings)
			{
				if(!(i is Player)) continue;
				var player :Player = i as Player;
				if(player.isWin)
				{
					winPlayers.push(player);
//					win.addShowCharactor(player);
				}
				else
				{
					failPlayers.push(player);
//					fail.addShowCharactor(player);
				}
			}
			if(winPlayers.length > 0)
			{
				win.addShowCharactor(winPlayers);
				win.showLvUp();
			}
			if(failPlayers.length > 0)
			{
				fail.addShowCharactor(failPlayers);
				fail.showLvUp();
			}
			var npcList:Array = $game.missionInfo.missionOverNPCMovies;
			
			if(npcList)
			{
				for(var j:uint = 0; j < npcList.length; j++)
				{
					var movieClass:Class = ClassUtils.getDefinition(String(npcList[j])) as Class;
					
					var tmp:DisplayObject = (new movieClass()) as DisplayObject

					if($game.selfGamePlayer.isWin)
					{
						fail.addShowNPC(tmp);
					}
					else
					{
						win.addShowNPC(tmp);
					}
				}
			}
		}
		
		private var _upgradeClew:upgradeClewAsset;
		private function showUpgradeClew():void
		{
			if(!_game)return;
			for each(var i:Living in _game.livings)
			{
				if(!(i is Player)) continue;
				var player :Player = i as Player;
				if(player.isUpGrade &&  player.isSelf)
				{
					if(_upgradeClew)
					{
						_upgradeClew.removeEventListener(Event.ENTER_FRAME,__cartoonFrameHandler);
						if(_upgradeClew && _upgradeClew.parent)removeChild(_upgradeClew);
						_upgradeClew = null;
					}
					var chatMsg:ChatData = new ChatData();
					chatMsg.msg          = LanguageMgr.GetTranslation("ddt.manager.GradeExaltClewManager");
					chatMsg.channel	  = ChatInputView.SYS_NOTICE;
					ChatManager.Instance.chat(chatMsg);
					_upgradeClew = new upgradeClewAsset();
					_upgradeClew.x = (Config.GAME_WIDTH) / 2;
					_upgradeClew.y = (Config.GAME_HEIGHT) / 2;
					_upgradeClew.addEventListener(Event.ENTER_FRAME,__cartoonFrameHandler);
					addChild(_upgradeClew);
					_upgradeClew.gotoAndPlay(1);
					TipManager.AddTippanel(_upgradeClew);
				}
			}
		}
		
		private function __cartoonFrameHandler(evt:Event):void
		{
			if(_upgradeClew == null)return;
			if(_upgradeClew.currentFrame == _upgradeClew.totalFrames)
			{
				_upgradeClew.gotoAndStop(_upgradeClew.totalFrames);
				TipManager.RemoveTippanel(_upgradeClew);
				if(_upgradeClew)_upgradeClew.removeEventListener(Event.ENTER_FRAME,__cartoonFrameHandler);
				if(_upgradeClew && _upgradeClew.parent)removeChild(_upgradeClew);
				_upgradeClew = null;
			}
		}
		
		private function setDefyInfo():void
		{
			var winDefy:Array = [];
			var failDefy:Array = [];
			var defy:Array = [];
			for each(var i:Living in _game.livings)
			{
				var player :Player = i as Player;
				if(player.isWin)
				{
					winDefy.unshift(player.playerInfo.NickName);
				}else
				{
					failDefy.unshift(player.playerInfo.NickName);
				}
			}
			defy[0]=winDefy;
			defy[1]=failDefy;
			RoomManager.Instance.setRoomDefyInfo(defy);
		}
		
		private function showPVPCartoonView():void
		{
			setCartoonPos();
			var winPlayers:Array = [];
			var failPlayers:Array = [];
			for each(var l:Living in _game.livings)
			{
				var player:Player = l as Player;
				if(player.isWin)
				{
					winPlayers.push(player);
//					_winResultCartoon.addShowCharactor(player);		
				}
				else
				{
					failPlayers.push(player);
//					_failResultCartoon.addShowCharactor(player);
				}
			}
			if(winPlayers.length > 0)
			{
				_winResultCartoon.addShowCharactor(winPlayers);		
				_winResultCartoon.showLvUp();
			}
			if(winPlayers.length > 0)
			{
				_failResultCartoon.addShowCharactor(failPlayers);
				_failResultCartoon.showLvUp();
			}
			setDefyInfo();
		}
		
		private function __dupCompleteHandler(e:Event):void
		{
			_duplicate.removeEventListener(Event.COMPLETE,__dupCompleteHandler);
			
			if(_self.isWin)
			{
				showPVECards();
			}
			else
			{
				if(_game.missionInfo.missionIndex > 1 && enableTryAgain)
				{
					GameManager.Instance.addEventListener(GameManager.ENTER_MISSION_RESULT, __enterMissionResult);
					GameManager.Instance.addEventListener(GameManager.ENTER_ROOM, __enterRoom);
					GameManager.Instance.addEventListener(GameManager.ENTER_DUNGEON, __enterDungeon);
					GameManager.Instance.addEventListener(GameManager.PLAYER_CLICK_PAY, __reshowTryagainConfirm);
					GameManager.Instance.addEventListener(GameManager.LEAVE_MISSION, __leaveMission);
					if(_game.gameType == 5)//探险模式（练级关）
					{
						showTrophyDialog();
					}
					else
					{
						showTryagainConfirm();
					}
				}
				else
				{
					showTrophyDialog();
				}
			}
		}
		
		private function showTryagainConfirm():void
		{
			var dialog:HConfirmDialog = HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.dungeon.tryagain.title"),LanguageMgr.GetTranslation("ddt.dungeon.tryagain.content"),false,restartMission,leaveMission,true,null,null,0,false);
//			var dialog:HConfirmDialog = HConfirmDialog.show("再玩一次","是否再次挑战本关卡\n<FONT COLOR='#FF0000'>注：该功能只能由房主选择，<BR>当选择再试一次时，将扣除房主100点券。</FONT>",false,restartMission,leaveMission);
			
			if(!PlayerManager.selfRoomPlayerInfo.isHost)
			{
				dialog.okBtnEnable = false;
			}
		}
		
		private function __reshowTryagainConfirm(e:Event):void
		{
			showTryagainConfirm();
		}
		
		private function __expCompleteHandler(e:Event):void
		{
			_experience.removeEventListener(Event.COMPLETE,__expCompleteHandler);
			changeCartoonPos()
			showPVPCards();
		}
		
		private function changeCartoonPos():void
		{
			setCartoonViewPos(_winResultCartoon,_failResultCartoon,_asset.leftPos_mc,_asset.rightPos_mc);
			_asset.addChild(_winResultCartoon);
			_asset.addChild(_failResultCartoon);
		}
		
		private function setCartoonPos():void
		{
			setCartoonViewPos(_winResultCartoon,_failResultCartoon,_asset.leftPos_mc,_asset.rightPos_mc);
			
			if(_experience)
			{
				var winGlobalPoint:Point = _asset.localToGlobal(new Point(_winResultCartoon.x,_winResultCartoon.y));
				var failGlobalPoint:Point = _asset.localToGlobal(new Point(_failResultCartoon.x, _failResultCartoon.y));
				
				var winExpLocalPoint:Point = _experience.globalToLocal(winGlobalPoint);
				var failExpLocalPoint:Point = _experience.globalToLocal(failGlobalPoint);
				
				_winResultCartoon.x = winExpLocalPoint.x;
				_winResultCartoon.y = winExpLocalPoint.y;
				
				_failResultCartoon.x = failExpLocalPoint.x;
				_failResultCartoon.y = failExpLocalPoint.y;
				
				_experience.gotoAndStop(1);
				
				_experience.addChild(_winResultCartoon);
				_experience.addChild(_failResultCartoon);
				
				var index:int = _experience.getChildIndex(_experience.cartoonLayer_index);
				
				//modified by Freeman
				_experience.setChildIndex(_winResultCartoon,_experience.numChildren-1);
				_experience.setChildIndex(_failResultCartoon,index);
				
				_experience.cartoonLayer_index.gotoAndStop(1);
				_experience.cartoonLayer_index.parent.removeChild(_experience.cartoonLayer_index);
			}
			else
			{
				_asset.addChild(_winResultCartoon);
				_asset.addChild(_failResultCartoon);
			}
		}
		
		
		public static function setCartoonViewPos(win:Sprite,fail:Sprite, $left:Sprite, $right:Sprite):void
		{
			var player:Player = GameManager.Instance.Current.selfGamePlayer;
			
			var left:Sprite;
			var right:Sprite;
			
			if(player.team == 1)
			{
				if(player.isWin)
				{
					left = $left;
					right = $right;
				}
				else
				{
					left = $right;
					right = $left;
				}
			}
			else
			{
				if(player.isWin)
				{
					left = $right;
					right = $left;
				}
				else
				{
					left = $left;
					right = $right;
				}
			}
			
			win.x = left.x;
			win.y = left.y + 36;
			
			fail.x = right.x;
			fail.y = right.y + 36;
			
			left.visible = false;
			right.visible = false;
		}
		
		private function clearMC():void
		{
			if(_asset.leftPos_mc && _asset.leftPos_mc.parent)
			{
				_asset.leftPos_mc.parent.removeChild(_asset.leftPos_mc);
			}
			if(_asset.rightPos_mc && _asset.rightPos_mc.parent)
			{
				_asset.rightPos_mc.parent.removeChild(_asset.rightPos_mc);
			}
		}
		
		private function showPVECards():void
		{
			duplicateDispose();
			experienceDispose();
			winResultCartoonDispose();
			failResultCartoonDispose();
			if(_asset.gameover_mc.parent)
			{
				_asset.gameover_mc.parent.removeChild(_asset.gameover_mc);
			}
			_asset.gameover_mc = null;
			if(_game.missionInfo.tackCardType == 1)
			{
				_missionspoilview = new MissionSpoilViewII(_game);
				_missionspoilview.addEventListener(Event.COMPLETE, __missionspoilCompleteHandler);
				_asset.addChild(_missionspoilview);				
			}else if(_game.missionInfo.tackCardType == 2)
			{
				_spoilcrampview = new SpoilCrampView(_game);
				_spoilcrampview.x = 45;
				_spoilcrampview.y = 15;
				_spoilcrampview.addEventListener(Event.COMPLETE, __spoilcramCompleteHandler);
				_asset.addChild(_spoilcrampview);
			}else if(_game.missionInfo.tackCardType == 0)
			{
				__spoilcramCompleteHandler(null);
			}
		}
		
		private function showPVPCards():void
		{
			duplicateDispose()
			experienceDispose();
			_missionspoilview = new MissionSpoilView(_game);
			_missionspoilview.addEventListener(Event.COMPLETE, __missionspoilCompleteHandler);
			_asset.addChild(_missionspoilview);
		}
		
		private function __spoilcramCompleteHandler(e:Event):void
		{
			if(_spoilcrampview)_spoilcrampview.removeEventListener(Event.COMPLETE, __spoilcramCompleteHandler);
			showTrophyDialog();
		}
		
		private function __missionspoilCompleteHandler(e:Event):void
		{
			_missionspoilview.removeEventListener(Event.COMPLETE, __missionspoilCompleteHandler);
			showTrophyDialog();
		}

		private function showTrophyDialog():void
		{
			PlayerManager.Instance.Self.TempBag.removeEventListener(BagEvent.UPDATE,__getTempItem);
			var hasTrophy:Boolean =  (PlayerManager.Instance.Self.TempBag && PlayerManager.Instance.Self.TempBag.itemNumber>0);
			if(!hasTrophy){
		 		if(!CheckCodePanel.Instance.isShowed)
				{
					CheckCodePanel.Instance.show();
					CheckCodePanel.Instance.addEventListener(Event.CLOSE,__checkCodeComplete);
				}
				StateManager.setState(PlayerManager.gotoState);
			 }
			 else{			
				setTrophyPannel();
			 }
		}
		
		private function setTrophyPannel():void
		{
			tempTrophyController = new TrophyController()
			tempTrophyController.addEventListener(Event.CLOSE,__onTrophyClose);
			tempTroyView = tempTrophyController.getView() as TrophyPannelView;
			tempTroyView.x = 92;
			tempTroyView.y = 30;
			tempTroyView.showView();
		}
		
		private function __onTrophyClose(e:Event):void
		{
			var _selfInfo : PlayerInfo = PlayerManager.selfRoomPlayerInfo.info as SelfInfo;
			if(_selfInfo)
			{
				StateManager.setState(PlayerManager.gotoState);
			}
			else
			{
				StateManager.setState(RoomManager.Instance.current.backRoomListType);
			}
			_selfInfo = null;
		}
		
		private function getHost(room:RoomInfo):Boolean
		{
			for(var i:int;i <room.players.length;i++)
			{
				if(room.players.list[i].isSelf == true && room.players.list[i].isHost)
				{
					return true;
				}else
				{
					return false;
				}
			}
			return false;
		}
		
		private function __checkCodeComplete(e:Event):void
		{
			CheckCodePanel.Instance.removeEventListener(Event.CLOSE,__checkCodeComplete);
			StateManager.setState(PlayerManager.gotoState);
		}
		
		private function __removePlayer(event:ArrayChangeEvent):void
		{
			var info:Player = event.Elements[0] as Player;
			if(info && info.isSelf)
			{
				StateManager.setState(RoomManager.Instance.current.backRoomListType);
			}
		}
		
		override public function addedToStage():void
		{
			stage.focus = this;
			ChatManager.Instance.setFocus();
		}
		
		private function __focuson(event:Event):void
		{
			if(ExternalInterface.available)
			{
				ExternalInterface.call("end");
			}
		}
		
		private function winResultCartoonDispose():void
		{
			if(_winResultCartoon)
			{
				_winResultCartoon.dispose();
			}
			_winResultCartoon = null;
		}
		
		private function failResultCartoonDispose():void
		{
			if(_failResultCartoon)
			{
				_failResultCartoon.dispose();
			}
			_failResultCartoon = null;
		}
		
		private function experienceDispose():void
		{
			if(_experience)
			{
				_experience.removeEventListener(Event.COMPLETE,__expCompleteHandler);
				_experience.dispose();
			}
			_experience = null;
		}
		
		private function duplicateDispose():void
		{
			if(_duplicate)
			{
				_duplicate.removeEventListener(Event.COMPLETE,__dupCompleteHandler);
				_duplicate.dispose();
			}
			_duplicate = null;
		}
		
		private function spoilcrampviewDispose():void
		{
			if(_spoilcrampview)
			{
				_spoilcrampview.removeEventListener(Event.COMPLETE, __spoilcramCompleteHandler);
				_spoilcrampview.dispose()
			}
			_spoilcrampview = null;
		}
		
		private function tempTrophyControllerDispose():void
		{
			if(tempTrophyController)
			{
				tempTrophyController.removeEventListener(Event.CLOSE,__onTrophyClose);
				tempTrophyController.dispose();
				tempTroyView = null;
			}
			tempTrophyController = null;
		}
		
		private function missionspoilviewDispose():void
		{
			if(_missionspoilview)
			{
				_missionspoilview.removeEventListener(Event.COMPLETE, __missionspoilCompleteHandler);
				_missionspoilview.dispose();
			}
			_missionspoilview = null;
		}
	}
}