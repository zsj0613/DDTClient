package ddt.request
{
	import flash.events.Event;
	import flash.utils.describeType;
	
	import road.serialize.xml.XmlSerialize;
	
	import ddt.data.PathInfo;
	import ddt.data.RegisterDropInfo;
	import ddt.loader.CompressTextLoader;
	import ddt.manager.PathManager;


	public class GetRegisterDropList extends CompressTextLoader
	{
		private static const PATH:String = "DropList.xml";
		
		public var list:Array;
		
		public function GetRegisterDropList()
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
				var mcInfo:XML = describeType(new RegisterDropInfo());
				for(var i:int = 0;i < xmllist.length(); i ++)
				{
					var info:RegisterDropInfo = XmlSerialize.decodeType(xmllist[i],RegisterDropInfo,mcInfo);
					list.push(info);
				}
				super.onTextReturn(txt);
			}
		}	
		
	}
}