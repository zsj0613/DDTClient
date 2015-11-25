package ddt.view.HAccordion
{
	import fl.controls.ScrollBar;
	import fl.events.ScrollEvent;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import road.ui.controls.SimpleGrid;
	public class HAccordion extends Sprite
	{
		private var _parents:Array;
		private var _children:Array;
		private var _content:Sprite;
		private var _vGap:Number = 2;
		private var _hGap:Number = 2;
		private var _scroller:ScrollBar;
		
		private var _height:Number;
		private var _width:Number;
		
		private var currentHeight:Number;
		
		public function HAccordion(parents:Array=null,children:Array=null)
		{
			_parents = parents;
			_children = children;
			if(children == null)
			{
				_children = new Array();
				for(var i:int=0;i<_parents.length;i++)
				{
					_children.push(new Array());
				}
			}
			_scroller = new ScrollBar();
			addChild(_scroller);
			_content = new Sprite();
			addChild(_content);
			updateView();
			
			initEvent();
		}
		
		private function initEvent():void
		{
			_scroller.addEventListener(ScrollEvent.SCROLL,__onScroll);
			for each(var parentItem:AccordionStrip in _parents)
			{
				parentItem.addEventListener(MouseEvent.CLICK,__click);
			}
		}
		
		private function removeEvent():void
		{
			_scroller.removeEventListener(ScrollEvent.SCROLL,__onScroll);
			for each(var parentItem:AccordionStrip in _parents)
			{
				parentItem.removeEventListener(MouseEvent.CLICK,__click);
			}
		}
		
		public function addParent(value:AccordionStrip):void
		{
			if(_children == null) _children = [];
			_parents.push(value);
			_children.push(new Array());
			value.addEventListener(MouseEvent.CLICK,__click);
		}
		
		public function addParentAt(value:AccordionStrip,index:int):void
		{
			if(_children == null) _children = [];
			_parents.splice(index,0,value);
			_children.splice(index,0,new Array());
			updateView();
		}
		
		public function addChildNodeAt(value:AccordionStrip,parentIndex:int,childIndex:int=0):void
		{
			if(_children == null) _children = [];
			var childernArr:Array = _children[parentIndex];
			childernArr.splice(childIndex,0,value);
			updateView();
		}
		
		private function __click(evt:MouseEvent):void
		{
			for each(var parentItem:AccordionStrip in _parents)
			{
				parentItem.close();
			}
			(evt.currentTarget as AccordionStrip).open();
			updateView();
		}
		
		public function updateView():void
		{
			currentHeight = 0;
			while(_content.numChildren>0)
			{
				_content.removeChildAt(0);
			}
			for each(var parentItem:AccordionStrip in _parents)
			{
				parentItem.y = currentHeight;
				_content.addChild(parentItem);
				currentHeight+=parentItem.height;
				if(parentItem.isOpened)
				{
					showAllChildren(_parents.indexOf(parentItem));
				}
			}
			if(currentHeight>_height)
			{
				_scroller.visible = true;
				_scroller.x = _width;
				_scroller.height = _height;
				_scroller.minScrollPosition = 0;
				_scroller.maxScrollPosition = currentHeight-_height;
			}else
			{
				_scroller.visible = false;
				if(_content.scrollRect == null)
				{
					_content.scrollRect = new Rectangle(0,0,_width,_height);
				}
				var rect:Rectangle = _content.scrollRect;
				rect.y = 0;
				_content.scrollRect = rect;
			}
		}
		
		private function showAllChildren(index:int):void
		{
			if(_children == null || _children[index] == null)
			{
				return;
			}
			for each(var childItem:AccordionStrip in _children[index])
			{
				childItem.y = currentHeight;
				childItem.x = _hGap;
				_content.addChild(childItem);
				currentHeight+=childItem.height;
			}
		}

		public function setSize($width:Number,$height:Number):void
		{
			_width = $width;
			_height = $height;
			_content.scrollRect = new Rectangle(0,0,_width,_height);
		}
		
		private function __onScroll(evt:ScrollEvent):void
		{
			var rect:Rectangle = _content.scrollRect;
			rect.y = evt.position;
			_content.scrollRect = rect;
		}

		public function dispose():void
		{
			
		}

	}
}