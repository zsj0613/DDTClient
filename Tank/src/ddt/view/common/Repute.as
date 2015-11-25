package ddt.view.common
{
	import game.crazyTank.view.common.ReputeAsset;
	
	import ddt.manager.LanguageMgr;

	public class Repute extends ReputeAsset
	{
		private var _repute:int;
		private var _level:int;
		
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		private var _align:String = RIGHT;
		public function Repute(re:int,level:int)
		{
			_repute = re;
			_level = level;
			super();
			init();
		}
		
		private function init():void
		{
			setRepute(_repute);
		}
		public function set level($level : int) : void
		{
			this._level = $level;
		}
		
		public function setRepute(re:int):void
		{
			_repute = re;
			repute_txt.text = (_level <= 3 || re > 9999999 || re == 0) ? LanguageMgr.GetTranslation("ddt.room.RoomIIPlayerItem.new") : String(re);
			repute_txt.width = repute_txt.textWidth + 3;
			if(_align == LEFT)
			{
				icon.x = 0;
				repute_txt.x =  icon.x + 50;
			}else{
				repute_txt.x =  -repute_txt.textWidth;
				icon.x = repute_txt.x - 50;//icon.width;
			}
			
		}
		public function set align ($align:String):void
		{
			_align = $align;
			if($align == LEFT)
			{
				icon.x = 0;
				repute_txt.x =  icon.x + 50;
			}else{
				repute_txt.x =  -repute_txt.textWidth;
				icon.x = repute_txt.x -50;// icon.width;
			}
		}
		
		public function dispose():void
		{
			if(parent)
			{
				parent.removeChild(this);
			}
		}
	}
}