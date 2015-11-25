package ddt.request.store
{
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import road.data.DictionaryData;
	import road.serialize.xml.XmlDecoder;
	
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.data.goods.ShopItemInfo;
	import ddt.loader.CompressTextLoader;
	import ddt.data.PathInfo;
	import ddt.manager.PathManager;
	
	public class LoadStoreInfo extends CompressTextLoader
	{
		private static const PATH:String = "TemplateAllList.xml";
		//		private static const PATH:String = "TemplateAlllist.ashx";
		
		public var list:DictionaryData;
		
		public function LoadStoreInfo()
		{
			super(PathManager.solveXMLPath()+PATH+"?"+Math.random());
		}
		
		override protected function onTextReturn(txt:String):void
		{
			_xml = new XML(content);
			list = new DictionaryData();
			parseTemplate();
		}	
		
		/**
		 * 分段处理，避免占用cpu 
		 * @param xml
		 * 
		 */	
		protected function parseTemplate():void
		{
			_xmllist = _xml.ItemTemplate..Item;
			_index = -1;
			_timer = new Timer(30);
			_timer.addEventListener(TimerEvent.TIMER,__partexceute);
			_timer.start();
		}
		
		private var _xml:XML;
		private var _timer:Timer;
		private var _xmllist:XMLList;
		
		
		
		private var _index:int;
		private function  __partexceute(event:TimerEvent):void
		{
			for( var i:int = 0;i < 40; i ++)
			{
				_index ++;
				if(_index < _xmllist.length())
				{
					var node:XmlDecoder = new XmlDecoder();
					node.readXmlNode(_xmllist[_index]);
					
					var info:ItemTemplateInfo = new ItemTemplateInfo();
					info.TemplateID = node.getInt("TemplateID");
					info.Name = node.getString("Name");
					info.CategoryID = node.getInt("CategoryID");
					info.Description = node.getString("Description");
					
					info.Attack = node.getInt("Attack");
					info.Defence = node.getInt("Defence");
					info.Luck = node.getInt("Luck");
					info.Agility = node.getInt("Agility");
					
					info.Level = node.getInt("Level");
					info.Pic = node.getString("Pic");
					
					info.NeedLevel = node.getInt("NeedLevel");
					info.NeedSex = node.getInt("NeedSex");
					info.AddTime =  node.getString("AddTime");
					info.Gold = node.getInt("Gold");
					info.Money = node.getInt("Money");
					info.Quality = node.getInt("Quality");
					info.MaxCount = node.getInt("MaxCount");
					
					info.Property1 = node.getString("Property1");
					info.Property2 = node.getString("Property2");
					info.Property3 = node.getString("Property3");
					info.Property4 = node.getString("Property4");
					info.Property5 = node.getString("Property5");
					info.Property6 = node.getString("Property6");
					info.Property7 = node.getString("Property7");
					info.Property8 = node.getString("Property8");
					
					info.CanCompose = node.getBoolean("CanCompose");
					info.CanDelete = node.getBoolean("CanDelete");
					info.CanDrop = node.getBoolean("CanDrop");
					info.CanEquip = node.getBoolean("CanEquip");
					info.CanStrengthen = node.getBoolean("CanStrengthen");
					info.CanUse = node.getBoolean("CanUse");
					info.BindType = node.getInt("BindType");

					info.FusionType = node.getInt("FusionType");
					info.FusionRate = node.getInt("FusionRate");
					info.FusionNeedRate = node.getInt("FusionNeedRate");
					
					info.Hole = node.getString("Hole");
					info.Refinery = node.getInt("RefineryLevel");
					
					info.Data = node.getString("Data");
					info.ReclaimType=node.getInt("ReclaimType");
					info.ReclaimValue=node.getInt("ReclaimValue");
					info.IsOnly=node.getBoolean("IsOnly");
					list.add(info.TemplateID,info);
				}
				else
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