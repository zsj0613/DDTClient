package ddt.store.data
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import road.data.DictionaryData;
	import road.data.DictionaryEvent;
	
	import ddt.store.events.StoreBagEvent;
	import ddt.store.events.UpdateItemEvent;
	
	import ddt.data.EquipType;
	import ddt.data.StoneType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.player.BagInfo;
	import ddt.data.player.PlayerInfo;
	import ddt.data.player.SelfInfo;
	import ddt.view.bagII.BagEvent;
	
	public class StoreModel extends EventDispatcher
	{
		private static const FORMULA_FLOCCULANT:int = 11301;
		private static const FORMULA_BIRD:int       = 11201;
		private static const FORMULA_SNAKE:int      = 11202;
		private static const FORMULA_DRAGON:int     = 11203;
		private static const FORMULA_TIGER:int      = 11204;
		
		private static const FORMULA_RING:int    = 11302; //戒指熔炼公式
		private static const FORMULA_BANGLE:int  = 11303; //手镯熔炼公式
		
		private static const RING_TIANYU:int = 9002; //天羽
		private static const RIN_GZHUFU:int  = 8002;  //祝福
		
		
		
		private var _info:SelfInfo;
		private var _equipmentBag:DictionaryData;           //装备背包
		private var _propBag:DictionaryData;                //道具背包
	
		private var _canCpsEquipmentList:DictionaryData;    //可以合成的装备
		private var _canStrthEqpmtList:DictionaryData;      //可以强化的装备：衣服，帽子，武器
		private var _strthAndANchList:DictionaryData;       //强化石与神符、幸运符（符咒）
		private var _cpsAndANchList:DictionaryData;         //合成石（青龙、白虎、朱雀、玄武）与符咒
		private var _cpsAndStrthAndformula:DictionaryData;  //合成石，强化石，与熔炼公式
		private var _canTransEquipmengtList:DictionaryData; //可以转移的装备
		private var _canRongLiangEquipmengtList:DictionaryData;//可以熔练的装备
		private var _canLianhuaEquipList:DictionaryData;    //可以炼化的装备
		private var _canLianhuaPropList:DictionaryData;     //可以炼化的道具
		private var _canEmbedEquipList:DictionaryData;      //可以镶嵌的装备
		private var _canEmbedPropList:DictionaryData;       //可以镶嵌的道具
		
		
		private var _currentPanel:int;                      //当前铁匠铺的面板
		
		private var _needAutoLink:int = 0;
		
		public function StoreModel(info:PlayerInfo)
		{
			_info         = info as SelfInfo;
			_equipmentBag = _info.Bag.items;
			_propBag      = _info.PropBag.items;	
				
			initData();
			initEvent();
		}
		
		private function initData():void
		{
			_canStrthEqpmtList      = new DictionaryData();
			_canCpsEquipmentList    = new DictionaryData();
			_strthAndANchList       = new DictionaryData();
			_cpsAndANchList         = new DictionaryData();
			_cpsAndStrthAndformula  = new DictionaryData();
			_canTransEquipmengtList = new DictionaryData();
			_canLianhuaEquipList    = new DictionaryData();
			_canLianhuaPropList     = new DictionaryData();
			_canEmbedEquipList      = new DictionaryData();
			_canEmbedPropList       = new DictionaryData();
			
			_canRongLiangEquipmengtList = new DictionaryData();
			
			pickValidItemsOutOf(_equipmentBag,true);
			pickValidItemsOutOf(_propBag,false);
			
			_canStrthEqpmtList      = sortEquipList(_canStrthEqpmtList);
			_canCpsEquipmentList    = sortEquipList(_canCpsEquipmentList);
			_strthAndANchList       = sortPropList(_strthAndANchList);
			_cpsAndANchList         = sortPropList(_cpsAndANchList,true);			
			_cpsAndStrthAndformula  = sortPropList(_cpsAndStrthAndformula);			
			_canTransEquipmengtList = sortEquipList(_canTransEquipmengtList);
			_canLianhuaEquipList    = sortEquipList(_canLianhuaEquipList);
			_canLianhuaPropList     = sortPropList(_canLianhuaPropList);
			_canEmbedEquipList      = sortEquipList(_canEmbedEquipList);
			_canEmbedPropList       = sortPropList(_canEmbedPropList);
			
			_canRongLiangEquipmengtList = sortRoogEquipList(_canRongLiangEquipmengtList);	
		}
		
		private function pickValidItemsOutOf(bag:DictionaryData,isEquip:Boolean):void
		{
			for each(var item:InventoryItemInfo in bag)
			{
				if(isEquip)
				{ 
					/**可以强化的装备*/
					if(isProperTo_CanStrthEqpmtList(item))
					{					
						_canStrthEqpmtList.add(_canStrthEqpmtList.length,item);
					}
					/**可以合成的装备*/
					if(isProperTo_CanCpsEquipmentList(item))
					{
						_canCpsEquipmentList.add(_canCpsEquipmentList.length,item);
					}
					/**可熔炼的装备*/
					if(isProperTo_CanRongLiangEquipmengtList(item))
					{
						_canRongLiangEquipmengtList.add(_canCpsEquipmentList.length,item);
					}
					/**可以转移属性的装备*/	
					if(isProperTo_CanTransEquipmengtList(item))
					{
						_canTransEquipmengtList.add(_canTransEquipmengtList.length,item);
					}
					/**可以炼化的装备*/
					if(isProperTo_canLianhuaEquipList(item))
					{
						_canLianhuaEquipList.add(_canLianhuaEquipList.length,item);
					}
					/**可以镶嵌的装备*/
					if(isProperTo_CanEmbedEquipList(item))
					{
						_canEmbedEquipList.add(_canEmbedEquipList.length,item);
					}
				}else
				{
					/**强化石与符咒*/
					if(isProperTo_StrthAndANchList(item))
					{
						_strthAndANchList.add(_strthAndANchList.length,item);
					}
					/**合成石与符咒*/	
					if(isProperTo_CpsAndANchList(item))
					{
						_cpsAndANchList.add(_cpsAndANchList.length,item);
					}
					/**合成石、强化石与熔炼公式*/
					if(isProperTo_CpsAndStrthAndformula(item))
					{
						_cpsAndStrthAndformula.add(_cpsAndStrthAndformula.length,item);
					}
					/**炼化的材料*/
					if(isProperTo_canLianhuaPropList(item))
					{
						_canLianhuaPropList.add(_canLianhuaPropList.length,item);
					}
					/**可以镶嵌的材料*/
					if(isProperTo_CanEmbedPropList(item))
					{
						_canEmbedPropList.add(_canEmbedPropList.length,item);
					}
				}
			}
		}
		
		/**
		 *  监听包包 当有装备或者道具跟新时触发update事件 
		 */
		private function initEvent():void
		{
			_info.PropBag.addEventListener(BagEvent.UPDATE,updateBag);
			_info.Bag.addEventListener(BagEvent.UPDATE,updateBag)
		}
		
		private function updateBag(evt:BagEvent):void
		{
			var bag:BagInfo = evt.target as BagInfo;
			var changes:Dictionary = evt.changedSlots;
			for each(var i:InventoryItemInfo in changes)
			{
				var c:InventoryItemInfo = bag.getItemAt(i.Place);
				if(c)
				{
					if(bag.BagType == BagInfo.EQUIPBAG)
					{
						__updateEquip(c)
					}else if(bag.BagType == BagInfo.PROPBAG)
					{
						__updateProp(c);
					}
				}else
				{
					if(bag.BagType == BagInfo.EQUIPBAG)
					{
						removeFrom(i,_canStrthEqpmtList);
						removeFrom(i,_canCpsEquipmentList);
						removeFrom(i,_canTransEquipmengtList);
						removeFrom(i,_canLianhuaEquipList);
						removeFrom(i,_canEmbedEquipList);
						removeFrom(i,_canRongLiangEquipmengtList);
					}else
					{
						removeFrom(i,_strthAndANchList);
						removeFrom(i,_cpsAndANchList);
						removeFrom(i,_cpsAndStrthAndformula);
						removeFrom(i,_canLianhuaPropList);
						removeFrom(i,_canEmbedPropList);
					}
				}
			}
		}
		
		private function __updateEquip(item:InventoryItemInfo):void
		{
			if(isProperTo_CanStrthEqpmtList(item))
			{
				updateDic(_canStrthEqpmtList,item);
			}else
			{
				removeFrom(item,_canStrthEqpmtList);
			}
			if(isProperTo_CanCpsEquipmentList(item))
			{
				updateDic(_canCpsEquipmentList,item);
			}else
			{
				removeFrom(item,_canCpsEquipmentList);
			}
			if(isProperTo_CanTransEquipmengtList(item))
			{
				updateDic(_canTransEquipmengtList,item);
			}else
			{
				removeFrom(item,_canTransEquipmengtList);
			}
			if(isProperTo_CanRongLiangEquipmengtList(item))
			{
				updateDic(_canRongLiangEquipmengtList,item);
			}else
			{
				removeFrom(item,_canRongLiangEquipmengtList);
			}
			if(isProperTo_canLianhuaEquipList(item))
			{
				updateDic(_canLianhuaEquipList,item);
			}else
			{
				removeFrom(item,_canLianhuaEquipList);
			}
			if(isProperTo_CanEmbedEquipList(item))
			{
				updateDic(_canEmbedEquipList,item);
			}else
			{
				removeFrom(item,_canEmbedEquipList);
			}
		}
		
		private function __updateProp(item:InventoryItemInfo):void
		{
			if(isProperTo_CpsAndANchList(item))
			{   
			    updateDic(_cpsAndANchList,item);
			}else
			{
				removeFrom(item,_cpsAndANchList);
			}
			if(isProperTo_CpsAndStrthAndformula(item))
			{
				updateDic(_cpsAndStrthAndformula,item);
			}else
			{
				removeFrom(item,_cpsAndStrthAndformula);
			}
			if(isProperTo_StrthAndANchList(item))   
			{
			    updateDic(_strthAndANchList,item);
			}else
			{
				removeFrom(item,_strthAndANchList);
			}
			if(isProperTo_canLianhuaPropList(item))
			{
				updateDic(_canLianhuaPropList,item);
			}else
			{
				removeFrom(item,_canLianhuaPropList);
			}
			if(isProperTo_CanEmbedPropList(item))
			{
				updateDic(_canEmbedPropList,item);
			}else
			{
				removeFrom(item,_canEmbedPropList);
			}
		}
		
		private function isProperTo_CanCpsEquipmentList(item:InventoryItemInfo):Boolean
		{
			if(item.CanCompose&&item.getRemainDate()>0) return true; //bouer:item.CategoryID != 17用于判断是否是副手武器
			return false;
		}
		
		private function isProperTo_CanStrthEqpmtList(item:InventoryItemInfo):Boolean
		{
			if(item.CanStrengthen&&item.getRemainDate()>0) return true;
			return false;
		}
		
		private function isProperTo_StrthAndANchList(item:InventoryItemInfo):Boolean
		{
			if(item.getRemainDate()<=0) return false;
			if(EquipType.isStrengthStone(item)||(item.CategoryID == 11&&item.Property1==StoneType.SOULSYMBOL)||(item.CategoryID == 11&&item.Property1==StoneType.LUCKY)) return true;
			return false;
		}
		
		/**
		 * 如果item是合成石 或者是幸运石 返回true
		 */
		private function isProperTo_CpsAndANchList(item:InventoryItemInfo):Boolean
		{
			if(item.getRemainDate()<=0) return false;
			if(EquipType.isComposeStone(item)||(item.CategoryID == 11&&item.Property1==StoneType.LUCKY)) return true;
			return false;
		}
		
		private function isProperTo_CpsAndStrthAndformula(item:InventoryItemInfo):Boolean
		{
			if(item.getRemainDate()<=0) return false;
			if(item.FusionType != 0) return true;
			if(EquipType.isComposeStone(item)||(item.CategoryID == 11 && item.Property1 == StoneType.FORMULA)||EquipType.isStrengthStone(item)) return true;
			if(item.CategoryID == 11 && item.Property1 == "31") return true; //宝珠
			return false;
		}
		/**
		 * 可熔练的装备
		 * **/
		private function isProperTo_CanRongLiangEquipmengtList(item:InventoryItemInfo):Boolean
		{
			if(item.FusionType != 0&&item.getRemainDate()>0)return true;
			return false;
		}
		private function isProperTo_canLianhuaEquipList(item:InventoryItemInfo):Boolean
		{
			if(item.Refinery>=0 && item.getRemainDate()>=0) return true;
			return false;
		}
		
		private function isProperTo_canLianhuaPropList(item:InventoryItemInfo):Boolean
		{
			if(item.getRemainDate()<=0) return false;
			if((item.CategoryID == 11 && (item.Property1 == "32" || item.Property1 == "33")) || (item.CategoryID == 11&&item.Property1==StoneType.LUCKY) ) return true;
			return false;
		}
		
		private function isProperTo_CanTransEquipmengtList(item:InventoryItemInfo):Boolean
		{
			if(item.getRemainDate()<=0) return false;
			if((item.Level == 3) && (item.CanCompose || item.CanStrengthen)) return true;
			return false;
		}
		
		private function isProperTo_CanEmbedEquipList(item:InventoryItemInfo):Boolean
		{
			if(item.getRemainDate()<=0) return false;
			if(!item.CanEquip) return false;
			for(var i:int=1; i<7; i++)
			{
				if(item["Hole"+i]>=0) return true;
			}
			return false;
		}
		
		private function isProperTo_CanEmbedPropList(item:InventoryItemInfo):Boolean
		{
			if(item.getRemainDate()<=0) return false;
			if(item.CategoryID == 11 && item.Property1 == "31") return true;
			return false;
		}
		
		/**
		 *  更新对应dictionary
		 */
		private function updateDic(dic:DictionaryData,item:InventoryItemInfo):void
		{
			for(var i:int = 0;i<dic.length;i++)
			{
				if(dic[i]!=null&&dic[i].Place == item.Place)
				{
					dic.add(i,item);
					dic.dispatchEvent(new UpdateItemEvent(UpdateItemEvent.UPDATEITEMEVENT,i,item));
					return;
				}
			}

			addItemToTheFirstNullCell(item,dic);
		}
		
		private function __removeEquip(evt:DictionaryEvent):void
		{
			var item_1:InventoryItemInfo = evt.data as InventoryItemInfo;
			removeFrom(item_1,_canCpsEquipmentList);
			removeFrom(item_1,_canStrthEqpmtList);
			removeFrom(item_1,_canTransEquipmengtList);
			removeFrom(item_1,_cpsAndStrthAndformula);
		}
		
		/*添加物品到背包的第一个空闲的格子*/
		private function addItemToTheFirstNullCell(item:InventoryItemInfo,dic:DictionaryData):void
		{
			dic.add(findFirstNullCellID(dic),item);
		}
		
		private function findFirstNullCellID(dic:DictionaryData):int
		{
			var result:int = -1;
			var lth:int = dic.length;
			for(var i:int=0;i<=lth;i++)
			{
			    if(dic[i]==null)
			    {
			        result = i;
			        break;
			    }
			}
			return result;
		}
		
		/*通过obj删除dictionary里面的数据*/
		private function removeFrom(item:InventoryItemInfo,dic:DictionaryData):void
		{
			var lth:int=dic.length;
			for(var i:int=0;i<lth;i++)
			{
				if(dic[i]&&dic[i].Place==item.Place)
				{
					dic[i]=null;					
					dic.dispatchEvent(new StoreBagEvent(StoreBagEvent.REMOVE,i,item));
					break;
				}
			}
		}
        
        /*按照武器→衣服→帽子→眼镜→手镯→戒指的顺序整理装备*/
        public function sortEquipList(equipList:DictionaryData):DictionaryData
        {
        	var temp:DictionaryData = equipList;
        	equipList = new DictionaryData();
        	fillByCategoryID(temp,equipList,EquipType.ARM);
        	fillByCategoryID(temp,equipList,EquipType.CLOTH);
        	fillByCategoryID(temp,equipList,EquipType.HEAD);
        	fillByCategoryID(temp,equipList,EquipType.GLASS);
        	fillByCategoryID(temp,equipList,EquipType.ARMLET);
        	fillByCategoryID(temp,equipList,EquipType.RING);
        	fillByCategoryID(temp,equipList,EquipType.OFFHAND);
			fillByCategoryID(temp,equipList,EquipType.PET);
			fillByCategoryID(temp,equipList,EquipType.ShenQi1);
			fillByCategoryID(temp,equipList,EquipType.ShenQi2);
			return equipList;
        }
        /**
        * 按照 手鐲-戒指 顺序整理装备
		**/
        public function sortRoogEquipList(equipList:DictionaryData):DictionaryData
        {
        	var temp:DictionaryData = equipList;
        	equipList = new DictionaryData();
        	rongLiangFill(temp, equipList, EquipType.ARMLET);//手镯
        	rongLiangFill(temp, equipList, EquipType.RING);//戒指
        	rongLiangFill(temp, equipList, EquipType.NECKLACE);//项链
			return equipList;
        }
        
        private function fillByCategoryID(source:DictionaryData, target:DictionaryData, categoryID:int):void
        {
        	for each(var item:InventoryItemInfo in source)
        	{
        		if(item.CategoryID == categoryID)
        		{
        			target.add(target.length,item);
        		}
        	}
        }
        /**
        * 查找可以熔练的同类别的物品
        * **/
        private function rongLiangFill(source:DictionaryData, target:DictionaryData, CategoryID:int) : void
        {
        	for each(var item:InventoryItemInfo in source)
        	{
        		if(item.CategoryID == CategoryID)
        		{
        			target.add(target.length,item);
        		}
        	}
        }
        /**
        * 除前面五个的熔练公式
        * **/
        private function  rongLiangFunFill(source:DictionaryData, target:DictionaryData) : void
        {
        	for each(var item:InventoryItemInfo in source)
        	{
        		if(item.Property1 == StoneType.FORMULA)
        		{
        			target.add(target.length,item);
        		}
        	}
        }
        
        private function fillByTemplateID(source:DictionaryData, target:DictionaryData, templateID:int):void
        {
        	for each(var item:InventoryItemInfo in source)
        	{
        		if(item.TemplateID == templateID)
        		{
        			target.add(target.length,item);
        		}
        	}
        }
        
        private function fillByProperty1AndProperty3(source:DictionaryData, target:DictionaryData, property1:String, property3:String):void
        {
        	var tempArr:Array = [];
        	var item:InventoryItemInfo;
        	for each(item in source)
        	{
        		if(item.Property1 == property1 && item.Property3 == property3)
        		{
        			tempArr.push(item);
        		}
        	}
        	bubbleSort(tempArr);
        	for each(item in tempArr)
        	{
        		target.add(target.length,item);
        	}
        }
        
        private function fillByProperty1(source:DictionaryData , target:DictionaryData, property1:String):void
        {
        	var tempArr:Array = [];
        	var item:InventoryItemInfo;
        	for each(item in source)
        	{
        		if(item.Property1 == property1)
        		{
        			tempArr.push(item);
        		}
        	}
        	bubbleSort(tempArr);
        	for each(item in tempArr)
        	{
        		target.add(target.length,item);
        	}
        }
        
        /*按照神恩符→幸运符→强化石（4级→1级）→合成石（4级→1级）→所有熔炼公式的顺序整理道具*/
        public function sortPropList(propList:DictionaryData,isCompose:Boolean = false):DictionaryData
        {
        	var temp:DictionaryData = propList;
        	propList = new DictionaryData();
        	
        	rongLiangFunFill(temp, propList);

        	fillByProperty1(temp,propList,StoneType.STRENGTH);                            //强化石4-1级
        	fillByProperty1(temp,propList,StoneType.STRENGTH_1);
        	fillByProperty1(temp,propList,StoneType.LIANHUA_MAIN_MATIERIAL);
        	fillByProperty1(temp,propList,StoneType.LIANHUA_AIDED_MATIERIAL);
        	fillByProperty1(temp,propList,"31");//宝珠
        	fillByProperty1AndProperty3(temp,propList,StoneType.COMPOSE,StoneType.BIRD);  //朱雀石4-1级
        	fillByProperty1AndProperty3(temp,propList,StoneType.COMPOSE,StoneType.SNAKE); //玄武石4-1级
        	fillByProperty1AndProperty3(temp,propList,StoneType.COMPOSE,StoneType.DRAGON);//青龙石4-1级
        	fillByProperty1AndProperty3(temp,propList,StoneType.COMPOSE,StoneType.TIGER); //白虎石4-1级
        	if(!isCompose){
        		fillByProperty1(temp,propList,StoneType.SOULSYMBOL);                          //神符	
        	}
        	fillByProperty1(temp,propList,StoneType.LUCKY);                               //幸运符
        	rongLiangFill(temp, propList, 8);
        	rongLiangFill(temp, propList, 9);
        	rongLiangFill(temp, propList, 14);
			fillByProperty1(temp,propList,StoneType.BADGE);
        	return propList;
        }
        
        private function bubbleSort(dic:Array):void
        {
        	var lth:int = dic.length;
            for(var i:int=0;i<lth;i++)
            {
            	var flag:Boolean = true;
            	for(var j:int=0;j<lth-1;j++)
            	{
            		if(dic[j].Quality<dic[j+1].Quality)
            		{
            			var temp:InventoryItemInfo = dic[j];
            			dic[j] = dic[j+1];
            			dic[j+1] = temp;
            			flag = false;
            		}
            	}
            	if(flag)
            	{
            	    return;
            	}
            }	
        }
        
        public function get info():PlayerInfo
        {
            return _info;        
        }
		
		public function set currentPanel(currentPanel:int):void
		{
		    _currentPanel = currentPanel;
		}
		
		public function get currentPanel():int
		{
			return this._currentPanel;
		}
		
		public function get canCpsEquipmentList():DictionaryData
		{
			return this._canCpsEquipmentList;
		}
		
		public function get canLianhuaEquipList():DictionaryData
		{
			return this._canLianhuaEquipList;
		}
		
		public function get canLianhuaPropList():DictionaryData
		{
			return this._canLianhuaPropList;
		}
		
		public function get canStrthEqpmtList():DictionaryData
		{
			return this._canStrthEqpmtList;
		}
		
		public function get strthAndANchList():DictionaryData
		{
			return this._strthAndANchList;
		}
		
		public function get cpsAndANchList():DictionaryData
		{
			return this._cpsAndANchList;
		}
		
		public function get cpsAndStrthAndformula():DictionaryData
		{
			return this._cpsAndStrthAndformula;
		}
		
		public function get canTransEquipmengtList():DictionaryData
		{
			return this._canTransEquipmengtList;
		}	
	    public function get canRongLiangEquipmengtList():DictionaryData
		{
			return this._canRongLiangEquipmengtList;
		}
		public function get canEmbedEquipList():DictionaryData
		{
			return _canEmbedEquipList;
		}
		
		public function get canEmbedPropList():DictionaryData
		{
			return _canEmbedPropList;
		}
		
		public function set NeedAutoLink(value:int):void
		{
			_needAutoLink = value;
		}
		
		public function get NeedAutoLink():int
		{
			return _needAutoLink;
		}
		
		/**
		 * 检查可以镶嵌的装备是否镶嵌过宝石
		 */
		public function checkEmbeded():Boolean{
			for(var length:String in _canEmbedEquipList){
				var item:InventoryItemInfo = _canEmbedEquipList[int(length)] as InventoryItemInfo;
				if(item && item.Hole1 != -1 && item.Hole1 != 0) return false;
				if(item && item.Hole2 != -1 && item.Hole2 != 0) return false;
				if(item && item.Hole3 != -1 && item.Hole3 != 0) return false;
				if(item && item.Hole4 != -1 && item.Hole4 != 0) return false;
				if(item && item.Hole5 != -1 && item.Hole5 != 0) return false;
				if(item && item.Hole6 != -1 && item.Hole6 != 0) return false;
			}
			return true;
		}

        public function clear():void
        {
        	_info.PropBag.removeEventListener(BagEvent.UPDATE,updateBag);
			_info.Bag.removeEventListener(BagEvent.UPDATE,updateBag)
        	_info = null;
        	_propBag = null;
        	_equipmentBag = null;
        }
	}
}