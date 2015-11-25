package phy.maps
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	public class Ground extends Tile
	{
		private var _bound:Rectangle;
		
		public function Ground(bitmapData:BitmapData,digable:Boolean)
		{
			super(bitmapData,digable);
			
			_bound = new Rectangle(0,0,width,height);
		}
		
		public function IsEmpty(x:int,y:int):Boolean
		{
			return GetAlpha(x,y) <= 150;
		}
		
		/**
		 * Check the four edges. 
		 * @param rect
		 * @return 
		 * 
		 */		
		public function IsRectangleEmpty(rect:Rectangle):Boolean
		{
			rect = _bound.intersection(rect);
			if(rect.width == 0 ||rect.height == 0) return true;
			if(!IsXLineEmpty(rect.x,rect.y,rect.width)) return false;
			if(rect.height > 1)
			{
				if(!IsXLineEmpty(rect.x,rect.y + rect.height -1,rect.width)) return false;
				if(!IsYLineEmtpy(rect.x,rect.y +1, rect.height -1)) return false;
				if(rect.width > 1 && !IsYLineEmtpy(rect.x+rect.width -1,rect.y,rect.height -1)) return false;
			}
			return true;
		}
		
		/**
		 * Only check the four corners. 
		 * @param rect
		 * @return 
		 * 
		 */		
		public function IsRectangeEmptyQuick(rect:Rectangle):Boolean
		{
			rect = _bound.intersection(rect);
			if(IsEmpty(rect.right,rect.bottom) && IsEmpty(rect.left,rect.bottom) && IsEmpty(rect.right,rect.top) && IsEmpty(rect.left,rect.top)) return true;
			return false;
		}
		
		public function IsXLineEmpty(x:int,y:int,w:int):Boolean
		{
			x = x < 0 ? 0 : x;
			w = x + w > width ? width - x : w;
			for(var i:int = 0; i < w; i++)
			{
				if(!IsEmpty(x+i,y)) return false;
			}
			return true;
		}
		
		public function IsYLineEmtpy(x:int,y:int,h:int):Boolean
		{
			y = y < 0 ? 0 : y;
			h = y + h > height ? height - y : h;
			for(var i:int = 0; i < h; i ++)
			{
				if(!IsEmpty(x,y + i)) return false;
			}
			return true;
		}
		
	}
}