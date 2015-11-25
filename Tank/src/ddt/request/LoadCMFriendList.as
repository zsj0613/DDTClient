package ddt.request
{
	import flash.events.Event;
	import flash.utils.describeType;
	
	import road.data.DictionaryData;
	
	import ddt.data.CMFriendInfo;
	import ddt.loader.RequestLoader;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.view.common.SimpleLoading;

	public class LoadCMFriendList extends RequestLoader
	{
		public function LoadCMFriendList(account:String)
		{
			var paras:Object = new Object();
			paras.uid = account;//1003100
			super(PathManager.CommunityFriendList(), paras,false,false);
			SimpleLoading.instance.show(true);
		}
		override protected function onLoadError():void
		{
			super.onLoadError();
			SimpleLoading.instance.hide();
		}
		
		override protected function onRequestReturn(xml:XML):void
		{
			SimpleLoading.instance.hide();
//			trace("请求社区好友返回");
//			trace(xml.toXMLString());
			var _cmFriendList:DictionaryData = new DictionaryData();
			
			var xmllist:XMLList = xml..Item;
			
			var cmInfo:XML = describeType(new CMFriendInfo());
			
			for(var i:uint = 0; i < xmllist.length(); i++)
			{
				var info:CMFriendInfo = new CMFriendInfo();//XmlSerialize.decodeType(xmllist[i],CMFriendInfo,cmInfo);
				
				info.NickName = xmllist[i].@NickName;
				info.UserName = xmllist[i].@UserName;
				info.UserId = xmllist[i].@UserId;
				info.Photo = xmllist[i].@Photo;
				info.PersonWeb = xmllist[i].@PersonWeb;
				info.OtherName = xmllist[i].@OtherName;
				info.level = xmllist[i].@Level;
				var sex:int = xmllist[i].@Sex;
				if(sex == 0)
				{
					info.sex = false
				}else
				{
					info.sex = true
				}
				var tmp:String = xmllist[i].@IsExist;
				if(tmp == "true")
				{
					info.IsExist = true;
				}
				else
				{
					info.IsExist = false;
				}
				_cmFriendList.add(info.UserName,info);
			}
			PlayerManager.Instance.CMFriendList = _cmFriendList;
		}
	}
}