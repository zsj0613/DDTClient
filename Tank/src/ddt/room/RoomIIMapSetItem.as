package ddt.room
{
	import flash.display.DisplayObject;
	
	import road.ui.controls.PictureBox;
	
	import ddt.game.map.MapBigIcon;

	public class RoomIIMapSetItem extends PictureBox
	{
		private var _pic:MapBigIcon;
		
		public function RoomIIMapSetItem()
		{
			super();
		}
		
		public function setPic(pic:MapBigIcon):void
		{
			if(_pic != null)
			{
				removeItem(_pic);
			}
			_pic = pic;
			if(_pic)
			{
				
				pic.width = 221;
				pic.height = 90;
				appendItem(pic);
			}
		}
		
		public function dispose ():void
		{
			if(_pic)
			{
				_pic.dispose();
				_pic = null;
			}
		}
			
	}
}