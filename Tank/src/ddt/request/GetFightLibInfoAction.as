package ddt.request
{
	import flash.utils.describeType;
	
	import road.serialize.xml.XmlSerialize;
	
	import ddt.data.FightLibInfo;
	import ddt.data.PathInfo;
	import ddt.loader.CompressTextLoader;
	import ddt.manager.PathManager;
	
	public class GetFightLibInfoAction extends CompressTextLoader
	{
		private static const PATH:String = "FightLibInfo.xml";
		
		public var list:Array;
		
		public function GetFightLibInfoAction()
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
				var mcInfo:XML = describeType(new FightLibInfo());
				for(var i:int = 0;i < xmllist.length(); i ++)
				{
					var info:FightLibInfo = XmlSerialize.decodeType(xmllist[i],FightLibInfo,mcInfo);
					if(info.name == "") continue;
					list.push(info);
				}
				super.onTextReturn(txt);
			}
		}
	}
}