package ddt.menu
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.System;
	import flash.text.TextFormat;
	
	import road.BitmapUtil.ScaleBitmap;
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.controls.hframe.bitmap.BlackFrameBG;
	import road.ui.manager.TipManager;
	
	import ddt.data.ConsortiaDutyType;
	import ddt.data.player.PlayerInfo;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.manager.ChatManager;
	import ddt.manager.ConsortiaDutyManager;
	import ddt.manager.EffortManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PathManager;
	import ddt.manager.PersonalInfoManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;
	import ddt.view.im.IMController;
	import ddt.view.im.IMFriendPhotoCell;
	import tank.menu.RightMenuAsset;
	import tank.menu.*;

	public class RightMenuPanel extends RightMenuAsset
	{
		private var _info:PlayerInfo;
		
		private var btnPrivateChat:SubMenuItem;
		private var btnViewInfo:SubMenuItem;
		private var btnAddFriend:SubMenuItem;
		
		private var btnPropose:HBaseButton;
		
		private var btnCopyName:SubMenuItem;
		private var btnAddBlack:SubMenuItem;
		private var btnLookEffort:SubMenuItem;
		
		private var btnUp:HBaseButton;
		private var btnDown:HBaseButton;
		private var btnFire:HBaseButton;
		private var btnInvite:HBaseButton;
		
		private var _bg:ScaleBitmap;
		private var _photo : IMFriendPhotoCell;
		private var _photoBtn : HBaseButton;
		//挑战
		private var _BtnChallenge:HBaseButton;
		public static const CHALLENGE:String = "challenge";
		private var icon:iconAsset;
		private var _minusY:Number;

		public function get minusY():Number
		{
			return _minusY;
		}

		public function set minusY(value:Number):void
		{
			_minusY = value;
		}
		
		
		public function RightMenuPanel()
		{
			_bg = new BlackFrameBG();
			_bg.y = -21;
			_bg.width = 183;
			_bg.height = 265;
			addChildAt(_bg,0);
			icon = new iconAsset();
			tbxName.mouseEnabled = false;;
			tbxClubName.mouseEnabled = false;
			tbxGongXun.mouseEnabled = false;
			tbxLevel.mouseEnabled = false;
			
			tbxWin.mouseEnabled = false;
			tbxLost.mouseEnabled = false;
			tbxWinRate.mouseEnabled = false;
			tbxTotal.mouseEnabled = false;
			FightPower_txt.mouseEnabled =false;
			var startPos:Number = 120;
			
			btnLookEffort = new SubMenuItem("",icon.lookEffort_mc);
			btnLookEffort.x = 5;
			btnLookEffort.y = startPos;
			startPos+=22;
			btnLookEffort.enable = false;
			btnLookEffort.addEventListener(MenuEvent.CLICK,__menuClick);
			addChild(btnLookEffort);
			
			btnAddFriend = new SubMenuItem("",icon.friend_mc);
			btnAddFriend.x = 5;
			btnAddFriend.y = startPos;
			startPos+=22;
			btnAddFriend.addEventListener(MenuEvent.CLICK,__menuClick);
			addChild(btnAddFriend);
			
			btnPrivateChat = new SubMenuItem("",icon.chat_mc);
			btnPrivateChat.x = 5;
			btnPrivateChat.y = startPos;
			startPos+=22;
			btnPrivateChat.addEventListener(MenuEvent.CLICK,__menuClick);
			addChild(btnPrivateChat);
			
			btnCopyName = new SubMenuItem("",icon.copy_mc);
			btnCopyName.x = 5;
			btnCopyName.y = startPos;
			startPos+=22;
			btnCopyName.addEventListener(MenuEvent.CLICK,__menuClick);
			addChild(btnCopyName);
			
			btnViewInfo = new SubMenuItem("",icon.look_mc);
			btnViewInfo.x = 5;
			btnViewInfo.y = startPos;
			startPos+=22;
			btnViewInfo.addEventListener(MenuEvent.CLICK,__menuClick);
			addChild(btnViewInfo);
			
			btnAddBlack = new SubMenuItem("",icon.black_mc);
			btnAddBlack.x = 5;
			btnAddBlack.y = startPos;
			startPos+=24;
			btnAddBlack.enable = false;
			btnAddBlack.addEventListener(MenuEvent.CLICK,__menuClick);
			addChild(btnAddBlack);
			
			btnPropose = new HBaseButton(proposeBtnAsset);
			btnPropose.useBackgoundPos = true;
			btnPropose.addEventListener(MouseEvent.CLICK,__buttonsClick);
			addChild(btnPropose);
			
			_BtnChallenge = new HBaseButton(challenge_mc);
			_BtnChallenge.useBackgoundPos = true;
			_BtnChallenge.addEventListener(MouseEvent.CLICK,__BtnChallengeClick);
			_BtnChallenge.visible=false;
			addChild(_BtnChallenge);

			
			
//			btnPropose = new SubMenuItem("向其求婚");
//			btnPropose.x = 9;
//			btnPropose.y = startPos;
//			startPos+=18;
//			btnPropose.addEventListener(MenuEvent.CLICK,__menuClick);
//			addChild(btnPropose);
			
			////////////////////////////////底部按钮////////////////////////////////////////
			mc_bg2.y = startPos - 5;
			
			btnUp = new HBaseButton(mc_bg2.mc_up,LanguageMgr.GetTranslation("ddt.menu.Up"));
			btnUp.textField.textColor = 0xffffff;
			btnUp.addEventListener(MouseEvent.CLICK,__buttonsClick);
			btnUp.useBackgoundPos = true;
			mc_bg2.addChild(btnUp);
			
			btnDown = new HBaseButton(mc_bg2.mc_down,LanguageMgr.GetTranslation("ddt.menu.Down"));
			btnDown.textField.textColor = 0xffffff;
			btnDown.addEventListener(MouseEvent.CLICK,__buttonsClick);
			btnDown.useBackgoundPos = true;
			mc_bg2.addChild(btnDown);
		
			btnInvite = new HBaseButton(mc_bg2.mc_invite,LanguageMgr.GetTranslation("ddt.menu.Invite"));
			btnInvite.textField.textColor = 0xffffff;
			btnInvite.addEventListener(MouseEvent.CLICK,__buttonsClick);
			btnInvite.useBackgoundPos = true;
			mc_bg2.addChild(btnInvite);
		
		//	btnFire = new HBaseButton(mc_bg2.mc_chat,LanguageMgr.GetTranslation("ddt.menu.fire"));
		//	btnFire.textField.textColor = 0xffffff;
		//	btnFire.addEventListener(MouseEvent.CLICK,__buttonsClick);
		//	btnFire.useBackgoundPos = true;
		//	mc_bg2.addChild(btnFire);
		//	btnFire.enable = false;
			
			graphics.beginFill(0,0);
			graphics.drawRect(-3000,-3000,6000,6000);
			graphics.endFill();
			addEventListener(MouseEvent.CLICK,__mouseClick);
			
			if(PlayerManager.isShowPHP)
			{
				_photo = new IMFriendPhotoCell();
				_photo.x = cell.x;
				_photo.y = cell.y ;
				addChild(_photo);
				if(PathManager.checkOpenPHP())
				{
					_photoBtn = new HBaseButton(_photo);
					_photoBtn.useBackgoundPos = true;
					addChild(_photoBtn);
					_photoBtn.addEventListener(MouseEvent.CLICK,  __openPersonalHomePage);
				}
				
			}
			cell.visible = false;
//			ComponentHelper.replaceChild(this,this.cell,_photo);
//			_photo.buttonMode = true;
			
			
			
			
		}
		
		private function __openPersonalHomePage(evt : MouseEvent) : void
		{
			evt.stopImmediatePropagation();
			SoundManager.Instance.play("008");
			var loginName : String 
			if(_info){
				loginName = _info.LoginName;
				var url : String = PathManager.solveLoginPHP(loginName);
				if(PathManager.checkOpenPHP())navigateToURL(new URLRequest(url),"_blank");
			}
		}
		public function set playerInfo(value:PlayerInfo):void
		{
//			if(_info == value) return;
			if(_info)
			{
				_info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__onPopChange);
			}
			_info = value;
			_info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__onPopChange);
			
			update();
		}
		
		public function update():void
		{
			if(_info)
			{
				tbxName.text = _info.NickName;
				tbxClubName.text = LanguageMgr.GetTranslation("ddt.menu.ClubName",(_info.ConsortiaName ? _info.ConsortiaName : ""));
				tbxGongXun.text = LanguageMgr.GetTranslation("ddt.menu.GongXun",_info.Offer);
				tbxLevel.text = LanguageMgr.GetTranslation("ddt.menu.Level",_info.Grade);
				
				tbxWin.text = LanguageMgr.GetTranslation("ddt.menu.WinCount",_info.WinCount);
				tbxLost.text = LanguageMgr.GetTranslation("ddt.menu.LostCount",_info.TotalCount - _info.WinCount);
				var rate:Number = _info.TotalCount > 0 ? (_info.WinCount / _info.TotalCount) * 100 : 0;
				tbxWinRate.text = LanguageMgr.GetTranslation("ddt.menu.Winrate",rate.toFixed(2)) + "%";
				tbxTotal.text = LanguageMgr.GetTranslation("ddt.menu.TotalCount",_info.TotalCount);
				FightPower_txt.text = LanguageMgr.GetTranslation("ddt.menu.FightPower",_info.FightPower);
			}
			else
			{
				tbxName.text = "";
				tbxClubName.text = "";
				tbxGongXun.text = "";
				tbxLevel.text = "";
				
				tbxWin.text = "";
				tbxLost.text = "";
				tbxWinRate.text = "";
				tbxTotal.text = "";
				FightPower_txt.text = ""
			}
			
			if(_info && (_info.DutyLevel > PlayerManager.Instance.Self.DutyLevel) && (_info.ID != PlayerManager.Instance.Self.ID))
			{
				if(_info.ConsortiaID != 0 && _info.ConsortiaID == PlayerManager.Instance.Self.ConsortiaID)
				{
					//btnFire.visible = ConsortiaDutyManager.GetRight(PlayerManager.Instance.Self.Right,ConsortiaDutyType._6_Expel);
					//btnFire.enable = true;
			
					
					btnUp.visible = ConsortiaDutyManager.GetRight(PlayerManager.Instance.Self.Right,ConsortiaDutyType._12_UpGrade);
					btnUp.enable = _info.DutyLevel != 2;
				
					btnDown.visible = ConsortiaDutyManager.GetRight(PlayerManager.Instance.Self.Right,ConsortiaDutyType._12_UpGrade);
					btnDown.enable = _info.DutyLevel != 5;
					btnInvite.visible = false;
				}else
				{
					//btnFire.visible = false;
					btnInvite.visible = false;
					btnDown.visible = false;
					
				}

				mc_bg2.visible = btnInvite.visible || btnUp.visible || btnDown.visible;
			}
			else
			{
				
				//btnFire.visible = false;
				btnInvite.visible = false;
				btnDown.visible = false;
				btnUp.visible = false;
				mc_bg2.visible = false;
				if(_info.ConsortiaID == 0 && PlayerManager.Instance.Self.ConsortiaID != 0 && _info.ConsortiaName == "" && _info.ID != PlayerManager.Instance.Self.ID)
				{
					btnInvite.visible = ConsortiaDutyManager.GetRight(PlayerManager.Instance.Self.Right,ConsortiaDutyType._2_Invite) && _info.ConsortiaID == 0;
					mc_bg2.visible = btnInvite.visible;
				}
			}
			if(_photo)
			{
				_photo.clearSprite();
				_photo.playerLoginName = String(_info.LoginName);
			}
		}
		
		private function __onPopChange(e:PlayerPropertyEvent):void
		{
			if(e.changedProperties["DutyLevel"])
			{
				btnUp.enable = _info.DutyLevel != 2;
				btnDown.enable = _info.DutyLevel != 5;
				//btnFire.enable = ConsortiaDutyManager.GetRight(PlayerManager.Instance.Self.Right,ConsortiaDutyType._6_Expel);
			}
		}
		
		private function __mouseClick(event:Event):void
		{
			SoundManager.Instance.play("008");
			hide();
		}
		
		private function __menuClick(event:MenuEvent):void
		{
			if(_info)
			{
				switch(event.currentTarget)
				{
					case btnPrivateChat:
						ChatManager.Instance.privateChatTo(_info.NickName,_info.ID);
						break;
					case btnViewInfo:
						PersonalInfoManager.instance.addPersonalInfo(_info.ID,PlayerManager.Instance.Self.ZoneID);
						break;
					case btnAddFriend:
						IMController.Instance.addFriend(_info.NickName);
						break;
					case btnCopyName:
						System.setClipboard(_info.NickName);
						break;
					case btnAddBlack:
						IMController.Instance.addBlackList(_info.NickName);
						break;
					case btnLookEffort:
						EffortManager.Instance.lookUpEffort(_info.ID);
						break;
				}
			}
		}
		
		private function __sendBandChat(e:MouseEvent):void
		{
			SocketManager.Instance.out.sendForbidSpeak(_info.ID,true);
		}
		private function __sendNoBandChat(e:MouseEvent):void
		{
			SocketManager.Instance.out.sendForbidSpeak(_info.ID,false);
		}
		
		private function __buttonsClick(event:MouseEvent):void
		{
			if(_info)
			{
				switch(event.currentTarget)
				{
					case btnUp:
						if(PlayerManager.Instance.Self.bagLocked)
						{
							new BagLockedGetFrame().show();
							return;
						}
					SocketManager.Instance.out.sendConsortiaMemberGrade(_info.ID,true);
						break;
					case btnDown:
						if(PlayerManager.Instance.Self.bagLocked)
						{
							new BagLockedGetFrame().show();
							return;
						}
					SocketManager.Instance.out.sendConsortiaMemberGrade(_info.ID,false);
						break;
					case btnFire:
						if(PlayerManager.Instance.Self.bagLocked)
						{
							new BagLockedGetFrame().show();
							return;
						}
						HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.DeleteMemberFrame.titleText"),LanguageMgr.GetTranslation("ddt.menu.fireConfirm") + "“" +_info.NickName + "”?",true,ok);
						break;
					case btnInvite:
					SocketManager.Instance.out.sendConsortiaInvate(_info.NickName);
						break;
					case btnPropose:
						//求婚
						if(PlayerManager.Instance.Self.bagLocked)
						{
							new BagLockedGetFrame().show();
							return;
						}
						PlayerManager.Instance.sendValidateMarry(_info);
						break;
				}
			}
		}
		
		private function ok():void {
			SocketManager.Instance.out.sendConsortiaOut(_info.ID);
		}
		
		private function __BtnChallengeClick(evt:MouseEvent):void
		{
			dispatchEvent(new Event(CHALLENGE));
		}
		
		public function show():void
		{
			TipManager.AddTippanel(this);
			if(stage && parent)
			{
				var pos:Point = parent.globalToLocal(new Point(stage.mouseX,stage.mouseY - 18));
				this.x = pos.x - 182;
				if(mc_bg2.visible)
				{
					this.y = pos.y - 240 - 14 - 40;
				}else
				{
					this.y = pos.y - 240 - 14;
				}
				if(x < 10)
				{
					this.x = 10;
				}
				if(y < 20)
				{
					y = 70;
				}
			}
		}
		
		public function setSelfDisable(b:Boolean):void
		{
			if(b)
			{
				btnPrivateChat.enable = false;
				btnAddBlack.enable = false;
				btnAddFriend.enable = false;
				btnPropose.enable = false;
				_BtnChallenge.enable = false;
				btnLookEffort.enable = false;
			}else
			{
				btnPrivateChat.enable = true;
				btnAddBlack.enable = true;
				btnAddFriend.enable = true;
				btnPropose.enable = true;
				_BtnChallenge.enable = true;
				btnLookEffort.enable = true;
			}
		}
		public function proposeEnable(b : Boolean) : void
		{
			btnPropose.enable = b;
		}
		private var _chanllageEnable:Boolean = false;
		public function set chanllengeEnable(value:Boolean):void
		{
			_chanllageEnable = value;
			_BtnChallenge.visible = _chanllageEnable;
		}
		
		public function setPos(x:int , y:int):void
		{
			this.x  = x;
			this.y  = y;
		}
		
		public function get chanllengeEnable():Boolean
		{
			return _chanllageEnable;
		}
		
		public function get info():PlayerInfo
		{
			return _info;
		}
		
		public function hide():void
		{
			if(parent)
			{
				parent.removeChild(this);
			}
		}
	}
}