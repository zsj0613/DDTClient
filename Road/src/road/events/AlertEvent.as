package road.events
{
	import flash.events.Event;
	public class AlertEvent extends Event
	{
		public static const CANCEL_CLICK:int = 4;
		public static const CLOSE_CLICK:int = 0;
		public static const ENTER_CLICK:int = 2;
		public static const ESC_CLICK:int = 1;
		public static const RESPONSE:String = "response";
		public static const SUBMIT_CLICK:int = 3;

		public function AlertEvent(responseCode:int)
		{
			this.responseCode = responseCode;
			super(RESPONSE);
		}

		public var responseCode:int = -1;
	}
}