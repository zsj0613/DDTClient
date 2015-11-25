package ddt.register.request
{
	import flash.net.URLVariables;
	import ddt.loader.RequestLoader;
	public class RegisterCharacter extends RequestLoader
	{
		private static const PATH:String = "VisualizeRegister.ashx";
		private var _nickName:String;
		public var message:String;
		public function RegisterCharacter(user:String,pass:String,Sex:Boolean,NickName:String)
		{
			var param:URLVariables = new URLVariables();
			param["Sex"] = Sex;
			param["Name"] = user;
			param["Pass"] = pass;
			param["NickName"] = NickName;
			param["site"] = "";
			super(PATH,param);
		}
		protected override function onRequestReturn(xml:XML):void
		{
						isSuccess = xml.@value == "true";
									message = xml.@message;
		}
		
	}
}