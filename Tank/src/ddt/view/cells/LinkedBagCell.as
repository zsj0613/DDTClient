package ddt.view.cells
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import road.manager.SoundManager;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.interfaces.IDragable;
	import ddt.manager.PlayerManager;
	import ddt.view.bagII.BagIIEquipListView;
	import ddt.view.infoandbag.CellEvent;

	public class LinkedBagCell extends BagCell
	{
		
		protected var _bagCell:BagCell;
		private var _timer:Timer = new Timer(BagIIEquipListView.DoubleClickSpeed,1);
		
		public var DoubleClickEnabled:Boolean = true;
		
		public function LinkedBagCell(bg:Sprite)
		{
			super(0,null,true,bg);
			init();
		}
		
		private function init():void
		{
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE,__timer);
			addEventListener(MouseEvent.MOUSE_DOWN,__onMouseDown);
		}
		
		private function __timer(evt:TimerEvent):void
		{
			if(_info && !locked && stage && allowDrag)
			{
				SoundManager.instance.play("008");
			}
			dragStart();
		}
		
		public function get bagCell():BagCell
		{
			return _bagCell;
		}
		
		public function set bagCell(value:BagCell):void
		{
			if(_bagCell)
			{
				_bagCell.removeEventListener(Event.CHANGE,__changed);
				if(_bagCell.itemInfo&&_bagCell.itemInfo.BagType == 0)
				{
					PlayerManager.Instance.Self.Bag.unlockItem(_bagCell.itemInfo);
				}else if(_bagCell.itemInfo)
				{
					PlayerManager.Instance.Self.PropBag.unlockItem(_bagCell.itemInfo);
				}
				_bagCell.locked = false;
				info = null;
			}
			_bagCell = value;
			if(_bagCell)
			{
				_bagCell.addEventListener(Event.CHANGE,__changed);
				this.info = _bagCell.info;
			}
		}
		
		public override function get place():int
		{
			if(_bagCell)
				return _bagCell.itemInfo.Place;
			else
				return -1;
		}
		
		protected function __onMouseDown(evt:MouseEvent):void
		{
			if(!DoubleClickEnabled)return;
			if((evt.currentTarget as BagCell).info!=null){
			    if(_timer.running)
		    	{
			    	if((evt.currentTarget as BagCell).info != null)
				    {
				    	_timer.stop();
				    	dispatchEvent(new CellEvent(CellEvent.DOUBLE_CLICK,this,true));
				    	if(!mouseSilenced)SoundManager.instance.play("008");
				    }
			    }
		    	else
		    	{
			    	_timer.reset();
				    _timer.start();
			    }
			}
		}
		
		override public function dragStop(effect:DragEffect):void
		{
			if(PlayerManager.Instance.Self.bagLocked && bagLocked)return;
			if(_bagCell)
			{
				if(effect.action != DragEffect.NONE || effect.target)
				{
					_bagCell.dragStop(effect);
					
					//不能直接调用 bagcell = null,因为里面有 _bagcell.locked = false, 会导致拖动到其他格子时状态不锁定
					_bagCell.removeEventListener(Event.CHANGE,__changed);
					_bagCell = null;
					info = null;
				}
				else
				{
					locked = false;
				}
			}
		}
		
		private function __changed(event:Event):void
		{
			this.info = (_bagCell == null ? null : _bagCell.info);
			if(_bagCell == null || _bagCell.info == null) {
				clearLinkCell();
			}
			else {
				_bagCell.locked = true;
			}
		}
		
		override public function getSource():IDragable
		{
			return _bagCell;
		}
		
		public function clearLinkCell():void
		{
			if(_bagCell)
			{
				_bagCell.removeEventListener(Event.CHANGE,__changed);
				if(_bagCell.itemInfo && _bagCell.itemInfo.lock)
				{
					if(_bagCell.itemInfo&&_bagCell.itemInfo.BagType == 0)
					{
						PlayerManager.Instance.Self.Bag.unlockItem(_bagCell.itemInfo);
					}else
					{
						PlayerManager.Instance.Self.PropBag.unlockItem(_bagCell.itemInfo);
					}
				}
				_bagCell.locked = false;
			}
			bagCell = null;
		}
		
		override public function set locked (b:Boolean):void
		{
			
		}
		
		override public function dispose():void
		{
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,__timer);
			removeEventListener(MouseEvent.MOUSE_DOWN,__onMouseDown);
			clearLinkCell();
			if(info is InventoryItemInfo)
			{
				info["lock"] = false;
			}
			super.dispose();
			bagCell = null;
			_timer = null;
		}
		
	}
}