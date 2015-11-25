package ddt.hotSpring.events
{
	import flash.events.Event;

	public class CharacterEvent extends Event
	{
//		/**
//		 *用户基础行为形象集合合成成功 
//		 */
//		public static const CHARACTER_SYNTHETIC_COMPLETE:String = "CharacterSyntheticComplete";
		public static const MOVEMENT : String = "movement";
		public static const ARRIVED_NEXT_STEP:String = "arrived next step";
		public static const ACTION_CHANGE:String = "action change";
		
		public var _object:Object;
		
		public function CharacterEvent(type:String, object:Object)
		{
			super(type);
			this._object=object;
		}
	}
}