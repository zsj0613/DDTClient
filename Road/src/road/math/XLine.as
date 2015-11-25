package road.math
{
	import flash.geom.Point;
	import flash.utils.setInterval;
	
	public class XLine
	{
		public function XLine(...arg)
		{
			line = arg;
		}
		
		protected var list:Array;
		
		protected var fix:Boolean = true;
		
		protected var fixValue:Number = 1;
		
		public function set line(value:Array):void
		{
			list = value;
			if(list == null || list.length == 0)
			{
				fix = true;
				fixValue = 1;
			}
			else if(list.length == 1)
			{
				fix = true;
				fixValue = list[0].y;
			}
			else if(list.length == 2 && list[0].y == list[1].y)
			{
				fix = true;
				fixValue = list[0].y;
			}
			else
			{
				fix = false;
			}
		}
		
		public function get line():Array
		{
			return list;
		}
		
		public function interpolate(x:Number):Number
		{
			if(!fix)
			{
				var p1:Point;
				var p2:Point;
				for(var i:int = 1; i < list.length;i ++)
				{
					p2 = list[i];
					p1 = list[i -1];
					if(p2.x > x)
					{
						break;
					}
				}
				return interpolatePointByX(p1,p2,x);
			}
			else
			{
				return fixValue;
			}
		}
		
		public static function ToString(value:Array):String
		{
			var rlt:String = "";
			try
			{			
				for each(var p:Point in value)
				{
					rlt += p.x+":"+p.y+",";
				}
			}
			catch(e:Error){}
			return rlt;
		}
		
		public static function parse(str:String):Array
		{
			var list:Array = new Array();
			try
			{
				var temp:Array = str.match(/([-]?\d+[\.]?\d*)/g);
				var nums:Array = new Array();
				for(var i:int = 0; i < temp.length; i +=2)
				{
					list.push(new Point(Number(temp[i]),Number(temp[i+1])));
				}			
			}
			catch(e:Error){}
			return list;	
		}

	}
}