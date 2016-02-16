package ddt.invite
{
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.common.SexIconAsset;
	import game.crazyTank.view.invite.InviteItemBgAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.utils.ComponentHelper;
	
	import ddt.data.RoomInfo;
	import ddt.data.player.ConsortiaPlayerInfo;
	import ddt.manager.GameManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.RoomManager;
	import ddt.socket.GameInSocketOut;
	import ddt.view.common.LevelIcon;

	public class InvitePlayerItem extends InviteItemBgAsset
	{
		private var _level_icon:LevelIcon;
		private var _sex_icon:SexIconAsset;
		private var _info:Object;
		private var invite_btn:HBaseButton;
		
		public function InvitePlayerItem(info:Object)
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
			}
			else
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
			var roominfo:RoomInfo = RoomManager.Instance.current;
			if(_info is ConsortiaPlayerInfo && roominfo.roomType < 2)
			{
				
				if(_info.info.Grade < 4)
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.invite.InvitePlayerItem.cannot"));
					return;
				}
			}else if(_info.Grade < 4 && roominfo.roomType < 2)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.invite.InvitePlayerItem.cannot"));
				return;
				
			}
			
//			SocketManager.Instance.out.sendInviteGame(_info.ID);

			
			if(_info is ConsortiaPlayerInfo)
			{
				if(checkLevel(_info.info.Grade))GameInSocketOut.sendInviteGame(_info.info.ID);
			}else
			{
				if(checkLevel(_info.Grade))GameInSocketOut.sendInviteGame(_info.ID);
			}
			hadinvite_mc.visible = true;
			invite_btn.visible = false;
		}
		private function checkLevel(level : int) : Boolean
		{
			var roominfo:RoomInfo = RoomManager.Instance.current;
			if(roominfo.roomType > 2)
			{
				if(level < GameManager.MinLevelDuplicate)
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.PlayerManager.gradeLow",GameManager.MinLevelDuplicate));
					return false;
				}
			}
			else if(roominfo.roomType == 2)
			{
				if((roominfo.levelLimits-1)*10 > level)
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.invite.InvitePlayerItem.levelInadequate"));
					return false;
				}
			}
			return true;
		}
		
		public function dispose():void
		{
			if(_level_icon)
				_level_icon.dispose();
			_level_icon = null;
			
			if(_sex_icon && _sex_icon.parent)
				_sex_icon.parent.removeChild(_sex_icon);
			_sex_icon = null;
			
			if(invite_btn)
			{
				invite_btn.removeEventListener(MouseEvent.CLICK,__mouseClick);
				invite_btn.dispose();
			}
			invite_btn = null;
			
			_info = null;
			
			if(parent)parent.removeChild(this);
		}
	}
}