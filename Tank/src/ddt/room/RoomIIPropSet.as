package ddt.room
{
	import fl.controls.ScrollPolicy;
	
	import game.crazyTank.view.roomII.RoomIIPropSetAsset;
	
	import road.data.DictionaryEvent;
	import road.ui.controls.SimpleGrid;
	import road.utils.ComponentHelper;
	
	import tank.assets.ScaleBMP_13;
	import ddt.data.RoomInfo;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.data.goods.PropInfo;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.data.player.RoomPlayerInfo;
	import ddt.data.player.SelfInfo;
	import ddt.manager.PlayerManager;
	import ddt.manager.RoomManager;
	import ddt.manager.ShopManager;
	import ddt.view.bagII.BagEvent;

	public class RoomIIPropSet extends RoomIIPropSetAsset
	{
		
		private var _myproplist:SimpleGrid;
		private var _storelist:SimpleGrid;
		private var _myitems:Array;
		private var _storeitems:Array;
		private var _self:RoomPlayerInfo;
		private var _selfInfo:SelfInfo;
		private var _bottomBMP:ScaleBMP_13;

		public function RoomIIPropSet()
		{
			super();
			_self = PlayerManager.selfRoomPlayerInfo;
			_selfInfo = _self.info as SelfInfo;
			init();
			initEvent();
		}
		
		private function init():void
		{
			_myitems = [];
			_storeitems = [];
			_bottomBMP = new ScaleBMP_13();
			addChildAt(_bottomBMP,0);
			_bottomBMP.visible = false; // 不显示
			
			_myproplist = new SimpleGrid(40,40,3);
			_myproplist.cellPaddingWidth = 32;
			_myproplist.verticalScrollPolicy = _myproplist.horizontalScrollPolicy = ScrollPolicy.OFF;
			ComponentHelper.replaceChild(this,myprop_pos,_myproplist);
			var i:int = 0;
			for(i = 0; i < 3; i++)
			{
				var item:RoomIIPropItem = new RoomIIPropItem(true);
				_myproplist.appendItem(item);
				_myitems.push(item);
			}
			for(i = 0; i < 3; i++)
			{
				var t:ItemTemplateInfo = (_self.info as SelfInfo).FightBag.items[i];
				if(t){
					var prop:PropInfo = new PropInfo(t);
					prop.Place = i;
					_myitems[i].info = prop;
				}
			}
			
			_storelist = new SimpleGrid(40,40,3);
			_storelist.cellPaddingWidth = 32;
			_storelist.cellPaddingHeight = 15;
			_storelist.verticalScrollPolicy = _storelist.horizontalScrollPolicy = ScrollPolicy.OFF;
			ComponentHelper.replaceChild(this,propstore_pos,_storelist);
			
			var proplist:Array = ShopManager.Instance.getPropShopTemplate();
			for(i = 0; i < proplist.length; i++)
			{
				var info:PropInfo = new PropInfo(proplist[i].TemplateInfo);
				var sitem:RoomIIPropItem = new RoomIIPropItem(false);
				_storelist.appendItem(sitem);
				_storeitems.push(sitem);
				sitem.info = info;
			}
		//	alpha_mask.visible = false;
			gold_txt.text = String(_self.info.Gold);
		}
		
		private function initEvent():void
		{
			_selfInfo.FightBag.addEventListener(BagEvent.UPDATE,__update);
			_selfInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__propertyChange);
		}
		
		private function __update(event:BagEvent):void
		{
			for(var i:String in event.changedSlots)
			{
				var place:int = int(i);
				var info:InventoryItemInfo = PlayerManager.Instance.Self.FightBag.getItemAt(place);
				var prop:PropInfo = new PropInfo(info);
				prop.Place = place;
				if(info)
				{
					
				}else
				{
					prop = null;
				}
				
				_myitems[place].info = prop;
			}
		}
		
		private function __addSelfProp(evt:DictionaryEvent):void
		{
			var info:PropInfo = evt.data as PropInfo;
			_myitems[info.Place].info = info;
		}
		
		private function __removeSelfProp(evt:DictionaryEvent):void
		{
			var info:PropInfo = evt.data as PropInfo;
			_myitems[info.Place].info = null;
		}
		
		private function __propertyChange(evt:PlayerPropertyEvent):void
		{
			if(evt.changedProperties["Gold"] || evt.changedProperties["Money"])
			{
				gold_txt.text = String(_self.info.Gold);
			}
		}
		
		public function dispose():void
		{
			_selfInfo.FightBag.removeEventListener(BagEvent.UPDATE,__update);
			_selfInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__propertyChange);
			
			if(_myproplist)
			{
				for each(var i:RoomIIPropItem in _myproplist.items)
				{
					i.dispose();
					i = null;
				}
				_myproplist.clearItems();
				
				if(_myproplist.parent)
					_myproplist.parent.removeChild(_myproplist);
			}
			_myproplist = null;
			
			if(_storelist)
			{
				for each(var j:RoomIIPropItem in _storelist.items)
				{
					j.dispose();
					j = null;
				}
				_storelist.clearItems();
				
				if(_storelist.parent)
					_storelist.parent.removeChild(_storelist);
			}
			_storelist = null;
			
			if(_bottomBMP && _bottomBMP.parent)
			{
				_bottomBMP.parent.removeChild(_bottomBMP);
			}
			_bottomBMP = null;
			
			_self = null;
			_selfInfo = null;
			_myitems = null;
			_storeitems = null;
			
			if(parent)
				parent.removeChild(this);
		}
	}
}