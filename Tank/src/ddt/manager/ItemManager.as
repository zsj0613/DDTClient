package ddt.manager
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import road.data.DictionaryData;
	import road.ui.controls.hframe.HAlertDialog;
	import road.utils.ClassFactory;
	
	import ddt.data.EquipType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.request.store.LoadGoodCategory;
	import ddt.request.store.LoadStoreInfo;
	import ddt.utils.LeavePage;
	
	[Event(name="templateReady",type="flash.events.Event")]
	public class ItemManager extends EventDispatcher
	{
		private var _categorys:Array;//拍卖行物品种类
		private var _goodsTemplates:DictionaryData;//物品模板
		
		public function setup():void
		{
			new LoadStoreInfo().loadSync(__getStoreGoods,3);
			new LoadGoodCategory().loadSync(__getGoodCategory,3);
		}
		
		private function __getStoreGoods(loader:LoadStoreInfo):void
		{
			if(loader.isSuccess)
			{
				setGoodsTemplates(loader.list);
				dispatchEvent(new Event("templateReady"));
			}
			else
			{
				HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Error"),LanguageMgr.GetTranslation("ddt.manager.ItemManager.loader"),true,callSolveLogin,"stage",HAlertDialog.OK_LABEL,callSolveLogin);
			}
		}
		
		private function __getGoodCategory(action:LoadGoodCategory):void
		{
			if(action.isSuccess)
			{
				_categorys = action.list;
			}else
			{
				HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Error"),LanguageMgr.GetTranslation("ddt.manager.ItemManager.falseLoading"),true,callSolveLogin,"stage",HAlertDialog.OK_LABEL,callSolveLogin);
				//HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Error"),"物品类型数据加载失败");
			}
		}
		
		private function callSolveLogin():void
		{
			LeavePage.LeavePageTo(PathManager.solveLogin(),"_self");
		}
		
		public function get categorys():Array
		 {
		 	return _categorys.slice(0);
		 }
		
		/**
		 * 商店种类标签 
		 */		
		private var _storeCateCory:Array;
		public function get storeCateCory():Array
		{
			return _storeCateCory;
		}
		public function set storeCateCory(value:Array):void
		{
			_storeCateCory = value;
		}
		
		/**
		 * 所有商品的数据
		 * _shopGoods:by templateid
		 *  _goodsTemplates:sort by templateId(all)
		 * _categeryTemplates:sort by categeryId(in store)
		 * _propTemplates:sort by templateId(in prop)
		 * 
		 * _currentResult:记录结果集，查询种类不变时(翻页)数据不会改变
		 * _currentIds:
		 * _currentSex
		 */		
		
		
		public function get goodsTemplates():DictionaryData
		{
			return _goodsTemplates;	
		}
		
		public function setGoodsTemplates(value:DictionaryData):void
		{
			if(_goodsTemplates == null)
			{
				_goodsTemplates = value;
			}
		}
		
		public function getTemplateById(templateId:int):ItemTemplateInfo
		{
			return _goodsTemplates[templateId];
		}
		
		/**
		 * 通过名字获取模版资料 
		 */		
		public function getTemplateByName(name:String):ItemTemplateInfo
		{
			for each(var info:ItemTemplateInfo in _goodsTemplates)
			{
				if(info.Name == name)
				{
					return info;
				}
			}
			return null;
		}
		
		public function getFreeTemplateByCategoryId(categoryid:int,sex:int = 0):ItemTemplateInfo
		{
			if(categoryid != EquipType.ARM)
			{
				return getTemplateById(Number(String(categoryid) + String(sex) + "01"));
			}
			else
			{
				return getTemplateById(Number(String(categoryid) + "00" + String(sex)));
			}
			return null;
		}
		
		public static function fill(item:InventoryItemInfo):InventoryItemInfo
		{
			var t:ItemTemplateInfo = ItemManager.Instance.getTemplateById(item.TemplateID);
			ClassFactory.copyProperties(t,item);
			return item;
		}
		
		public static function fillInventoryFromJson(jsonObject:Object):InventoryItemInfo
		{
			var t:InventoryItemInfo = new InventoryItemInfo();
			ClassFactory.copyPropertiesByTarget(jsonObject,t);
			var tt:ItemTemplateInfo = ItemManager.Instance.getTemplateById(t.TemplateID);
			ClassFactory.copyProperties(tt,t);
			return t;
		}
		
		private static var _instance:ItemManager;
		public static function get Instance():ItemManager
		{
			if(_instance == null)
			{
				_instance = new ItemManager();
			}
			return _instance;
		}
	}
}