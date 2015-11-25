package road.loader
{
	import flash.events.Event;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	public class CompressTextLoader extends BaseLoader
	{
		private var _deComressedText:String;
		
		public function CompressTextLoader(id:int, url:String, args:URLVariables=null)
		{
			if(args == null)args = new URLVariables();
			args["rnd"] = TextLoader.TextLoaderKey;
			super(id, url, args);
		}
		
		override protected function __onDataLoadComplete(event:Event):void
		{
			removeEvent();
			_loader.close();
			var temp:ByteArray = _loader.data;
			temp.uncompress();
			temp.position = 0;
			_deComressedText = temp.readUTFBytes(temp.bytesAvailable);
			if(analyzer)
			{
				analyzer.analyzeCompleteCall = fireComplete;
				analyzer.analyze(_deComressedText);
			}else
			{
				fireComplete();
			}
		}
		
		override public function get content():*
		{
			return _deComressedText;
		}
		
		override public function get type():int
		{
			return BaseLoader.COMPRESS_TEXT_LOADER;
		}
	}
}