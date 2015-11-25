package road.math
{
	import flash.geom.Point;
	
	public class ColorLine extends XLine
	{
		override public function interpolate(x:Number):Number
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
				return interpolateColors(p1.y,p2.y,1 - (x - p1.x)/(p2.x - p1.x));
			}
			else
			{
				return fixValue;
			}
		}
		
	}
}