package ddt.data.channel
{
	import ddt.manager.LanguageMgr;
	
	public class ChannelType
	{
		public static const ALL:uint = 0;
		public static const CURRENT:uint = 1;
		public static const CONSORTIA:uint = 2;
		
		LanguageMgr.GetTranslation("ddt.data.channel.ChannelType.house")
		public static const NAMES:Array = [LanguageMgr.GetTranslation("ddt.auctionHouse.view.BrowseLeftListView"),LanguageMgr.GetTranslation("ddt.data.channel.ChannelType.current"),LanguageMgr.GetTranslation("ddt.data.channel.ChannelType.house")];
		//public static const NAMES:Array = ["所有","当前","公会"];
	}
}