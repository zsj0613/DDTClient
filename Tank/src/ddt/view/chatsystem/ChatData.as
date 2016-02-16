package ddt.view.chatsystem
{
	import ddt.utils.Helpers;

	public class ChatData
	{
		public var channel:uint;
		public var htmlMessage:String = "";
		public var msg:String = "";
		public var receiver:String = "";
		public var receiverID:int;
		public var sender:String = "";
		public var senderID:int;
		public var zoneID:int = -1;
		public var type:int=-1;
		public var server:String ="";
		/**
		 *  <Object{uint index,int TemplateID,,Number ItemID}>
		 */		
		public var link:Array;
		public function clone():ChatData
		{
			var re_chatdata:ChatData=new ChatData;
			Helpers.copyProperty(this,re_chatdata,["channel","htmlMessage","msg","receiver","receiverID","sender","senderID","zoneID","type"]);
			re_chatdata.link=new Array().concat(link);
			return re_chatdata;
		}
	}
}