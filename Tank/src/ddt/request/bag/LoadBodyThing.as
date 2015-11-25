package ddt.request.bag
{
	import flash.utils.describeType;
	
	import road.data.DictionaryData;
	import road.serialize.xml.XmlSerialize;
	
	import ddt.data.BuffInfo;
	import ddt.data.EquipType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.loader.RequestLoader;
	import ddt.manager.ItemManager;
	import ddt.manager.PlayerManager;

	public class LoadBodyThing extends RequestLoader
	{
		private static const PATH:String = "LoadUserEquip.ashx";
//        private static const PATH:String = "111.xml";
		private var _callback:Function;
		public var __id:int;
		public var Style:String;
		public var Colors:String;
		public var Grade:int;
		public var Attack:int;
		public var Defence:int;
		public var Luck:int;
		public var Agility:int;
		public var GP:int;
		public var Repute:int;
		public var Hide:int;
		public var ConsortiaName:String;
		public var Offer:int;
		public var Sex:Boolean;
		public var Skin:String;
		public var NickName:String;
		public var LastSpaDate:Object;//最后退出温泉房间的时间
		
				
		public function LoadBodyThing(id:int,callback:Function = null)
		{
			this.__id = id;
			_callback = callback;
			var obj:Object = new Object();
			obj["ID"] = id;
			super(PATH, obj);
		}
		
		override protected function onRequestReturn(xml:XML):void
		{
//			trace(xml.toXMLString());
			var itemList:DictionaryData = new DictionaryData();
			var buffList:DictionaryData = new DictionaryData();
			var xmllist:XMLList = xml..Item;
			var icInfo:XML = describeType(new InventoryItemInfo());
			Style = String(xml.@Style);
			Colors = String(xml.@Colors);
			Grade = int(xml.@Grade);
			Attack = int(xml.@Attack);
			Defence = int(xml.@Defence);
			Luck = int(xml.@Luck);
			Agility = int(xml.@Agility);
			Repute = int(xml.@Repute);
			GP = int(xml.@GP);
			Hide = int(xml.@Hide);
			Offer = int(xml.@Offer);
			ConsortiaName = String(xml.@ConsortiaName);
			Sex = xml.@Sex;
			Skin = String(xml.@Skin);
			NickName = String(xml.@NickName);
			LastSpaDate = xml.@LastSpaDate as Date;
			PlayerManager.Instance.Self.IsGM = xml.@IsGM=="True"?true:false;
			PlayerManager.Instance.Self.VIPLevel = xml.@VIPLevel;
			
			PlayerManager.Instance.Self.Bag.beginChanges();
			for(var i:int = 0;i < xmllist.length(); i ++)
			{
				var info:InventoryItemInfo = XmlSerialize.decodeType(xmllist[i],InventoryItemInfo,icInfo);
				ItemManager.fill(info);
				itemList.add(info.Place,info);
				if(info.CategoryID == EquipType.ARM)
				{
					if(__id == PlayerManager.Instance.Self.ID)
					{
						PlayerManager.Instance.Self.WeaponID = info.TemplateID;
					}
				}
				if(__id == PlayerManager.Instance.Self.ID)
					PlayerManager.Instance.Self.Bag.addItem(info);
			}
			PlayerManager.Instance.Self.Bag.commiteChanges();
			if(_callback != null)
			{
				_callback(itemList,buffList);
			}
		}
	}
}