package ddt.events
{
	import flash.events.Event;
	
	public class SceneCharacterEvent extends Event
	{
		public static const CHARACTER_MOVEMENT : String = "characterMovement";
		public static const CHARACTER_ARRIVED_NEXT_STEP:String = "characterArrivedNextStep";
		public static const CHARACTER_ACTION_CHANGE:String = "characterActionChange";
		
		/**
		 *人物形象方向有改变事件 
		 */		
		public static const CHARACTER_DIRECTION_CHANGE:String = "characterDirectionChange";
		
		public var data:Object;
		
		public function SceneCharacterEvent(type:String, data:Object=null)
		{
			super(type);
			this.data=data;
		}
	}
}