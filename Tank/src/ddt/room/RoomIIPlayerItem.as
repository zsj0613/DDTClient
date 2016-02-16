package ddt.room
{
	import com.hurlant.crypto.symmetric.NullPad;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import ddt.data.Experience;
	import ddt.data.RoomInfo;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.data.player.RoomPlayerInfo;
	import ddt.events.RoomEvent;
	import ddt.manager.ChatManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.manager.RoomManager;
	import ddt.menu.RightMenu;
	import ddt.socket.GameInSocketOut;
	import ddt.utils.DisposeUtils;
	import ddt.utils.Helpers;
	import ddt.view.bagII.bagStore.BagStore;
	import ddt.view.characterII.ICharacter;
	import ddt.view.characterII.ShowCharacter;
	import ddt.view.chatsystem.ChatData;
	import ddt.view.chatsystem.ChatEvent;
	import ddt.view.chatsystem.ChatInputView;
	import ddt.view.common.ChatBallView;
	import ddt.view.common.ConsortiaIcon;
	import ddt.view.common.FaceContainer;
	import ddt.view.common.GradeContainer;
	import ddt.view.common.LevelIcon;
	import ddt.view.common.MarryIcon;
	import ddt.view.common.VIPIcon;
	import ddt.view.im.IMController;
	
	import game.crazyTank.view.LevelUpFaileMC;
	import game.crazyTank.view.roomII.RoomIIPlayerItemAsset;
	
	import road.display.MovieClipWrapper;
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HTipButton;
	
	import tank.view.LevelCartoonAsset;

	public class RoomIIPlayerItem extends RoomIIPlayerItemAsset
	{
		public static const SHOWINFO:String = "showinfo";
		
		private var _info:RoomPlayerInfo;
		private var _place:int;
		private var _player:ShowCharacter;
		private var _chatballview:ChatBallView;
		private var _face:FaceContainer;
		private var _grade:GradeContainer; // 显示升级动画
		private var _level:LevelIcon;
		private var _cIcon:ConsortiaIcon;
		private var _mIcon:MarryIcon;
		private var _vIcon:VIPIcon;
		
//		private var _levelcartoon:MovieClipWrapper;
		private var _controller:RoomIIPlayer2List;
		
		private var btnAddFriend : HTipButton;
		private var btnViewInfo  : HTipButton;
		private var btnClose     : HTipButton;
		
		private var buttonModelSprite:Sprite;
		
		private var _isclose:Boolean;
		
		public function get close():Boolean
		{
			return _isclose;
		}
		
		public function set close(value:Boolean):void
		{
			if(_isclose == value)	return;
			_isclose = value;
			waiting_mc.visible = !_isclose;
			info = null;
		}
		
		public function RoomIIPlayerItem(place:int,controller:RoomIIPlayer2List = null)
		{
			_controller = controller;
			_place = place;
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			buttonModelSprite = new Sprite();
			buttonModelSprite.graphics.beginFill(0x000000,0);
			buttonModelSprite.graphics.drawRect(0,0,156,158);
			buttonModelSprite.graphics.endFill();
			buttonModelSprite.x=4;
			buttonModelSprite.y=24;
			buttonModelSprite.buttonMode = true;
			buttonModelSprite.mouseChildren = buttonModelSprite.mouseEnabled = false;
			addChild(buttonModelSprite);
			
			btnAddFriend = new HTipButton(addFriend_btn,"",LanguageMgr.GetTranslation("ddt.room.RoomIIPlayerItem.addFriend"));
			btnAddFriend.useBackgoundPos = true;
			addChild(btnAddFriend);
			btnAddFriend.visible = false;
			
			btnViewInfo  = new HTipButton(view_btn,"",LanguageMgr.GetTranslation("ddt.room.RoomIIPlayerItem.view"));
			btnViewInfo.useBackgoundPos = true;
			addChild(btnViewInfo);
			btnViewInfo.visible = false;
			
			btnClose = new HTipButton(close_btn,"",LanguageMgr.GetTranslation("ddt.room.RoomIIPlayerItem.exitRoom"));
			btnClose.useBackgoundPos = true;
			addChild(btnClose);
			btnClose.visible = false;

			ConsortiaName_txt.mouseEnabled = false;
			
			_isclose = false;
			bg.buttonMode = true;
			bg.mouseEnabled = false;
			waiting_mc.buttonMode = true;
			waiting_mc.mouseEnabled = false;
			level_pos.visible = false;
			name_txt.mouseEnabled = false;
			ready_mc.mouseEnabled = false;
			
			_level = new LevelIcon("b",1,0,0,0,0);
			_level.x = level_pos.x;
			_level.y = level_pos.y;
			addChild(_level);
			

			_cIcon = new ConsortiaIcon(0,ConsortiaIcon.BIG,false);
			_cIcon.x = _level.x + 3;
//			_cIcon.y = _level.y+_level.height+4;
			_cIcon.y = _level.y+39;
			addChild(_cIcon);
			
			
			_face = new FaceContainer(true);
			_face.y = 103;
			addChild(_face);
			
			_grade = new GradeContainer(true); // 升级动画
			_grade.y = 50;
			_grade.x = 50;
			addChild(_grade);
			
			_chatballview = new ChatBallView();
			_chatballview.y = 110;
			_chatballview.x = 100;
			addChild(_chatballview);
			
			signal_tip.gotoAndStop(1);
			
			figure_pos.addEventListener(MouseEvent.CLICK,__figureClick);
			
//			levelUpMC = new LevelUpStandMC();
			resetView();
		}
		
		private function __figureClick(event:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			dispatchEvent(new Event(SHOWINFO));
//			RightMenu.show(_info.info);

		}
		
		private function resetView():void
		{
			bg_Mc.gotoAndStop(1);
			ready_mc.visible = false;
			name_txt.text = "";
			btnClose.visible = false;
			btnViewInfo.visible = false;
			host_mc.visible = false;
			signal_tip.visible = false;
			btnAddFriend.visible = false;
			signal_mc.gotoAndStop(1);
			signal_mc.visible = false;
			if(_player != null)
			{
				if(_player.parent == figure_pos)
					figure_pos.removeChild(_player as DisplayObject);
				_player = null;
			}
			_face.clearFace();	
			if(_level != null)
			{
				_level.visible = false;
			}
			if(_cIcon != null)
			{
				_cIcon.dispose();
				_cIcon.visible = false;
			}
			if(_mIcon != null)
			{
				_mIcon.visible = false;
			}
			
			ConsortiaName_txt.text = "";
//			if(_levelcartoon != null)
//			{
//				if(_levelcartoon.parent)_levelcartoon.parent.removeChild(_levelcartoon);
//			}
			_chatballview.clear();
		}
		
		private function initEvent():void
		{
			btnViewInfo.addEventListener(MouseEvent.CLICK,__viewClick);
			btnClose.addEventListener(MouseEvent.CLICK,__closeClick);
			btnAddFriend.addEventListener(MouseEvent.CLICK,__addFriendClick);
			
			signal_mc.addEventListener(MouseEvent.MOUSE_OVER,__signalMouseOver);
			signal_mc.addEventListener(MouseEvent.MOUSE_OUT,__signalMouseOut);
			
			waiting_mc.addEventListener(MouseEvent.CLICK,__waitingClick);
			bg.addEventListener(MouseEvent.CLICK,__bgClick);
			
			ChatManager.Instance.model.addEventListener(ChatEvent.ADD_CHAT,__getChat);
			ChatManager.Instance.addEventListener(ChatEvent.SHOW_FACE,__getFace);
			
			BagStore.Instance.addEventListener(BagStore.OPEN_BAGSTORE,bagStoreOpenHandler);
			BagStore.Instance.addEventListener(BagStore.CLOSE_BAGSTORE,bagStoreClosedHandler);
			
			PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__updateGrade);
		}
		
		public function clearFace():void
		{
			if(_face != null)
			{
				_face.clearFace();
			}
			if(_chatballview != null)
				_chatballview.clear();
		}
		
		public function get character():ICharacter
		{
			return _player;
		}
		
		public function get info():RoomPlayerInfo
		{
			return _info;
		}
		
		public function get id():Number
		{
			if(_info == null)return -1;
			return _info.info.ID;
		}
		
		public function set info(value:RoomPlayerInfo):void
		{
			if(_info == value)return;
			if(_info)
			{
				resetView();
			}
			if(value == null && _info && _info.info)
			{
				_info.info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__propertyChange);
			}
			_info = value;
			if(_info)
			{
				_info.info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__propertyChange);
				_info.addEventListener(RoomEvent.PLAYER_STATE_CHANGED,__roomInfoChanGed);
				udpatePlayerInfo();
				_info.resetCharacter();
				_player = _info.character;
				_player.showGun = true;
				_player.setShowLight(true,new Point(0,5));
				
				if(RoomManager.Instance.current.roomType  == 1)
				{
					if(place % 2 == 1)
					{
						_player.scaleX = _face.scaleX = 1;
						_face.x = 80;
						figure_pos.x = 36;
					}
					else 
					{
						_player.scaleX = _face.scaleX = -1;
						_face.x = 100;
						
					}
				}
				else
				{
					_player.scaleX = _face.scaleX = -1;
					_face.x = 100;
				}
				figure_pos.addChild(_player as DisplayObject);
				
				if(RoomManager.Instance.current.roomType == 1)
				{
					bg_Mc.gotoAndStop(_info.team+1);
				}
				else
				{
					bg_Mc.gotoAndStop(4);
				}
				
				signal_mc.visible = true;
//				__stateChange(null);
				
				btnViewInfo.visible = true;
				btnAddFriend.visible = true;
				btnClose.visible = true;
				var self : RoomPlayerInfo =  PlayerManager.selfRoomPlayerInfo;
				
				updateButton(self,RoomManager.Instance.current);
				
//				updateButton(_controller.self,_controller.room);
	//			trace("_info.isUpGrade............",_info.isUpGrade);
			
				if(_info.isUpGrade)
				{
					_grade.setGrade(new LevelUpFaileMC());  //播放升级动画
					
					_info.isUpGrade = false;
				   var levelcartoon:MovieClipWrapper = new MovieClipWrapper(new LevelCartoonAsset(),true,true);
					levelUp.addChild(levelcartoon);
				}
			}
		}
		
		private function __propertyChange(evt:PlayerPropertyEvent):void
		{
			if(_info && _info.info) 
				udpatePlayerInfo();
		}
		
		private function udpatePlayerInfo():void
		{
			//global.traceStr("OnUpdatePlayerInfo");
			name_txt.text = String(_info.info.NickName);
			name_txt.mouseEnabled = false;
			ConsortiaName_txt.text = _info.info.ConsortiaName;
			//global.traceStr(_info.info.Grade.toString()+""+_info.info.GP.toString());	
			
			_level.resetLevelTip(_info.info.Grade,_info.info.Repute,_info.info.WinCount,_info.info.TotalCount);
			_level.Battle = _info.info.FightPower;
			_level.visible = true;
				
			if(_cIcon)
			{
				_cIcon.consortiaID = _info.info.ConsortiaID;
				_cIcon.consortiaName = _info.info.ConsortiaName;
				_cIcon.consortiaLevel = _info.info.ConsortiaLevel;
				_cIcon.consortiaRepute = _info.info.ConsortiaRepute;
				_cIcon.x = _level.x + 3;
//					_cIcon.y = _level.y+_level.height+4;
				_cIcon.y = _level.y+ 39;
				if(_info.info.ConsortiaID > 0)
				{
					
					addChild(_cIcon);
					if(getChildIndex(_cIcon)<getChildIndex(_level))
					{
						swapChildren(_cIcon,_level);
					}
					_cIcon.visible = true;
				}
				else
				{
					_cIcon.visible = false;
				}
			}
			
			if(_info.info.IsMarried)
			{
				if(_mIcon)
				{
					_mIcon.dispose();
					_mIcon = new MarryIcon(_info.info);
				}else
				{
					_mIcon = new MarryIcon(_info.info);
				}
				_mIcon.x = _level.x + 4;
				
				if(_cIcon&&_cIcon.visible)
				{
					_mIcon.y = _cIcon.y+_cIcon.height+4;
				}else
				{
//						_mIcon.y = _level.y+_level.height+4;
					_mIcon.y = _level.y+ 39;
				}
				addChild(_mIcon);
				addChild(_chatballview);
				addChild(_face);
			}
			if(_info.info.VIPLevel >=1)
			{
				if(_vIcon)
				{
					_vIcon.dispose();
					_vIcon = null;
					_vIcon = new VIPIcon(_info.info,false);
				}
				else					
				{
					_vIcon = new VIPIcon(_info.info,false);
				}
				_vIcon.x =  _level.x;
				if(_cIcon&&!_mIcon)
				{
					_vIcon.y = _cIcon.y +_cIcon.height+4;
				}else if(!_cIcon&&_mIcon)
				{
					_vIcon.y = _mIcon.y +_mIcon.height+4;
				}
				else
				{
					_vIcon.y = _level.y + 39;
				}
				addChild(_vIcon);
				
			}

		}

		public function updateButton(self:RoomPlayerInfo,room:RoomInfo):void
		{
			if(self.isHost && room.canKitPlayer())
			{
				if(_info != self)
				{
					btnClose.enable = true;
				}
				else
				{
					btnClose.enable = false;
					btnClose.buttonMode = false;
					close_btn.buttonMode = false;
				}
				waiting_mc.mouseEnabled = true;
				bg.mouseEnabled = true;
			}
			else
			{
				btnClose.enable = false;
				btnClose.buttonMode = false;
				close_btn.buttonMode = false;
				waiting_mc.mouseEnabled   = false;
				bg.mouseEnabled = false;
			}
			
			if(self.isHost || info!=null)
			{
				buttonModelSprite.buttonMode = true;
			}else
			{
				buttonModelSprite.buttonMode = false;
			}
		}
		
		public function changeTeam():void
		{
			bg_Mc.gotoAndStop(_info.team+1);
		}
		
		private function __changeTeam(evt:RoomEvent):void
		{
			bg_Mc.gotoAndStop(_info.team+1);
		}
		
		private function __roomInfoChanGed(evt:RoomEvent):void
		{
			if(_info)
			{
				ready_mc.visible = (_info.isHost ? false : _info.isReady);
				host_mc.visible = _info.isHost;
				figure_pos.buttonMode = buttonModelSprite.buttonMode;
			}
		}
		
		public function gameReadyChange(isReady:Boolean):void
		{
			ready_mc.visible = (_info.isHost ? false : isReady);
			host_mc.visible = _info.isHost;
			figure_pos.buttonMode = buttonModelSprite.buttonMode;
		}
		
		public function roomReadyChange():void
		{
			ready_mc.visible = (_info.isHost ? false : _info.isReady);
			host_mc.visible = _info.isHost;
			figure_pos.buttonMode = buttonModelSprite.buttonMode;
		}
		
		public function stateChange():void
		{
			signal_mc.gotoAndStop(4 - _info.webSpeedInfo.stateId);
			signal_tip.gotoAndStop(4 - _info.webSpeedInfo.stateId);
		}
		
		private function __closeClick(evt:MouseEvent):void
		{
			if(!_info.isHost)
			{
				if(RoomManager.Instance.current.canKitPlayer())
				{
					SoundManager.Instance.play("008");
					GameInSocketOut.sendGameRoomKick(_place);
				}
			}
		}
		
		private function __viewClick(evt:MouseEvent):void
		{
			var minusY:Number = mouseY - localToGlobal(new Point(evt.target.x,evt.target.y)).y
			
			RightMenu.Instance.minusY= minusY;
				
			RightMenu.show(_info.info);
			
			
			//evt.target.height
			//RightMenu.Instance.y  -= mouseY - evt.target.y
				
			SoundManager.Instance.play("008");
//			dispatchEvent(new Event(SHOWINFO));
		}
		
		public function playerGPChange():void
		{
			var grade:int = Experience.getGrade(_info.info.GP);
			_info.info.Grade = grade;
			_level.level = grade;
			_level.Battle = _info.info.FightPower;
		}
		
		private function __waitingClick(evt:MouseEvent):void
		{
			if(_controller)
			{
				_controller.closePlace(_place);
			}
			else
			{
				dispatchEvent(new Event(Event.CLOSE));
			}
			SoundManager.Instance.play("009");
		}
		
		private function __updateGrade(evt:PlayerPropertyEvent):void
		{
			if(evt.changedProperties["SpouseName"])
			{
				if(_mIcon && !PlayerManager.Instance.Self.IsMarried)
				{
					_mIcon.dispose()
					_mIcon=null;
				}else if(!_mIcon && PlayerManager.Instance.Self.IsMarried && _info && _level)
				{
					_mIcon = new MarryIcon(_info.info);
					_mIcon.x = _level.x + 4;
					if(_cIcon&&_cIcon.visible)
					{
						_mIcon.y = _cIcon.y+_cIcon.height+4;
					}else
					{
						_mIcon.y = _level.y+ 39;
					}
					addChild(_mIcon);
					addChild(_face);
				}
			}
		}
		
		private function __getChat(evt:ChatEvent):void
		{
			if(_info == null)return;
			var data:ChatData =ChatData(evt.data).clone();
			if(data.senderID == _info.info.ID && (data.channel == ChatInputView.CURRENT||data.channel == ChatInputView.TEAM))
			{
				addChild(_chatballview);
				data.msg = Helpers.deCodeString(data.msg);
				_chatballview.setText(data.msg,_info.info.paopaoType);
			}
		}
		
		private function __getFace(evt:ChatEvent):void
		{
			if(_info == null)return;
			var data:Object = evt.data;
			if(data["playerid"] == _info.info.ID)
			{
				//trace("_getFace>>>",data["faceid"]);
				_face.setFace(data["faceid"]);
			}
		}
		
		private function __bgClick(evt:MouseEvent):void
		{
			if(_isclose)
			{
				if(_controller)
				{
					_controller.openPlace(_place);
				}
				else
				{
					dispatchEvent(new Event(Event.OPEN));
				}
				SoundManager.Instance.play("009");
			}
		}
		
		
		
		
		public function get place():int
		{
			return _place;
		}
		
		private function __addFriendClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			IMController.Instance.addFriend(_info.info.NickName);
		}
		
		private function playSound():void
		{
			SoundManager.Instance.play("008");
		}
		
		private function __signalMouseOver(evt:MouseEvent):void
		{
			signal_tip.visible = true;
		}
		
		private function __signalMouseOut(evt:MouseEvent):void
		{
			signal_tip.visible = false;
		}
		
		public function ConsortiaLevelChange(level:int):void
		{
			if(_cIcon)
			{
				_cIcon.consortiaLevel = level;
			}
		}
		
		public function ConsortiaIDChange(id:int):void
		{
			_cIcon.consortiaID = int(id);
			
			if(_info && _info.info && _info.info.IsMarried)
			{
				if(_mIcon)removeChild(_mIcon);
				if(_mIcon)
				{
					_mIcon.dispose();
					_mIcon = new MarryIcon(_info.info);
				}else
				{
					_mIcon = new MarryIcon(_info.info);
				}
				_mIcon.x = _level.x;
				_mIcon.y = _cIcon.y+_cIcon.height+4;
				
				addChild(_mIcon);
				addChild(_chatballview);
				addChild(_face);
			}
			_cIcon.consortiaID = id;
			if(_cIcon.consortiaID==0)
			{
				ConsortiaName_txt.text = "";
			}else
			{
				if(_info!=null && _info.info)
				{
					ConsortiaName_txt.text = _info.info.ConsortiaName;
				}
			}
		}
		
		private function bagStoreOpenHandler(evt:Event):void
		{
			stopPlayerAnimation();
		}
		
		private function bagStoreClosedHandler(evt:Event):void
		{
			playPlayerAnimation();
		}
		
		public function stopPlayerAnimation():void
		{
			if(_player)
			{
				_player.stopAnimation();
			}
			if(_level)
			{
				_level.stop();
			}
		}
		
		public function playPlayerAnimation():void
		{
			if(_player)
			{
				_player.playAnimation();
			}
			if(_level)
			{
				_level.play();
			}
		}
		
		public function ConsortiaReputeChange(repute:int):void
		{
			_cIcon.consortiaRepute = repute;
		}
		
		public function dispose():void
		{
			if(_info&&_info.info)_info.info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__propertyChange);
			if(_info)
			{
				_info.isUpGrade = false;
				_info.removeEventListener(RoomEvent.PLAYER_STATE_CHANGED,__roomInfoChanGed);
			}
			info = null;
			_player = null;
			
			figure_pos.removeEventListener(MouseEvent.CLICK,__figureClick);
			
			btnAddFriend.removeEventListener(MouseEvent.CLICK,__addFriendClick);
			btnClose.removeEventListener(MouseEvent.CLICK,__closeClick);
			btnViewInfo.removeEventListener(MouseEvent.CLICK,__viewClick);
			DisposeUtils.disposeHBaseButton(btnAddFriend);
			DisposeUtils.disposeHBaseButton(btnClose);
			DisposeUtils.disposeHBaseButton(btnViewInfo);
			btnAddFriend = null;
			btnClose = null;
			btnViewInfo = null;
			
			waiting_mc.removeEventListener(MouseEvent.CLICK,__waitingClick);
			bg.removeEventListener(MouseEvent.CLICK,__bgClick);
			
			signal_mc.removeEventListener(MouseEvent.MOUSE_OVER,__signalMouseOver);
			signal_mc.removeEventListener(MouseEvent.MOUSE_OUT,__signalMouseOut);
			
			ChatManager.Instance.model.removeEventListener(ChatEvent.ADD_CHAT,__getChat);
			ChatManager.Instance.removeEventListener(ChatEvent.SHOW_FACE,__getFace);
			
			BagStore.Instance.removeEventListener(BagStore.OPEN_BAGSTORE,bagStoreOpenHandler);
			BagStore.Instance.removeEventListener(BagStore.CLOSE_BAGSTORE,bagStoreClosedHandler);
			
			PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__updateGrade);
			
			if(_level)
				_level.dispose();
			_level = null;
			
			if(_cIcon)
				_cIcon.dispose();
			_cIcon = null;
			
			if(_mIcon&&_mIcon.parent)
			{
				_mIcon.parent.removeChild(_mIcon);
				_mIcon.dispose();
			}
			_mIcon = null;
			
			if(_face)
				_face.dispose();
			_face = null;
			
			if(_grade)
				_grade.dispose();
			_grade = null;
			
//			if(_levelcartoon)
//				_levelcartoon.stop();
//			_levelcartoon = null;
			
			if(_chatballview)
				_chatballview.dispose();
			_chatballview = null;
			
			_controller = null;
			
			if(parent)
				parent.removeChild(this);
		}
	}
}