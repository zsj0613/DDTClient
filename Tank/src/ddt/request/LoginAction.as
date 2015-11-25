package ddt.request
{
	import flash.utils.ByteArray;
	
	import road.serialize.xml.XmlSerialize;
	import road.ui.controls.hframe.HAlertDialog;
	
	import ddt.data.AccountInfo;
	import ddt.data.ChurchRoomInfo;
	import ddt.data.CrytoHelper;
	import ddt.loader.RequestLoader;
	import ddt.manager.ChurchRoomManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.StateManager;
	import ddt.manager.StatisticManager;
	import ddt.states.StateType;
	import ddt.utils.LeavePage;

	public class LoginAction extends RequestLoader
	{
		private static var w:String = "abcdefghijklmnopqrstuvwxyz";
		
		private static const PATH:String = "Login.ashx";
		
		private var _tempPass:String;
		
		public var message:String;
		public function get newPassword():String
		{
			return _tempPass;
		}
		
		public function LoginAction(acc:AccountInfo,name:String)
		{
			//trace("LoginAction")
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
			
			temp.writeUTFBytes(acc.Account+","+acc.Password+"," +_tempPass+","+ name);
			var p:String = CrytoHelper.rsaEncry4(acc.Key,temp);
			
			super(PATH,{p:p,v:Version.Build});
		}
		private var _alerDialog:HAlertDialog;
		override protected function onRequestReturn(xml:XML):void
		{
//			trace("LoginAction+++"+xml);
			var result:String = xml.@value;
			message = xml.@message;
			if(result == "true")
			{
				PlayerManager.Instance.Self.beginChanges();
				if(PlayerManager.Instance.Self.IsNovice)
				{
					XmlSerialize.decodeObject(xml..Item[0],PlayerManager.Instance.Self);
					PlayerManager.Instance.Self.IsNovice = true;
				}else
				{
					XmlSerialize.decodeObject(xml..Item[0],PlayerManager.Instance.Self);
				}
				
				if(PlayerManager.Instance.Self.IsFirst == 0)
				{
					StatisticManager.Instance().IsNovice = true;
					PlayerManager.Instance.Self.IsNovice = true;
				}
				
				PlayerManager.Instance.Account.Password = _tempPass;
//				PlayerManager.Instance.Self.updateStyle((xml..Item[0].@Sex == "false" ? false : true),int(xml..Item[0].@Hide),t,xml..Item[0].@Colors,xml..Item[0].@Skin);
				
				
				ChurchRoomManager.instance.selfRoom = xml..Item[0].@IsCreatedMarryRoom == "false"?null:new ChurchRoomInfo();
				PlayerManager.Instance.Self.commitChanges();
			}
			else
			{
				_alerDialog = HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),xml.@message,true,errorOkCallBack,"stage",null,errorOkCallBack);
				//AlertDialog.show("提示",xml.@message,true,errorOkCallBack);
				isSuccess = false;
			}
		}
		
		private function errorOkCallBack():void
		{
			LeavePage.LeavePageTo(PathManager.solveLogin(),"_self");
			if(_alerDialog)_alerDialog.dispose();
		}
	} 
}