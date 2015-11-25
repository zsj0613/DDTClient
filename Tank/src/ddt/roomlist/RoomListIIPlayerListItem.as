package ddt.roomlist
{
	import game.crazyTank.view.roomlistII.RoomListIIPlayerItemAsset;
	
	import road.utils.ComponentHelper;
	
	import ddt.data.player.PlayerInfo;
	import ddt.view.common.LevelIcon;

	public class RoomListIIPlayerListItem extends RoomListIIPlayerItemAsset
	{
		private var _info:PlayerInfo;
		
		public function RoomListIIPlayerListItem(info:PlayerInfo)
		{
			_info = info;
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			var lIcon:LevelIcon = new LevelIcon("s",_info.Grade,_info.Repute,_info.WinCount,_info.TotalCount,_info.FightPower);
			ComponentHelper.replaceChild(this,level_pos,lIcon);
//			level.gotoAndStop(_info.Grade);
			name_txt.text = String(_info.NickName);
			sex_mc.gotoAndStop(_info.Sex ? 1 : 2);
		}
		
		private function initEvent():void
		{
//			addEventListener(MouseEvent.CLICK,__itemClick,false,0,true);
		}
		
//		private function __itemClick(evt:MouseEvent):void
//		{
//			if(Manager.Instance.chatView != null)
//			{
//				Manager.Instance.chatView.priateChatTo(_info.ID,_info.NickName);
//			}
//		}
		
		public function get id():int
		{
			return _info.ID;
		}
	}
}