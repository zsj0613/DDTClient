package ddt.view.bagII
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	
	import game.crazyTank.view.bagII.DeleteDragAsset;
	import game.crazyTank.view.bagII.RublishAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HConfirmDialog;
	
	import ddt.interfaces.IDragable;
	import ddt.manager.DragManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;
	import ddt.view.cells.BagCell;
	import ddt.view.cells.DragEffect;
	import ddt.view.cells.ICell;

    public class DeleteGoodsBtn extends RublishAsset implements IDragable
	{
		public var isActive:Boolean = false;
		private var lightingFilter:ColorMatrixFilter;
		public function DeleteGoodsBtn()
		{
			super();
			init();			
		}
		
		private function init():void
		{
			buttonMode = true;
			addEventListener(MouseEvent.MOUSE_OVER,__mouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,__mouseOut);
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
		
		public function dragStart(stageX:Number,stageY:Number):void
		{
			isActive = true;
			var dragAsset:Sprite=new DeleteDragAsset();
			DragManager.startDrag(this,this,dragAsset,stageX,stageY,DragEffect.MOVE,false);
		}
		
		private var _dragTarget:BagCell;
		private var _confirm:HConfirmDialog;
		public function dragStop(effect:DragEffect):void
		{
			isActive = false;
			if(PlayerManager.Instance.Self.bagLocked && effect.target is ICell)
			{
//				HConfirmDialog.show("提示","二级密码尚未解锁，不可进行操作。");
				new BagLockedGetFrame().show();
				return;
			}
			if(effect.action == DragEffect.MOVE && effect.target is ICell)
			{
				var cell:BagCell = effect.target as BagCell;
				if(cell)
				{
					_dragTarget = cell;
					SoundManager.Instance.play("008");
					_confirm = HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.bagII.DeleteGoodsBtn.sure"),true,confirmBack,cancelBack);
//					ConfirmDialog.show("提示","确定删除此物品？",true,confirmBack,cancelBack);
					_confirm.addEventListener(Event.REMOVED, __removeHandler);
				}
			}
		}
		
		private function __removeHandler(e:Event):void
		{
			_confirm.removeEventListener(Event.REMOVED, __removeHandler);
			cancelBack();
			_confirm = null;
		}
		
		public function getSource():IDragable
		{
			return this;
		}
		
		public function getDragData():Object
		{
			return this;
		}

		private function confirmBack():void
		{
			if(_dragTarget && _dragTarget.itemInfo)
			{
				SocketManager.Instance.out.sendMoveGoods(_dragTarget.itemInfo.BagType,-1,_dragTarget.itemInfo.BagType,_dragTarget.itemInfo.Place);
			}
			
			//开始第二次删除的拖动
			if(stage)
			{
				dragStart(stage.mouseX,stage.mouseY);
			}
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
			removeEventListener(MouseEvent.MOUSE_OVER,__mouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT,__mouseOut);
			
			lightingFilter = null;
			this.filters = null;
			
			if(_confirm)
			{
				_confirm.removeEventListener(Event.REMOVED, __removeHandler);
				_confirm.close();
				_confirm.dispose();
			}
			_confirm = null;
			
			if(parent)
				parent.removeChild(this);
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