package road.loader
{
	import flash.events.Event;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	public class ModuleLoader extends DisplayLoader
	{
		public function ModuleLoader(id:int, url:String)
		{
			super(id, url);
		}
		
		public static function decry(src:ByteArray):ByteArray
		{
			var bytes:ByteArray = new ByteArray();
			bytes.writeByte(67);
			bytes.writeByte(87);
			bytes.writeByte(83);
			src.position = 100;
			src.readBytes(bytes,200,src.bytesAvailable -197);
			src.readBytes(bytes,3);
			return bytes;
		}
		
		public static function getDefinition(classname:String):*
		{
			return DisplayLoader.Context.applicationDomain.getDefinition(classname);
		}
		
		override protected function __onDataLoadComplete(event:Event):void
		{
			removeEvent();
			_loader.close();
			_displayLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,__onContentLoadComplete);
			if(_loader.data.length == 0)return;
			var temp:ByteArray = _loader.data ;
			if((temp[0] != 67) || (temp[1] != 87) || (temp[2] != 83))
			{
				temp = decry(temp);
			}
			LoaderSavingManager.cacheFile(_url,temp,false);
			_displayLoader.loadBytes(temp,Context);
		}
		
		override public function get type():int
		{
			return BaseLoader.MODULE_LOADER;
		}
	}
}