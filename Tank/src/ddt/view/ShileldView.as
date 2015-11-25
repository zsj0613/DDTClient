package ddt.view
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import ddt.data.Config;
	/**
	 * 游戏屏敝窗口 
	 * @author SYC
	 * 
	 */
	public class ShileldView extends Sprite
	{
		public function ShileldView()
		{
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			graphics.beginFill(0xff0000,0);
			graphics.drawRect(0,0,Config.GAME_WIDTH,Config.GAME_HEIGHT);
			graphics.endFill();
		}
		
		private function initEvent():void
		{
			addEventListener(MouseEvent.CLICK,__shile);
		}
		
		private function __shile(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
		}

		
	}
}