package ddt.civil
{
	import flash.events.Event;

	public class CivilDataEvent extends Event
	{
		public static const CIVIL_PLAYERINFO_ARRAY_CHANGE:String = "civilplayerinfoarraychange";
		public static const CIVIL_MARRY_STATE_CHANGE:String = "civilmarrystatechange";
		public static const SELECT_CLICK_ITEM:String = "selectclickitem";
		public static const CIVIL_UPDATE:String      = "CivilUpdate";
		public static const CIVIL_UPDATE_BTN:String      = "CivilUpdateBtn";
		
		public var data:Object;
		public function CivilDataEvent($type:String,$data:Object = null)
		{
			super($type, $data);
			this.data = $data;
		}
		
	}
}