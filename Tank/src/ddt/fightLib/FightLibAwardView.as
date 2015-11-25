package ddt.fightLib
{
	import road.ui.controls.SimpleGrid;
	
	import ddt.manager.ItemManager;
	import ddt.manager.LanguageMgr;
	import ddt.view.taskII.TaskAwardCell;
	import tank.fightLib.FightLibAwardAsset;

	public class FightLibAwardView extends FightLibAwardAsset
	{
		private var _list:SimpleGrid;
		private var _gift:int;
		private var _exp:int;
		private var _items:Array;
		public function FightLibAwardView()
		{
			_list = new SimpleGrid(157,67,2);
			_list.setSize(322,228);
			_list.x = 4;
			_list.y = 120;
			addChild(_list);
		}
		
		public function setGiftAndExpNum(giftValue:int,expValue:int):void
		{
			_gift = giftValue;
			_exp = expValue;
			updateTxt();
		}
		
		public function setAwardItems(value:Array):void
		{
			_items = value;
			updateList();
		}
		
		private function updateTxt():void
		{
			var str:String = "";
			if(_exp > 0)
			{
				str = LanguageMgr.GetTranslation("ddt.fightLib.FightLibAwardView.exp") + _exp.toString() + " ,";
			}
			if(_gift > 0)
			{
				str += LanguageMgr.GetTranslation("ddt.gameover.takecard.gifttoken") + _gift.toString();
			}
			awardTxt.text = str;
		}
		
		private function updateList():void
		{
			_list.clearItems();
			for each(var i:Object in _items)
			{
				var cell:TaskAwardCell = new TaskAwardCell();
				cell.info = ItemManager.Instance.getTemplateById(i.id);
				cell.count = i.count;
				_list.appendItem(cell);
			}
		}
		
		public function dispose():void
		{
			_items = null;
			_list.clearItems();
			_list = null;
			if(parent)
			{
				parent.removeChild(this);
			}
		}
	}
}