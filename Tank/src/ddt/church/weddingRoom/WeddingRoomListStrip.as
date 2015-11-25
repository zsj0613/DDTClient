package ddt.church.weddingRoom
{
	import road.ui.controls.ISelectable;
	
	import tank.church.RoomStripAsset;
	import ddt.data.ChurchRoomInfo;
	
	public class WeddingRoomListStrip extends RoomStripAsset implements ISelectable
	{
		private var _selected:Boolean;
		private var _info:ChurchRoomInfo;
		
		public function get info():ChurchRoomInfo
		{
			return _info;
		}
		
		public function WeddingRoomListStrip(info:ChurchRoomInfo)
		{
			this._info = info;
			init();
		}
		
		private function init():void
		{
			this.mouseChildren = false;
			this.selected = false;
			this.buttonMode = true;
			
			update();
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		public function set selected(value:Boolean):void
		{
			if(_selected == value)return;
			_selected = value;
			update();
		}
		
		private function update():void
		{
			if(_info)
			{
				id_txt.text = String(_info.id);
				name_txt.text  = _info.roomName;
				name_txt.x = _info.isLocked?lock_mc.x+20:lock_mc.x;
				lock_mc.visible = _info.isLocked;
				
				if(_info.status == ChurchRoomInfo.WEDDING_ING&&_info.currentNum<2)
				{
					num_txt.text = "2/100";
				}else
				{
					num_txt.text = String(_info.currentNum)+"/100";
				}
				
				if(_info.currentNum >= 100 || _info.status == ChurchRoomInfo.WEDDING_ING)
				{
					bg_mc.gotoAndStop(1);
				}else
				{
					bg_mc.gotoAndStop(2);
				}
			}
		}
	}
}