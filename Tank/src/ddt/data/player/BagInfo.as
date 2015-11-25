package ddt.data.player
{
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import road.data.DictionaryData;
	
	import ddt.data.EquipType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.manager.SocketManager;
	import ddt.view.bagII.BagEvent;
	
	[Event(name="update",type="ddt.view.bagII.BagEvent")]
	public class BagInfo extends EventDispatcher
	{
		public static const EQUIPBAG:int = 0;
		public static const PROPBAG:int = 1;
		public static const TASKBAG:int = 2;
		public static const FIGHTBAG:int = 3;
		public static const TEMPBAG:int = 4;
		public static const CONSORTIA:int = 11;
		
		public static const STOREBAG:int = 12;
		
		private var _type:int;
		//private var _capability:int;
		
		private var _items:DictionaryData;
		
		public function BagInfo(type:int,a:int=0)
		{	
			_type = type;		
			_items = new DictionaryData();
			// _capability = capability;
		}
		
		public function get BagType():int
		{
			return _type;
		}
		
		public function getItemAt(slot:int):InventoryItemInfo
		{
			return _items[slot];
		}
		
		public function get items():DictionaryData
		{
			return _items;
		}
		
		public function get itemNumber():int
		{
			var result:int = 0;
			for(var i:int=0; i<49; i++)
			{
				if(_items[i] != null) result++;
			}
			return result;
		}
		
		public function set items(dic:DictionaryData):void
		{
			_items = dic;
		}
		
		public function addItem(item:InventoryItemInfo):void
		{
			item.BagType = _type;
			_items.add(item.Place,item);
//			trace(item.BagType + "战利品增加： 1个" + item.Name);
			onItemChanged(item.Place,item);
		}
		
		public function removeItemAt(slot:int):void
		{
			var item:InventoryItemInfo = _items[slot];
			if(item)
			{
				_items.remove(slot);
	//			delete _items[slot];
				onItemChanged(slot,item);
			}	
		}
		
		public function updateItem(item:InventoryItemInfo):void
		{
			if(item.BagType == _type)
			{
				onItemChanged(item.Place,item);
			}
		}
		
		private var _changedCount:int = 0;
		private var _changedSlots:Dictionary = new Dictionary();
		
		public function beginChanges():void
		{
			_changedCount ++;
		}
		
		public function commiteChanges():void
		{
			_changedCount --;
			if(_changedCount <= 0)
			{
				_changedCount = 0;
				updateChanged();
			}
		}
		
		protected function onItemChanged(slot:int,value:InventoryItemInfo):void
		{
			_changedSlots[slot] = value;
			if(_changedCount <= 0)
			{
				_changedCount = 0;
				updateChanged();
			}
		}
		
		protected function updateChanged():void
		{
			dispatchEvent(new BagEvent(BagEvent.UPDATE,_changedSlots));
			_changedSlots = new Dictionary();
		}
		
		public function findItems(categoryId:int,validate:Boolean = true):Array
		{
			var list:Array = new Array();
			for each(var i:InventoryItemInfo in _items)
			{
				if(i.CategoryID == categoryId)
				{
					if(!validate || i.getRemainDate() > 0)
					{
						list.push(i);
					}
				}
			}
			return list;
		}
		
		public function findFirstItem(categoryId:int,validate:Boolean = true):InventoryItemInfo
		{
			for each(var i:InventoryItemInfo in _items)
			{
				if(i.CategoryID == categoryId)
				{
					if(!validate || i.getRemainDate() > 0)
					{
						return i;
					}
				}
			}
			return null;
		}
		public function findEquipedItemByTemplateId(TemplateID:int,validate:Boolean = true):InventoryItemInfo
		{
			for each(var i:InventoryItemInfo in _items)
			{
				if(i.TemplateID == TemplateID)
				{
					if(i.Place > 30){
						continue;
					}
					if(!validate || i.getRemainDate() > 0)
					{
						return i;
					}
				}
			}
			return null;
		}
		public const NUMBER:Number=1.00000000;
		public function findOvertimeItems(lefttime:Number = 0):Array
		{
			var list:Array = new Array();
			for each(var i:InventoryItemInfo in _items)
			{
				var num:Number=i.getRemainDate();
				if( num > lefttime && num < NUMBER )
				{
					list.push(i);
				}
			}
			return list;
		}
		
		public function findOvertimeItemsByBody():Array
		{
			var list:Array = [];
			for(var i:uint = 0; i < 30; i++)
			{
				if((_items[i] as InventoryItemInfo))
				{
					var num:Number=(_items[i] as InventoryItemInfo).getRemainDate();
					if(num <= 0)
						list.push(_items[i]);
				}
			}
			return list;
		}
		
		public function findItemsForEach(categoryId:int,validate:Boolean = true):Array
		{
			var t:DictionaryData = new DictionaryData();
			for each(var i:InventoryItemInfo in _items)
			{
				if(i.CategoryID == categoryId && t[i.TemplateID] == null)
				{
					if(!validate || i.getRemainDate() > 0)
					{
						t.add(i.TemplateID,i);
					}
				}
			}
			return t.list;
		}
		
		public function findFistItemByTemplateId(templateId:int,validate:Boolean = true,usedFirst:Boolean = false):InventoryItemInfo
		{
			var used:InventoryItemInfo = null;
			var normal:InventoryItemInfo = null;
			for each(var i:InventoryItemInfo in _items)
			{
				if(i.TemplateID == templateId && (!validate || i.getRemainDate() > 0))
				{
					if(usedFirst)
					{
						if(i.IsUsed)
						{
							if(used == null)
							{
								used = i;
							}
						}
						else
						{
							if(normal == null)
							{
								normal = i;
							}
						}
					}
					else
					{
						return i;
					}
				}
			}
			return used ? used : normal;
		}
		
		public function findBodyThingByCategory(id:int):Array
		{
			var arr:Array = new Array();
			
			for(var i:int = 0; i < 30 ;i++)
			{
				var item:InventoryItemInfo = _items[i] as InventoryItemInfo;
				
				if(item == null)
				{
					continue;
				}
				
				if(item.CategoryID == id)
				{
					arr.push(item);
				}
			}
			
			return arr;
		}
		
		public function getItemCountByTemplateId(templateId:int,validate:Boolean = true):int
		{
			var count:int = 0;
			for each(var i:InventoryItemInfo in _items)
			{
				if(i.TemplateID == templateId && (!validate || i.getRemainDate() > 0))
				{
					count += i.Count;
				}
			}
			return count;
		}
		
		public function findItemsByTempleteID(templeteID:int,validate:Boolean = true):Array
		{
			var t:DictionaryData = new DictionaryData();
			for each(var i:InventoryItemInfo in _items)
			{
				if(i.TemplateID == templeteID && t[i.TemplateID] == null)
				{
					if(!validate || i.getRemainDate() > 0)
					{
						t.add(i.TemplateID,i);
					}
				}
			}
			return t.list;
		}
		
		public function clearnAll():void
		{
			for(var i:int=0; i<49; i++)
			{
				removeItemAt(i);
			}
		}
		
		public function unlockItem(item:InventoryItemInfo):void
		{
			item.lock = false;
			onItemChanged(item.Place,item);
		}
		
		public function unLockAll():void
		{
			beginChanges();
			for each(var i:InventoryItemInfo in _items)
			{
				if(i.lock)
				{
					onItemChanged(i.Place,i);
				}
				i.lock = false;
			}
			commiteChanges();
		}
		
		/**
		 * 批量整理(移动)
		 */	
 		public function Finishing(bagInfo:BagInfo, startPlace:int, endPlace:int):void
		{
  			var bagData:DictionaryData=bagInfo.items;  			
  			var arrayBag:Array=[];
  			var arrayBag2:Array=[];
  			
			var CategoryIDSort:int=0;
			var listLen:int=bagData.list.length;
   			for(var i:int;i<listLen;i++)
  			{
  				if(int(bagData.list[i].Place)>=startPlace)
  				{
	  				arrayBag.push({TemplateID:bagData.list[i].TemplateID, ItemID:bagData.list[i].ItemID, CategoryIDSort:getBagGoodsCategoryIDSort(uint(bagData.list[i].CategoryID)), Place:bagData.list[i].Place, RemainDate:bagData.list[i].getRemainDate()>0, CanStrengthen:bagData.list[i].CanStrengthen, StrengthenLevel:bagData.list[i].StrengthenLevel, IsBinds:bagData.list[i].IsBinds});
  				}
  			}
  			
			var fooBA:ByteArray = new ByteArray();
			fooBA.writeObject(arrayBag);
			fooBA.position = 0;
			arrayBag2 = fooBA.readObject() as Array;
  			
  			arrayBag.sortOn(["RemainDate", "CategoryIDSort", "TemplateID", "CanStrengthen", "IsBinds", "StrengthenLevel", "Place"], [Array.DESCENDING, Array.NUMERIC, Array.NUMERIC | Array.DESCENDING, Array.DESCENDING, Array.DESCENDING, Array.NUMERIC | Array.DESCENDING, Array.NUMERIC]);
			
    		if(bagComparison(arrayBag, arrayBag2, startPlace))
  			{
  				return;
  			}

  			SocketManager.Instance.out.sendMoveGoodsAll(bagInfo.BagType, arrayBag, startPlace);
		}
		
		public function getBagGoodsCategoryIDSort(CategoryID:uint):int
		{
			var arrCategoryIDSort:Array=[EquipType.ARM, EquipType.OFFHAND, EquipType.HEAD, EquipType.CLOTH, EquipType.ARMLET, EquipType.RING, EquipType.GLASS, EquipType.NECKLACE, EquipType.SUITS, EquipType.WING, EquipType.HAIR, EquipType.FACE, EquipType.EFF, EquipType.CHATBALL];//按照物品类型进行排序
			for(var i:int=0;i<arrCategoryIDSort.length;i++)
			{
				if(CategoryID==arrCategoryIDSort[i])
				{
					return i;
				}
			}
			
			return 9999;
		}
		
		private function bagComparison(bagArray1:Array, bagArray2:Array, startPlace:int):Boolean
		{
			if(bagArray1.length<bagArray2.length)
			{
				return false;
			}

			var len:int=bagArray1.length;
			for(var i:int=0;i<len;i++)
			{
				if((i+startPlace)!=bagArray2[i].Place || bagArray1[i].ItemID!=bagArray2[i].ItemID || bagArray1[i].TemplateID!=bagArray2[i].TemplateID)
				{
					return false;
				}
			}
			
			return true;
		}
		
		//取得在物品栏中的物品总计
		public function itemBgNumber(startPlace:int, endPlace:int):int
		{
			var result:int = 0;
			for(var i:int=startPlace; i<=endPlace; i++)
			{
				if(_items[i] != null) result++;
			}
			return result;
		}
	}
}