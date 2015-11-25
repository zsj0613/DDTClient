package ddt.request
{
	import flash.utils.Dictionary;
	
	import road.data.DictionaryData;
	import road.serialize.xml.XmlDecoder;
	
	import ddt.data.PathInfo;
	import ddt.manager.PathManager;
	import ddt.data.bossBoxInfo.BoxGoodsTempInfo;
	import ddt.loader.RequestLoader;
	
	public class LoadBoxTempInfo extends RequestLoader
	{
		private static const PATH:String = "BoxTemplateList.xml";
		private var _goodsList:XMLList;
		
		private var _boxTemplateID:Dictionary;
		public var inventoryItemList:DictionaryData;
		
		public function LoadBoxTempInfo(boxTemplateID:Dictionary)
		{
			super(PathManager.solveXMLPath()+PATH + "?" +Math.random(),null,false,false);
			_boxTemplateID = boxTemplateID;
		}
		
		override protected function onRequestReturn(xml:XML):void
		{	
			_goodsList = xml..Item;
			
			inventoryItemList = new DictionaryData();
			
			initDictionaryData();
			_partexceute();
		}
		
		private function _partexceute():void
		{
			for(var i:int = 0 ; i < _goodsList.length() ; i++)
			{
				var node1:XmlDecoder = new XmlDecoder();
				node1.readXmlNode(_goodsList[i]);
				
				var boxTempID:String = node1.getString("ID");
				if(_boxTemplateID[boxTempID])
				{
					var info:BoxGoodsTempInfo = new BoxGoodsTempInfo();
					info.TemplateId = node1.getInt("TemplateId");
					info.StrengthenLevel = node1.getInt("StrengthenLevel");
					info.IsBind = node1.getBoolean("IsBind");
					info.ItemCount = node1.getInt("ItemCount");
					info.LuckCompose = node1.getInt("LuckCompose");
					info.DefendCompose = node1.getInt("DefendCompose");
					info.AttackCompose = node1.getInt("AttackCompose");
					info.AgilityCompose = node1.getInt("AgilityCompose");
					info.ItemValid = node1.getInt("ItemValid");
					
					inventoryItemList[boxTempID].push(info);
				}
			}
		}
		
		private function initDictionaryData():void
		{
			for each(var id:String in _boxTemplateID)
			{
				var goodsArray:Array = new Array();
				
				inventoryItemList.add(id, goodsArray);
			}
		}
	}
}





