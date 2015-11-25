package ddt.request
{
	import flash.utils.describeType;
	
	import road.serialize.xml.XmlSerialize;
	
	import ddt.data.MovementInfo;
	import ddt.data.PathInfo;
	import ddt.loader.CompressTextLoader;
	import ddt.view.movement.MovementModel;
	import ddt.manager.PathManager;

	public class LoadActiveInfoAction extends CompressTextLoader
	{
		private static const PATH:String = "ActiveList.xml";
		
		private var _list:Array;
		public function get list():Array
		{
			return _list.slice(0);
		}
		
		public function LoadActiveInfoAction()
		{
			super(PathManager.solveXMLPath()+PATH + "?" +Math.random(),null);
		}
		
		override protected function onTextReturn(txt:String):void
		{
			var xml:XML = new XML(txt);
//			trace(txt);
			_list = new Array();
			var xmllist:XMLList = xml..Item;
			var bcInfo:XML = describeType(new MovementInfo());
			for(var i:int = 0; i < xmllist.length(); i ++)
			{
				var info:MovementInfo = XmlSerialize.decodeType(xmllist[i],MovementInfo,bcInfo);
				_list.push(info);
			}
			super.onTextReturn(txt);
		}
		
//		override protected function onRequestReturn(xml:XML):void
//		{
//			var xmllist:XMLList = xml..Item;
//			_list = new Array();
//			var bcInfo:XML = describeType(new MovementInfo());
//			for(var i:int = 0; i < xmllist.length(); i ++)
//			{
//				var info:MovementInfo = XmlSerialize.decodeType(xmllist[i],MovementInfo,bcInfo);
//				_list.push(info);
//			}
//		}
		
	}
}