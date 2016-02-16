package ddt.missionresult
{
	import flash.events.Event;
	
	import game.crazyTank.view.GameOverAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.manager.TipManager;
	
	import tank.commonII.asset.upgradeClewAsset;
	import ddt.data.Config;
	import ddt.data.GameInfo;
	import ddt.data.game.Living;
	import ddt.data.game.Player;
	import ddt.game.GameView;
	import ddt.gameLoad.GameLoadingControler;
	import ddt.gameover.FailCartoonView;
	import ddt.gameover.GameOverView;
	import ddt.gameover.WinCartoonView;
	import ddt.gameover.settlement.MissionSettleView;
	import ddt.gameover.settlement.MissionSpoilCrampView;
	import ddt.gameover.settlement.MissionSpoilViewII;
	import ddt.gameover.torphy.TrophyController;
	import ddt.gameover.torphy.TrophyPannelView;
	import ddt.manager.ChatManager;
	import ddt.manager.GameManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.manager.RoomManager;
	import ddt.manager.StateManager;
	import ddt.socket.GameInSocketOut;
	import ddt.states.BaseStateView;
	import ddt.states.StateType;
	import ddt.view.bagII.BagEvent;
	import ddt.view.chatsystem.ChatData;
	import ddt.view.chatsystem.ChatInputView;
	import ddt.view.common.BellowStripViewII;
	
	public class MissionResult extends BaseStateView
	{
		private var _game:GameInfo;
		
		private var _missionoverView:MissionSettleView;
		private var _missionspoilview:MissionSpoilViewII;
		private var _missionSpoilCampView:MissionSpoilCrampView;
		private var _loading:GameLoadingControler;
		
		private var tempTroyView:TrophyPannelView;
		private var tempTrophyController:TrophyController;
		
		private var _winResultCartoon:WinCartoonView;
		private var _failResultCartoon:FailCartoonView;	
		
		public function MissionResult()
		{
			super();
			GameManager.Instance.setup();
		}
		
		override public function getType():String
		{
			return StateType.MISSION_RESULT;
		}
		
		override public function getBackType():String
		{
			return StateType.DUNGEON;
		}
		
		override public function prepare():void
		{
			removeLoading();
		}
		override public function enter(prev:BaseStateView, data:Object=null):void
		{
			SoundManager.Instance.playMusic("065");
			_game = data as GameInfo;
			if(_game == null)
			{
				_game = GameManager.Instance.Current;
			}
			super.enter(prev,data);
			GameManager.Instance.addEventListener(GameManager.START_LOAD,__startLoading);
			PlayerManager.Instance.Self.TempBag.addEventListener(BagEvent.UPDATE,__getTempItem);
			BellowStripViewII.Instance.backFunction = __backFunction;
			if(_game.missionInfo.tackCardType > 0)
			{
				initTakeCard();
				ChatManager.Instance.state = ChatManager.CHAT_GAMEOVER_STATE;
				addChild(ChatManager.Instance.view);
			}
			else
			{
				initMission(_game);
			}
		}
		
		override public function leaving(next:BaseStateView):void
		{
			GameManager.Instance.removeEventListener(GameManager.START_LOAD,__startLoading);
			PlayerManager.Instance.Self.TempBag.removeEventListener(BagEvent.UPDATE,__getTempItem);
			RoomManager.Instance.current.resetReadyStates();
			missionspoilviewDispose();
			if(!(next is GameView))
			{
				GameInSocketOut.sendGamePlayerExit();
				RoomManager.Instance.current = null;
			}
			if(_winResultCartoon)
			{
				_winResultCartoon.dispose();
			}
			_winResultCartoon = null;
			
			if(_failResultCartoon)
			{
				_failResultCartoon.dispose();
			}
			_failResultCartoon = null;
			if(_missionoverView)
			{
				_missionoverView.dispose();
			}
			_missionoverView = null;
			
			if(tempTrophyController)
			{
				tempTrophyController.removeEventListener(Event.CLOSE,__onTrophyClose);
				tempTrophyController.dispose();
			}
			tempTrophyController = null;
			
			removeLoading();
			
			BellowStripViewII.Instance.backFunction = null;
			_game = null;
			if(tempTroyView)tempTroyView.dispose();
			tempTroyView = null;
			
			if(RoomManager.isRemovePlayerInRoomAndGame(next.getType()))
			{
				RoomManager.Instance.removeAndDisposeAllPlayer();
				RoomManager.Instance.current = null;
			}
			
			if(_upgradeClew && _upgradeClew.parent)removeChild(_upgradeClew);
			_upgradeClew = null;
			
			if(_missionSpoilCampView)
			{
				_missionSpoilCampView.removeEventListener(Event.COMPLETE,__missionSpoilCampComplete);
				_missionSpoilCampView.dispose();
			}
			_missionSpoilCampView = null;
		}
		
		private function __backFunction() : void
		{
			if(_game.gameType == 5) // 探险模式
			{
				HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.missionsettle.explore.leaveConfirm.title"), LanguageMgr.GetTranslation("ddt.missionsettle.explore.leaveConfirm.contents"), true, _callbackFunc,null,true,LanguageMgr.GetTranslation("ddt.missionresult.leave"));
//				HConfirmDialog.show("离开战斗", "是否确定离开当前战斗？", true, _callbackFunc);
			}
			else
			{
				HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.missionsettle.dungeon.leaveConfirm.title"), LanguageMgr.GetTranslation("ddt.missionsettle.dungeon.leaveConfirm.contents"), true, _callbackFunc,null,true,LanguageMgr.GetTranslation("ddt.game.ToolStripView.exit"),"取消");
//				HConfirmDialog.show("离开副本", "是否确定离开当前副本？", true, _callbackFunc);
			}
		}
		
		private function _callbackFunc():void
		{
			StateManager.setState(RoomManager.Instance.current.backRoomListType);
			GameManager.Instance.reset();
		}
		
		private function initMission(data:GameInfo):void
		{
			missionspoilviewDispose();
			
			_missionoverView = new MissionSettleView(data);
			addChild(_missionoverView);
			
			showTrophyView();
		}
		
		private function initTakeCard():void
		{
			if(_game.missionInfo.tackCardType == 1)
			{
				_winResultCartoon = new WinCartoonView();
				_failResultCartoon = new FailCartoonView();
				var _goasset:GameOverAsset = new GameOverAsset();
				GameOverView.setCartoonViewPos(_winResultCartoon, _failResultCartoon, _goasset.leftPos_mc, _goasset.rightPos_mc);
				addChild(_winResultCartoon);
				addChild(_failResultCartoon);
				GameOverView.parsePvePlayerToCartoonView(_winResultCartoon,_failResultCartoon,_game);
				
				_missionspoilview = new MissionSpoilViewII(_game);
				_missionspoilview.addEventListener(Event.COMPLETE, __missionspoilCompleteHandler);
				addChild(_missionspoilview);
			}else if(_game.missionInfo.tackCardType == 2)
			{
				_missionSpoilCampView = new MissionSpoilCrampView(_game);
				_missionSpoilCampView.x = 45;
				_missionSpoilCampView.y = 15;
				_missionSpoilCampView.addEventListener(Event.COMPLETE,__missionSpoilCampComplete);
				addChild(_missionSpoilCampView);
			}
			showUpgradeClew();
		}
		
		private function __missionSpoilCampComplete(event:Event):void
		{
			_missionSpoilCampView.removeEventListener(Event.COMPLETE,__missionSpoilCampComplete);
			_missionSpoilCampView.dispose();
			_missionSpoilCampView = null;
			initMission(_game);
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
		
		private function __getTempItem(e:BagEvent):void
		{
			var playSound:Boolean = GameManager.Instance.selfGetItemShowAndSound(e.changedSlots);
			
			if(playSound)
			{
				SoundManager.Instance.play("1001");
			}
		}
		
		private function __missionspoilCompleteHandler(e:Event):void
		{
			_missionspoilview.removeEventListener(Event.COMPLETE, __missionspoilCompleteHandler);
			initMission(_game);
		}
		
		private function __startLoading(e:Event):void
		{
			removeView();
			_loading = new GameLoadingControler();
			addChild(_loading);
		}
		
		private function removeLoading() : void
		{
			if(_loading)_loading.dispose();
			_loading = null;
		}
		
		private function removeView():void
		{
			if(_missionoverView)
			{
				_missionoverView.resetPlayerReady();
				_missionoverView.dispose();
				_missionoverView = null;
			}
		}
		
		private function missionspoilviewDispose():void
		{
			if(_winResultCartoon)
			{
				_winResultCartoon.dispose();
			}
			_winResultCartoon = null;
			
			if(_failResultCartoon)
			{
				_failResultCartoon.dispose();
			}
			_failResultCartoon = null;
			
			if(_missionspoilview)
			{
				_missionspoilview.removeEventListener(Event.COMPLETE, __missionspoilCompleteHandler);
				_missionspoilview.dispose();
			}
			_missionspoilview = null;
			if(tempTroyView)tempTroyView.dispose();
			tempTroyView = null;
		}
		
		/**战利品*/
		private function showTrophyView():void
		{
			PlayerManager.Instance.Self.TempBag.removeEventListener(BagEvent.UPDATE,__getTempItem);
			var hasTrophy:Boolean =  (PlayerManager.Instance.Self.TempBag && PlayerManager.Instance.Self.TempBag.itemNumber>0);
			
			 if(hasTrophy)
			 {
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
		private function __onTrophyClose(evt:Event):void{
			//todo:go to some state after the trophy window dispose;
			tempTrophyController.removeEventListener(Event.CLOSE,__onTrophyClose);
		}
		/**战利品end*/
	}
}