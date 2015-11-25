package ddt.manager
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import ddt.view.consortia.QuitConsortiaTipFrame;
	
	public class ConsortiaQuitTipManager extends EventDispatcher
	{
		private static var _instance:ConsortiaQuitTipManager;
		private var _message:String;
		private var _isQuitMessage:Boolean = false;
		public static const QUITCONSORTIAGOODSTOBAG:String = "quitConsortiaGoodsToBag";
	//	private var _tipView:QuitConsortiaTipFrame;
		
		public function ConsortiaQuitTipManager(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function showMessage():void
		{
			var _tipView:QuitConsortiaTipFrame = new QuitConsortiaTipFrame(_message);
			_tipView.show();
		}
		
		public function set message(str:String):void
		{
			_message = str;
		}
		
		public function set isQuitMessage(value:Boolean):void
		{
			_isQuitMessage = value;
			if(_isQuitMessage)
			{
				dispatchEvent(new Event(ConsortiaQuitTipManager.QUITCONSORTIAGOODSTOBAG));
			}
		}
		
		public function get isQuitMessage():Boolean
		{
			return _isQuitMessage;
		}
		
		public static function get Instance():ConsortiaQuitTipManager
		{
			if(_instance == null)
			{
				_instance = new ConsortiaQuitTipManager();
			}
			return _instance;
		}
	}
}