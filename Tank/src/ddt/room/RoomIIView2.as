package ddt.room
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.utils.Timer;
	
	import game.crazyTank.view.roomII.RoomIIBg2Asset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.HCheckBox;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.manager.TipManager;
	import road.ui.manager.UIManager;
	import road.utils.ComponentHelper;
	
	import tank.assets.ScaleBMP_14;
	import tank.assets.ScaleBMP_4;
	import ddt.data.RoomInfo;
	import ddt.data.player.BagInfo;
	import ddt.data.player.RoomPlayerInfo;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.events.RoomEvent;
	import ddt.manager.BossBoxManager;
	import ddt.manager.ChatManager;
	import ddt.manager.GameManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.RoomManager;
	import ddt.manager.ServerManager;
	import ddt.manager.ShopManager;
	import ddt.manager.SocketManager;
	import ddt.manager.StateManager;
	import ddt.manager.UserGuideManager;
	import ddt.socket.GameInSocketOut;
	import ddt.states.StateType;
	import ddt.view.DefyAfficheView;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;
	import ddt.view.bossbox.SmallBoxButton;
	import ddt.view.common.BellowStripViewII;
	import ddt.view.shop.ShopBugleFrame;
	
	public class RoomIIView2 extends RoomIIBg2Asset
	{
		private var _controller:RoomIIController;
		private var _self:RoomPlayerInfo;
		private var _room:RoomInfo;
		
		private var _chat:Sprite;
		private var _playerlist:RoomIIPlayer2List;
		private var _roomset:RoomIIMapSet;
		private var _propset:RoomIIPropSet;
		private var _kickTimer:Timer;
		
		private var _boxButton:SmallBoxButton;
		
//		private var _roomLoad:RoomLoading;								//新的Load界面
		
		private var btnCancel : HBaseButton;
		private var btnSwitchTeam : HBaseButton;
		private var btnInvite : HBaseButton;
		
		private var _pickupPanel:PickupInfoPannel;
		private var _duplicateInfoPane : DuplicateInfoPanel;//副本掉落列表
		private var _getFlag:RoomIIFlagPanel;
		
		private var autoReadyCheck:HCheckBox;
		private var _bottomBMP1:ScaleBMP_4;
		private var _bottomBMP2:ScaleBMP_14; 
		public static var wait30Sec : Boolean = false;/**是否有等30秒***/
		private var myColorMatrix_filter:ColorMatrixFilter;
		
		private var _crossZoneBtn:HCheckBox;
		
		private var _simpleTip:RoomDupSimpleTipFram;
		private var shopBugle : ShopBugleFrame;
		
		public function RoomIIView2(controller:RoomIIController)
		{
			_controller = controller;
			_self = controller.self;
			_room = controller.room;
			BellowStripViewII.Instance.visible = true;
			initButtons();
			init();
			initEvent();
		}
		
		private function initButtons() : void
		{
			btnCancel  = new HBaseButton(cancel_btn);
			btnCancel.useBackgoundPos = true;
			addChild(btnCancel);
			btnSwitchTeam = new HBaseButton(setteam_btn);
			btnSwitchTeam.useBackgoundPos = true;
			addChild(btnSwitchTeam);
			
			if(_room.roomType >= 2)
			{
				btnSwitchTeam.enable = false;
			}
			btnInvite = new HBaseButton(invite_btn);
			btnInvite.useBackgoundPos = true;
			addChild(btnInvite);
			removeChild(checkPos);
			removeChild(autoReadyAccect);
		
		}

		private function init():void
		{
			myColorMatrix_filter = new ColorMatrixFilter([0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0]);
			start_btn.buttonMode = true;
			ready_btn.buttonMode = true;
			BellowStripViewII.Instance.enabled = true;
			
			_bottomBMP1 = new ScaleBMP_4();
			addChildAt(_bottomBMP1,0);
			_bottomBMP1.x = 7;
			_bottomBMP1.y = 5;
			_bottomBMP2 = new ScaleBMP_14();
			addChildAt(_bottomBMP2,0);
			_bottomBMP2.x = 5;
			_bottomBMP2.y = 3;
			
			var cx:int=crossBtn.x;
			var cy:int=crossBtn.y;
			crossBtn.x = crossBtn.y = 0;
			_crossZoneBtn = new HCheckBox("",null,this.crossBtn);
			_crossZoneBtn.selected = _room.allowCrossZone;
			_crossZoneBtn.x = cx;
			_crossZoneBtn.y = cy;
			addChild(_crossZoneBtn);
			_crossZoneBtn.visible = false;
			
			_playerlist = new RoomIIPlayer2List(_controller.room.players,PlayerManager.selfRoomPlayerInfo,_controller);
			_playerlist.x = playerlist_pos.x;
			_playerlist.y = playerlist_pos.y;
			removeChild(playerlist_pos);
			addChild(_playerlist);
			_roomset = new RoomIIMapSet(_controller);
			_roomset.x = roomset_pos.x;
			_roomset.y = roomset_pos.y;
			removeChild(roomset_pos);
			addChild(_roomset);
			
			_propset = new RoomIIPropSet();
			ComponentHelper.replaceChild(this._room_shop,this._room_shop.propset_pos,_propset);
			
			this._room_shop.room_name_mc.id_txt.text = String(RoomManager.Instance.current.ID); //房间名称 , 房间编号
			this._room_shop.room_name_mc.name_txt.text = String(RoomManager.Instance.current.Name);
			
						
			var fullName:String = String(ServerManager.Instance.current.Name);
			if(fullName.indexOf("(") != -1)
			{
				this._room_shop.room_name_mc.server_txt.text = fullName.substring(0,fullName.indexOf("("));
			}else
			{
				this._room_shop.room_name_mc.server_txt.text = fullName;
			}
			
			click_mc.visible = false;
			click_mc.buttonMode = true;
			
			if(_room.roomType == 0)
			{
				roombk_mc.gotoAndStop(1);
				_bottomBMP2.visible = false;
				_bottomBMP1.visible = true;
				_crossZoneBtn.visible = true;
				btnSwitchTeam.visible = false;
				if(!_self.isHost)
				{
					_crossZoneBtn.enable = false;
				}
				_pickupPanel = new PickupInfoPannel(_room,_self);
				_pickupPanel.x+=3;
				addChild(_pickupPanel);
			}
			else if(_room.roomType == 1)
			{
				roombk_mc.gotoAndStop(2);
				_bottomBMP2.visible = true;
				_bottomBMP1.visible = false;
				openDefyAffiche();
			}
			else if(_room.roomType == 2||_room.roomType == 3){
				_duplicateInfoPane = new DuplicateInfoPanel(_room,"show1.jpg");
			    addChild(_duplicateInfoPane);
			    _duplicateInfoPane.x = 376;
			    _duplicateInfoPane.y = -50;
			    _duplicateInfoPane.isShowIco = true;
			    _duplicateInfoPane.showDrop = false;
			    _duplicateInfoPane.isShowhelp = false;
			    _duplicateInfoPane.choicePos.graphics.beginFill(0xffffff , 0);
		    	_duplicateInfoPane.choicePos.graphics.drawRect(_duplicateInfoPane.choicePos.x-57,_duplicateInfoPane.choicePos.y+200,325,131);
		     	_duplicateInfoPane.choicePos.graphics.endFill();
		     	_duplicateInfoPane.isShowNote = false;
		     	_duplicateInfoPane.caloricPos.visible = false;
		     	_duplicateInfoPane.noteEnable = false;
				roombk_mc.gotoAndStop(3);
				_bottomBMP2.visible = false;
				_bottomBMP1.visible = true;
			}
			else
			{// 夺宝，探险
			    _duplicateInfoPane = new DuplicateInfoPanel(_room);
			    addChild(_duplicateInfoPane);
			    _duplicateInfoPane.x = 376;
			    _duplicateInfoPane.y = -50;
			    if(_room.mapId == 1000 )
			    {
				    _duplicateInfoPane.isShowNote = false;
				    _duplicateInfoPane.isShowhelp = false;
				    _duplicateInfoPane.caloricPos.visible = false;
			    }
			     _duplicateInfoPane.noteEnable = false;
			    if(_self.isHost)
			    {
			    	_duplicateInfoPane.choicePos.choiceIco.visible = true;
			    	_duplicateInfoPane.isShowIco = true;
			    }else
			    {
			    	_duplicateInfoPane.choicePos.choiceIco.visible = false;
			    	_duplicateInfoPane.isShowIco = false;
			    }
				roombk_mc.gotoAndStop(3);
				_bottomBMP2.visible = false;
				_bottomBMP1.visible = true;
			}
			ChatManager.Instance.state = ChatManager.CHAT_ROOM_STATE;
			_chat = ChatManager.Instance.view;
			removeChild(chat_pos);
			addChild(_chat);
			_kickTimer = new Timer(1000);
			
			_simpleTip = new RoomDupSimpleTipFram();
			
			//if(_self.info._isDupSimpleTip)
			//{
			//	_self.info._isDupSimpleTip = false;
			//	_simpleTip.show();
			//}
			
			if(BossBoxManager.instance.isShowBoxButton())
			{
				_boxButton = new SmallBoxButton();
				_boxButton.x = _smallBoxButton.x;
				_boxButton.y = _smallBoxButton.y;
				BossBoxManager.instance.smallBoxButton = _boxButton;
				addChild(_boxButton);
			}
			
			if(BossBoxManager.instance.isShowGradeBox)
			{
				BossBoxManager.instance.isShowGradeBox = false;
				BossBoxManager.instance.showGradeBox();
			}
		}
		
		private function openDefyAffiche():void
		{
			if(!_room || !_room.defyInfo)return;
			for(var i:int = 0;i<=_room.defyInfo[0].length;i++)
			{
				if(_self.info.NickName == _room.defyInfo[0][i])
				{
					if(_room.defyInfo[1].length != 0)
					new DefyAfficheView(_room).show();
				}
			}
		}
		
		public function removeEvent() : void
		{
			if(_room)
			{
				_room.removeEventListener(RoomEvent.STATE_CHANGED,__stateChanged);
				_room.removeEventListener(RoomEvent.START_LOADING,__startLoading);
				_room.removeEventListener(RoomEvent.ALLOW_CROSS_CHANGE,__changeAllowCross);
				_room.removeEventListener(RoomEvent.CHANGED      ,__RoomChanged);
				_self.removeEventListener(RoomEvent.PLAYER_STATE_CHANGED,__stateChanged);
			}
			
			
			if(_self)_self.removeEventListener(RoomEvent.PLAYER_STATE_CHANGED,__stateChanged);
			
			_crossZoneBtn.removeEventListener(MouseEvent.CLICK,__crossClick);
			_crossZoneBtn.removeEventListener(MouseEvent.MOUSE_OVER,_crossOver); //鼠标经过
			_crossZoneBtn.removeEventListener(MouseEvent.MOUSE_OUT,_crossOut);
			
			btnInvite.removeEventListener(MouseEvent.CLICK,__inviteClick);
			btnCancel.removeEventListener(MouseEvent.CLICK,__cancelClick);
			
			if(_kickTimer)_kickTimer.removeEventListener(TimerEvent.TIMER,__onKickTimer);
			if(_pickupPanel)
			{
				_pickupPanel.removeEventListener(RoomEvent.WAITSEC30,   __wait30SecHandler);
				_pickupPanel.stopPickup();
			}
			
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FIGHT_NPC,__onFightNpc);
		}

		private function initEvent():void
		{
			btnInvite.addEventListener(MouseEvent.CLICK,__inviteClick,false,0,true);
			if(btnSwitchTeam)btnSwitchTeam.addEventListener(MouseEvent.CLICK,__teamSetClick,false,0,true);
			btnCancel.addEventListener(MouseEvent.CLICK,__cancelClick,false,0,true);
			ready_btn.addEventListener(MouseEvent.CLICK,__readyClick,false,0,true);
			start_btn.addEventListener(MouseEvent.CLICK,__startClick,false,0,true);
			click_mc.addEventListener(MouseEvent.CLICK,__clickMCClick,false,0,true);
			
			_crossZoneBtn.addEventListener(MouseEvent.CLICK,__crossClick);
			_crossZoneBtn.addEventListener(MouseEvent.MOUSE_OVER,_crossOver); //鼠标经过
			_crossZoneBtn.addEventListener(MouseEvent.MOUSE_OUT,_crossOut);
			
			_room.addEventListener(RoomEvent.ALLOW_CROSS_CHANGE,__changeAllowCross);
			_room.addEventListener(RoomEvent.STATE_CHANGED,__stateChanged);
			_room.addEventListener(RoomEvent.START_LOADING,__startLoading);
			_room.addEventListener(RoomEvent.CHANGED ,__RoomChanged);
			_self.addEventListener(RoomEvent.PLAYER_STATE_CHANGED,__stateChanged);
			
			_kickTimer.addEventListener(TimerEvent.TIMER,__onKickTimer); 
			if(_pickupPanel)_pickupPanel.addEventListener(RoomEvent.WAITSEC30,   __wait30SecHandler);
			__stateChanged(null);
			
			if(_duplicateInfoPane)_duplicateInfoPane.addEventListener(DuplicateInfoPanel.OPEN_ROOMSET ,__OpenRoomSet);
			addEventListener(Event.ADDED_TO_STAGE,userGuide);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FIGHT_NPC,__onFightNpc);
		}
		private function userGuide(e:Event):void{
			if(!UserGuideManager.Instance.getIsFinishTutorial(16)){//点开始
				UserGuideManager.Instance.setupStep(16,UserGuideManager.CONTROL_GUIDE,beforeUserGuide16,checkUserGuide16);
			}
			if(!UserGuideManager.Instance.getIsFinishTutorial(29)){//when quit fight
				UserGuideManager.Instance.setupStep(29,UserGuideManager.CONTROL_GUIDE,null,checkUserGuide29);
			}
			if(!UserGuideManager.Instance.getIsFinishTutorial(56)){//
				UserGuideManager.Instance.setupStep(56,UserGuideManager.BUTTON_GUIDE,beforeUserGuide56,start_btn);
			}
			if(!UserGuideManager.Instance.getIsFinishTutorial(57)){//
				UserGuideManager.Instance.setupStep(57,UserGuideManager.CONTROL_GUIDE,beforeUserGuide57,checkUserGuide57);
			}
			if(!UserGuideManager.Instance.getIsFinishTutorial(60)){//
				UserGuideManager.Instance.setupStep(60,UserGuideManager.CONTROL_GUIDE,null,checkUserGuide60);
			}
		}
		private function checkUserGuide60():Boolean{
			return true;
		}
		private function beforeUserGuide16():void{
			var sp:Sprite = new Sprite();
			
			sp.graphics.beginFill(0x000000);
			sp.graphics.drawRect(-2000,-2000,4000,4000);
			sp.graphics.endFill();
			TipManager.AddTippanel(sp);
		}
		private function checkUserGuide16():Boolean{
			SocketManager.Instance.out.enterUserGuide();
			sendStartGame()
			return true;
		}
		private function checkUserGuide29():Boolean{
			StateManager.setState(StateType.MAIN);
			return true;
		}
		private function beforeUserGuide56():void{
			
			if(!PlayerManager.Instance.Self.WeaponID){
				
				//trace("no weapon");
				SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,32/** 武器在背包的位置*/,BagInfo.EQUIPBAG,6./**武器的装备栏*/);
			}
		}
		private function beforeUserGuide57():void{
			btnCancelVisible = btnCancel.visible;
		}
		private var btnCancelVisible:Boolean;
		private function checkUserGuide57():Boolean{
			if(btnCancel){
				if(btnCancel.visible != btnCancelVisible){
					UserGuideManager.Instance.switchStartButton(btnCancel.visible)
					btnCancelVisible = btnCancel.visible;
				}
			}
			if(StateManager.currentStateType != StateType.ROOM){
				return true;
			}else{
				return false;
			}
		}
		
		private function __crossClick(evt:MouseEvent):void
		{
//			_room.allowCrossZone = !_room.allowCrossZone;
			GameInSocketOut.sendGameRoomSetUp(_room.mapId,_room.roomType,2,0,0,!_room.allowCrossZone);
		}
		
		private function _crossOver(evt:MouseEvent):void
		{
			if(_crossZoneBtn.enable)
			{
				var matrix:Array = new Array();
				matrix = matrix.concat([1.3, 0, 0, 0, 0]); // red
				matrix = matrix.concat([0, 1.3, 0, 0, 0]); // green
				matrix = matrix.concat([0, 0, 1.3, 0, 0]); // blue
				matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha

				_crossZoneBtn.filters = [new ColorMatrixFilter(matrix)];
			}
		}
		
		private function _crossOut(evt:MouseEvent):void
		{
			if(_crossZoneBtn.enable)
			{
				_crossZoneBtn.filters = [];
			}
		}
		
		private function __changeAllowCross(evt:RoomEvent):void
		{
			_crossZoneBtn.selected = _room.allowCrossZone;
			
			if(_crossZoneBtn.selected)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.RoomIIView.cross.kuaqu"));
			}else
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.RoomIIView.cross.benqu"));
			}
		}
		
		private function __stateChanged(event:Event):void
		{
			_kickTimer.reset();
			setClickVisible(false);
			if(_duplicateInfoPane)
			{
				_duplicateInfoPane.btnButtonMode = _self.isHost;
			    _duplicateInfoPane.isShowIco = _self.isHost;
			}
			if(_controller.currentState != 1)BellowStripViewII.Instance.show();
			switch(_room.roomState)
			{
				case RoomInfo.STATE_UNREADY:
					
					if(_pickupPanel)
						_pickupPanel.stopPickup();
					btnInvite.enable = true;
					if(_room.roomType == 1)
					{
						if(btnSwitchTeam)btnSwitchTeam.enable = true;
					}else
					{
						if(btnSwitchTeam)btnSwitchTeam.enable = false;
					}
					if(_room.roomType == 0)
					{
						_crossZoneBtn.visible = true;
						btnSwitchTeam.visible = false;
					}else
					{
						_crossZoneBtn.visible = false;
						btnSwitchTeam.visible = true;
					}
					if(_self.isHost)
					{
						startdisable_btn.visible = true;
						start_btn.visible = false;
						ready_btn.visible = false;
						_crossZoneBtn.enable = true;
						_kickTimer.start();
					}else
					{
						startdisable_btn.visible = false;
						start_btn.visible = false;
						ready_btn.visible = true;
						_crossZoneBtn.enable = false;
					}
					
					btnCancel.visible = false;
					BellowStripViewII.Instance.enableAll();
					break;
				case RoomInfo.STATE_READY:
					btnInvite.enable = true;
					if(_pickupPanel)
						_pickupPanel.stopPickup();
					BellowStripViewII.Instance.disableAll();
					if(_room.roomType == 0)
					{
						_crossZoneBtn.visible = true;
						btnSwitchTeam.visible = false;
					}else
					{
						_crossZoneBtn.visible = false;
						btnSwitchTeam.visible = true;
					}
					if(_self.isHost)
					{
						_crossZoneBtn.enable = true;
						start_btn.visible = true;
						startdisable_btn.visible = false;
						btnCancel.visible = false;
						if(_room.roomType == 0)
						{
							if(btnSwitchTeam)btnSwitchTeam.enable = false;
						}
						else if(_room.roomType >= 2)
						{
							if(btnSwitchTeam)btnSwitchTeam.enable = false;
						}else
						{
							if(btnSwitchTeam)btnSwitchTeam.enable = true;
						}
						BellowStripViewII.Instance.enableAll();
						_kickTimer.start();
//						if(_room.players.length > 1)
//						{
//							
//						}
					}else
					{
						start_btn.visible = false;
						_crossZoneBtn.enable = false;
						startdisable_btn.visible = false;
						btnCancel.visible = true;
						btnCancel.enable = true;
						if(btnSwitchTeam)btnSwitchTeam.enable = false;
						BellowStripViewII.Instance.goFriendListBtn.enable = true;
						BellowStripViewII.Instance.goTaskBtn.enable = true;
					}
					ready_btn.visible = false;
					break;
				case RoomInfo.STATE_PICKING:
					_controller.hideInvite();
					btnInvite.enable = false;
					_crossZoneBtn.enable = false;
					if(btnSwitchTeam)btnSwitchTeam.enable = false;
					start_btn.visible = false;
					startdisable_btn.visible = false;
					btnCancel.visible = true;
					if(_self.isHost)
					{
						btnCancel.enable = true;
//						autoReadyCheck.enable = false;//bret 09.7.13
					}
					else
					{
						btnCancel.enable = false;
					}
					if(_pickupPanel)_pickupPanel.startPickup();
					BellowStripViewII.Instance.disableAll();
					BellowStripViewII.Instance.goFriendListBtn.enable = true;
					BellowStripViewII.Instance.goTaskBtn.enable = true;
					break;
				case RoomInfo.STATE_LOADING:
					TipManager.clearTipLayer();
					_controller.hideInvite();
					btnInvite.enable = false;
					_crossZoneBtn.enable = false;
					if(btnSwitchTeam)btnSwitchTeam.enable = false;
					start_btn.visible = false;
					_crossZoneBtn.visible = false;
					startdisable_btn.visible = false;
					btnCancel.visible = true;
					btnCancel.enable = false;
					if(_pickupPanel)
						_pickupPanel.stopPickup();
					BellowStripViewII.Instance.disableAll();
					BellowStripViewII.Instance.goFriendListBtn.enable = true;
					BellowStripViewII.Instance.goTaskBtn.enable = true;
					break;
			}
			
			wait30Sec = false;
		}
		
		private function __OpenRoomSet(evt:Event):void
		{
			if(_self.isHost)
			{
				SoundManager.instance.play("045");
				if(_roomset.mapSetFlicker_mc.visible)
				_roomset.mapSetFlicker();
				_controller.showMapSet();
			}
		}
		
		private function __startLoading(event:RoomEvent):void
		{
			//if(_room.gameMode == 4)
			//{
			//	showGetFlag();
			//}
			//else
			{
				showLoad();
			}
		}
		
		private function __inviteClick(evt:MouseEvent):void
		{
			if(_playerlist.PlaceFill())
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.RoomIIView2.noplacetoinvite"));
//				MessageTipManager.getInstance().show("房间没有空余的位置");
			}else
			{
				_controller.showInvite();
			}
			SoundManager.instance.play("008");
		}
		
		private function __RoomChanged(evt:RoomEvent):void
		{
			if(_room.mapId != 10000 && _duplicateInfoPane)
			{
				_duplicateInfoPane.isShowhelp = true;
				_duplicateInfoPane.caloricPos.visible = true;
			}
			 if(_duplicateInfoPane && _self.isHost && !_controller.setingAchieve)
		    {
		    	_duplicateInfoPane.choicePos.choiceIco.visible = true;
		    }else if(_duplicateInfoPane)
		    {
		    	_duplicateInfoPane.choicePos.choiceIco.visible = false;
		    }
		}
		
		private function __teamSetClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("012");
			if(!_self.isReady || _self.isHost)
			{
				GameInSocketOut.sendGameTeam(int(_self.team % 2) + 1);			
			}
		}

		private function leaveRoom() : void
		{
//			SoundManager.instance.play("008");
			StateManager.setState(_room.backRoomListType);
			RoomManager.Instance.current.defyInfo = null;
		}
		private function canceBack() : void
		{
			SoundManager.instance.play("008");
		}
		private function __cancelClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			if(_self.isHost)
			{
				if(_pickupPanel)_pickupPanel.resetTimer();
				GameInSocketOut.sendCancelWait();
			}
			else
			{
				_controller.setSelfReadyState(false);
			}
		}
		
		private function __readyClick(evt:MouseEvent):void{
			configRoomList();
			SoundManager.instance.play("008");
			if(!_self.hasWeapon())
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.RoomIIController.weapon"));
				return;
			}
			_controller.setSelfReadyState(true);
		}
		
		private function __onKickTimer(evt:TimerEvent):void
		{
			var unReady : Boolean = false;
			for each(var info : RoomPlayerInfo in _room.players)
			{
				if(info.info.ID != _self.info.ID && !info.isReady)
				{
					unReady = true;
					break;
				}
			}
			if(_kickTimer.currentCount == 30)
			{
				if(!unReady && _room.canStart())setClickVisible(true);
			}
			if(_self.isHost)
			{
				if(_room.players.length == 1)
				{
					if(_kickTimer.currentCount >= 300)kickHandler();
				}
				else
				{
					if(_kickTimer.currentCount < 60)return;
//					var unReady : Boolean = false;
//					for each(var info : RoomPlayerInfo in _room.players)
//					{
//						if(info.info.ID != _self.info.ID && !info.isReady)
//						{
//							unReady = true;
//							break;
//						}
//					}
					if(_kickTimer.currentCount >= 1200)
					{
						if(unReady)kickHandler();
					}
					else if(_kickTimer.currentCount >= 60)
					{
						if(!unReady)kickHandler();
					}
				}
			}
			
		}
		
		private function kickHandler() : void
		{
			_kickTimer.reset();
			ChatManager.Instance.sysChatRed(LanguageMgr.GetTranslation("ddt.room.RoomIIView2.kick"));
			if(_room){
				StateManager.setState(_room.backRoomListType);
			}else{
				StateManager.setState(StateType.DUNGEON);
			}
			
			PlayerManager.Instance.Self.unlockAllBag();
		}
		private function __wait30SecHandler(evt : RoomEvent) : void
		{
			wait30Sec = true;
			btnCancel.enable = true;
		}
		private function setClickVisible(b:Boolean):void
		{
			SoundManager.instance.stop("007");
			if(b)
			{
				SoundManager.instance.play("007",false,true,10000);
			}
		}
		private function configRoomList():void{
			switch(_room.roomType){
				case 0:
				case 1:
					_room.backRoomListType = StateType.ROOM_LIST;
					break;
				case 2:
				default:
					break;
			}
		}
		private function __startClick(evt:MouseEvent):void
		{
			configRoomList();
			if(_self.info.WeaponID <= 0)
			{
				SoundManager.instance.play("008");
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.RoomIIController.weapon"));
				return;
			}
			if(_room.roomType == 10){
				sendStartGame();
			}else if(!_controller.setingAchieve && _room.roomType > 2)
			{
				SoundManager.instance.play("008");
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.RoomIIView2.setRoomInfo"));
				if(!_roomset.mapSetFlicker_mc.visible)
				_roomset.mapSetFlicker();
				return;
			}
			if(_room.roomType == 3)
			{
				SoundManager.instance.play("008");
				if(PlayerManager.Instance.Self.bagLocked)
				{
					new BagLockedGetFrame().show();
					return;
				}
				HConfirmDialog.OK_LABEL = LanguageMgr.GetTranslation("continue");
				//HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.room.RoomIIView2.notenoughmoney.title"), LanguageMgr.GetTranslation("ddt.room.RoomIIView2.confirmtostartgame"), true, sendStartGame, cancelCallback);
				HConfirmDialog.show("提示", "此操作会扣除BOSS通行门票一张，是否继续？", true, sendStartGame, cancelCallback);
				//sendStartGame()
				if(_duplicateInfoPane)
					_duplicateInfoPane.setMouseMoveUnListen();
			}else if(_room.roomType == 4 && _playerlist.room.players.length == 1)
			{
				SoundManager.instance.play("008");
//				HConfirmDialog.OK_LABEL = LanguageMgr.GetTranslation("ddt.room.RoomIIView2.affirm");
				HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("ddt.room.RoomIIView2.clewContent"),true,sendStartGame, cancelCallback,true,LanguageMgr.GetTranslation("ddt.room.RoomIIView2.affirm"));
//				HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.room.RoomIIView2.notenoughmoney.title"),"副本难度较大，适合2人以上团队挑战，\n\		确定要单人闯关吗？",true,sendStartGame, cancelCallback, "确认");
				if(_duplicateInfoPane)
					_duplicateInfoPane.setMouseMoveUnListen();
			}
			else
			{
				sendStartGame();
			}
		}
		
		private function sendStartGame():void
		{
//			HConfirmDialog.OK_LABEL = LanguageMgr.GetTranslation("ok");
			if(_room.roomType==3)
			{
				if(PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(88)<=0)
				{
					if(ShopManager.Instance.getMoneyShopItemByTemplateID(88))
					{
						if(shopBugle && !shopBugle.parent)
						{
							shopBugle = null;
						}				
						if(!shopBugle)
						{
							shopBugle = new ShopBugleFrame();
							shopBugle.type = 88;
						}
					return;
					}
				}
			}
			if(_duplicateInfoPane)
			{
				_duplicateInfoPane.SetMouseMoveListen();
			}
			_controller.startGame();
			//global.traceStr("sendStartGame");
			SoundManager.instance.play("008");
		}
		
		private function cancelCallback():void
		{
//			HConfirmDialog.OK_LABEL = LanguageMgr.GetTranslation("ok");
			if(_duplicateInfoPane)
				_duplicateInfoPane.SetMouseMoveListen();
		}
		
		private function __clickMCClick(evt:MouseEvent):void
		{
			if(start_btn.visible)
				__startClick(evt);
			else 
				__readyClick(evt);
		}
		
		public function showGetFlag():void
		{
			_getFlag = new RoomIIFlagPanel(_controller,_self);
			_getFlag.addEventListener(Event.COMPLETE,__getFlagComplete);
			UIManager.AddDialog(_getFlag);
		}
		
		private function __getFlagComplete(evt:Event):void
		{
			_getFlag.removeEventListener(Event.COMPLETE,__getFlagComplete);
			_getFlag.dispose();
			_getFlag = null;
			showLoad();
		}
		private function __onFightNpc(evt:CrazyTankSocketEvent):void{
			var isShowAlert:Boolean = evt.pkg.readBoolean();
			_room.frightMatchWithNPC = true;
			if(isShowAlert)_pickupPanel.displayFightNpc();
		}
		
		public function dispose():void
		{
			removeEvent();
			SoundManager.instance.stop("007");
			if( RoomManager.Instance.current && RoomManager.Instance.current.defyInfo)
			{
				RoomManager.Instance.current.defyInfo = null;
			}
			
			_kickTimer.reset();
			_kickTimer.removeEventListener(TimerEvent.TIMER,__onKickTimer);
			if(_duplicateInfoPane)
			{
				_duplicateInfoPane.removeEventListener(DuplicateInfoPanel.OPEN_ROOMSET ,__OpenRoomSet);
				_duplicateInfoPane.dispose();
			}
			_duplicateInfoPane = null;
			if(_getFlag)
			{
				_getFlag.dispose();
				_getFlag = null;
			}
			
			if(_pickupPanel)
			{
				_pickupPanel.dispose();
				_pickupPanel = null;
			}
			
			if(_chat && _chat.parent)
				_chat.parent.removeChild(_chat);
			_chat = null;
			
			_playerlist.dispose();
			_playerlist = null;
			
			_roomset.dispose();
			_roomset = null;
			
			_propset.dispose();
			_propset = null;
			
			_self = null;
			_controller = null;
			_room = null;
			
			if(_boxButton)
			{
				BossBoxManager.instance.deleteBoxButton();
				_boxButton.dispose();
			}
			_boxButton = null;
			
			if(_simpleTip)
			{
				_simpleTip.dispose();
				_simpleTip = null;
			}
			
			if(btnSwitchTeam)
			{
				btnSwitchTeam.removeEventListener(MouseEvent.CLICK,__teamSetClick);
				btnSwitchTeam.dispose();
			}
			
			btnCancel.dispose();
			btnInvite.dispose();
			
			btnCancel = null;
			btnSwitchTeam = null;
			btnInvite = null;
			if(parent)
				parent.removeChild(this);
			if(_bottomBMP1)
			{
				removeChild(_bottomBMP1);
				_bottomBMP1 = null;
			}
			if(_bottomBMP2)
			{
				removeChild(_bottomBMP2);
				_bottomBMP2 = null;
			}
		}
		
		public function showLoad():void
		{
			_kickTimer.reset();
			ChatManager.Instance.setFocus();
			this.visible = false;
			BellowStripViewII.Instance.hide();
			ChatManager.Instance.setFocus();
			GameManager.Instance.startLoading();
		}
	}
}