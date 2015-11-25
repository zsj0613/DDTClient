package road.ui
{
	import com.gskinner.motion.easing.Sine;
	public final class ComponentSetting
	{
		/**
		 * 按钮按住时开始 发出change的时间 
		 */		
		public static var BUTTON_PRESS_START_TIME:int = 500;
		/**
		 *  按钮按住时每次发出change的时间间隔 
		 */		
		public static var BUTTON_PRESS_STEP_TIME:int = 100;
		/**
		 * Combox执行隐藏缓动动画的缓动函数 
		 */		
		public static var COMBOBOX_HIDE_EASE_FUNCTION:Function = Sine.easeInOut;
		/**
		 * Combox执行隐藏缓动动画的时间
		 */	
		public static var COMBOBOX_HIDE_TIME:Number = 0.5;
		/**
		 * Combox执行展示缓动动画的缓动函数 
		 */
		public static var COMBOBOX_SHOW_EASE_FUNCTION:Function = Sine.easeInOut;
		/**
		 * Combox执行展示缓动动画的时间
		 */
		public static var COMBOBOX_SHOW_TIME:Number = 0.5;
		/**
		 * bitmapData配置在XML中的标签名称 
		 */		
		public static var BITMAPDATA_TAG_NAME:String = "bitmapData";
		/**
		 * bitmap配置在XML中的标签名称 
		 */
		public static var BITMAP_TAG_NAME:String = "bitmap";
		/**
		 *  简单Alert的默认名称
		 */		
		public static var SIMPLE_ALERT_STYLE:String = "SimpleAlert";
		/**
		 * SimpleBitmapButton的filterString 
		 */		
		public static var SimpleBitmapButtonFilter:String = "null,lightFilter,null,grayFilter";
	}
}