package ddt.gameover.settlement
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import game.crazyTank.view.gameOverSettle.gameOverSettleAsset;
	
	import road.data.DictionaryEvent;
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.manager.UIManager;
	import road.utils.ComponentHelper;
	
	import ddt.data.GameEvent;
	import ddt.data.GameInfo;
	import ddt.data.RoomInfo;
	import ddt.data.game.Living;
	import ddt.data.game.Player;
	import ddt.data.gameover.BaseSettleInfo;
	import ddt.data.player.RoomPlayerInfo;
	import ddt.events.RoomEvent;
	import ddt.invite.IInviteController;
	import ddt.invite.InviteController;
	import ddt.manager.BossBoxManager;
	import ddt.manager.ChatManager;
	import ddt.manager.GameManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.RoomManager;
	import ddt.manager.ServerManager;
	import ddt.manager.StateManager;
	import ddt.room.DuplicateInfoPanel;
	import ddt.room.DuplicatePlayerList;
	import ddt.room.RoomIIMapSet;
	import ddt.room.RoomIIPropSet;
	import ddt.socket.GameInSocketOut;
	import ddt.states.StateType;
	import ddt.view.bossbox.SmallBoxButton;
	import ddt.view.chatsystem.ChatData;
	import ddt.view.common.BellowStripViewII;
	
	public class MissionSettleView extends gameOverSettleAsset
	{
//		private var _pLst:Array;
		private var _propset:RoomIIPropSet;
		private var _playerFigureList:DuplicatePlayerList;
//		private var _playerSettleList:DuplicateSettleList;
		private var _invite:IInviteController;
		private var _room:RoomInfo;
		private var _self:RoomPlayerInfo;
		private var _chat:Sprite;
		private var _roominfo:RoomIIMapSet;
		private var _game:GameInfo;
//		private var leaveroom_Btn:HBaseButton;
		private var invite_Btn:HBaseButton;
		private var _duplicateDrop:DuplicateInfoPanel;
		private var _duplicateSettleView:DuplicateSettleView;
		
		private var _boxButton:SmallBoxButton;
		
		private var _kickTimer:Timer;

		public function MissionSettleView(gameinfo:GameInfo)
		{
			super();
//			_pLst=pLst;
			_game = gameinfo;
			
			init();
			initEvent();
			if(gameinfo && gameinfo.missionInfo)
			{
				_playerFigureList.updateSettle(gameinfo.missionInfo.missionOverPlayer);
//				_playerSettleList.updateSettle(gameinfo.missionInfo.missionOverPlayer);
			}
		}

		private function init():void
		{
			BellowStripViewII.Instance.show();
			BellowStripViewII.Instance.enableAll();
			start_Btn.buttonMode = true;
			preparation_Btn.buttonMode = true;
			cancel_Btn.buttonMode = true;
			
			invite_Btn = new HBaseButton(inviteplayer_Btn);
			invite_Btn.useBackgoundPos = true;
			invite_Btn.enable = true;
			addChild(invite_Btn);
			
//			leaveroom_Btn = new HBaseButton(leave_Btn);
//			leaveroom_Btn.useBackgoundPos = true;
//			leaveroom_Btn.enable = true;
//			addChild(leaveroom_Btn);
			
			_room = RoomManager.Instance.current;
			_self = PlayerManager.selfRoomPlayerInfo;
			
			_room.reset();
			
			setOtherInfo();
			
			_propset = new RoomIIPropSet();
			//_propset.x = myprop_pos.x;
			//_propset.y = myprop_pos.y;
			//addChild(_propset);
			ComponentHelper.replaceChild(this._gameOver_shop_room,this._gameOver_shop_room.propset_pos,_propset);
			
			_roominfo = new RoomIIMapSet();
			_roominfo.x = roominfo_pos.x;
			_roominfo.y = roominfo_pos.y;
			addChild(_roominfo);
			_roominfo.settingEnable = false;
			
			if(_self.isHost)
			{
				startdisable_Btn.visible = true;
				start_Btn.visible = false;
				preparation_Btn.visible = false;
				cancel_Btn.visible = false;
			}
			else
			{
				startdisable_Btn.visible = false;
				start_Btn.visible = false;
				preparation_Btn.visible = true;
				cancel_Btn.visible = false;
			}
			
			_duplicateDrop = new DuplicateInfoPanel(_room,_game.missionInfo.pic);//missionindex是在进入游戏以后才传过来的。。。
			_duplicateDrop.updateDescription(_game.missionInfo.description);
			addChild(_duplicateDrop);
			_duplicateDrop.x = 376;
			_duplicateDrop.y = -50;
			_duplicateDrop.choicePos.buttonMode = false;
			_duplicateDrop.choicePos.choiceIco.buttonMode = false;
			_duplicateDrop.choicePos.choiceIco.visible = false;
			
			if(_game.gameType == 5) // 探险模式
			{
				_duplicateDrop.showDrop = false;
			}
			
			_playerFigureList = new DuplicatePlayerList();
			_playerFigureList.x = figurelist_pos.x;
			_playerFigureList.y = figurelist_pos.y;
			addChild(_playerFigureList);
			
			
			ChatManager.Instance.state = ChatManager.CHAT_DUNGEON_STATE;
			_chat = ChatManager.Instance.view;
			addChild(_chat);
			
//			_playerSettleList = new DuplicateSettleList();
//			settleinfo.addChild(_playerSettleList);
			
			if(BossBoxManager.instance.isShowBoxButton())
			{
				_boxButton = new SmallBoxButton();
				_boxButton.x = _smallBoxButton.x;
				_boxButton.y = _smallBoxButton.y;
				BossBoxManager.instance.smallBoxButton = _boxButton;
				addChild(_boxButton);
			}
			
			clearMC();
			
			_kickTimer = new Timer(1000);
		}

		private function initEvent():void
		{
			start_Btn.addEventListener(MouseEvent.CLICK, __startClickHandler);
			preparation_Btn.addEventListener(MouseEvent.CLICK, __preparationClickHandler);
//			leaveroom_Btn.addEventListener(MouseEvent.CLICK, __leaveClickHandler);
			invite_Btn.addEventListener(MouseEvent.CLICK, __inviteClickHandler);
			cancel_Btn.addEventListener(MouseEvent.CLICK, __cancelClickHandler);
			
			_self.addEventListener(RoomEvent.PLAYER_STATE_CHANGED, __changeHandler);
			_game.selfGamePlayer.addEventListener(GameEvent.READY_CHANGED, __changeHandler);
			_game.livings.addEventListener(DictionaryEvent.REMOVE, __removeGamePlayerHandler);
			_duplicateDrop.addEventListener(DuplicateInfoPanel.OPEN_NOTE, __OpenNoteHandler);
			if(_kickTimer)_kickTimer.addEventListener(TimerEvent.TIMER,__onKickTimer);
			__changeHandler(null);
		}
		private function __OpenNoteHandler(evt:Event):void
		{
			if(_game.missionInfo && _game.missionInfo.missionOverPlayer && _game.missionInfo.missionOverPlayer.length > 0)
			{
				if(!_duplicateSettleView)
				{
					_duplicateSettleView = new DuplicateSettleView(_game);
					_duplicateSettleView.closeCallBack = duplicateSettleViewCloseCallBack;
					_duplicateSettleView.show();
				}
				else
				{
					duplicateSettleViewCloseCallBack();
				}
			}
		}
		
		private function __onKickTimer(evt:TimerEvent):void
		{
			if(_kickTimer.currentCount == 30 && _game.isAllReady() && _room.players.length != 1)
			{
				SoundManager.Instance.play("007",false,true,10000);
			}
			if(_kickTimer.currentCount < 60)return;//是否超过1分钟了
			
			if(_room.players.length == 1)//只有房主一个人是5分钟不开始，T，并且超过1分钟了
			{
				if(_kickTimer.currentCount >= 300)kickHandler();//超过5分钟
			}
			else if(_room.players.length > 1)//两个或两个以上，并且超过1分钟了
			{
				var isAllReady:Boolean = _game.isAllReady();//是否所有玩家都准备
				
				if(isAllReady)//所有玩家都准备了,T
				{
					kickHandler();
				}
				else if(_kickTimer.currentCount >= 1200)//有玩家未准备,并且超过了5分钟
				{
					kickHandler();
				}
			}
		}
		
		private function kickHandler() : void
		{
			if(_self.isHost == false)
				return;
			_kickTimer.reset();
			ChatManager.Instance.sysChatRed(LanguageMgr.GetTranslation("ddt.room.RoomIIView2.kick"));
			
			StateManager.setState(_room.backRoomListType);		
			PlayerManager.Instance.Self.unlockAllBag();
		}
		
		private function duplicateSettleViewCloseCallBack():void
		{
			if(_duplicateSettleView)
			{
				_duplicateSettleView.close();
			}
			
			_duplicateSettleView = null;
		}
		
		public function get duplicateDrop():DuplicateInfoPanel
		{
			return _duplicateDrop;
		}
		
		private function __changeHandler(e:Event):void
		{
			_kickTimer.reset();
			SoundManager.Instance.stop("007");
			// TODO 更新开始或准备按钮
			if(_game.selfGamePlayer.isReady||_game.isAllReady())
			{
				if(_self.isHost)
				{
					start_Btn.visible = true;//开始
					startdisable_Btn.visible = false;//灰显开始
					cancel_Btn.visible = false;//取消按钮
//					leaveroom_Btn.enable = true;//离开
					preparation_Btn.visible = false;//准备
					BellowStripViewII.Instance.enableAll();
					_playerFigureList.updatePlaceState();
					_kickTimer.start();
				}
				else
				{
					start_Btn.visible = false;//开始
					startdisable_Btn.visible = false;//灰显开始
					cancel_Btn.visible = true;//取消按钮
//					leaveroom_Btn.enable = false;//离开
					preparation_Btn.visible = false;//准备
					BellowStripViewII.Instance.disableAll();
					BellowStripViewII.Instance.goFriendListBtn.enable = true;
					BellowStripViewII.Instance.goTaskBtn.enable = true;
				}
			}
			else
			{
				if(_self.isHost)
				{
					start_Btn.visible = false;//开始
					startdisable_Btn.visible = true;//灰显开始
					cancel_Btn.visible = false;//取消按钮
//					leaveroom_Btn.enable = true;//离开
					preparation_Btn.visible = false;//准备
					BellowStripViewII.Instance.enableAll();
					_playerFigureList.updatePlaceState();
					_kickTimer.start();
				}
				else
				{
					start_Btn.visible = false;//开始
					startdisable_Btn.visible = false;//灰显开始
					cancel_Btn.visible = false;//取消按钮
//					leaveroom_Btn.enable = true;//离开
					preparation_Btn.visible = true;//准备
					BellowStripViewII.Instance.enableAll();
				}
			}
		}
		
		private function __removeGamePlayerHandler(e:DictionaryEvent):void
		{
			var l:Living = e.data as Living;
			if(l && l.isPlayer() && _game.missionInfo && _game.missionInfo.missionOverPlayer)
			{
				for(var i:uint = 0; i < _game.missionInfo.missionOverPlayer.length; i++)
				{
					var bsi:BaseSettleInfo = _game.missionInfo.missionOverPlayer[i] as BaseSettleInfo;
					
					if(bsi && bsi.playerid == l.playerInfo.ID)
					{
						_game.missionInfo.missionOverPlayer.splice(i,1);
						break;
					}
				}
			}
		}
		
		/**
		 * 设置房间相关信息
		 * 
		 */
		private function setOtherInfo():void
		{
			_gameOver_shop_room.room_mc.id_txt.text = _room.ID.toString();
			_gameOver_shop_room.room_mc.server_txt.text = ServerManager.Instance.current.Name;
			_gameOver_shop_room.room_mc.name_txt.text = _room.Name;
			if(_game && _game.dungeonInfo)
			{
				tollgatename_txt.htmlText= _game.dungeonInfo.Name + "  <FONT COLOR='#BC0001'>[" + RoomManager.Instance.current.getDifficulty(RoomManager.Instance.current.hardLevel) + "]</FONT>";
//				tollgatename_txt.text=_game.missionInfo.name+"("+_game.missionInfo.missionIndex+"/"+_game.missionInfo.totalMissiton+")";
			}
		}

		/**
		 * 开始按钮
		 * @param e
		 *
		 */
		private function __startClickHandler(e:MouseEvent):void
		{
			BellowStripViewII.Instance.disableAll();
			BellowStripViewII.Instance.goFriendListBtn.enable = true;
			BellowStripViewII.Instance.goTaskBtn.enable = true;
			
			SoundManager.Instance.play("008");
			
			if(_self.info.WeaponID <= 0)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.RoomIIController.weapon"));
				return;
			}
			
			GameInSocketOut.sendGameMissionStart(true);
			start_Btn.visible = false;
			start_Btn.enabled = false;
			startdisable_Btn.visible = true;
//			leaveroom_Btn.enable = false;
			invite_Btn.enable = false;
			invite_Btn.buttonMode = false;
		}

		/**
		 * 准备按钮
		 * @param e
		 *
		 */
		private function __preparationClickHandler(e:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			
			if(_self.info.WeaponID <= 0)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.RoomIIController.weapon"));
				return;
			}
			
			setSelfReadyState(true);
