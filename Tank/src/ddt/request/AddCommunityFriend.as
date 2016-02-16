package ddt.request
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	
	import road.utils.StringHelper;
	
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;

	public class AddCommunityFriend
	{
		public function AddCommunityFriend($friendId:String,$friendNickName: String)
		{
			if(StringHelper.IsNullOrEmpty(PathManager.solveCommunityFriend))return;
			var loader:URLLoader  = new URLLoader();
			loader.addEventListener(Event.COMPLETE,__addFriendComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR,__addFriendError);
			var url:URLRequest    = new URLRequest(PathManager.solveCommunityFriend);
			var obj:URLVariables  = new URLVariables();
			obj["fuid"]           = PlayerManager.Instance.Self.LoginName;
			obj["fnick"]          = PlayerManager.Instance.Self.NickName;
			obj["tuid"]           = $friendId;
			obj["tnick"]          = $friendNickName;
			url.data              = obj;
			loader.load(url);
		}
		
		private function __addFriendComplete(evt : Event) : void
		{
			if((evt.currentTarget as URLLoader).data == "0")
			{
//				trace("加社区好友成功");
			}
			else
			{
//				trace("加社区好友失败");
			}
		}
		private function __addFriendError(evt : IOErrorEvent) : void
		{
//			trace(evt.text);
		}
	}
}