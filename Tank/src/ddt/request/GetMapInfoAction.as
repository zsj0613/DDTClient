package ddt.request
{
	import flash.utils.describeType;
	
	import road.serialize.xml.XmlSerialize;
	
	import ddt.data.MapInfo;
	import ddt.data.PathInfo;
	import ddt.loader.CompressTextLoader;
	import ddt.manager.PathManager;

	/**
	 * 获取全部地图信息 
	 * @author SYC
	 * 
	 */
	public class GetMapInfoAction extends CompressTextLoader
	{
		private static const PATH:String = "MapList.xml";
		
		public var list:Array;
		
		public function GetMapInfoAction()
		{
			super(PathManager.solveXMLPath()+PATH + "?" +Math.random(),null);
		}
		
		override protected function onTextReturn(txt:String):void
		{
			var xml:XML = new XML(txt);
			if(xml.@value == "false") 
			{ 
				isSuccess = false;
			}
			else
			{
				list = new Array();
				var xmllist:XMLList = xml..Item;
				var mcInfo:XML = describeType(new MapInfo());
				for(var i:int = 0;i < xmllist.length(); i ++)
				{
					var info:MapInfo = XmlSerialize.decodeType(xmllist[i],MapInfo,mcInfo);
					if(info.Name == "") continue;
					if(info.ID > 2000)
					{
						info.canSelect = false;
					}
					else
					{
						info.canSelect = true;
					}
					list.push(info);
				}
				super.onTextReturn(txt);
			}
		}	
	}
}