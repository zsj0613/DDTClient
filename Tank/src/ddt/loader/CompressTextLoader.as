package ddt.loader
{
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import ddt.data.PathInfo;
	
	import road.loader.BaseLoader;
	
	import ddt.manager.PathManager;

	public class CompressTextLoader extends BaseLoader
	{
		public function CompressTextLoader(path:String,paras:Object = null)
		{

			if(paras != null)
			{
				var data:URLVariables = new URLVariables();
				if(paras)
				{
					for(var s:String in paras)
					{
						data[s] = paras[s];
					}
				}
			}
			super(0,path,data);
		}
		
		override protected function onCompleted():void
		{
			var temp:ByteArray = content as ByteArray;
			temp.uncompress();
			temp.position = 0;
			onTextReturn(temp.readUTFBytes(temp.bytesAvailable));
		}
		
		protected function onTextReturn(txt:String):void
		{
			super.onCompleted();
		}
		
	}
}