package ddt.request
{
	import flash.utils.ByteArray;
	
	import ddt.data.AccountInfo;
	import ddt.data.CrytoHelper;
	import ddt.loader.RequestLoader;
	import ddt.manager.PathManager;

	public class LoadRenameConsortiaName extends RequestLoader
	{
		private static var w:String = "abcdefghijklmnopqrstuvwxyz";
		private static const PATH:String = "RenameConsortiaName.ashx";
		private var _tempPass:String;
		public var errMsg:String;
		public function LoadRenameConsortiaName(acc:AccountInfo,nickName:String,newConsortiaName:String)
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
			temp.writeUTFBytes(acc.Account+","+acc.Password+","+_tempPass+","+ nickName+"," +newConsortiaName);
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