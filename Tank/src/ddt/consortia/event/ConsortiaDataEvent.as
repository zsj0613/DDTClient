package ddt.consortia.event
{
	import flash.events.Event;
	
	public class ConsortiaDataEvent extends Event
	{
		/* 自己的公会信息改变 */
		public static const MY_CONSORTIA_DATA_CHANGE:String = "myconsortiadatachange";
		public static const UP_MY_CONSORTIA_DATA_CHANGE : String = "upconsortiadatachager";
		public static const MY_CONSORTIA_AUDITING_APPLY_DATA_CHAGE : String = "myconsortiaauditingapplydatachage";
		
		/*  */
		public static const CONSORTIA_LIST_CHANGE          : String = "consortialistchange";
		public static const CONSORTIA_APPLY_RECORD_CHANGE  : String = "consortiaapplyrecordchange";
		public static const CONSORTIA_INVITE_RECORD_CHANGE : String = "consortiainviterecordchage";
		public static const SELECT_CLICK_ITEM              : String = "selectclickItem";
		public static const CONSORTIA_MEMBER_LIST_CHANGE   : String =  "consortiamemberlistchange";
		public static const CONSORTIA_ALLY_LIST_CHANGE     : String = "consortiaAllyListChange";
		public static const CONSORTIA_ALLY_ITEM_REMOVE     : String = "consortiaallyitemremove";/*删去公会外交中的一个公会*/
		public static const DUTY_LIST_CHANGE               : String = "consortiaDutyChange";
		public static const ALLY_APPLY_LIST_CHANGE         : String = "allyApplyListChange";
		public static const UP_MY_CONSORTIA_Description    : String = "upMyConsortiaDescription";/*修改公会宣言*/
		public static const DELETE_ALLY_APPLY_ITEM         : String = "deleteAllyApplyItem";
		public static const CONSORTIA_EVENT_LIST_CHANGE    : String = "consortiaEventListChange";
		public static const DELETE_CONSORTIA_APPLY         : String = "deleteConsortiaApply";
		public static const SELECT_RECORD_TYPE             : String = "selectRecordType";
		public static const CONSORTIA_ASSET_LEVEL_OFFER    : String = "ConsortiaAssetLevelOffer";
	
		public var data:Object;
		public function ConsortiaDataEvent(type:String,data:Object = null)
		{
			this.data = data;
			super(type);
			
		}

	}
}