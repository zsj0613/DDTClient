package ddt.request
{
	import ddt.data.PathInfo;
	import ddt.loader.CompressTextLoader;
	import ddt.manager.PathManager;

	public class LoadWeekOpenMap extends CompressTextLoader
	{
		public static const PATH:String = "MapServerList.xml";
		
		public var list:Array;
		private var _xml:XML;
		
		public function LoadWeekOpenMap()
		{
			super(PathManager.solveXMLPath()+PATH + "?" +Math.random(),null);
		}
		
		override protected function onTextReturn(txt:String):void
		{
			_xml = new XML(content);
//			trace(_xml.toXMLString());
			var result:String = _xml.@value;
			if(result != "true")
			{
				isSuccess = false;
			}
			else
			{
				isSuccess = true;
				list = new Array();
				var nodes:XMLList = _xml..Item;
				for(var i:int = 0; i < nodes.length(); i++)
				{
					list.push({maps:nodes[i].@OpenMap.split(","),serverID:nodes[i].@ServerID});
				}
			}
			if(_func != null)
			{
				_func(this);
			}
		}
	}
}