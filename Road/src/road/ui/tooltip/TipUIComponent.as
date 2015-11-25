package road.ui.tooltip
{
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import road.ui.manager.TipManager;

	public class TipUIComponent extends UIComponent implements ITipRender
	{
		private var background:Sprite;
		private var _tooltip:String;
		override protected function configUI():void
		{
			super.configUI();
			
			background = new Sprite();
			background.graphics.beginFill(0,0);
			background.graphics.drawRect(0,0,10,10);
			background.graphics.endFill();
			
			this.addChildAt(background,0);
			
			this.addEventListener(MouseEvent.ROLL_OVER,mouseOverHandler);
			this.addEventListener(MouseEvent.ROLL_OUT,mouseOutHandler);
			
			//this.buttonMode = true;
			//this.useHandCursor = true;
		}
		
		public function set toolTip(value:String):void
		{
			_tooltip = value;
			
		}
		public function get toolTip():String
		{
			return _tooltip;
		}
		
		override protected function draw():void
		{
			if(isInvalid(InvalidationType.SIZE))
			{
				drawLayout();
			}
			super.draw();
		}
		
		protected function drawLayout():void
		{
			background.width = this.width;
			background.height = this.height;
		}
		
		public function createTipRender():DisplayObject
		{
			if(_tooltip)
			{
				return new SimpleTipRender(_tooltip);
			}
			else
			{
				return null ;
			}
		}
		protected function mouseOverHandler(event:MouseEvent):void
		{
			var p:Point = this.localToGlobal(new Point(background.width,background.height));
			TipManager.setCurrentTarget(this,createTipRender());
		}
		
		protected function mouseOutHandler(event:MouseEvent):void
		{
			stopTip();
		}
		
		protected function stopTip():void
		{
			TipManager.setCurrentTarget(null,null);
		}
	}
}