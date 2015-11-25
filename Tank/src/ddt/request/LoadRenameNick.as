package ddt.request
{
	import flash.utils.ByteArray;
	
	import ddt.data.AccountInfo;
	import ddt.data.CrytoHelper;
	import ddt.loader.RequestLoader;
	import ddt.manager.PathManager;

	public class LoadRenameNick extends RequestLoader
	{
		private static var w:String = "abcdefghijklmnopqrstuvwxyz";
		private static const PATH:String = "RenameNick.ashx";
		private var _tempPass:String;
		public var errMsg:String;
		public function LoadRenameNick(acc:AccountInfo,nickName:String,newNickName:String)
		{
			var date:Date = new Date();
			var temp:ByteArray = new ByteArray();
			temp.writeShort(date.fullYearUTC);
			temp.writeByte(date.monthUTC + 1);
			temp.writeByte(date.dateUTC);
			temp.writeByte(date.hoursUTC);
			temp.writeByte(date.minutesUTC);
			temp.writeByte(date.secondsUTC);
			_tempPass = "";
			for(var i:int = 0; i < 6; i++)
			{
				_tempPass += w.charAt(int(Math.random() * 26));
			}
			temp.writeUTFBytes(acc.Account+","+acc.Password+","+_tempPass+","+ nickName+"," +newNickName);
			var p:String = CrytoHelper.rsaEncry4(acc.Key,temp);
			
			super(PATH,{p:p,v:Version.Build,site:PathManager.solveConfigSite()});
		}
		override protected function onRequestReturn(xml:XML):void
		{
//			trace("LoginAction+++"+xml);
			var result:String = xml.@value;
			if(result == "true")
			{
				
			}else
			{
				isSuccess = false;
				errMsg = xml.@message;
			}
			
		}
		
		
	}
}