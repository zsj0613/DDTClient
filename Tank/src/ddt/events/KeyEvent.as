package ddt.events
{
	import flash.events.Event;

	public class KeyEvent extends Event
	{
		public var keyCode:int;
		public static const KEY_UP_ENTER:String = "keyUpEnter";
		
		public static const KEY_DOWN_P:String = "keyDownP";
		
		public static const KEY_DOWN_PROP:String = "keyDownProp";
		
		public static const KEY_DOWN_PROPII:String = "keyDownPropII";
		
		/**
		 * 键盘 
		 */		
		public static const KEY_PRESS_SPACE:String = "keyPressSpace";
		public static const KEY_RELEASE_SPACE:String = "keyReleaseSpace";
		
		/**
		 * 必杀技快捷键 
		 */		
		public static const KEY_DOWN_B:String = "keyDownB";
		
		public function KeyEvent(type:String, value:int = 0,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type,bubbles,cancelable);
			keyCode = value;
		}
		
	}
}