//			leaveroom_Btn.enable = false;
		}
		
		/**
		 * 取消准备按钮
		 * @param e
		 * 
		 */		
		private function __cancelClickHandler(e:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			setSelfReadyState(false);
//			leaveroom_Btn.enable = true;
			invite_Btn.enable = true;
			invite_Btn.buttonMode = true;
		}
		/**
		 * 点击确定离开副本
		 *
		 */
		private function _callbackFunc():void
		{
			StateManager.setState(StateType.DUNGEON,StateType.DUNGEON);
			GameManager.Instance.reset();
		}

		/**
		 * 邀请按钮
		 * @param e
		 *
		 */
		private function __inviteClickHandler(e:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			showInvite();
//			_controller.showInvite();
		}
		
		/**
		 * 设置准备状态
		 * @param ready
		 * @return 
		 * 
		 */		
		private function setSelfReadyState(ready:Boolean):Boolean
		{
			if(ready)
			{
				if(!_self.hasWeapon())
				{
					SoundManager.Instance.play("008");
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.RoomIIController.weapon"));
					return false;
				}
				if(!_game.selfGamePlayer.isReady)
				{
					GameInSocketOut.sendGameMissionPrepare(_self.roomPos,ready);
					_game.selfGamePlayer.isReady = true;
					cancel_Btn.visible = true;
					preparation_Btn.visible = false;
//					leaveroom_Btn.enable = false;
					return true;
				}
			}
			else
			{
				if(_game.selfGamePlayer.isReady)
				{
					GameInSocketOut.sendGameMissionPrepare(_self.roomPos,ready);
					
					_game.selfGamePlayer.isReady = false;
					cancel_Btn.visible = false;
					preparation_Btn.visible = true;
//					leaveroom_Btn.enable = true;
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * 显示邀请窗口
		 * 
		 */		
		private function showInvite():void
		{
			if(_room.CanInvitePVE())
			{
				if(_invite == null)
				{
					_invite = new InviteController();
				}
				
				if(_invite.getView().parent)
				{
					hideInvite();
				}
				else
				{
					_invite.refleshList(0);
					UIManager.AddDialog(_invite.getView());
				}
			}
			else
			{
				
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.RoomIIView2.noplacetoinvite"));
//				MessageTipManager.getInstance().show("房间没有空余的位置");
			}
		}
		
		/**
		 * 关闭邀请窗口
		 * 
		 */		
		private function hideInvite():void
		{
			if(_invite)
			{
				UIManager.RemoveDialog(_invite.getView());
			}
		}

		/**
		 * 清除用于定位的MovieClip
		 *
		 */
		private function clearMC():void
		{
			removeChild(figurelist_pos);
			figurelist_pos = null;
			
			//removeChild(myprop_pos);
			//myprop_pos=null;
			
			removeChild(chat_pos);
			chat_pos = null;
			
			removeChild(roominfo_pos);
			roominfo_pos = null;
		}
		
		public function resetPlayerReady():void
		{
			for each(var p:Living in _game.livings)
			{
				if(p.isPlayer())Player(p).isReady = false;
			}
		}

		/**
		 * 析构函数
		 *
		 */
		public function dispose():void
		{
			start_Btn.removeEventListener(MouseEvent.CLICK, __startClickHandler);
			preparation_Btn.removeEventListener(MouseEvent.CLICK, __preparationClickHandler);
//			leaveroom_Btn.removeEventListener(MouseEvent.CLICK, __leaveClickHandler);
			invite_Btn.removeEventListener(MouseEvent.CLICK, __inviteClickHandler);
			cancel_Btn.removeEventListener(MouseEvent.CLICK, __cancelClickHandler);
			_duplicateDrop.removeEventListener(DuplicateInfoPanel.OPEN_NOTE, __OpenNoteHandler);
			_self.removeEventListener(RoomEvent.PLAYER_STATE_CHANGED, __changeHandler);
			_game.selfGamePlayer.removeEventListener(GameEvent.READY_CHANGED, __changeHandler);
			_game.livings.removeEventListener(DictionaryEvent.REMOVE, __removeGamePlayerHandler);
			if(_duplicateDrop) _duplicateDrop.dispose();
			_duplicateDrop = null;
			if(_kickTimer)
			{
				_kickTimer.reset();
				_kickTimer.removeEventListener(TimerEvent.TIMER,__onKickTimer);
			}
			_kickTimer = null;

			_propset.dispose();
			_propset = null;
			
			_playerFigureList.dispose();
			_playerFigureList = null;
			
			_room = null;
			_self = null;
			
			if(_boxButton)
			{
				BossBoxManager.instance.deleteBoxButton();
				_boxButton.dispose();
			}
			_boxButton = null;
			
			if(_chat && _chat.parent) _chat.parent.removeChild(_chat);
			_chat = null;
			if(_invite)
			{
				_invite.dispose();
			}
			_invite = null;
			
			_roominfo.dispose();
			_roominfo = null;
			
			_game = null;
			
			if(parent)
				parent.removeChild(this);
		}
	}
}