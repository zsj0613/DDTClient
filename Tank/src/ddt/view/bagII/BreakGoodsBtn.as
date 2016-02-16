package ddt.view.bagII
{
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	
	import game.crazyTank.view.bagII.BreakBtnAccect;
	import game.crazyTank.view.bagII.BreakMouseIconAccect;
	
	import road.manager.SoundManager;
	
	import ddt.interfaces.IDragable;
	import ddt.manager.DragManager;
	import ddt.manager.PlayerManager;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;
	import ddt.view.cells.BagCell;
	import ddt.view.cells.DragEffect;
	import ddt.view.cells.ICell;
	import ddt.view.common.ButtonTip;

	public class BreakGoodsBtn extends BreakBtnAccect implements IDragable
	{
		private var _tip:ButtonTip;
		private var _dragTarget:BagCell;
		private var _enabel:Boolean;
		
		private var myColorMatrix_filter:ColorMatrixFilter;
		
		private var lightingFilter:ColorMatrixFilter;
		
		public function BreakGoodsBtn()
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
//		
		private function __mouseClick(event:MouseEvent):void
		{
			if(!PlayerManager.Instance.Self.bagLocked)
			{
				dragStart(event.stageX,event.stageY);
			}
			
		}
		
		public function dragStart(stageX:Number,stageY:Number):void
		{
			DragManager.startDrag(this,this,new BreakMouseIconAccect(),stageX,stageY,DragEffect.MOVE);
		}

		
		public function dragStop(effect:DragEffect):void
		{
			if(effect.action == DragEffect.MOVE && effect.target is ICell)
			{
				var cell:BagCell = effect.target as BagCell;
				if(cell)
				{
					if(cell.itemInfo.Count > 1 && cell.itemInfo.BagType != 11)
					{
						_dragTarget = cell;
						SoundManager.Instance.play("008");
						var win:BreakGoodsView = new BreakGoodsView(cell);
						win.show();
					}
					
					//ConfirmDialog.show("提示","确定删除此物品？",true,confirmBack,cancelBack);
				}
			}
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
		
		private function breakBack():void
		{
			if(_dragTarget)
			{
			}
			
			//开始第二次删除的拖动
			if(stage)
			{
				dragStart(stage.mouseX,stage.mouseY);
			}
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
			removeEventListener(MouseEvent.CLICK,__mouseClick);
		}
		
		private function addEvent():void
		{
			addEventListener(MouseEvent.MOUSE_OVER,__mouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,__mouseOut);
			addEventListener(MouseEvent.CLICK,__mouseClick);
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
		
		
		
		private function cancelBack():void
		{
			if(_dragTarget)
			{
				_dragTarget.locked = false;
			}
		}
		
	}
}