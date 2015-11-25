package ddt.events
{
	import flash.events.Event;

	public class ChurchRoomEvent extends Event
	{
		public static const MOVEMENT : String = "movement";
		public static const ARRIVED_NEXT_STEP:String = "arrived next step";
		public static const ACTION_CHANGE:String = "action change";
		
		public static const WEDDING_STATUS_CHANGE:String = "wedding status change";

		public static const ROOM_INFO_CHANGE:String = "roomInfoChange";
		public static const ROOM_HIDE_NAME:String = "room hide name";
		public static const ROOM_HIDE_PAO:String = "room hide pao";
		public static const ROOM_HIDE_FIRE:String = "room hide fire";
		public static const ROOM_FIRE_ENABLE_CHANGE:String = "room fire enable change";
		public static const ROOM_VALIDETIME_CHANGE:String = "valide time change";
		
		public static const SCENE_CHANGE:String = "scene change";
		
		public var data:Object;
		public function ChurchRoomEvent($type:String,$data:Object = null)
		{
			super($type);
			this.data = $data;
		}
		
	}
}
