package ddt.roomlist
{
	import game.crazyTank.view.roomlistII.RoomListIIPlayerItemAsset;
	
	import road.ui.controls.ISelectable;
	import road.utils.ComponentHelper;
	
	import ddt.data.player.PlayerInfo;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.view.common.LevelIcon;

	public class RoomListIIPlayerItem extends RoomListIIPlayerItemAsset implements ISelectable
	{
		private var _info:PlayerInfo;
		
		private var _level:LevelIcon;
		
		public function RoomListIIPlayerItem(info:PlayerInfo)
		{
			_info = info;
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
//			level_mc.gotoAndStop(_info.Grade);
			_level = new LevelIcon("s",_info.Grade,_info.Repute,_info.WinCount,_info.TotalCount,_info.FightPower);
			ComponentHelper.replaceChild(this,level_pos,_level);
			name_txt.text = String(_info.NickName);
			name_txt.selectable = false;
			name_txt.mouseEnabled = false;
			sex_mc.gotoAndStop(_info.Sex ? 1 : 2);
			bg_mc.visible = false;
		}
		
		private function initEvent():void
		{
			_info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,updatePlayerInfo);
		}
		
		private function removeEvent():void
		{
			_info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,updatePlayerInfo);
		}
		
		private function updatePlayerInfo(evt:PlayerPropertyEvent):void
		{
			if(evt.changedProperties["Grade"])
			{
				_level.level = _info.Grade;
			}
		}
		
		public function get id():int
		{
			return _info.ID;
		}
		
		public function get selected():Boolean
		{
			return bg_mc.visible;
		}
		public function set selected(value:Boolean):void
		{
			bg_mc.visible = value;
		}
		
		public function get info():PlayerInfo
		{
			return _info;
		}
		
		public function get Grade():int
		{
			return _info.Grade;
		}
		
		public function get BP():int
		{
			return _info.GP;
		}
		
		public function get Nick():String
		{
			return _info.NickName;
		}
		
		public function dispose():void
		{
			removeEvent();
			
			_info = null;
			
			if(_level)
			{
				_level.dispose();
			}
			_level = null;
			
			if(parent)
				parent.removeChild(this);
		}
	}
}