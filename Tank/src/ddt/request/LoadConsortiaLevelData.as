package ddt.request
{
	import road.serialize.xml.XmlSerialize;
	
	import ddt.data.ConsortiaLevelInfo;
	import ddt.data.PathInfo;
	import ddt.manager.PathManager;
	import ddt.loader.CompressTextLoader;

	public class LoadConsortiaLevelData extends CompressTextLoader
	{
		public var list:Array;
		private var _xml:XML;
		private static const PATH:String = "ConsortiaLevelList.xml";
		
		public function LoadConsortiaLevelData()
		{
			super(PathManager.solveXMLPath()+PATH + "?" +Math.random(),null);
		}
		override protected function onTextReturn(txt:String):void
		{
			_xml = new XML(content);
//			trace(_xml.toXMLString());
			list = new Array();
			var xmllist:XMLList = XML(_xml)..Item;
			for(var i:int = 0; i < xmllist.length(); i++)
			{
				list.push(XmlSerialize.decodeType(xmllist[i],ConsortiaLevelInfo));
			}
			if(_func != null)
			{
				_func(this);
			}
		}
		
	}
}