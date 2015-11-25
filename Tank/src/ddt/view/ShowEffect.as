package ddt.view
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import tank.asset.GuardWordAsset;
	
	/**
	 * @author Wicki-LA
	 * @time 01/18/2010
	 * @description 类似于掉血的那种头上冒出的效果
	 * 				若要添加效果，在initPicture里面添加case，然后嵌入图片
	 * */

	public class ShowEffect extends Sprite
	{	
		public static var GUARD:String = "guard";
		
		private var _type:String;
		private var _pic:MovieClip;
		
		public function ShowEffect(type:String)
		{
			super();
			_type = type;
			init();
		}
		
		private function init():void
		{
			initPicture();
			addChild(_pic);
			addEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}
		
		private var tmp:int = 0;
		private var add:Boolean = true;
		private function enterFrameHandler(evt:Event):void
		{
			if(_pic.alpha > 0.95)
			{
				tmp ++;
				if(tmp == 20)
				{
					add = false;
					_pic.alpha = 0.9;
				}
			}
			if(_pic.alpha < 1)
			{
				if(add)
				{
					_pic.y -= 8;
					_pic.alpha += 0.22;
				}
				else
				{
					_pic.y -= 6;
					_pic.alpha -= 0.1;
				}
			}
			if(_pic.alpha < 0.05)
			{
				dispose();
			}
		}
		
		private function initPicture():void
		{
			switch(_type)
			{
				case GUARD:
					_pic = new GuardWordAsset();
					break;
				default:
					_pic = new MovieClip();
					break;
			}
		}
		
		public function dispose():void
		{
			removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
			if(parent) parent.removeChild(this);
			_pic = null;
		}
		
	}
}