package ddt.data
{
	public class DungeonInfo
	{
		public function DungeonInfo()
		{
		}
		public var ID:int;
		public var Description:String;
		/**
		 *掉落表，一大堆TempleteID 
		 */		
//		public var TemplateIds:String;
		public var SimpleTemplateIds : String;//简单掉落
		public var NormalTemplateIds : String;
		public var HardTemplateIds   : String;
		public var TerrorTemplateIds : String;//噩梦掉落
		public var Pic:String;
		public var Name:String;
		public var AdviceTips:String;
		private var _levelLimits : int;
		public function set LevelLimits(i : int) : void
		{
			_levelLimits = i;
		}
		public function get LevelLimits() : int
		{
			return _levelLimits;
		}
		
		
		private var _isOpen : Boolean = true;
		public function get isOpen() : Boolean
		{
			return true;
		}
		public function set isOpen( b : Boolean) : void
		{
			_isOpen = b;
		}
		/**
		 *标识是那种房间的地图 
		 */		
		 /**
		 * 房间类型，自由 1 撮合 0 ，2夺宝，3 BOSS战，4探险
		 */	
		public var Type:int;
	}
}