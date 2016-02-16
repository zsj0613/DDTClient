package ddt.view.dailyconduct
{
	import com.dailyconduct.view.DailyConductBgAsset;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HFrame;
	
	import ddt.view.common.BellowStripViewII;

	public class DailyConductFrame extends HFrame
	{
		private var _dailyTask       : DailyTaskList;
		private var _dailyMovement   : DailyMovementList;
		private var _dayGet          : DayGetList;
		private var _container       : DailyConductBgAsset;
		private static var _displayeState   : Boolean = false;
		
		
		public function DailyConductFrame()
		{
			super();
			init();
		}
		private function init() : void
		{
			blackGound = false;
			alphaGound = false;
			mouseEnabled = false;
			showBottom = false;
			fireEvent = false;
			setSize(790,523);
			titleText = "每日引导";			
			_container = new DailyConductBgAsset();
			_container.x = 16;
			_container.y = 40;
			
			_dayGet    = new DayGetList(_container);
			_dailyTask = new DailyTaskList(_container);
			_dailyMovement = new DailyMovementList(_container);
			addContent(_container,true);
			
			addEventListener(KeyboardEvent.KEY_DOWN,__onKeyDownd);
		}
		
	    private function __onKeyDownd(evt : KeyboardEvent) : void
	    {
	    	if(evt.keyCode == Keyboard.ESCAPE)
	    	{
	    		SoundManager.Instance.play("008");
		    	BellowStripViewII.Instance.switchDailyConduct();
	    	}
	    }
		
		override public function close():void
		{
			BellowStripViewII.Instance.switchDailyConduct();
		}
		
		
		override public function show():void
		{
			super.show();
			_displayeState = true;
			this.x = 129;
			this.y = 50;
		}
		public static function get displayeState() : Boolean
		{
			return _displayeState;
		}
		override public function dispose() : void
		{
			_displayeState = false;
			removeEventListener(KeyboardEvent.KEY_DOWN,__onKeyDownd);
			if(_dailyTask)_dailyTask.dispose();
			if(_dailyMovement)_dailyMovement.dispose();
			if(_dayGet)_dayGet.dispose();
			if(_container && _container.parent)_container.parent.removeChild(_container);
			_dailyTask     = null;
			_dailyMovement = null;
			_dayGet        = null;
			_container     = null;
//			dispatcher     = null;
			super.dispose();
		}
		
		
		
		/**移动到数据里去**/
		public static var dispatcher : EventDispatcher = new EventDispatcher();
		private static var _isDayGet   : Boolean       = false; 
		public static function set isDayGet(b : Boolean) : void
		{
			_isDayGet = b;
			dispatcher.dispatchEvent(new Event(Event.CHANGE));
		}
		public static function get isDayGet(): Boolean
		{
			return _isDayGet;
		}
		
		private static var _isClientGet :Boolean = false;
		public static function get isClientGet():Boolean
		{
			return _isClientGet;
		}
		public static function set isClientGet(value:Boolean):void
		{
			_isClientGet = value;
			dispatcher.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}