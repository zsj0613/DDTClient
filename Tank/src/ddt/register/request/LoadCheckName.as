package ddt.register.request
{
	import flash.net.URLVariables;
	
	import ddt.loader.RequestLoader;

	public class LoadCheckName extends RequestLoader
	{
		private var path:String = "CheckNickName.ashx";
		private var _name:String;
		public var message:String;
		public function LoadCheckName(name:String)
		{
			var param:URLVariables = new URLVariables();
			param["NickName"] = name;
			super(path,param);
		}
		protected override function onRequestReturn(xml:XML):void
		{
			isSuccess = xml.@value == "true";
			message = xml.@message;
		}
	}
}