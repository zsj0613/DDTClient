package ddt.request.store
{
	import road.serialize.xml.XmlSerialize;
	
	import ddt.data.goods.CateCoryInfo;
	import ddt.loader.CompressTextLoader;
	import ddt.data.PathInfo;
	import ddt.manager.PathManager;

	public class LoadGoodCategory extends CompressTextLoader
	{
		private static var PATH:String = "ItemsCategory.xml";
		private  var _list:Array;
		private var _xml:XML;
		public function get list():Array
		{
			return _list;
		}
		public function LoadGoodCategory()
		{
			super(PathManager.solveXMLPath()+PATH+"?"+Math.random());
		}
		
		override protected function onTextReturn(txt:String):void
		{
			_xml = new XML(content);
			_list = new Array();
			var xmllist:XMLList = _xml..Item;
			for(var i:int = 0;i < xmllist.length(); i ++)
			{
				var info:CateCoryInfo = XmlSerialize.decodeType(xmllist[i],CateCoryInfo);
				list.push(info);
			}
			if(_func != null)
			{
				_func(this);
			}
		}
		
	}
}