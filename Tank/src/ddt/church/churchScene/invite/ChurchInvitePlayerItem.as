package ddt.church.churchScene.invite
{
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.common.SexIconAsset;
	import game.crazyTank.view.invite.InviteItemBgAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.utils.ComponentHelper;
	
	import ddt.data.ChurchRoomInfo;
	import ddt.data.player.ConsortiaPlayerInfo;
	import ddt.manager.ChurchRoomManager;
	import ddt.manager.SocketManager;
	import ddt.utils.DisposeUtils;
	import ddt.view.common.LevelIcon;

	public class ChurchInvitePlayerItem extends InviteItemBgAsset
	{
		private var _level_icon:LevelIcon;
		private var _sex_icon:SexIconAsset;
		private var _info:Object;
		private var invite_btn:HBaseButton;
		
		public function ChurchInvitePlayerItem(info:Object)
		{
			_info = info;
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			if(_info is ConsortiaPlayerInfo)
			{
				_level_icon = new LevelIcon("s",_info.info.Grade,_info.info.Repute,_info.info.WinCount,_info.info.TotalCount,_info.info.FightPower);
			}else
			{
				_level_icon = new LevelIcon("s",_info.Grade,_info.Repute,_info.WinCount,_info.TotalCount,_info.FightPower);
			}
			
			ComponentHelper.replaceChild(this,level_pos,_level_icon);
			_sex_icon = new SexIconAsset();
			_sex_icon.gotoAndStop(_info.Sex ? 1 : 2);
			ComponentHelper.replaceChild(this,sex_pos,_sex_icon);
			
			name_txt.text = String(_info.NickName);
			hadinvite_mc.visible = false;
			invite_btn = new HBaseButton(inventBtnAccect);
			invite_btn.useBackgoundPos = true;
			addChild(invite_btn);
		}
		
		private function initEvent():void
		{
			invite_btn.addEventListener(MouseEvent.CLICK,__mouseClick);
		}
	
		private function __mouseClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			var roominfo:ChurchRoomInfo = ChurchRoomManager.instance.currentRoom;

			if(_info is ConsortiaPlayerInfo)
			{
				SocketManager.Instance.out.sendChurchInvite(_info.info.ID);
			}else
			{
				SocketManager.Instance.out.sendChurchInvite(_info.ID);
			}
			
			hadinvite_mc.visible = true;
			invite_btn.visible = false;
		}
		
		public function dispose():void
		{
			invite_btn.removeEventListener(MouseEvent.CLICK,__mouseClick);
			if(_level_icon && _level_icon.parent)_level_icon.parent.removeChild(_level_icon);
			if(_level_icon)_level_icon.dispose();
			_level_icon = null;
			DisposeUtils.disposeDisplayObject(_sex_icon);
			DisposeUtils.disposeHBaseButton(invite_btn);
			if(parent)parent.removeChild(this);
			
		}
	}
}