package ddt.request
{
	import road.serialize.xml.XmlSerialize;
	
	import ddt.data.DaylyGiveInfo;
	import ddt.data.PathInfo;
	import ddt.manager.PathManager;
	import ddt.loader.CompressTextLoader;

	public class LoadDaylyGiveTemplete extends CompressTextLoader
	{
		private static const PATH:String = "DailyAwardList.xml";
		public var list:Array;
		public function LoadDaylyGiveTemplete()
		{
			super(PathManager.solveXMLPath()+PATH + "?" +Math.random(),null);
		}
		
		override protected function onTextReturn(txt:String):void
		{
			var xml:XML = new XML(txt);
			list = new Array();
			var xmllist:XMLList = xml..Item;
			for(var i:int = 0; i < xmllist.length(); i++)
			{
				list.push(XmlSerialize.decodeType(xmllist[i],DaylyGiveInfo));
			}
			if(_func != null)
			{
				_func(this);
			}
		}
		
		
	}
}