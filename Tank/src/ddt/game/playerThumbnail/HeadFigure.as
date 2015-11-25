package ddt.game.playerThumbnail
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ddt.data.game.Living;
	import ddt.data.game.Player;
	import ddt.data.game.SimpleBoss;
	import ddt.view.characterII.ShowCharacter;

	public class HeadFigure extends Sprite
	{
		private var _head:Bitmap;
		private var _info:Player;
		private var _width:Number;
		private var _height:Number;
		private var _living:Living;
		
		private var _isGray:Boolean = false;
		
		public function HeadFigure($width:Number,$height:Number,Obj:Object = null)
		{
			if(Obj is Player)
			{
				_info=(Obj as Player);
				_info.character.addEventListener(Event.COMPLETE,bitmapChange);
			}else
			{
				_living=(Obj as Living);
				_living.addEventListener(Event.COMPLETE,bitmapChange);
			}
			_width = $width;
			_height = $height;
			initFigure();
			this.width = $width;
			this.height = $height;
		}
		
		private function initFigure():void
		{
			
			if(_living)
			{
				_head = _living.thumbnail;
		//		_head.width = 
				addChild(_head);
			}else
			{
				var cBitmapData:BitmapData= (_info.character as ShowCharacter).characterBitmapdata.clone();
				drawHead(cBitmapData);
				addChild(_head);
			}
		}
		
		private function bitmapChange(e:Event):void
		{
			var cBitmapData:BitmapData = _info.character.characterBitmapdata;
			drawHead(cBitmapData);
			if(_isGray) gray();
		}
		
		private function drawHead(source:BitmapData):void
		{
				if(source == null) return;
				if(_head)
				{
					_head.bitmapData.dispose();
					_head = null;
				}
				var temp:BitmapData;
				if(_living is SimpleBoss)
				{
					temp = new BitmapData(110,110,true,0);
				}else{
					temp = new BitmapData(80,80,true,0);
				}
			//	var temp:BitmapData = new BitmapData(80,80,true,0);
				_head = new Bitmap(new BitmapData(_width,_height,true,0),PixelSnapping.NEVER,true);
				temp.copyPixels(source,getHeadRect(),new Point(0,0));
				_head.bitmapData = temp;
				temp = null;
				source = null;
				
				addChild(_head);
		}
		
		private function getHeadRect():Rectangle
		{
				if(_info == null)
				{
					if(_living is SimpleBoss)
					{
						return 	new Rectangle(0,0,300,300);
					}else{
						return  new Rectangle(-2,-2,80,80);//(10,25,80,80);
					}
				} 
				if(_info.playerInfo.getSuitsType() == 1)
				return new Rectangle(10,6,80,80);
				return new Rectangle(10,25,80,80);
		}
		
		public function gray():void
		{
			if(_head)
			{
				_head.filters = [new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0])];
			}
			_isGray = true;
		}
		
		public function dispose():void
		{
			if(_info)
			{
				_info.character.removeEventListener(Event.COMPLETE,bitmapChange);
				_head.bitmapData.dispose();
				_head.bitmapData = null;
			}
			_living = null;
			_head = null;
			_info = null;
			if(parent) parent.removeChild(this);
		}
	}
}