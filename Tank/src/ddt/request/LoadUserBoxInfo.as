package ddt.request
{

	
	import flash.utils.Dictionary;
	
	import road.data.DictionaryData;
	import road.serialize.xml.XmlDecoder;
	
	import ddt.data.bossBoxInfo.GradeBoxInfo;
	import ddt.data.bossBoxInfo.TimeBoxInfo;
	import ddt.loader.CompressTextLoader;
	import ddt.loader.RequestLoader;
	import ddt.data.PathInfo;
	import ddt.manager.PathManager;
	
	public class LoadUserBoxInfo extends RequestLoader
	{
		private static const PATH:String = "Box.xml";
		private var _goodsList:XMLList;
		
		public var timeBoxList:DictionaryData;
		public var gradeBoxList:DictionaryData;
		public var boxTemplateID:Dictionary;
		
		public function LoadUserBoxInfo()
		{
			super(PathManager.solveXMLPath()+PATH + "?" +Math.random(),null,false,false);
		}
		
	 	override protected function onRequestReturn(xml:XML):void
		{	
			_goodsList = xml..Item;
		//	trace(xml.toString());
			
			timeBoxList = new DictionaryData();
			gradeBoxList = new DictionaryData();
			boxTemplateID = new Dictionary();

			_partexceute();
		}
		
		private function _partexceute():void
		{
			for(var i:int = 0 ; i < _goodsList.length() ; i++)
			{
				var node1:XmlDecoder = new XmlDecoder();
				node1.readXmlNode(_goodsList[i]);
				
				var type:int = node1.getInt("Type");
				switch(type)
				{
					case 0:
						var timeInfo:TimeBoxInfo = new TimeBoxInfo();
						timeInfo.boxID = node1.getInt("ID");
						timeInfo.Level = node1.getInt("Level");
						timeInfo.time = node1.getInt("Condition");
						timeInfo.TemplateIDList = node1.getString("TemplateID");
						boxTemplateID[timeInfo.TemplateIDList] = timeInfo.TemplateIDList;
						
						timeBoxList.add(timeInfo.boxID, timeInfo);
						break;
					case 1:
						var gradeInfo:GradeBoxInfo = new GradeBoxInfo();
						gradeInfo.boxID = node1.getInt("ID");
						gradeInfo.Level = node1.getInt("Level");
						gradeInfo.sex = (node1.getInt("Condition") == 1)?true:false;
						gradeInfo.TemplateIDList = node1.getString("TemplateID");
						boxTemplateID[gradeInfo.TemplateIDList] = gradeInfo.TemplateIDList;
						
						gradeBoxList.add(gradeInfo.boxID, gradeInfo);
						break;
					default:
						break;
				}
			}
		}

	}
}