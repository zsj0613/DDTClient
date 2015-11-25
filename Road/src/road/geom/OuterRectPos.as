package road.geom
{
	import flash.geom.Point;

	public class OuterRectPos
	{
		private var _posX:int;
		private var _posY:int;
		private var _lockDirection:int;
		public function OuterRectPos(posX:int,posY:int,lockDirection:int)
		{
			_posX = posX;
			_posY = posY;
			_lockDirection = lockDirection;
		}
		
		public function getPos(sourceW:int,sourceH:int,outerW:int,outerH:int):Point
		{
			var result:Point = new Point();
			if(_lockDirection == LockDirectionTypes.LOCK_T)
			{
				result.x = (outerW - sourceW)/2+_posX;
				result.y = _posY;
			}else if(_lockDirection == LockDirectionTypes.LOCK_TL)
			{
				result.x = _posX;
				result.y = _posY;
				
			}else if(_lockDirection == LockDirectionTypes.LOCK_TR)
			{
				
			}
			
			return result;
		}
	}
}