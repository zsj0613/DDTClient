package ddt.request
{
	import road.ui.controls.hframe.HAlertDialog;
	
	import ddt.loader.RequestLoader;
	import ddt.manager.LanguageMgr;
	
	public class RegisterAction extends RequestLoader
	{
		
		private static const PATH:String = "Register.ashx";
		
		public function RegisterAction(Name:String,Pass:String,Sex:Boolean,NickName:String)
		{
			super(PATH,{Name:Name,Pass:Pass,Sex:Sex,NickName:NickName});
		}
		
		/**
		 *  
		 * @param event
		 * 0：成功。1：不知道错误。2：用户已存在.3：用户名或密码为空。
		 */	
		override protected function onRequestReturn(xml:XML):void
		{
			var result:String = xml.@value;
			if(result != "true")
			{
//				AlertDialog.alert("提示",xml.@message,true);
				HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),xml.@message,true);
				isSuccess = false;
			}
		}
		
	}
}