package ddt.view.bagII
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	
	import game.crazyTank.view.bagII.PropGlowBgAccect;
	
	import ddt.interfaces.IAcceptDrag;
	import ddt.manager.DragManager;
	import ddt.view.cells.DragEffect;
	import ddt.view.items.ItemCellView;

	public class KeySetItem extends ItemCellView implements IAcceptDrag
	{
		private var _isGlow:Boolean = false;
		private var glow_mc:PropGlowBgAccect;
		private var lightingFilter:ColorMatrixFilter;
		
		public function KeySetItem(index:uint=0, item:DisplayObject=null, isCount:Boolean=false)
		{
			super(index, item, isCount);
			glow_mc = new PropGlowBgAccect();
			addChild(glow_mc);
			this.glow_mc.visible = false;
			addEventListener(MouseEvent.ROLL_OVER,__over);
			addEventListener(MouseEvent.ROLL_OUT,__out);
			setUpLintingFilter();
		}
		
		public function dragDrop(effect:DragEffect):void
		{
			DragManager.acceptDrag(this,DragEffect.NONE);
		}
		
		private function __over(e:MouseEvent):void
		{
			this.filters = [lightingFilter];
		}
	
		private function __out(e:MouseEvent):void
		{
			this.filters = null;
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
		
	
		public function set glow (b:Boolean):void
		{
			_isGlow = b;
			this.glow_mc.visible = _isGlow;
		}
		
		public function get glow():Boolean
		{
			return _isGlow;
		}
		
		override public function dispose():void
		{
			removeEventListener(MouseEvent.ROLL_OVER,__over);
			removeEventListener(MouseEvent.ROLL_OUT,__out);
			
			if(glow_mc && glow_mc.parent)
			{
				glow_mc.parent.removeChild(glow_mc);
			}
			
			lightingFilter = null;
			this.filters = null;
			
			glow_mc = null;
			
			super.dispose();
		}
	}
}