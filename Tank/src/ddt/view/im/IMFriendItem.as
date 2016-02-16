package ddt.view.im
{
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import game.crazyTank.view.common.SexIconAsset;
	import game.crazyTank.view.im.IMFriendItemAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HFrameButton;
	import road.ui.controls.HButton.HTipButton;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.utils.ComponentHelper;
	
	import ddt.data.player.ConsortiaPlayerInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.utils.DisposeUtils;
	import ddt.view.common.LevelIcon;

	public class IMFriendItem extends IMFriendItemAsset
	{
		protected var _info:Object;
		protected var _level_icon:LevelIcon;
		protected var _sex_icon:SexIconAsset;
		protected var delete_btn:HTipButton;
		private   var _personalHomePageBtn : HFrameButton;
		private   var _isShowlevelIcon:Boolean;
		private   var _selected:Boolean;
		public function IMFriendItem(info:Object , isShowlevelIcon:Boolean = true)
		{
			_info = info;
			_isShowlevelIcon = isShowlevelIcon;
			super();
			init();
			initEvent();
		}
		
		protected function init():void
		{
			//this.buttonMode = true;
			_info.State == 1 ? icon.gotoAndStop(1) : icon.gotoAndStop(2);
			name_txt.text = String(_info.NickName);
			name_txt.mouseEnabled = false;
			_selected = false;
			overbg.gotoAndStop(1);
			
			if(_isShowlevelIcon)
			{
	 			if(_info is ConsortiaPlayerInfo)
				{
					_level_icon = new LevelIcon("s",_info.info.Grade,_info.info.Repute,_info.info.WinCount,_info.info.TotalCount,_info.info.FightPower);
				}
				else
				{
					_level_icon = new LevelIcon("s",_info.Grade,_info.Repute,_info.WinCount,_info.TotalCount,_info.FightPower);
				}
				_level_icon.stop();
			}
//			dutyName_txt.visible = true;
//			dutyName_txt.mouseEnabled = false;
			_sex_icon = new SexIconAsset();
			if(_isShowlevelIcon)
			{
				ComponentHelper.replaceChild(this,level_pos,_level_icon);
			}
			ComponentHelper.replaceChild(this,sex_pos,_sex_icon);
			_sex_icon.gotoAndStop(_info.Sex ? 1 : 2);
			
			delete_btn = new HTipButton(delIcon,"",LanguageMgr.GetTranslation("ddt.view.im.IMFriendItem.delete"));
			delete_btn.useBackgoundPos = true;
			addChild(delete_btn);
			
//			_personalHomePageBtn = new HFrameButton(PersonalHomePageBtn);
//			_personalHomePageBtn.useBackgoundPos = true;
//			addChild(_personalHomePageBtn);
//			_personalHomePageBtn.visible = (PathManager.checkOpenPHP() && PlayerManager.isShowPHP);
			
		}
		
		
		private function initEvent():void
		{
			addEventListener(MouseEvent.MOUSE_OVER,__mouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,__mouseOut);
			addEventListener(MouseEvent.CLICK,__mouseClick);
			delete_btn.addEventListener(MouseEvent.CLICK,__delClick);
//			_personalHomePageBtn.addEventListener(MouseEvent.CLICK,    __openPersonalHomePage);
		}
		
		private function __mouseOver(evt:MouseEvent):void
		{
			_selected ? overbg.gotoAndStop(3):overbg.gotoAndStop(2);
		}
//		
		private function __mouseOut(evt:MouseEvent):void
		{
			if(!_selected)
			{
				overbg.gotoAndStop(1);
			}
		}
		
		private function __mouseClick(evt:MouseEvent):void
		{
			overbg.gotoAndStop(3);
		}
		
		public function set selected(b:Boolean):void
		{
			_selected = b;
			updateOverbg();
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		private function updateOverbg():void
		{
			_selected ? overbg.gotoAndStop(3):overbg.gotoAndStop(1);
		}
		
		public function get info():Object
		{
			return _info;
		}
		
		private function __delClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			evt.stopImmediatePropagation();
			HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.view.emailII.WritingView.tip"),LanguageMgr.GetTranslation("ddt.view.im.IMFriendItem.deleteFriend"),true,deleteFriend,cancelDel);
		}
		private function __openPersonalHomePage(evt : MouseEvent) : void
		{
			evt.stopImmediatePropagation();
			SoundManager.Instance.play("008");
			var loginName : String;
			if(_info is ConsortiaPlayerInfo)
			{
				loginName = _info.info.LoginName;
			}
			else
			{
				loginName = _info.LoginName;
			}
			navigateToURL(new URLRequest(PathManager.solveLoginPHP(loginName)),"_blank");
		}
		
		private function deleteFriend():void
		{
			if(_info == null)
				return;
			SoundManager.Instance.play("008");
			SocketManager.Instance.out.sendDelFriend(_info.ID);
		}
		
		private function cancelDel():void
		{
			SoundManager.Instance.play("008");
		}
		
		public function dispose():void
		{
			if(delete_btn)
			{
				delete_btn.removeEventListener(MouseEvent.CLICK,__delClick);
				delete_btn.dispose();
			}
			delete_btn = null;
			
//			if(_personalHomePageBtn)
//			{
//				_personalHomePageBtn.removeEventListener(MouseEvent.CLICK,    __openPersonalHomePage);
//				DisposeUtils.disposeHBaseButton(_personalHomePageBtn);
//			}
			_personalHomePageBtn = null;
			
			if(_level_icon)
			{
				_level_icon.dispose();
				if(_level_icon.parent)
					_level_icon.parent.removeChild(_level_icon);
			}
			_level_icon = null;
			
			if(_sex_icon && _sex_icon.parent)
				_sex_icon.parent.removeChild(_sex_icon);
			_sex_icon = null;
			
			_info = null;
		}
		
	}
}