package ddt.auctionHouse.event
{
	import flash.events.Event;

	public class AuctionHouseEvent extends Event
	{
		/**
		 * 切换界面 
		 */		
		public static const CHANGE_STATE:String = "changeState";
		
		public static const GET_GOOD_CATEGORY:String = "getGoodCateGory";
		
		public static const SELECT_STRIP:String = "selectStrip";
		
		/**
		 * 删除拍卖 
		 */		
		public static const DELET_AUCTION:String = "deleteAuction";
		
		/**
		 * 填加拍卖 
		 */		
		public static const ADD_AUCTION:String = "addAuction";
		
		public static const UPDATE_PAGE:String = "updatePage";
		
		public static const PRE_PAGE:String = "prePage";
		
		public static const NEXT_PAGE:String = "nextPage";
		
		public static const SORT_CHANGE:String = "sortChange";
		
		/**
		 * 浏览界面的类型改变 
		 */		
		public static const BROWSE_TYPE_CHANGE:String = "browseTypeChange";
		
		public function AuctionHouseEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}		
	}
}