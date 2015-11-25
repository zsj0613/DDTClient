package road.geom
{
	import flash.geom.Rectangle;
	/**
	 * 一个根据外部的宽高来确定内部矩形宽高的类
	 * 
	 * @author Herman
	 * 
	 */	
	public class InnerRectangle
	{
		
		/**
		 * 
		 * @param leftGape 左边间距
		 * @param rightGape 右边间距
		 * @param topGape   上面间距
		 * @param bottomGape 下面间距
		 * @param lockDirection 锁定的方向。
		 * 
		 * 
		 */		
		public function InnerRectangle(leftGape:int,rightGape:int,topGape:int,bottomGape:int,lockDirection:int = 0)
		{
			this.leftGape = leftGape;
			this.rightGape = rightGape;
			this.topGape = topGape;
			this.bottomGape = bottomGape;
			this.lockDirection = lockDirection;
		}

		public var bottomGape:int;
		public var leftGape:int;
		public var lockDirection:int;
		public var rightGape:int;
		public var topGape:int;
		private var _outerHeight:int;
		private var _outerWidth:int;
		private var _resultRect:Rectangle;

		public function getInnerRect(outerWidth:int,outerHeight:int):Rectangle
		{
			_outerWidth = outerWidth;
			_outerHeight = outerHeight;
			return calculateCurrent();
		}
		
		private function calculateCurrent():Rectangle
		{
			var resultRect:Rectangle = new Rectangle();
			if(lockDirection == LockDirectionTypes.UNLOCK)
			{
				resultRect.x = leftGape;
				resultRect.y = topGape;
				resultRect.width = _outerWidth - leftGape - rightGape;
				resultRect.height = _outerHeight - topGape - bottomGape;
			}else if(lockDirection == LockDirectionTypes.LOCK_T)
			{
				resultRect.x = leftGape;
				resultRect.y = topGape;
				resultRect.width = _outerWidth - leftGape - rightGape;
				resultRect.height = bottomGape;
			}else if(lockDirection == LockDirectionTypes.LOCK_L)
			{
				resultRect.x = leftGape;
				resultRect.y = topGape;
				resultRect.width = rightGape;
				resultRect.height = _outerHeight - topGape - bottomGape;
			}else if(lockDirection == LockDirectionTypes.LOCK_R)
			{
				resultRect.x =_outerWidth -  leftGape - rightGape;
				resultRect.y = topGape;
				resultRect.width = leftGape;
				resultRect.height = _outerHeight - topGape - bottomGape;
			}else if(lockDirection == LockDirectionTypes.LOCK_B)
			{
				resultRect.x = leftGape;
				resultRect.y = _outerHeight -  topGape - bottomGape;
				resultRect.width = _outerWidth - leftGape - rightGape;
				resultRect.height = topGape;
			}else if(lockDirection == LockDirectionTypes.LOCK_TL)
			{
				resultRect.x = leftGape;
				resultRect.y = topGape;
				resultRect.width = _outerWidth - rightGape - leftGape;
				resultRect.height = _outerHeight - bottomGape - topGape;
			}else if(lockDirection == LockDirectionTypes.LOCK_TR)
			{
				resultRect.x = _outerWidth - leftGape - rightGape;
				resultRect.y = topGape;
				resultRect.width = _outerWidth - rightGape - leftGape;
				resultRect.height = _outerHeight - bottomGape - topGape;
			}else if(lockDirection == LockDirectionTypes.LOCK_BL)
			{
				resultRect.x = leftGape;
				resultRect.y = _outerHeight - bottomGape - topGape;
				resultRect.width = _outerWidth - rightGape - leftGape;
				resultRect.height = _outerHeight - bottomGape - topGape;
			}else if(lockDirection == LockDirectionTypes.LOCK_BR)
			{
				resultRect.x = _outerWidth - leftGape - rightGape;
				resultRect.y = _outerHeight - bottomGape - topGape;
				resultRect.width = _outerWidth - rightGape - leftGape;
				resultRect.height = _outerHeight - bottomGape - topGape;
			}else if(lockDirection == LockDirectionTypes.NO_SCALE_T)
			{
				resultRect.x = (_outerWidth - leftGape)/2 +bottomGape;
				resultRect.y = topGape;
				resultRect.width = leftGape;
				resultRect.height = rightGape;
			}else if(lockDirection == LockDirectionTypes.NO_SCALE_B)
			{
				resultRect.x = (_outerWidth - leftGape)/2 +topGape;
				resultRect.y = _outerHeight - bottomGape - rightGape;
				resultRect.width = leftGape;
				resultRect.height = rightGape;
			}else if(lockDirection == LockDirectionTypes.NO_SCALE_L)
			{
				resultRect.x = leftGape;
				resultRect.y = (_outerHeight - bottomGape)/2+rightGape;
				resultRect.width = topGape;
				resultRect.height = bottomGape;
			}else if(lockDirection == LockDirectionTypes.NO_SCALE_R)
			{
				resultRect.x = _outerWidth - rightGape - topGape;
				resultRect.y = (_outerHeight - topGape)/2 + leftGape;
				resultRect.width = topGape;
				resultRect.height = bottomGape;
			}else if(lockDirection == LockDirectionTypes.NO_SCALE_TL)
			{
				resultRect.x = leftGape;
				resultRect.y = topGape;
				resultRect.width = rightGape;
				resultRect.height = bottomGape;
			}else if(lockDirection == LockDirectionTypes.NO_SCALE_TR)
			{
				resultRect.x = _outerWidth - leftGape - rightGape;
				resultRect.y = topGape;
				resultRect.width = leftGape;
				resultRect.height = bottomGape;
			}else if(lockDirection == LockDirectionTypes.NO_SCALE_BL)
			{
				resultRect.x = leftGape;
				resultRect.y = _outerHeight - bottomGape - topGape;
				resultRect.width = rightGape;
				resultRect.height = topGape;
			}else if(lockDirection == LockDirectionTypes.NO_SCALE_BR)
			{
				resultRect.x = _outerWidth - leftGape - rightGape;
				resultRect.y = _outerHeight - bottomGape - topGape;
				resultRect.width = leftGape;
				resultRect.height = topGape;
			}else if(lockDirection == LockDirectionTypes.UNLOCK_OUTSIDE)
			{
				resultRect.x = -leftGape;
				resultRect.y = -topGape;
				resultRect.width = _outerWidth + leftGape + rightGape;
				resultRect.height = _outerHeight + bottomGape + topGape;
			}
			
			return resultRect;
		}
		
		public function equals(innerRect:InnerRectangle):Boolean
		{
			if(innerRect == null)return false;
			return bottomGape == innerRect.bottomGape &&
				leftGape == innerRect.leftGape &&
				lockDirection == innerRect.lockDirection &&
				rightGape == innerRect.rightGape &&
				topGape == innerRect.topGape
		}
	}
}