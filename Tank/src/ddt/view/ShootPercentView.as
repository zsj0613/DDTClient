package ddt.view
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import tank.asset.*;
	
	public class ShootPercentView extends Sprite
	{
		private var _pic:Sprite;
		private var _type:int;
		private var _isAdd:Boolean;
		
		public function ShootPercentView(n:int,type:int = 1,isadd:Boolean = false)
		{
			_type = type;
			_isAdd = isadd;
			_pic = getPercent(n);			
			this.addEventListener(Event.ADDED_TO_STAGE,__addToStage);
			if(_pic != null)
				addChild(_pic);
		}
		
		private function __addToStage(evt:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,__addToStage);
			if(_pic == null)return;
			if(_type == 1)
			{
				_pic.x = -70;
				_pic.y = -20;
			}
			else
			{
				_pic.scaleX = _pic.scaleY = 0.5;
			}
			_pic.alpha = 0;
			_pic.addEventListener(Event.ENTER_FRAME,__enterFrame);
		}
		
		
		private function __enterFrame(evt:Event):void
		{
			if(_type == 1)
			{
				doShowType1();
			}
			else
			{
				doShowType2();
			}
		}
		
		private var add:Boolean = true;
		private var tmp:int = 0;
		private function doShowType1():void
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
				_pic.removeEventListener(Event.ENTER_FRAME,__enterFrame);
				if(parent)parent.removeChild(this);
				_pic = null;
			}
		}
		
		private function doShowType2():void
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
					_pic.scaleX = _pic.scaleY += 0.24;
					_pic.alpha += 0.4;
				}
				else
				{
					_pic.scaleX = _pic.scaleY += 0.125;
					_pic.alpha -= 0.15;
				}
				_pic.x = -_pic.width / 2 + 10;
				_pic.y = -_pic.height / 2;
			}
			if(_pic.alpha < 0.05)
			{
				_pic.removeEventListener(Event.ENTER_FRAME,__enterFrame);
				if(parent)parent.removeChild(this);
				_pic = null;
			}
		}
		
		public function getPercent(n:int):Sprite
		{
			if(n > 99999)return null;
			var numberContainer:Sprite = new Sprite();
			numberContainer.mouseChildren = numberContainer.mouseEnabled = false;
			numberContainer.scrollRect = null;
			if(_type == 2)
			{
				if(!_isAdd)
				{
					numberContainer.addChild(new RedNumberBackgound());
				}
			}
			var s:String = String(n);
			var len:int = s.length;
			var xpos:int = 33 + (4 - len) * 10;
			if(_isAdd)
			{
				s = " " + s;
				len += 1;
				xpos -= 10;
				var addIcon:GreenNumberAddIcon = new GreenNumberAddIcon();
				addIcon.x = xpos;
				addIcon.y = 20;
				numberContainer.addChild(addIcon);
			}
			for(var i:int = _isAdd ? 1 : 0; i < len; i++)
			{
				var b:MovieClip;
				if(_isAdd)
				{
					b = new GreenNumberAsset();
				}else
				{
					b = new RedNumberAsset();
				}
				b.x = xpos + i * 20;
				b.y = 20;
				b.gotoAndStop(int(s.charAt(i))+1);
				numberContainer.addChild(b);
			}
			return numberContainer;
		}
	}
}