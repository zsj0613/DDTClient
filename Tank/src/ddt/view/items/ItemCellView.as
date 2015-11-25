package ddt.view.items
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	
	import game.crazyTank.view.PropContainerAsset;
	
	[Event(name="itemClick",type="ddt.view.items.ItemEvent")]
	[Event(name="itemOver",type="ddt.view.items.ItemEvent")]
	[Event(name="itemOut",type="ddt.view.items.ItemEvent")]
	[Event(name="itemMove",type="ddt.view.items.ItemEvent")]
	public class ItemCellView extends Sprite
	{
		private var _item:DisplayObject;
		
		private var _asset:PropContainerAsset;
		
		private var _index:uint;
		
		private var _clickAble:Boolean;
		
		public function setClick(clickAble:Boolean,isGray:Boolean,isExist:Boolean):void
		{
			_clickAble = clickAble;
			setGrayII(isGray,isExist);
		}
		
		public function ItemCellView(index:uint = 0,item:DisplayObject = null,isCount:Boolean = false)
		{
			super();
			_index = index;
			_asset = new PropContainerAsset();
			addChild(_asset);
			setItem(item,false);
		}
		
		private function __click(event:MouseEvent):void
		{
			//SoundManager.instance.play("047");
			stage.focus = this;
			if(_clickAble && _item)
			{
				dispatchEvent(new ItemEvent(ItemEvent.ITEM_CLICK,item,_index));		
			}
		}
		
		public function mouseClick():void
		{
			__click(null);
		}
		
		private function __over(event:MouseEvent):void
		{
			dispatchEvent(new ItemEvent(ItemEvent.ITEM_OVER,item,_index));
		}
		
		private function __out(event:MouseEvent):void
		{
			dispatchEvent(new ItemEvent(ItemEvent.ITEM_OUT,item,_index));
		}
		
		private function __move(event:MouseEvent):void
		{
			dispatchEvent(new ItemEvent(ItemEvent.ITEM_MOVE,item,_index));
		}
		
		public function get item():DisplayObject
		{
			return _item;
		}
		
		public function setItem(value:DisplayObject,isGray:Boolean):void
		{
			if(_item)
			{
				removeEvent();
				removeChild(_item);
			}
			
			_item = value;
			if(_item)
			{
				mouseEnabled = true;
				buttonMode = true;
				addEvent();
				addChild(_item);
				if(_item is PropItemView)
				{
					setGrayII(isGray,PropItemView(_item).isExist);
				}else{
					setGrayII(isGray,true);
				}
			}
			else
			{
				buttonMode = false;
				mouseEnabled = false;
			}
		}
		
		private function addEvent():void
		{
			addEventListener(MouseEvent.CLICK,__click);	
			addEventListener(MouseEvent.MOUSE_OVER,__over);
			addEventListener(MouseEvent.MOUSE_OUT,__out);
			addEventListener(MouseEvent.MOUSE_MOVE,__move);
		}
		
		private function removeEvent():void
		{
			removeEventListener(MouseEvent.CLICK,__click);
			removeEventListener(MouseEvent.MOUSE_OVER,__over);
			removeEventListener(MouseEvent.MOUSE_OUT,__out);
			removeEventListener(MouseEvent.MOUSE_MOVE,__move);
		}
		
		public function seleted(value:Boolean):void
		{
			
		}
		
		public function get index ():int
		{
			return _index;
		}
		
		public function setBackgroundVisible(value:Boolean):void
		{
			_asset.alpha = value ? 1 : 0;
		}
		
		public function setGrayII(isGray:Boolean,isExist:Boolean):void
		{
			if(item)
			{
				if(!isGray && isExist)
				{
					item.filters = null;
				}
				else
				{
					item.filters = [new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0])];
				}
			}
		}
		
		public function dispose():void
		{
			removeEvent();
			if(_asset && _asset.parent)
			{
				_asset.parent.removeChild(_asset);
			}
			_asset = null;
			
			if(_item && _item.parent)
			{
				_item.parent.removeChild(_item);
			}
			_item = null;
			
			if(parent)
				parent.removeChild(this);
		}
	}
}