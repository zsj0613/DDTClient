package road.ui.controls.HButton
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;

	public class HGlowButton extends HTipButton
	{
		
		private var timFilter:ColorMatrixFilter;
		private var glowAni:MovieClip;
		
		private var isGlow:Boolean = false;
		public function HGlowButton($bg:DisplayObject, $label:String="label", $tip:String="tips")
		{
			
			super($bg, $label, $tip);
			super.hitArea = $bg as Sprite;
			initAin();
			setUpTimFilter();
			if(_bg is MovieClip)
			{
				MovieClip(_bg).gotoAndStop(1);
			}
		}
	
		private function initAin():void
		{
			glowAni = new GlowAniAccect();
			glowAni.mouseEnabled = false;
			glowAni.x = _bg.width/2;
			glowAni.y = _bg.height/2;
		}
		
		
		private function setUpTimFilter():void
		{
			var matrix:Array = [1.82968,-0.73128,-0.0984,0,0,-0.37032,1.46872,-0.0984,0,0,-0.37032,-0.73128,2.1016,0,0,0,0,0,1,0]
			timFilter = new ColorMatrixFilter(matrix);
		}
		
		override protected function outHandler(evt:MouseEvent):void
		{
			super.outHandler(evt);
			container.filters = null;
		}
		
		
		public function set glow(b:Boolean):void
		{
			isGlow = b;
			if(!enable && b)return;
			if(b)
			{
				addChild(glowAni);
				if(_bg is MovieClip)
				{
					MovieClip(_bg).gotoAndStop(2);
				}
			}else
			{
				if(glowAni.parent)
				{
					removeChild(glowAni);
				}
				if(_bg is MovieClip)
				{
					MovieClip(_bg).gotoAndStop(1);
				}
			}
		}
		
		
		
		override public function set enable(b:Boolean):void
		{
			super.enable = b;
			if(!b)
			{
				if(isGlow)
				{
					glow = false;
					isGlow = true;
				}
			}else
			{
				if(isGlow)
				{
					glow = true;
				}
			}
		}
		
		

		override protected function downHandler(evt:MouseEvent):void
		{
			container.filters = [timFilter];
		}
		override protected function upHandler(evt:MouseEvent):void
		{
			container.filters = null;
		}
		
	}
}