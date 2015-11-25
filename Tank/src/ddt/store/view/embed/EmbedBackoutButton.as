package ddt.store.view.embed
{
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	
	import game.crazyTank.view.storeII.embedBackoutDownItem.embedBackoutBtn;
	
	import road.ui.controls.hframe.HConfirmFrame;
	
	import ddt.interfaces.IDragable;
	import ddt.view.cells.DragEffect;
	
	public class EmbedBackoutButton extends embedBackoutBtn implements IDragable
	{
		private var _enabel:Boolean;
		private var _dragTarget:EmbedStoneCell;
		private var myColorMatrix_filter:ColorMatrixFilter;
		private var _hcFrame:HConfirmFrame;
		private var lightingFilter:ColorMatrixFilter;
		public var isAction:Boolean;//是否已激活拆除按钮
		
		public function EmbedBackoutButton()
		{
			super();
			init();	
		}
		
		private function init ():void
		{
			buttonMode = true;
			addEvent();
			setUpGrayFilter();
			setUpLintingFilter();
		}
		
		private function __mouseOver(evt:MouseEvent):void
		{
			this.filters = [lightingFilter];
		}
		
		private function __mouseOut(evt:MouseEvent):void
		{
			this.filters = null;
		}
		
		public function dragStop(effect:DragEffect):void
		{
			this.mouseEnabled=true;
			this.isAction=false;
		}
		
		private function setUpGrayFilter():void {
			var myElements_array:Array = [0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0];
			myColorMatrix_filter = new ColorMatrixFilter(myElements_array);
		}
		
		public function set enable (b:Boolean):void
		{
			_enabel = b;
			buttonMode = b;
			if(b)
			{
				addEvent();
				this.filters = null;
				
			}else
			{
				removeEvent();
				this.filters = [myColorMatrix_filter];
			}
		}
		
		public function get enable ():Boolean
		{
			return _enabel;
		}
		
		public function getSource():IDragable
		{
			return this;
		}
		
		public function getDragData():Object
		{
			return this;
		}
		
		private function removeEvent():void
		{
			removeEventListener(MouseEvent.MOUSE_OVER,__mouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT,__mouseOut);
		}
		
		private function addEvent():void
		{
			addEventListener(MouseEvent.MOUSE_OVER,__mouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,__mouseOut);
		}
		
		private function setUpLintingFilter():void
		{
			var matrix:Array = new Array();
			matrix = matrix.concat([1, 0, 0, 0, 25]);// red
			matrix = matrix.concat([0, 1, 0, 0, 25]);// green
			matrix = matrix.concat([0, 0, 1, 0, 25]);// blue
			matrix = matrix.concat([0, 0, 0, 1, 0]);// alpha
			lightingFilter = new ColorMatrixFilter(matrix);   //这里好像是 new BitmapFilter(matrix);
		}
		
		public function dispose ():void
		{
			removeEvent();
		}
	}
}