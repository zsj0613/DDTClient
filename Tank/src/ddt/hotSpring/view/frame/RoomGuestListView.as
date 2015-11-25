package ddt.hotSpring.view.frame
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import road.data.DictionaryData;
	import road.data.DictionaryEvent;
	import road.manager.SoundManager;
	import road.ui.accect.CloseBtnAccect;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.SimpleGrid;
	import road.utils.ComponentHelper;
	
	import tank.assets.ScaleBMP_20;
	import ddt.data.player.ChurchPlayerInfo;
	import ddt.data.player.PlayerInfo;
	import tank.hotSpring.HotSpringGuestListAsset;
	import ddt.hotSpring.player.HotSpringPlayer;
	import ddt.manager.ChurchRoomManager;
	import ddt.manager.PlayerManager;
	
	public class RoomGuestListView extends HotSpringGuestListAsset
	{
		private var _list:SimpleGrid; 
		private var _data:DictionaryData;
		private var _closeBtn:HBaseButton;
		private var _bg : ScaleBMP_20;
		private var _roomGuestListItemMenuView:RoomGuestListItemMenuView;
		private var _callBack:Function;
		
		public function RoomGuestListView(data:DictionaryData, callBack:Function)
		{
			_data = data;
			_callBack=callBack;
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			_bg  = new ScaleBMP_20();
			ComponentHelper.replaceChild(this,BgPos,_bg);
			_list = new SimpleGrid(166,20,1);
			_list.verticalScrollPolicy = ScrollPolicy.ON;
			_list.horizontalScrollPolicy = ScrollPolicy.OFF;
			_list.cellPaddingHeight = 6;
			ComponentHelper.replaceChild(this,list_pos,_list);
			
			_list.content.addEventListener(MouseEvent.CLICK,menuClickHandler);
			
			updateList();
			
			_closeBtn = new HBaseButton(new CloseBtnAccect());
			_closeBtn.x = width - _closeBtn.width - 12;
			_closeBtn.y = 12;
			_closeBtn.scaleX = _closeBtn.scaleY = 0.7;
			addChild(_closeBtn);
			_closeBtn.addEventListener(MouseEvent.CLICK,closeHandler);
			addEventListener(Event.ADDED_TO_STAGE,__addToStage);
		}
		
		private function initEvent():void
		{
			_data.addEventListener(DictionaryEvent.ADD,__addGuest);
			_data.addEventListener(DictionaryEvent.REMOVE,__removeGuest);
		}
		
		private function updateList():void
		{
			var arr:Array = _data.list;
			
			for(var i:uint =0;i<arr.length;i++)
			{
				var item:RoomGuestListItemView = new RoomGuestListItemView((arr[i] as HotSpringPlayer).playerVO.playerInfo);
				item.addEventListener(MouseEvent.CLICK,__itemClickHandler);
				_list.appendItem(item);
			}
		}
		
		private function clearList() : void
		{
			for(var i:int = (_list.items.length-1);i>=0;i--)
			{
				var item:RoomGuestListItemView = _list.getItemAt(i) as RoomGuestListItemView;
				item.removeEventListener(MouseEvent.CLICK,__itemClickHandler);
				_list.removeItem(item);
				item = null;
			}
			_list.clearItems();
		}

		/**房间列表中玩家列表,第一位是自已**/
		private function upSelfItem() : void
		{
			for(var i : int=0;i<_list.getItems().length;i++)
			{
				var item : RoomGuestListItemView = _list.getItemAt(i) as RoomGuestListItemView;
				if(item.info.ID == PlayerManager.Instance.Self.ID)
				{
					_list.removeItem(item);
					_list.appendItemAt(item,0);
					break;
				}
			}
		}
		
		private function __addGuest(evt:DictionaryEvent):void
		{
			var item:RoomGuestListItemView = new RoomGuestListItemView((evt.data as HotSpringPlayer).playerVO.playerInfo);
			item.addEventListener(MouseEvent.CLICK,__itemClickHandler);
			_list.appendItem(item);
			_list.sortByCustom(sortItem);
		}
		
		private function sortItem(items:Array):void
		{
			items.sortOn(["Grade","Nick"],[Array.NUMERIC,Array.DESCENDING]);
			items.reverse();
			upSelfItem();
		}
		
		
		private function __removeGuest(evt:DictionaryEvent):void
		{
			_list.removeItem(_list.getItem("id",(evt.data as HotSpringPlayer).playerVO.playerInfo.ID));
		}
		
		private function menuClickHandler(e:Event):void
		{
			if(_list.selectedItem as RoomGuestListItemView)
			{
				var info:PlayerInfo = (_list.selectedItem as RoomGuestListItemView).info;
				if(info.ID == PlayerManager.Instance.Self.ID) return;
				
				_roomGuestListItemMenuView=new RoomGuestListItemMenuView(info);
				_roomGuestListItemMenuView.show();
			}
		}
		
		private function __itemClickHandler(e:MouseEvent):void
		{
			_list.selectedItem = e.currentTarget as DisplayObject;
		}
		
		private function closeHandler(e:MouseEvent):void
		{
			SoundManager.instance.play("008");
			if(parent)
			{
				parent.removeChild(this);
			}
			removeEventListener(KeyboardEvent.KEY_DOWN,__onKeyDown);
			if(_callBack!=null) _callBack();
		}
		
		private function __addToStage(evt:Event):void
		{
			stage.focus = this;
			addEventListener(KeyboardEvent.KEY_DOWN,__onKeyDown);
		}
		
		private function __onKeyDown(evt:KeyboardEvent):void
		{
			if(evt.keyCode == Keyboard.ESCAPE)
			{
				closeHandler(null);
			}
		}
		
		public function dispose():void
		{
			clearList();
			_data.removeEventListener(DictionaryEvent.ADD,__addGuest);
			_data.removeEventListener(DictionaryEvent.REMOVE,__removeGuest);
			removeEventListener(KeyboardEvent.KEY_DOWN,__onKeyDown);
			removeEventListener(Event.ADDED_TO_STAGE,__addToStage);
			
			if(_roomGuestListItemMenuView)
			{
				if(_roomGuestListItemMenuView.parent) _roomGuestListItemMenuView.parent.removeChild(_roomGuestListItemMenuView);
				_roomGuestListItemMenuView.dispose();
			}
			_roomGuestListItemMenuView=null;
			
			_data = null;
			if(_list.parent)_list.parent.removeChild(_list);
			_list = null;
			if(this.parent)this.parent.removeChild(this);
			_callBack=null;
		}
	}
}