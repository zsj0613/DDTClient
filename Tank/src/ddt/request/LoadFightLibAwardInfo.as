package ddt.request
{
	import road.loader.TextLoader;
	
	import ddt.data.FightLibAwardInfo;
	import ddt.data.FightLibInfo;
	import ddt.data.PathInfo;
	import ddt.loader.CompressTextLoader;
	import ddt.loader.RequestLoader;
	import ddt.manager.PathManager;
	
	public class LoadFightLibAwardInfo extends CompressTextLoader
	{
		private static var PATH:String = "FightLabDropItemList.xml";
		public var list:Array;
		public function LoadFightLibAwardInfo()
		{
			list = [];
			super(PathManager.solveXMLPath()+PATH + "?" +Math.random(),null);
		}
		
		override protected function onTextReturn(txt:String):void
		{
			var tempList:Array = [];
			var infos:XMLList = XML(txt).Item;
			for each(var awardInfo:XML in infos)
			{
				var awardItem:Object = new Object();
				awardItem.id = int(awardInfo.@ID);
				awardItem.diff = int(awardInfo.@Easy);
				awardItem.itemID = int(awardInfo.@AwardItem);
				awardItem.count = int(awardInfo.@Count);
				tempList.push(awardItem);
			}
			sortItems(tempList);
			super.onTextReturn(txt);
		}
		
		private function sortItems(items:Array):void
		{
			for each(var item:Object in items)
			{
				pushInListByIDAndDiff({id:item.itemID,count:item.count},item.id,item.diff);
			}
		}
		
		private function pushInListByIDAndDiff(item:Object,id:int,diff:int):void
		{
			var awardInfo:FightLibAwardInfo = findAwardInfoByID(id);
			switch(diff)
			{
				case FightLibInfo.EASY:
					awardInfo.easyAward.push(item);
					break;
				case FightLibInfo.NORMAL:
					awardInfo.normalAward.push(item);
					break;
				case FightLibInfo.DIFFICULT:
					awardInfo.difficultAward.push(item);
					break;
				default:
					break;
			}
		}
		
		private function findAwardInfoByID(id:int):FightLibAwardInfo
		{
			var result:FightLibAwardInfo;
			for(var i:int=0;i<list.length;i++)
			{
				if(list[i].id == id)
				{
					result = list[i];
					break;
				}
			}
			if(result == null)
			{
				result = new FightLibAwardInfo();
				result.id = id;
				list.push(result);
			}
			return result;
		}
	}
}