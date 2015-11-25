package ddt.game.smallmap
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import game.crazyTank.view.SmallMapAsset;
	
	import road.manager.SoundManager;
	import road.ui.manager.TipManager;
	
	import ddt.data.Config;
	import ddt.game.animations.DragMapAnimation;
	import ddt.game.map.MapView;
	import ddt.manager.LanguageMgr;
	import ddt.manager.RoomManager;
	import tank.game.smallmap.*;

	/**
	 * 小地图 
	 * @author SYC
	 * 
	 */
	public class SmallMapView extends SmallMapAsset
	{
		private static const NUMBERS_ARR:Array = [ShineNumber1,ShineNumber2,ShineNumber3,ShineNumber4,ShineNumber5,
											ShineNumber6,ShineNumber7,ShineNumber8,ShineNumber9];
		
		private var _isSwitchScreen:Boolean;
		
		
		private var _changeScale:Number = 0.2;
		
		private var _locked:Boolean;
		
		private var _allowDrag:Boolean = true;
		
		private var _split:Sprite;
		private var _texts:Array;
		private var _mask:Sprite;
		
		public function set locked(value:Boolean):void
		{
			 _locked = value;
		}
		public function get locked():Boolean{
			return _locked;
		}
		
		public function set allowDrag(value:Boolean):void
		{
			_allowDrag = value;
			if(!_allowDrag) __mouseUp(null);
		}
		
		public static var MAX_WIDTH:int = 165;
		
		public static var MIN_WIDTH:int = 120;
		
		private var _mapBmp:Bitmap;
		
		private var _mapDeadBmp:Bitmap;
		
		private var _rateX:Number;
		
		private var _map:MapView;
		

		public static const HARD_LEVEL:Array = [LanguageMgr.GetTranslation("ddt.game.smallmap.simple"),LanguageMgr.GetTranslation("ddt.game.smallmap.normal"),LanguageMgr.GetTranslation("ddt.game.smallmap.difficulty"),LanguageMgr.GetTranslation("ddt.game.smallmap.hero")];
		public static const HARD_LEVEL1:Array = [LanguageMgr.GetTranslation("ddt.game.smallmap.simple1"),LanguageMgr.GetTranslation("ddt.game.smallmap.normal1"),LanguageMgr.GetTranslation("ddt.game.smallmap.difficulty1")];
		
		public function get rateX():Number
		{
			return _rateX;
		}
		
		private var _rateY:Number;
		public function get rateY():Number
		{
			return _rateY;
		}
		
		public function get smallMapW():Number
		{
			return mask_mc.width;
		}
		
		public function get smallMapH():Number
		{
			return mask_mc.height;
		}
		
		public function SmallMapView(map:MapView)
		{
			_map = map;
			initView();
			initEvent();
		}
		
		/**
		 * 
		 * @param value
		 * @param type 0是普通副本的“简单、普通、困难、英雄” 1是作战实验室的“初级、中级、高级”
		 * 
		 */	
		public function setHardLevel(value:int,type:int=0):void
		{
			if(type == 0)
			{
				hardLevel_txt.text = HARD_LEVEL[value];
			}else
			{
				hardLevel_txt.text = HARD_LEVEL1[value];
			}
		}
		private var ballPathContaint:Sprite;
		private function initView():void
		{
			var h:Number = _map.bound.height;
			var w:Number = _map.bound.width;
			
			var scaleH:Number = h / 120;
			smallMapContainer_mc.width = w / scaleH;
			smallMapContainer_mc.scaleY = 1;
			
			MAX_WIDTH = smallMapContainer_mc.width;
			MIN_WIDTH = MAX_WIDTH * (1 - _changeScale) *(1 -  _changeScale);
			MIN_WIDTH = MIN_WIDTH < 120 ? 120 : MIN_WIDTH;
			
			mapBorder_mc.width = w / scaleH;
			mapBorder_mc.scaleY = 1;
			mask_mc.width = smallMapContainer_mc.width;
			mask_mc.height = smallMapContainer_mc.height;
			screen_mc.buttonMode = true;
			screen_mc.useHandCursor = true;
			
			ballPathContaint = new Sprite();
			foreMap_mc.addChild(ballPathContaint);
			
			foreMap_mc.addChild(screen_mc);
			foreMap_mc.x = - mask_mc.width;
			_changeScale = -.2;
			_mapBmp = new Bitmap();
			_mapDeadBmp = new Bitmap();
			_mapBmpData = new BitmapData(smallMapContainer_mc.width - 1, smallMapContainer_mc.height - 1,true,0x000000);
			if(_map.stone)
			{
				_mapDeadBmpData = new BitmapData(smallMapContainer_mc.width - 1, smallMapContainer_mc.height - 1,true,0x000000);
			}
			if(RoomManager.Instance.current.roomType >= 2)
			{
				hardLevel_txt.selectable = false;
				hardLevel_txt.filters = [new GlowFilter(0x000000,1,4,4,10)];
				hardLevel_txt.x = mapBorder_mc.x - mapBorder_mc.width;
				hardLevel_txt.text = HARD_LEVEL[RoomManager.Instance.current.hardLevel];
			}
			large_btn.parent.removeChild(large_btn);
			small_btn.parent.removeChild(small_btn);
			
			_split = new Sprite();
			_split.mouseChildren = _split.mouseEnabled = false;
			foreMap_mc.addChild(_split);
			updateSpliter();
		}
		
		private function updateSpliter():void
		{
			while(_split.numChildren>0)
			{
				_split.removeChildAt(0);
			}
			_texts = [];
			var perW:Number = screen_mc.width/10;
			_split.graphics.clear();
			_split.graphics.lineStyle(1,0xffffff,1);
			for(var i:int=1;i<10;i++)
			{
				_split.graphics.moveTo(perW*i,0);
				_split.graphics.lineTo(perW*i,screen_mc.height);
				var round:MovieClip = new NUMBERS_ARR[i-1]();
				round.scaleX = round.scaleY = .5;
				round.x = perW*i;
				round.y = (screen_mc.height - round.height)/2;
				round.stop();
				_split.addChild(round);
				_texts.push(round);
			}
			_split.graphics.endFill();
		}
		
		public function ShineText(value:int):void
		{
			large();
			drawMask();
			for(var i:int=0;i<value;i++)
			{
				setTimeout(shineText,(i)*1500,i);
			}
		}
		
		private function drawMask():void
		{
			if(_mask == null)
			{
				_mask = new Sprite();
				_mask.graphics.beginFill(0x000000,.8);
				_mask.graphics.drawRect(0,0,Config.GAME_WIDTH,Config.GAME_HEIGHT);
				_mask.graphics.endFill();
				_mask.blendMode = BlendMode.LAYER;
				var hole:Sprite = new Sprite();
				hole.graphics.beginFill(0x000000,1);
				hole.graphics.drawRect(0,0,-foreMapMask_mc.width*scaleX,(foreMapMask_mc.height+mapBorder_mc.height)*scaleY);
				hole.graphics.endFill();
				hole.x = this.x;
				hole.y = this.y;
				hole.blendMode = BlendMode.ERASE;
				_mask.addChild(hole);
			}
			TipManager.AddTippanel(_mask);
		}
		
		private function clearMask():void
		{
			TipManager.RemoveTippanel(_mask);
		}
		
		private function large():void
		{
			scaleX = scaleY = 3;
			x -= 225;
			y += 130;
		}
		
		public function restore():void
		{
			scaleX = scaleY = 1;
			x = Config.GAME_WIDTH;
			y = 0;
			clearMask();
		}
		
		public function restoreText():void
		{
			for each(var round:MovieClip in _texts)
			{
				round.gotoAndStop(1);
			}
		}
		
		private function shineText(i:int):void
		{
			restoreText();
			if(i>4)
			{
				(_texts[4] as MovieClip).play();
			}else
			{
				(_texts[i] as MovieClip).play();
			}
		}
		
		public function showSpliter():void
		{
			_split.visible = true;
		}
		
		public function hideSpliter():void
		{
			_split.visible = false;
		}
		
		private function initEvent():void
		{
			large_btn.addEventListener(MouseEvent.CLICK,__largeMap);
			small_btn.addEventListener(MouseEvent.CLICK,__smallMap);
			
			screen_mc.addEventListener(MouseEvent.MOUSE_DOWN,__mouseDown);
			screen_mc.addEventListener(MouseEvent.MOUSE_UP,__mouseUp);
			screen_mc.addEventListener(MouseEvent.MOUSE_OUT,__mouseUp);
			
			foreMap_mc.addEventListener(MouseEvent.MOUSE_DOWN,__click);
//			
		}
		
		
		
		public function update():void
		{
			smallMapContainer_mc.mouseChildren = smallMapContainer_mc.mouseEnabled = false;
			smallMapContainer_mc.scrollRect = null;
//			if((smallMapContainer_mc.width >= MAX_WIDTH && _changeScale > 0) || (smallMapContainer_mc.width <= MIN_WIDTH && _changeScale < 0))
//			{
//				return;
//			}
			smallMapContainer_mc.scaleX = smallMapContainer_mc.scaleX + _changeScale ;
			smallMapContainer_mc.scaleY = smallMapContainer_mc.scaleY + _changeScale;
			
			mapBorder_mc.scaleX = mapBorder_mc.scaleX + _changeScale;
			
			mask_mc.width = smallMapContainer_mc.width - 1;
			mask_mc.height = smallMapContainer_mc.height- 2;
			
			foreMapMask_mc.width = mask_mc.width;
			foreMapMask_mc.height = mask_mc.height;
			foreMap_mc.x = -mask_mc.width;
			foreMap_mc.mask = foreMapMask_mc;
			
			_rateX = mask_mc.width / _map.info.ForegroundWidth;
			_rateY = mask_mc.height / _map.info.ForegroundHeight;
			
			screen_mc.width = Config.GAME_WIDTH * _rateX;
			screen_mc.height = Config.GAME_HEIGHT * _rateY;
			if(_changeScale != 0)
			{
				if(_mapBmpData)
					_mapBmpData.dispose();
				_mapBmpData = new BitmapData(smallMapContainer_mc.width - 1, smallMapContainer_mc.height - 1,true,0x000000);
				if(_map.stone)
				{
					if(_mapDeadBmpData)
						_mapDeadBmpData.dispose();
					_mapDeadBmpData = new BitmapData(smallMapContainer_mc.width - 1, smallMapContainer_mc.height - 1,true,0x000000);
				}
			}
			draw(true);
			drawDead(true);
			if(RoomManager.Instance.current.roomType >= 2)
			{
				hardLevel_txt.x = mapBorder_mc.x - mapBorder_mc.width;
			}		
			updateSpliter();
			_split.x = screen_mc.x;
			_split.y = screen_mc.y;
		}
		
		private var _mapDeadBmpData:BitmapData;
		private function drawDead(mustDraw:Boolean = false):void
		{
			if(!_map.mapChanged && !mustDraw) return;
			if(!_map.stone)return;
			_mapDeadBmpData.fillRect(new Rectangle(0,0,_mapDeadBmpData.width,_mapDeadBmpData.height),0xffffff);
			_mapDeadBmpData.draw(_map.stone,new Matrix(_rateX,0,0,_rateY),null,null,null,true);
			_mapDeadBmp.bitmapData = _mapDeadBmpData;
			foreMap_mc.addChildAt(_mapDeadBmp,0);	
		}
		
		private var _mapBmpData:BitmapData;
		public function draw(mustDraw:Boolean = false):void
		{
			if(!_map.mapChanged && !mustDraw) return;
			if(!_map.ground)return;
			_mapBmpData.fillRect(new Rectangle(0,0,_mapBmpData.width,_mapBmpData.height),0xffffff);
			_mapBmpData.draw(_map.ground,new Matrix(_rateX,0,0,_rateY),null,null,null,true);	
			_mapBmp.bitmapData = _mapBmpData;
			foreMap_mc.addChildAt(_mapBmp,0);
			setScreenPos(_map.x,_map.y);
		}		
		
		public function setScreenPos(posX:Number,posY:Number):void
		{
			if(!_locked)
			{
				screen_mc.x =  Math.abs(posX * _rateX);
				screen_mc.y = Math.abs(posY * _rateY);
			}
			_split.x = screen_mc.x;
			_split.y = screen_mc.y;
		}
		
		private var _child:Dictionary = new Dictionary();
		public function addObj(display:Sprite):void
		{
			display.mouseEnabled = false;
			display.mouseChildren = false;
			foreMap_mc.addChild(display);
			_child[display] = display;
		}
		
		public function removeObj(display:Sprite):void
		{
			if(display.parent == foreMap_mc)
			{
				foreMap_mc.removeChild(display);
			}
			delete _child[display];
		}
		
		public function updatePos(view:Sprite,pos:Point):void
		{
			if(view == null) return;
			foreMap_mc.addChild(view);
			view.x = pos.x * _rateX;
			view.y = pos.y * _rateY;
			_split.x = screen_mc.x;
			_split.y = screen_mc.y;
			//TipManager.AddTippanel(this,true);
		}
		
		public function dispose():void
		{
			removeEventListener(Event.ENTER_FRAME,__enterFrame);
			if(large_btn)large_btn.removeEventListener(MouseEvent.CLICK,__largeMap);
			if(small_btn)small_btn.removeEventListener(MouseEvent.CLICK,__smallMap);
			if(screen_mc)
			{
				screen_mc.removeEventListener(MouseEvent.MOUSE_DOWN,__mouseDown);
				screen_mc.removeEventListener(MouseEvent.MOUSE_UP,__mouseUp);
				screen_mc.removeEventListener(MouseEvent.MOUSE_OUT,__mouseUp);
			}
			
			if(foreMap_mc)foreMap_mc.removeEventListener(MouseEvent.MOUSE_DOWN,__click);
			removeEventListener(Event.ENTER_FRAME,__enterFrame);

			if(_mapBmp)
			{
				if(_mapBmp.parent)_mapBmp.parent.removeChild(_mapBmp);
				if(_mapBmp.bitmapData)_mapBmp.bitmapData.dispose();
			}
			_mapBmp = null;
			if(_mapDeadBmp)
			{
				if(_mapDeadBmp.parent)_mapDeadBmp.parent.removeChild(_mapDeadBmp);
				if(_mapDeadBmp.bitmapData)_mapDeadBmp.bitmapData.dispose();
			}
			_mapDeadBmp = null;
			if(_mapBmpData)
			{
				_mapBmpData.dispose();
			}
			_mapBmpData = null;
			if(_mapDeadBmpData)
			{
				_mapDeadBmpData.dispose();
			}
			_mapDeadBmpData = null;
			_map = null;
			while(this.numChildren > 0)
			{
				var mc : DisplayObject = this.getChildAt(0) as DisplayObject;
				if(mc && mc.parent)mc.parent.removeChild(mc);
				mc = null;
			}
			if(parent)
			{
				parent.removeChild(this);
			}
		}	
			
		private function __largeMap(event:MouseEvent):void
		{
			_changeScale = 0.2;
			var oldRateX:Number = _rateX;
			var oldRateY:Number = _rateY;
			update();
			updateChildPos(oldRateX,oldRateY);
			SoundManager.instance.play("008");
		}
		
		private function __smallMap(event:MouseEvent):void
		{
			_changeScale = -0.2;
			var oldRateX:Number = _rateX;
			var oldRateY:Number = _rateY;
			update();
			updateChildPos(oldRateX,oldRateY);
			SoundManager.instance.play("008");
		}
		
		private function updateChildPos(oldRateX:Number,oldRateY:Number):void
		{
			for each(var c:Sprite in _child)
			{
				c.x = c.x / oldRateX * _rateX;
				c.y = c.y / oldRateY * _rateY;
			}
		}

		private function __click(event:MouseEvent):void
		{
			if(!_locked && _allowDrag)
			{
				if((event.target as MovieClip).name == "screen_mc") return;
				_map.animateSet.addAnimation(new DragMapAnimation(event.localX / _rateX,event.localY / _rateY));
			}
		}
		
		private function __mouseDown(event:MouseEvent):void
		{
			if(!_allowDrag) return;
			screen_mc.startDrag();
			addEventListener(Event.ENTER_FRAME,__enterFrame);
			
			//禁止通过大地图更新小地图的坐标
			//通过拖拽小地图更新大地图坐标，每次更新会延迟的下一个EnterFrame，这时更新了小地图的坐标，则，小地图的拖动的新坐标就被替换掉
			//会出现无法拖动的情况，所以在拖动时，禁止小地图跟随大地图更新。
			_locked = true;
		}
		
		private var _update:Boolean;
		private function __enterFrame(event:Event):void
		{
			var tx:Number = (screen_mc.x + screen_mc.width /2) / _rateX;
			var ty:Number = (screen_mc.y + screen_mc.height /2) / _rateY;
			_split.x = screen_mc.x;
			_split.y = screen_mc.y;
			_map.animateSet.addAnimation(new DragMapAnimation(tx,ty,true));
		}
		
		private function __mouseUp(event:Event):void
		{
			_locked = false;
			screen_mc.stopDrag();
			removeEventListener(Event.ENTER_FRAME,__enterFrame);
		}
		
		public function clearBallPath():void
		{
			ballPathContaint.graphics.clear();
		}
		
		public function setPathStyle(thickness:Number = 1, color:uint = 0x000000):void
		{
			ballPathContaint.graphics.lineStyle(thickness, color);
		}
		
		public function resetPathPos(mapX:int, mapY:int):void
		{
			var tmpX:Number = mapX * _rateX;
			var tmpY:Number = mapY * _rateY;
			ballPathContaint.graphics.moveTo(tmpX, tmpY);
		}
		
		public function updateBallPath(mapX:int, mapY:int):void
		{
			var tmpX:Number = mapX * _rateX;
			var tmpY:Number = mapY * _rateY;
			
			if(tmpX > this.width)
			{
				tmpX = this.width;
			}
			if(tmpY > this.height)
			{
				tmpY = this.height;
			}
			
			ballPathContaint.graphics.lineTo(tmpX, tmpY);
		}
	}
}
