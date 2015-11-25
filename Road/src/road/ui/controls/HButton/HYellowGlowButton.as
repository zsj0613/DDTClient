package road.ui.controls.HButton
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;

	public class HYellowGlowButton extends HBaseButton
	{
		private var  bgCloneData : BitmapData;
		private var  bgclone     : Bitmap;
		private var  itemsName   : String;
		
		private var yellowGlow1  : GlowFilter;
		private var yellowGlow2  : GlowFilter;
		private var _select      : Boolean;
		public function HYellowGlowButton($bg: DisplayObject,name : String="",$itemsName:String="", $label:String="")
		{
			super($bg, $label);
			bgCloneData =($bg as Bitmap).bitmapData.clone();
			bgclone = new Bitmap(bgCloneData);
			if(name != "")
			this.name = this.container.name = name;
			itemsName = $itemsName;
			creatGlow();
			initRemoveEvent();
		}
		
		private function creatGlow():void
		{
			yellowGlow1 = new GlowFilter(0xFFFF99,1,15,15,1,BitmapFilterQuality.LOW);
			yellowGlow2 = new GlowFilter(0xFFFF99,1,10,10,1.6,BitmapFilterQuality.HIGH,true,true);
		}
		private function initRemoveEvent() : void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN,downHandler);
			removeEventListener(MouseEvent.MOUSE_UP,upHandler);
		}
		
		override protected function overHandler(evt:MouseEvent):void
		{
			bg.filters = [yellowGlow1];
			bgclone.filters = [yellowGlow2];
			addChild(bgclone);
		}
		override protected function outHandler(evt:MouseEvent):void
		{
			if(_select)return;
//			this.dispatchEvent(new Event("move"));
//			if(this.itemsName != null && this.itemsName != "") return;
			bg.filters = null;
			if(bgclone.parent)
			removeChild(bgclone);
			
		}
		override protected function clickHandler(evt:MouseEvent):void
		{
			super.clickHandler(evt);
//			this.dispatchEvent(new Event("change"));
		}
		
		override public function dispose():void
		{
		    bgCloneData = null;
		    bgclone     = null;
		    yellowGlow1 = null;
		    yellowGlow2 = null;
			super.dispose();
		}
		
		
		
		
		/********************************
		 *        外部方法
		 * *****************************/
		
		/**
		 * 设为不选中
		 */
		public function revert() : void
		{
			bg.filters = [];
			bg.filters = null;
			if(bgclone.parent)
			bgclone.parent.removeChild(bgclone);
			_select = false;
		}
		
		/**
		 * 是否为当前组的选中节点
		 */
		public function currentItem() : void
		{
			revert();
			bg.filters = [yellowGlow1];
			bgclone.filters = [yellowGlow2];
			addChild(bgclone);
			
			_select = true;
		}
		
		
		
		
		
	}
}