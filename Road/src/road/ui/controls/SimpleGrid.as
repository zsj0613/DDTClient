package road.ui.controls
{
	import fl.containers.BaseScrollPane;
	import fl.controls.ScrollPolicy;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	[Event(name="change",type="flash.events.Event")]
	public class SimpleGrid extends BaseScrollPane
	{
		protected var _marginWidth:int = 2;
		protected var _marginHeight:int = 2;
		
		protected var _cellPaddingWidth:int = 2;
		protected var _cellPaddingHeight:int = 2;
		
		protected var _cellWidth:int;
		protected var _cellHeight:int;
		
		protected var _column:uint = 1;
		
		protected var _selectedIndex:int;
		protected var _selectedItem:DisplayObject;
		
		protected var _container:UIComponent;
		private var _items:Array;
		
		private static var defaultStyles:Object = {	 
											skin:SimpleGrid_upSkin
											};
		public static function getStyleDefinition():Object { 
			return mergeStyles(defaultStyles, BaseScrollPane.getStyleDefinition());
		}
		
		public function SimpleGrid(cellWidth:uint = 100,cellHeight:uint = 20,column:uint = 1)
		{
			_cellWidth = cellWidth;
			_cellHeight = cellHeight;
			_column = column;
			_selectedIndex = -1;
			_items = [];
			super();
		}
		
		public function get marginWidth():uint
		{
			return _marginWidth;
		}
		public function set marginWidth(value:uint):void
		{
			if(_marginWidth == value)return;
			_marginWidth = value;
			invalidate(InvalidationType.SIZE);
		}
		public function get marginHeight():uint
		{
			return _marginHeight;
		}
		public function set marginHeight(value:uint):void
		{
			if(_marginHeight == value)return;
			_marginHeight = value;
			invalidate(InvalidationType.SIZE);
		}
		public function get cellPaddingWidth():int
		{
			return _cellPaddingWidth;
		}
		public function set cellPaddingWidth(value:int):void
		{
			if(_cellPaddingWidth == value)return;
			_cellPaddingWidth = value;
			invalidate(InvalidationType.SIZE);
		}
		public function get cellPaddingHeight():int
		{
			return _cellPaddingHeight;
		}
		public function set cellPaddingHeight(value:int):void
		{
			if(_cellPaddingHeight == value)return;
			_cellPaddingHeight = value;
			invalidate(InvalidationType.SIZE);
		}
		public function get cellWidth():uint
		{
			return _cellWidth;
		}
		public function set cellWidth(value:uint):void
		{
			if(_cellWidth == value)return;
			_cellWidth = value;
			invalidate(InvalidationType.SIZE);
		}
		public function get cellHeight():uint
		{
			return _cellHeight;
		}
		public function set cellHeight(value:uint):void
		{
			if(_cellHeight == value)return;
			_cellHeight = value;
			invalidate(InvalidationType.SIZE);			
		}
		
		public function get column():uint
		{
			return _column;
		}
		public function set column(value:uint):void
		{
			if(_column == value)return;
			_column = value;
			invalidate(InvalidationType.SIZE);
		}
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		public function set selectedIndex(value:int):void
		{
			if(_selectedIndex != value)
			{
				_selectedIndex = value;
				invalidate(InvalidationType.SELECTED);
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		public function get selectedItem():DisplayObject
		{
			return _items[_selectedIndex];
		}
		
		public function set selectedItem(item:DisplayObject):void
		{
			selectedIndex = _items.indexOf(item);
		}
		
		public function getItemAt(index:Number):DisplayObject
		{
			return _items[index];
		}
		
		public function getItem(key:String,value:Object):DisplayObject
		{
			var count:uint = _items.length;
			for(var i:uint = 0; i < count; i++)
			{
				if(_items[i][key] == value)
				{
					return _items[i];
				}
			}
			return null;
		}
		
		public function get itemCount():int
		{
			return _items.length;
		}
		
		public function get items():Array
		{
			return _items;
		}
		
		public function switchItemAt(index1:int,index2:int):void
		{
			var t:DisplayObject = _items[index1];
			_items[index1] = _items[index2];
			_items[index2] = t;
			_container.swapChildrenAt(index1,index2);
			invalidate(InvalidationType.DATA);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			_container = new UIComponent();
			_container.scrollRect = contentScrollRect;
			_horizontalScrollPolicy = ScrollPolicy.AUTO;
			_verticalScrollPolicy = ScrollPolicy.AUTO;
			this.addChild(_container);
		}
		
		public function get content():Sprite
		{
			return _container;
		}
		
		public function appendItem(item:DisplayObject):void
		{
			if(item.parent == _container)return;
			_container.addChild(item);
			_items.push(item);
			invalidate(InvalidationType.DATA);
		}
		
		public function appendItemAt(item:DisplayObject,index:int):void
		{
			if(item.parent == _container)return;
			_container.addChildAt(item,index);
			_items.splice(index,0,item);
			invalidate(InvalidationType.DATA);
		}
		
		public function setItems(items:Array):void
		{
			for each(var i:DisplayObject in items)
			{
				if(i)
				{
					if(i.parent == _container)continue;
					_container.addChild(i);
					_items.push(i);
				}
			}
			invalidate(InvalidationType.DATA);
		}
		
		public function getItems():Array
		{
			return _items;
		}
		
		public function removeItem(item:DisplayObject):void
		{
			if(item == null)return;
			if(item.parent != _container)return;
			_container.removeChild(item);
			_items.splice(_items.indexOf(item),1);
			invalidate(InvalidationType.DATA);
		}
		
		public function removeItemAt(index:int):void
		{
			_container.removeChildAt(index);
			_items.splice(index,1);
			invalidate(InvalidationType.DATA);
		}
		
		public function clearItems():void
		{
			var count:uint = _container.numChildren;
			for(var i:int = 0; i < count; i++)
			{
				_container.removeChildAt(0);
			}
			_items.splice(0,_items.length);
			invalidate(InvalidationType.DATA);
		}
		
		/**
		 * 
		 * @param fieldname
		 * @param options 
		 * 32数字降序
		 * 
		 */		
		public function sortOn(fieldname:Object,options:Object = null):void
		{
			_items.sortOn(fieldname,options);
			invalidate(InvalidationType.DATA);
		}
		
		public function sortByCustom(sortFunc:Function):void
		{
			if(sortFunc != null)
			{
				sortFunc(_items);
				invalidate(InvalidationType.DATA);
			}
		}
		
		override protected function draw():void
		{
			if(isInvalid(InvalidationType.DATA,InvalidationType.SIZE))
			{
				drawChildren();
				invalidate(InvalidationType.SELECTED,false);
				invalidate(InvalidationType.SIZE,false);
			}
			if(isInvalid(InvalidationType.SELECTED))
			{
				drawSelected();
			}
			super.draw();
		}
		
		protected function drawChildren():void
		{
			var count:uint = _items.length;
			var child:DisplayObject;
			contentWidth = 0;
			contentHeight = 0;
			for(var i:uint = 0; i < count; i++)
			{
				child = _items[i];
				child.x = _marginWidth + (i % _column * (_cellWidth + cellPaddingWidth));
				child.y = _marginHeight + (Math.floor(i / _column) * (_cellHeight + cellPaddingHeight));
				contentWidth = child.x + _cellWidth;
				contentHeight = child.y + _cellHeight;
			}
			contentWidth += _marginWidth;
			contentHeight += _marginHeight;
		}
		
		public function getContentWidth():Number
		{
			return contentWidth;
		}
		
		public function getContentHeight():Number
		{
			return contentHeight;
		}
		
		protected function drawSelected():void
		{
			var child:DisplayObject;
			for(var i:uint = 0; i < _items.length; i ++)
			{
				child = _items[i];
				if(child is ISelectable)
				{
					ISelectable(child).selected = i == _selectedIndex;
				}
			}
		}
		
		override protected function drawLayout():void
		{
			super.drawLayout();
			
			contentScrollRect = _container.scrollRect;
			contentScrollRect.width = availableWidth;
			contentScrollRect.height = availableHeight;
			_container.scrollRect = contentScrollRect;
		}
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		override protected function setVerticalScrollPosition(scrollPos:Number, fireEvent:Boolean=false):void {	
			var contentScrollRect:Rectangle = _container.scrollRect;
			contentScrollRect.y = scrollPos;
			_container.scrollRect = contentScrollRect;
		}

        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		override protected function setHorizontalScrollPosition(scrollPos:Number, fireEvent:Boolean=false):void {
			var contentScrollRect:Rectangle = _container.scrollRect;
			contentScrollRect.x = scrollPos;
			_container.scrollRect = contentScrollRect;
		}
	}
}