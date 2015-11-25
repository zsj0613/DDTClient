package ddt.room
{
	import flash.display.Sprite;
	
	public class DuplicateDropList extends Sprite
	{
		private var _CellHeight:int;
		private var _CellWidth:int;
		private var _ListHeight:int;
		private var _ListWidth:int;
		private var _CellList:Array;
		private var _space:int;
		public function DuplicateDropList(CellList:Array)
		{
			_CellList = CellList;
			init();
		}
		
		private function init():void
		{
			_CellHeight = _CellList[1].height;
			_CellWidth = _CellList[1].width;
			_ListWidth = _CellWidth*5;
			if(_CellList.length%5==0)
			_ListHeight = (_CellHeight*_CellList.length/5);
			else
			_ListHeight =  _CellHeight*((int)(_CellList.length/5)+1);
			for(var i:int=0 ; i<_CellList.length ;i++)
			{
				addChild(_CellList[i]);
				if(i!=0 && i%5!=0)
				{
					_CellList[i].x = _CellList[i-1].x + _CellList[1].width;
				}
				if(i!=0 && i%5==0)
				{
					_CellList[i].y = _CellList[i-1].y + _CellList[1].height;
					_CellList[i].x = this.x;
				}
			}
		}
		
		public function get ListHeight():int
		{
			return _ListHeight;
		}
		
		public function get ListWidth():int
		{
			return _ListWidth;
		}
		
		public function get CellHeight():int
		{
			return _CellHeight;
		}
		
		public function get CellWidth():int
		{
			return _CellWidth;
		}
	}
}