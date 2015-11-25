package ddt.request
{
	import flash.utils.Dictionary;
	import ddt.manager.PathManager;
	
	import road.loader.TextLoader;
	import road.utils.StringHelper;

	public class LoadLanguageAction extends TextLoader
	{
		public var languages:Dictionary;
		
		public function LoadLanguageAction()
		{
			languages = new Dictionary();
			super(0,PathManager.solveLanguagePath()+"?"+Math.random());
		}
		
		override protected function onCompleted():void
		{
		//	global.traceStr("OnCompleted");
			if(isSuccess)
			{
				parseContent();
			}
			super.onCompleted();
		}
		
		private function parseContent():void
		{
			var list:Array = String(content).split("\r\n");
			//global.traceStr(String(content).length.toString());
			var count:int =0;
			var temp:Boolean = true;
			for(var i:int = 0; i < list.length; i ++)
			{
				var s:String = list[i];
				if(s.indexOf("#") == 0)
					continue;
				s = s.replace("\\r","\r");
				s = s.replace("\\n","\n");
				var index:int = s.indexOf(":");
				if(index != -1)
				{
					var name:String = s.substring(0,index);
					var value:String = s.substr(index + 1);
					value = value.split("##")[0]
					//global.traceStr("LoadedLanguage:"+name + ":"+value)
					languages[name] = StringHelper.trimRight(value);
					if(temp)
					{
						temp=false;
						//global.traceStr(name + " is "+ value);
					}
					count++;
				}
				
			}
		//global.traceStr("LoadedLanguages:"+count)
		}
		
	}
}