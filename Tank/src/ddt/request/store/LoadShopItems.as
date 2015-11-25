package ddt.request.store
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import road.data.DictionaryData;
	import road.serialize.xml.XmlDecoder;
	
	import ddt.data.goods.ShopItemInfo;
	import ddt.loader.CompressTextLoader;
	import ddt.manager.ItemManager;
	import ddt.manager.ShopManager;
	import ddt.data.PathInfo;
	import ddt.manager.PathManager;

	public class LoadShopItems extends CompressTextLoader
	{
		private static const PATH:String = "ShopItemList.xml";
		
		public var categeryList:DictionaryData;
		public var propList:DictionaryData;
		public var giftList:DictionaryData;
		public var gesteList:DictionaryData;
		public var shopinfolist:DictionaryData;
		public var withoutSortTemplatesArr:Array;
		public var consortiaShopList1 : Array;
		public var consortiaShopList2 : Array;
		public var consortiaShopList3 : Array;
		public var consortiaShopList4 : Array;
		public var consortiaShopList5 : Array;
		
		private var _xml:XML;
		private var _shoplist:XMLList;
		
		private var index:int = -1;
		
		public function LoadShopItems()
		{
			super(PathManager.solveXMLPath()+PATH+"?"+Math.random());
		}
		
		override protected function onTextReturn(txt:String):void
		{
			_xml = new XML(content);
			categeryList = new DictionaryData();
			propList = new DictionaryData();
			giftList = new DictionaryData();
			gesteList= new DictionaryData();
			shopinfolist = new DictionaryData();
			withoutSortTemplatesArr = new Array();
			consortiaShopList1 = new Array();
			consortiaShopList2 = new Array();
			consortiaShopList3 = new Array();
			consortiaShopList4 = new Array();
			consortiaShopList5 = new Array();
			_shoplist = _xml.Store..Item;
			if(ItemManager.Instance.goodsTemplates != null)
			{
				parseShop(null);
			}else
			{
				ItemManager.Instance.addEventListener("templateReady",parseShop);
			}
		}
		
		private var _timer:Timer;
		private function parseShop(evt:Event):void
		{
			ItemManager.Instance.removeEventListener("templateReady",parseShop);
			_timer = new Timer(30);
			_timer.addEventListener(TimerEvent.TIMER,__partexceute);
			_timer.start();
		}
		
		private function __partexceute(evt:TimerEvent):void
		{
			for(var i:int = 0; i < 40; i++)
			{
				index++;
				if(index < _shoplist.length())
				{
					var node1:XmlDecoder = new XmlDecoder();
					node1.readXmlNode(_shoplist[index]);
					var info:ShopItemInfo = new ShopItemInfo(node1.getInt("ID"),node1.getInt("TemplateID"));
					info.ShopID = node1.getInt("ShopID");
					info.Sort = node1.getInt("Sort");
					info.IsBind = node1.getInt("IsBind");
					info.IsVouch = (node1.getInt("IsVouch") == 1)?true:false;
					info.Label = node1.getInt("Label");
					info.Beat = node1.getNumber("Beat");
					info.BuyType = node1.getNumber("BuyType");
					
					info.AUnit = node1.getInt("AUnit");
					info.APrice1 = node1.getInt("APrice1");
					info.AValue1 = node1.getInt("AValue1");
					info.APrice2 = node1.getInt("APrice2");
					info.AValue2 = node1.getInt("AValue2");
					info.APrice3 = node1.getInt("APrice3");
					info.AValue3 = node1.getInt("AValue3");
					
					info.BUnit = node1.getInt("BUnit");
					info.BPrice1 = node1.getInt("BPrice1");
					info.BValue1 = node1.getInt("BValue1");
					info.BPrice2 = node1.getInt("BPrice2");
					info.BValue2 = node1.getInt("BValue2");
					info.BPrice3 = node1.getInt("BPrice3");
					info.BValue3 = node1.getInt("BValue3");
					
					info.CUnit = node1.getInt("CUnit");
					info.CPrice1 = node1.getInt("CPrice1");
					info.CValue1 = node1.getInt("CValue1");
					info.CPrice2 = node1.getInt("CPrice2");
					info.CValue2 = node1.getInt("CValue2");
					info.CPrice3 = node1.getInt("CPrice3");
					info.CValue3 = node1.getInt("CValue3");
					info.IsCheap = node1.getBoolean("IsCheap");
					
					var obj:Object = new Object;
					obj["templateID"] = info.TemplateID;
					obj["currentCount"] = 0;
					ShopManager.countLimitArray.push(obj);
					
					shopinfolist.add(info.GoodsID,info);
					
					switch(info.ShopID)
					{
						case 1:
							withoutSortTemplatesArr.push(info);
							if(categeryList[info.TemplateInfo.CategoryID] == null)
								categeryList[info.TemplateInfo.CategoryID] = new DictionaryData();
							categeryList[info.TemplateInfo.CategoryID].add(info.TemplateID,info);
							break;
						case 2:
							propList.add(info.TemplateID,info);
							break;
						case 3:
							giftList.add(info.TemplateID,info);
							break;
						case 4:
							gesteList.add(info.TemplateID,info);
							break;
						/**11---15对应公会商城的1---5级显示的商品**/
						case 11:
							consortiaShopList1.push(info);
							break;
						case 12:
							consortiaShopList2.push(info);
							break;
						case 13:
							consortiaShopList3.push(info);
							break;
						case 14:
							consortiaShopList4.push(info);
							break;
						case 15:
							consortiaShopList5.push(info);
							break;
						default :
							break;
					}
				}else
				{
					_timer.removeEventListener(TimerEvent.TIMER,__partexceute);
					_timer.stop();
					_timer = null;
					super.onTextReturn(null);
					return;
				}
			}
		}
		
	}
}