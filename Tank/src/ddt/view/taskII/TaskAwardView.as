package ddt.view.taskII
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.quest.QuestInfo;
	import ddt.data.quest.QuestItemReward;
	import ddt.manager.ItemManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.manager.TaskManager;
	
	import crazytank.view.task.QuestAwardViewAsset;

	public class TaskAwardView extends QuestAwardViewAsset
	{
		private var _info:QuestInfo;
		
		private var _optionalItemAwards:Array;
		private var _constantItemAwards:Array;
		private var _itemAwardCells:Array;
		private var _optionalCellArr:Array;
		private var _itemAwardPosX:Number;
		private var _itemAwardPosY:Number;
		
		
		public function set info(value:QuestInfo):void
		{
			_info = value;
			update();
		}
		
		public function TaskAwardView()
		{
			initView();
		}
		
		private function initView():void
		{
			
			var format:TextFormat = new TextFormat();
			format.font = "Arial";
			format.color = 0xffffff;
			format.size = 14;
			format.bold = true;
			
			exp_mc.lblCount.text = "";
			gold_mc.lblCount.text = "";
			money_mc.lblCount.text = "";
			exploit_mc.lblCount.text = "";
			wealth_mc.lblCount.text = "";
			gift_mc.lblCount.text = "";
			
			exp_mc.lblCount.defaultTextFormat = format;
			gold_mc.lblCount.defaultTextFormat = format;
			money_mc.lblCount.defaultTextFormat = format;
			exploit_mc.lblCount.defaultTextFormat = format;
			wealth_mc.lblCount.defaultTextFormat = format;
			gift_mc.lblCount.defaultTextFormat = format;
			cardAsset.valueTxt.defaultTextFormat = format;
			
			_optionalCellArr = new Array();
		}
		public function get optionalCells():Array{
			return _optionalCellArr;
		}
		private function get _cell():TaskAwardCell{
			return _itemAwardCells[_itemAwardCells.length];
		}
		private function getSexByInt(Sex:Boolean):int{
			if(Sex){
				return 1;
			}
			return 2;
		}
		private function update():void
		{
			
			exp_mc.visible = false;
			gold_mc.visible = false;
			money_mc.visible = false;
			exploit_mc.visible = false;
			wealth_mc.visible = false;
			gift_mc.visible = false;
			
			TaskManager.itemAwardSelected = 0;
			dropView()
			
			
			itemsTitle_mc.visible = true;
			itemsTitle_mc.y = opitionalItemsTitle_mc.y;
			opitionalItemsTitle_mc.visible = false;
			
			_itemAwardPosY = 24 + itemsTitle_mc.y
			for each(var temp:QuestItemReward in _info.itemRewards){
				var info:InventoryItemInfo = new InventoryItemInfo();
				info.TemplateID = temp.itemID;
				ItemManager.fill(info);
				if((0!=info.NeedSex)&&(getSexByInt(PlayerManager.Instance.Self.Sex) != info.NeedSex)){
					continue;
				}
				if(temp.isOptional == 0){
					_constantItemAwards.push(temp);
				}else if(temp.isOptional == 1){
					_optionalItemAwards.push(temp);
				}
			}
			
		
			var index:int = 0;
			if(_info.RewardGP>0){
				addReward(exp_mc,_info.RewardGP,index);
				index++;
			}
			if(_info.RewardGold>0){
				addReward(gold_mc,_info.RewardGold,index);
				index++;
			}
			if(_info.RewardMoney>0){
				addReward(money_mc,_info.RewardMoney,index);
				index++;
			}
			if(_info.RewardOffer>0){
				addReward(exploit_mc,_info.RewardOffer,index);
				index++;
			}
			if(_info.RewardRiches>0){
				addReward(wealth_mc,_info.RewardRiches,index);
				index++;
			}
			if(_info.RewardGiftToken>0){
				addReward(gift_mc,_info.RewardGiftToken,index);
				index++;
			}
			_itemAwardPosX = 10;
			_itemAwardPosY += (Math.floor(index/2)*25 + 26);
			cardAsset.x = 0;
			cardAsset.y = _itemAwardPosY;
			if(_info.RewardBuffID !=0){
				cardAsset.buffName_mc.gotoAndStop(_info.RewardBuffID - 11994);
				/*	11995 无限道具
					11996 防踢
					11997 双倍功勋
					11998 双倍经验
				*/
				var buffTime:int = _info.RewardBuffDate
				if(_info.data && _info.data.quality){
					buffTime = buffTime * _info.data.quality;
				}
				cardAsset.valueTxt.text = buffTime + LanguageMgr.GetTranslation("hours");
				cardAsset.visible = true;
				_itemAwardPosY += 32;
			}
			else
			{
				cardAsset.valueTxt.text = "";
				cardAsset.visible = false;
			}
			
			drawItemAwardSet(_constantItemAwards);
			_itemAwardPosY+=16;
			if(_optionalItemAwards.length>0){
				opitionalItemsTitle_mc.visible = true;
				drawItemAwardSet(_optionalItemAwards,true);
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
			
		private function drawItemAwardSet(itemsArray:Array,opitional:Boolean = false):void{
			if(itemsArray.length<=0){
				return;
			}
			for(var i:int = 0;i<itemsArray.length;i++){
				var cell:TaskAwardCell = new TaskAwardCell();
				cell.x = 4;
				cell.y = _itemAwardPosY + i*60;
				if(opitional){
					cell.x = 206;
					cell.y = 32 + i*60
				}
				var tempItem:QuestItemReward = itemsArray[i];
				var info:InventoryItemInfo = new InventoryItemInfo();
				info.ValidDate = tempItem.ValidateTime;
				info.TemplateID = tempItem.itemID;
				info.IsJudge = true;
				info.IsBinds = tempItem.isBind;
				info.AttackCompose = tempItem.AttackCompose;
				info.DefendCompose = tempItem.DefendCompose;
				info.AgilityCompose = tempItem.AgilityCompose;
				info.LuckCompose = tempItem.LuckCompose;
				info.StrengthenLevel = tempItem.StrengthenLevel;
				
				ItemManager.fill(info);
				if(info && info.TemplateID != 0)
				{
					cell.visible = true;
					cell.info = info;
					cell.count = tempItem.count;
					if(tempItem.IsCount && _info.data && _info.data.quality){
						cell.count = tempItem.count * _info.data.quality;
					}
					_itemAwardCells.push(cell);
					if(opitional){
						TaskManager.itemAwardSelected = -1;
						cell.canBeSelected();
						cell.addEventListener(AwardSelectedEvent.ITEM_SELECTED,__chooseItemAward);
						_optionalCellArr.push(cell)
					}
					addChild(cell);
					
				}
				else
				{
					cell.visible = false;
					if(cell.parent)
						cell.parent.removeChild(cell);
					cell = null;
				}
			}
			
		}
		private function addReward(reward:Sprite,count:int,index:int):void{
			reward.visible = true;
			reward["lblCount"].text = count;
			if(_info.data && _info.data.quality>1){
				reward["lblCount"].text = count*_info.data.quality;
			}
			reward.x = index%2*100;
			if(count > 100000){
				reward["lblCount"].x = 30
			}
			reward.y = int(index/2)*25 + _itemAwardPosY;
		}
		private function dropView():void{
			for each(var cell:TaskAwardCell in _itemAwardCells){
				cell.removeEventListener(MouseEvent.CLICK,__chooseItemAward);
				if(cell.parent){
					cell.parent.removeChild(cell);
				}
				cell = null;
			}
			
			_itemAwardCells = new Array();
			_constantItemAwards = new Array();
			_optionalItemAwards = new Array();
		}
		private function __chooseItemAward(evt:AwardSelectedEvent):void{
			for each(var cell:TaskAwardCell in _itemAwardCells){
				cell.selected = false;
			}
			evt.itemCell.selected = true;
		}
		public function dispose():void
		{
			_info = null;
			for each(var _cell:TaskAwardCell in _itemAwardCells){
				if(_cell.parent){
					_cell.parent.removeChild(_cell);
					_cell.dispose();
					_cell = null;
				}
			}
		}
	}
}