package ddt.loader
{
	import flash.net.URLVariables;
	
	import road.loader.TextLoader;
	
	import ddt.manager.PathManager;
	
	public class RequestLoader extends TextLoader
	{
		public function RequestLoader(path:String,paras:Object = null,isValidate:Boolean = false, useDefaultDomain:Boolean = true)
		{
			var tempPath : String;
			if(useDefaultDomain)
			{
				tempPath = PathManager.solveRequestPath(path);
			}
			else
			{
				tempPath = path;
			}
			
			
			var data:URLVariables = new URLVariables();
			if(paras)
			{
				for(var s:String in paras)
				{
					data[s] = paras[s];
				}
			}
			data["rnd"] = Math.random();
			super(0,tempPath,data);
			//_url.method = URLRequestMethod.POST;
		}
		
		override protected function onCompleted():void
		{
			onRequestReturn(new XML(content));
			super.onCompleted();
		}
		
		protected virtual function onRequestReturn(xml:XML):void
		{
		}
	}
}