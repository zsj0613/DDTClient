package ddt.request
{
	import flash.utils.describeType;
	
	import road.data.DictionaryData;
	import road.serialize.xml.XmlSerialize;
	
	import ddt.data.player.FriendListPlayer;
	import ddt.loader.RequestLoader;
	import ddt.manager.PlayerManager;

	public class LoadFriendList extends RequestLoader
	{
		private var path:String = "IMListLoad.ashx";
		
		public function LoadFriendList(id:int)
		{
			var param:Object = new Object();
			param["id"] = id;
			super(path,param);
		}
		
		override protected function onRequestReturn(xml:XML):void
		{
//			trace(xml.toXMLString());
			var friendlist:DictionaryData = new DictionaryData();
			var blackList:DictionaryData = new DictionaryData();
			var xmllist:XMLList = xml..Item;
			var pcInfo:XML = describeType(new FriendListPlayer());
			for(var i:int = 0;i < xmllist.length(); i ++)
			{
				var player:FriendListPlayer = new FriendListPlayer();
				player.beginChanges();
				player = XmlSerialize.decodeObject(xmllist[i],player);
				player.commitChanges();
//				var info:FriendListPlayer = XmlSerialize.decodeType(xmllist[i],FriendListPlayer,pcInfo);
				if(player.Relation == 0)
				{
					friendlist.add(player.ID,player);
				}else
				{
					blackList.add(player.ID,player);
				}
			}
			PlayerManager.Instance.friendList = friendlist;
			PlayerManager.Instance.blackList = blackList;
		}
	}
}