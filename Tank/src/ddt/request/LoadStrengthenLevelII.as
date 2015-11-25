package ddt.request
{
	import flash.utils.Dictionary;
	
	import road.serialize.xml.XmlSerialize;
	
	import ddt.data.PathInfo;
	import ddt.data.store.StrengthenLevelII;
	import ddt.loader.CompressTextLoader;
	import ddt.manager.PathManager;
	
	/**********************************
	 *      加载关于强化,装备的等级与比值
	 *********************************/

	public class LoadStrengthenLevelII extends CompressTextLoader
	{
		public static const PATH:String = "ItemStrengthenList.xml";
		//public static const PATH:String = "ItemStrengthenList.xml";
		public var LevelItems1 : Dictionary;//武器
		public var LevelItems2 : Dictionary;//副武器
		public var LevelItems3 : Dictionary;//衣服
		public var LevelItems4 : Dictionary;//帽子
		private var _xml:XML;
		
		public function LoadStrengthenLevelII(paras:Object=null, isValidate:Boolean=false)
		{
			super(PathManager.solveXMLPath()+PATH + "?" +Math.random(),null);
			//SimpleLoading.instance.show();
/**
* 
*/
		}
		
		override protected function onTextReturn(txt:String):void
		{
			_xml = new XML(content);
			LevelItems1 = new Dictionary(true);
			LevelItems2 = new Dictionary(true);
			LevelItems3 = new Dictionary(true);
			LevelItems4 = new Dictionary(true);
			var xmllist:XMLList = _xml.Item;
			for(var i:int = 0; i < xmllist.length(); i ++)
			{
				var info: StrengthenLevelII = XmlSerialize.decodeType(xmllist[i],StrengthenLevelII);
				LevelItems1[info.StrengthenLevel] = info.Rock;
				LevelItems2[info.StrengthenLevel] = info.Rock1;
				LevelItems3[info.StrengthenLevel] = info.Rock2;
				LevelItems4[info.StrengthenLevel] = info.Rock3;
			}
			if(_func != null)
			{
				_func(this);
			}
			//SimpleLoading.instance.hide();
		}
		
	}
}