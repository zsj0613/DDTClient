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
	import ddt.view.common.LevelIcon;

	public class IMBlackItem extends IMFriendItemAsset
	{
		protected var _info:Object;
		protected var _level_icon:LevelIcon;
		protected var _sex_icon:SexIconAsset;
		protected var delete_btn:HTipButton;
//		private   var _personalHomePageBtn : HFrameButton;
	
		public function IMBlackItem(info:Object)
		{
			_info = info;
			super();
			init();
			initEvent();
		}
		
		protected function init():void
		{
			_info.State == 1 ? icon.gotoAndStop(1) : icon.gotoAndStop(2);
			name_txt.text = String(_info.NickName);
			name_txt.mouseEnabled = false;
			
			if(_info is ConsortiaPlayerInfo)
			{
				_level_icon = new LevelIcon("s",_info.info.Grade,_info.info.Repute,_info.info.WinCount,_info.info.TotalCount,_info.info.FightPower);
			}else
			{
				_level_icon = new LevelIcon("s",_info.Grade,_info.Repute,_info.WinCount,_info.TotalCount,_info.FightPower);
			}
			_level_icon.stop();
			_sex_icon = new SexIconAsset();
			ComponentHelper.replaceChild(this,level_pos,_level_icon);
			ComponentHelper.replaceChild(this,sex_pos,_sex_icon);
			_sex_icon.gotoAndStop(_info.Sex ? 1 : 2);
			_sex_icon.mouseEnabled = false;
			
			overbg.visible = false;
			
			delete_btn = new HTipButton(delIcon,"",LanguageMgr.GetTranslation("ddt.view.im.IMFriendItem.delete"));
			delete_btn.useBackgoundPos = true;
			addChild(delete_btn);
		}
		
		
		private function initEvent():void
		{
			delete_btn.addEventListener(MouseEvent.CLICK,__delClick);
		}
		
		private function __openPersonalHomePage(evt : MouseEvent) : void
		{
			evt.stopImmediatePropagation();
			SoundManager.instance.play("008");
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
		public function set selected(b:Boolean):void
		{
			overbg.visible = b;
		}
		
		public function get selected():Boolean
		{
			return overbg.visible;
		}
		
		
		public function get info():Object
		{
			return _info;
		}
		
		private function __delClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			evt.stopImmediatePropagation();
			HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.view.emailII.WritingView.tip"),LanguageMgr.GetTranslation("ddt.view.im.IMBlackItem.sure"),true,deleteFriend,cancelDel);
		}
		
		private function deleteFriend():void
		{
			SoundManager.instance.play("008");
			SocketManager.Instance.out.sendDelFriend(_info.ID);
		}
		
		private function cancelDel():void
		{
			SoundManager.instance.play("008");
		}
		
		public function dispose():void
		{
			if(_level_icon)
				_level_icon.dispose();
			_level_icon = null;
			
			if(_sex_icon && _sex_icon.parent)
				_sex_icon.parent.removeChild(_sex_icon);
			_sex_icon = null;
			
			if(delete_btn)
			{
				delete_btn.removeEventListener(MouseEvent.CLICK,__delClick);
				delete_btn.dispose();
			}
			delete_btn = null;
			
//			if(_personalHomePageBtn)
//			{
//				_personalHomePageBtn.removeEventListener(MouseEvent.CLICK,    __openPersonalHomePage);
//				_personalHomePageBtn.dispose();
//			}
//			_personalHomePageBtn = null;
			
			_info = null;
		}
		
	}
}