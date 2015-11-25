package ddt.view.im
{
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.common.SexIconAsset;
	import game.crazyTank.view.im.lookupItemAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HTipButton;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.utils.ComponentHelper;
	
	import ddt.data.CMFriendInfo;
	import ddt.data.player.ConsortiaPlayerInfo;
	import ddt.data.player.PlayerInfo;
	import ddt.manager.ChatManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.SocketManager;

	public class IMLookupItem extends lookupItemAsset
	{ 
		private var _info:Object;
		private var _sex_icon:SexIconAsset;
		private var delete_btn:HTipButton;
		private   var _selected:Boolean;
		public function IMLookupItem(info:Object)
		{
			_info = info;
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			name_txt.text = String(_info.NickName);
			if(name_txt.text == "")
			{
				name_txt.text = _info.OtherName;
			}
			name_txt.mouseEnabled = false;
			
			_sex_icon = new SexIconAsset();
			ComponentHelper.replaceChild(this,sex_pos,_sex_icon);
			if(_info is PlayerInfo)
			{
				_sex_icon.gotoAndStop(_info.Sex ? 1 : 2);
			}else if(_info is CMFriendInfo)
			{
				_sex_icon.gotoAndStop(_info.sex ? 1 : 2);
			}else if(_info is ConsortiaPlayerInfo)
			{
				_sex_icon.gotoAndStop(_info.info.Sex ? 1 : 2);
			}
			_selected = false
			delete_btn = new HTipButton(delIcon,"",LanguageMgr.GetTranslation("ddt.view.im.IMFriendItem.delete"));
			delete_btn.useBackgoundPos = true;
			addChild(delete_btn);
			
			bg.gotoAndStop(2);
		}
		
		private function initEvent():void
		{
			addEventListener(MouseEvent.MOUSE_OVER,__mouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,__mouseOut);
//			addEventListener(MouseEvent.CLICK,__mouseClick);
			delete_btn.addEventListener(MouseEvent.CLICK,__delClick);
			this.doubleClickEnabled = true;
		}
		
		private function __doubleClick(evt:MouseEvent):void
		{
			ChatManager.Instance.privateChatTo(_info.NickName,_info.ID);
		}
		
		private function __mouseOver(evt:MouseEvent):void
		{
			bg.gotoAndStop(1);
		}
		
		private function __mouseOut(evt:MouseEvent):void
		{
			if(!_selected)
			bg.gotoAndStop(2);
		}
		
		private function __delClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			if(_info is CMFriendInfo)
			{
				MessageTipManager.getInstance().show("不能删除社区好友");
				return;
			}
			if(_info is ConsortiaPlayerInfo)
			{
				MessageTipManager.getInstance().show("不能删除公会好友");
				return;
			}
			evt.stopImmediatePropagation();
			HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.view.emailII.WritingView.tip"),LanguageMgr.GetTranslation("ddt.view.im.IMFriendItem.deleteFriend"),true,deleteFriend,cancelDel);
		}
		
		private function deleteFriend():void
		{
			if(_info == null)
				return;
			SoundManager.instance.play("008");
			SocketManager.Instance.out.sendDelFriend(_info.ID);
		}
		
		public function get info():Object
		{
			return _info;
		}
		
		public function set selected(b:Boolean):void
		{
			_selected = b;
			updateOverbg();
		}
		
		private function updateOverbg():void
		{
			_selected ? bg.gotoAndStop(1):bg.gotoAndStop(2);
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		private function cancelDel():void
		{
			SoundManager.instance.play("008");
		}
		
		public function dispose():void
		{
			if(delete_btn)
			{
				delete_btn.removeEventListener(MouseEvent.CLICK,__delClick);
				delete_btn.dispose();
			}
			delete_btn = null;
			
			if(_sex_icon && _sex_icon.parent)
				_sex_icon.parent.removeChild(_sex_icon);
			_sex_icon = null;
			
			_info = null;
		}
	}
}