package ddt.loader
{
	import ddt.manager.LanguageMgr;
	
	public class LoadCheckName extends RequestLoader
	{
//		private var path:String = "NickNameCheck.ashx";
		private var __id:int;
		private var _name:String;
		private var _callback:Function;
		public function LoadCheckName( name:String,callback:Function = null,path:String = "CheckNickName.ashx")
		{
			_callback = callback;
			var param:Object = new Object();
			param["NickName"] = name;
			super(path,param);
		}
		
		override protected function onRequestReturn(xml:XML):void
		{
//			var b:Boolean = xml.@value == "true" ? true : false;
			var b:Boolean = xml.@value;
			var m:String;
			if(b)
			{
				m = xml.@message;
			}else
			{
				m = LanguageMgr.GetTranslation("choosecharacter.LoadCheckName.m");
				//m = "检测失败！";
			}
			if(_callback != null)
			{
				_callback(m);
			}
			
		}
		
	}
}