package road.ui.controls
{
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class PictureBox extends UIComponent
	{
		private var floor:DisplayObject;
		
		private var border:DisplayObject;
		
		private var container:Sprite;
		
		public function PictureBox()
		{
			super();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			container = new Sprite();
			addChild(container);
			
			floor = new PictureBox_Floor();
			addChild(floor);
			
			border = new PictureBox_Border();
			addChild(border);
		}
		
		public function appendItem(item:DisplayObject):void
		{
			container.addChild(item);
		}
		
		public function removeItem(item:DisplayObject):void
		{
			container.removeChild(item);
		}
		
		override protected function draw():void
		{
			if(isInvalid(InvalidationType.SIZE))
			{
				drawSize();
			}
			super.draw();
		}
		
		protected function drawSize():void
		{
			container.scrollRect = new Rectangle(1,1,width -1,height -1);
			this.scrollRect = new Rectangle(0,0,width,height);
			border.width = width;
			border.height = height;
		}
		
		
	}
}