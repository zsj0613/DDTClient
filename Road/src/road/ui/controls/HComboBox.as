package road.ui.controls
{
	import fl.controls.List;
	import fl.controls.listClasses.ICellRenderer;
	import fl.core.UIComponent;
	import fl.data.DataProvider;
	import fl.events.ListEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class HComboBox extends UIComponent
	{
		private var _bg:MovieClip;
		private var _text:TextField;
		private var _list:List;
		
		private var _highlightedCell:int;
		private var _currentIndex:int;
		private var _isOpen:Boolean = false;
		
		public var useHtmlText:Boolean = true;
		
		public function HComboBox(bg:MovieClip)
		{
			_bg = bg;
			init();
			initEvents();
			super();
		}
		
		override protected function configUI():void
		{
			addChild(_bg);
			addChild(_text);
		}
		
		private function init():void
		{
			_bg.gotoAndStop(1);
			_bg["clickAsset"].visible = false;
			_bg["clickAsset"].mouseEnabled = _bg["clickAsset"].mouseChildren = false;
			_text = new TextField();
			setTextPosition(2,3);
			_text.width = _bg.width - 30;
			_text.mouseEnabled = false;
			var textFormat:TextFormat = new TextFormat();
			textFormat.size = 18;
			_text.defaultTextFormat = textFormat;
			
			_list = new List();
			_list.width = _bg.width;
			_list.rowHeight = _bg.height * 0.9;
			_list.setRendererStyle("textFormat",new TextFormat(null,18));
		}
		
		private function initEvents():void
		{
			_bg.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_bg.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
			_bg.addEventListener(MouseEvent.CLICK,clickHandler);
			_bg.addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
			_bg.addEventListener(MouseEvent.MOUSE_UP,upHandler);
			_list.addEventListener(Event.CHANGE,listChangeHandler);
			_list.addEventListener(ListEvent.ITEM_CLICK,itemClickHanlder);
			addEventListener(Event.REMOVED_FROM_STAGE,removeFromStageHandler);
		}
		
		private function removeEvents():void
		{
			_bg.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_bg.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
			_bg.removeEventListener(MouseEvent.CLICK,clickHandler);
			_bg.removeEventListener(MouseEvent.MOUSE_DOWN,downHandler);
			_list.removeEventListener(Event.CHANGE,listChangeHandler);
			_list.removeEventListener(ListEvent.ITEM_CLICK,itemClickHanlder);
			removeEventListener(Event.REMOVED_FROM_STAGE,removeFromStageHandler);
		}
		
		private function overHandler(evt:MouseEvent):void
		{
			_bg.gotoAndStop(2);
		}
		
		private function outHandler(evt:MouseEvent):void
		{
			_bg.gotoAndStop(1);
			_bg["clickAsset"].visible = false;
		}
		
		private function clickHandler(evt:MouseEvent):void
		{
			if(!_isOpen)
			{
				open();
			}else
			{
				close();
			}
		}
		
		private function downHandler(evt:MouseEvent):void
		{
			_bg["clickAsset"].visible = true;
		}
		
		private function upHandler(evt:MouseEvent):void
		{
			_bg["clickAsset"].visible = false;
		}
		
		private function listChangeHandler(evt:Event):void
		{
			updateTxt();
			dispatchEvent(evt);
		}
		
		private function itemClickHanlder(evt:Event):void
		{
			close();
		}
		
		private function removeFromStageHandler(evt:Event):void
		{
			if(stage.contains(_list)) 
			{
				stage.removeChild(_list);
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageClick);
			}
		}
		
		private function updateTxt():void
		{
			if(useHtmlText)
			{
				_text.htmlText = _list.selectedItem == null ? "" :createHtmlText(String(_list.selectedItem.label).split(" "));
				
			}else
			{
				_text.text = _list.selectedItem == null ? "" : _list.selectedItem.label;
			}
		}
		
		private function createHtmlText(strings:Array):String
		{
			var result:String = "";
			result += "<B><FONT SIZE='15' FACE='宋体' COLOR='#10f7ff' BOLD = 'true'>" + strings[0] + "</FONT></B>"
					+ "<B><FONT SIZE='15' FACE='宋体' COLOR='#ffc000' BOLD = 'true'>" + strings[1] + "</FONT></B>";
			return result;
		}
		
		public function set dataProvider(dp:DataProvider):void
		{
			_list.dataProvider = dp;
			selectedIndex = 0;
			_list.rowCount = dp.length;
			updateTxt();
		}
		
		public function setTextPosition(x:Number,y:Number):void
		{
			_text.x = x;
			_text.y = y;
		}
		
		public function addItem(item:Object):void
		{
			_list.addItem(item);
		}
		
		public function removeItem(item:Object):void
		{
			_list.removeItem(item);
		}
		
		public function removeAll():void
		{
			_list.removeAll();
		}
		
		public function getItemAt(index:uint):Object {
			return _list.getItemAt(index);
		}
		
		public function get selectedIndex():int {
			return _list.selectedIndex;
		}

		public function set selectedIndex(value:int):void {
			_list.selectedIndex = value;
			highlightCell();
			updateTxt();
		}
		
		public function get selectedItem():Object
		{
			return _list.selectedItem;
		}
		
		public function get length():int
		{
			return _list.length;
		}
		
		public function set selectedItem(item:Object):void
		{
			_list.selectedItem = item;
			updateTxt();
		}
		
		public function get textFeild():TextField
		{
			return _text;
		}
		
		public function open():void
		{
			_currentIndex = selectedIndex;
			if (_isOpen || length == 0) { return; }

			dispatchEvent(new Event(Event.OPEN));
			_isOpen = true;

			addEventListener(Event.ENTER_FRAME, addCloseListener, false, 0, true);			

			positionList();
			_list.scrollToSelected();
			stage.addChild(_list);
		}
		
		public function close():void {
			highlightCell();
			_highlightedCell = -1;
			if (! _isOpen) { return; }
			
			dispatchEvent(new Event(Event.CLOSE));
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageClick);
			_isOpen = false;
			stage.removeChild(_list);
		}
		
		private function addCloseListener(event:Event):void {
			removeEventListener(Event.ENTER_FRAME, addCloseListener);
			if (!_isOpen) { return; }
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageClick, false, 0, true);
		}
		
		protected function onStageClick(event:MouseEvent):void {
			if (!_isOpen) { return; }
			if (! contains(event.target as DisplayObject) && !_list.contains(event.target as DisplayObject)) {
				if (_highlightedCell != -1) {
					selectedIndex = _highlightedCell;
					dispatchEvent(new Event(Event.CHANGE));
				}
				close();
			}
		}
		
		protected function highlightCell(index:int=-1):void {
			var renderer:ICellRenderer;
			
			if (_highlightedCell > -1) {
				renderer = _list.itemToCellRenderer(getItemAt(_highlightedCell));
				if (renderer != null) {
					renderer.setMouseState("up");
				}
			}
			
			if (index == -1) { return; }
			
			_list.scrollToIndex(index);
			_list.drawNow();
			
			renderer = _list.itemToCellRenderer(getItemAt(index));
			if (renderer != null) {
				renderer.setMouseState("over");
				_highlightedCell = index;
			}
		}
		
		private function positionList():void
		{
			var p:Point = localToGlobal(new Point(0,0));
			_list.x = p.x;
			if (p.y + height + _list.height > stage.stageHeight) {
				_list.y = p.y - _list.height;
			} else {
				_list.y = p.y + height;
			}
		}
		
		override public function get height():Number
		{
			return _bg.height;
		}
		
		override public function set height(value:Number):void
		{
			_bg.height = value;
		}
		
		override public function get width():Number { return _bg.width; }
		
		override public function set width(value:Number):void {
			if (_bg.width == value) { return; }
			_bg.width = value;
		}
		
		override public function setSize(width:Number, height:Number):void
		{
			_bg.width = width;
			_bg.height = height;
			_list.width = _bg.width;
			_list.rowHeight = _bg.height * 0.9;
		} 
		
		public function dispose():void
		{
			removeEvents();
			_list.removeAll();
			_list = null;
		}
		
	}
}