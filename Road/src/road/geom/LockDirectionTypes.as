package road.geom
{
	public class LockDirectionTypes
	{
		/**
		 * 锁定到底部  getInnerRect 返回的矩形结果为：<br>
		 * resultRect.x = leftGape;<br>
		 * resultRect.y = _outerHeight -  topGape - bottomGape;<br>
		 * resultRect.width = _outerWidth - leftGape - rightGape;<br>
		 * resultRect.height = topGape;
		 */		
		public static const LOCK_B:int = 4;
		/**
		 * 锁定到左下角  getInnerRect 返回的矩形结果为：<br>
		 * resultRect.x = leftGape; <br>
		 * resultRect.y = _outerHeight - bottomGape - topGape; <br>
		 * resultRect.width = rightGape; <br>
		 * resultRect.height = topGape; <br>
		 */		
		public static const LOCK_BL:int = 7;
		/**
		 * 锁定到右下角  getInnerRect 返回的矩形结果为：<br>
		 * resultRect.x = _outerWidth - leftGape - rightGape; <br>
		 * resultRect.y = _outerHeight - bottomGape - topGape; <br>
		 * resultRect.width = leftGape; <br>
		 * resultRect.height = topGape; <br>
		 */		
		public static const LOCK_BR:int = 8;
		/**
		 * 锁定到左侧  getInnerRect 返回的矩形结果为：<br>
		 * resultRect.x = leftGape; <br>
		 * resultRect.y = topGape; <br>
		 * resultRect.width = rightGape;<br>
		 * resultRect.height = _outerHeight - topGape - bottomGape;<br>
		 */		
		public static const LOCK_L:int = 2;
		/**
		 * 锁定到右侧  getInnerRect 返回的矩形结果为：<br>
		 * resultRect.x =_outerWidth -  leftGape - rightGape;
		 * resultRect.y = topGape;
		 * resultRect.width = leftGape;
		 * resultRect.height = _outerHeight - topGape - bottomGape; 
		 */		
		public static const LOCK_R:int = 3;
		/**
		 * 锁定到顶部  getInnerRect 返回的矩形结果为：<br>
		 * resultRect.x = leftGape;<br>
		 * resultRect.y = topGape;<br>
		 * resultRect.width = _outerWidth - leftGape - rightGape;<br>
		 * resultRect.height = bottomGape;	<br>
		 */
		public static const LOCK_T:int = 1;
		/**
		 * 锁定到左上角  getInnerRect 返回的矩形结果为：<br>
		 * resultRect.x = leftGape;<br>
		 * resultRect.y = topGape;<br>
		 * resultRect.width = rightGape;<br>
		 * resultRect.height = bottomGape; <br>
		 */		
		public static const LOCK_TL:int = 5;
		/**
		 * 锁定到右上角  getInnerRect 返回的矩形结果为：<br>
		 * resultRect.x = _outerWidth - leftGape - rightGape;<br>
		 * resultRect.y = topGape;<br>
		 * resultRect.width = leftGape;<br>
		 * resultRect.height = bottomGape;<br>
		 */		
		public static const LOCK_TR:int = 6;
		/**
		 * 不锁定
		 * resultRect.x = leftGape;<br>
		 * resultRect.y = topGape;<br>
		 * resultRect.width = _outerWidth - leftGape - rightGape;<br>
		 * resultRect.height = _outerHeight - topGape - bottomGape; <br>
		 */		
		public static const UNLOCK:int = 0;
		/**
		 * 向上锁定但是不修改宽高<br>
		 * resultRect.x = (_outerWidth - rightGape)/2 +leftGape;<br>
		 * resultRect.y = topGape;<br>
		 * resultRect.width = rightGape;<br>
		 * resultRect.height = bottomGape;<br>
		 */		
		public static const NO_SCALE_T:int = 9;
		
		/**
		 * 向下锁定但是不修改宽高<br>
		 * resultRect.x = (_outerWidth - rightGape)/2 +leftGape;<br>
		 * resultRect.y = _outerHeight - bottomGape - topGape;<br>
		 * resultRect.width = rightGape;<br>
		 * resultRect.height = bottomGape;<br>
		 */		
		public static const NO_SCALE_B:int = 10;
		
		/**
		 * 向下锁定但是不修改宽高<br>
		 * resultRect.x = (_outerWidth - rightGape)/2 +leftGape;<br>
		 * resultRect.y = _outerHeight - bottomGape - topGape;<br>
		 * resultRect.width = rightGape;<br>
		 * resultRect.height = bottomGape;<br>
		 */		
		public static const NO_SCALE_L:int = 11;
		
		/**
		 * 向下锁定但是不修改宽高<br>
		 * resultRect.x = (_outerWidth - rightGape)/2 +leftGape;<br>
		 * resultRect.y = _outerHeight - bottomGape - topGape;<br>
		 * resultRect.width = rightGape;<br>
		 * resultRect.height = bottomGape;<br>
		 */		
		public static const NO_SCALE_R:int = 12;
		
		public static const NO_SCALE_TL:int = 13;
		public static const NO_SCALE_TR:int = 14;
		public static const NO_SCALE_BL:int = 15;
		public static const NO_SCALE_BR:int = 16;
		
		public static const UNLOCK_OUTSIDE:int = -1;
	}
}