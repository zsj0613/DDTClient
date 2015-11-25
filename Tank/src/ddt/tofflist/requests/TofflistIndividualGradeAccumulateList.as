package ddt.tofflist.requests
{
	import flash.utils.describeType;
	
	import road.serialize.xml.XmlSerialize;
	
	import ddt.loader.CompressTextLoader;
	import ddt.tofflist.TofflistModel;
	import ddt.tofflist.data.TofflistPlayerInfo;
	import ddt.data.PathInfo;
	import ddt.manager.PathManager;

	public class TofflistIndividualGradeAccumulateList extends CompressTextLoader
	{
		public var list:Array;
		private var _xml:XML;
		private static const PATH:String = "CelebByGPList.xml";
		private var _path:String;
		public function TofflistIndividualGradeAccumulateList(path:String = "CelebByGPList.xml")
		{
			_path = path;
			super(PathManager.solveXMLPath()+_path+"?"+Math.random());
		}
		override protected function onTextReturn(txt:String):void
		{
			_xml = new XML(content);
			list = new Array();
			
			TofflistModel.Instance.lastUpdateTime = _xml.@date;
			
			var xmllist:XMLList = XML(_xml)..Item;
			var _tempInfo:TofflistPlayerInfo = new TofflistPlayerInfo();
			var _xmlInfo:XML = describeType(_tempInfo);
			for(var i:int = 0; i < xmllist.length(); i++)
			{
				var p:TofflistPlayerInfo= new TofflistPlayerInfo();
				p.beginChanges();
				XmlSerialize.decodeObject(xmllist[i],p);
				p.commitChanges();
				list.push(p);
				
			}
//			for(var i:int = 0; i < xmllist.length(); i++)
//			{
//				list.push(XmlSerialize.decodeType(xmllist[i],TofflistPlayerInfo));
//			}
			if(_func != null)
			{
				_func(this);
			}
		}
	}
}