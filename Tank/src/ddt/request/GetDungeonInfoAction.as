package ddt.request
{
	import flash.utils.describeType;
	
	import road.serialize.xml.XmlSerialize;
	
	import ddt.data.DungeonInfo;
	import ddt.manager.PathManager;
	import ddt.loader.CompressTextLoader;

	/**
	 * 获取全部地图信息 
	 * @author SYC
	 * 
	 */
	public class GetDungeonInfoAction extends CompressTextLoader
	{
		private static const PATH:String = "PVEList.xml";
		
		public var list:Array;
		
		public function GetDungeonInfoAction()
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
				var mcInfo:XML = describeType(new DungeonInfo());
				for(var i:int = 0;i < xmllist.length(); i ++)
				{
					var info:DungeonInfo = XmlSerialize.decodeType(xmllist[i],DungeonInfo,mcInfo);
					if(info.Name == "") continue;
					list.push(info);
				}
				super.onTextReturn(txt);
			}
		}	
	}
}