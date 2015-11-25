package ddt.request
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	import road.serialize.xml.XmlSerialize;
	
	import ddt.data.BallInfo;
	import ddt.data.PathInfo;
	import ddt.loader.CompressTextLoader;
	import ddt.manager.PathManager;

	public class LoadBallList extends CompressTextLoader
	{
		private var path:String = "BallList.xml";
		
		public var list:Dictionary;
		
		public function LoadBallList()
		{
			super(PathManager.solveXMLPath()+path + "?" +Math.random(),null);
		}
		
		override protected function onTextReturn(txt:String):void
		{
			var xml:XML = new XML(txt);
//			trace(xml.toXMLString());
			list = new Dictionary();
			var xmllist:XMLList = xml..Item;
			var bcInfo:XML = describeType(new BallInfo());
			for(var i:int = 0;i < xmllist.length(); i ++)
			{
				var info:BallInfo = XmlSerialize.decodeType(xmllist[i],BallInfo,bcInfo);
				var flyingpartical:Array = xmllist[i].@FlyingPartical.split(",");
				var bombPartical:Array = xmllist[i].@BombPartical.split(",");
				info.BombPartical = bombPartical;
				info.FlyingPartical = flyingpartical;
				list[info.ID] = info;
			}
			super.onTextReturn(txt);
		}
		
	}
}