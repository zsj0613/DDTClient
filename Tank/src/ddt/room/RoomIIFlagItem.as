package ddt.room
{
	import game.crazyTank.view.roomII.RoomIIFlagItemAsset;
	
	import ddt.data.player.RoomPlayerInfo;
	import ddt.view.common.LevelIcon;

	public class RoomIIFlagItem extends RoomIIFlagItemAsset
	{
		private var _level:LevelIcon;
		private var _info:RoomPlayerInfo;
		
		public function RoomIIFlagItem()
		{
			super();
			init();
		}
		
		private function init():void
		{
			flag_mc.gotoAndStop(1);
			flag_mc.visible = false;
			nick_txt.text = "";
			
			level_pos.visible = false;
		}
	
		public function set info(value:RoomPlayerInfo):void
		{
			init();			
			_info = value;
			if(_info == null)return;
			_level = new LevelIcon("s",value.info.Grade,_info.info.Repute,_info.info.WinCount,_info.info.TotalCount,_info.info.FightPower);
			_level.x = level_pos.x;
			_level.y = level_pos.y;
			_level.visible = true;
			addChild(_level);
			nick_txt.text = String(value.info.NickName);
			flag_mc.gotoAndStop(value.team);
		}
				
		public function dispose():void
		{
			if(_level)
				_level.dispose();
			_level = null;
			
			_info = null;
			
			if(parent)
				parent.removeChild(this);
		}
	}
}