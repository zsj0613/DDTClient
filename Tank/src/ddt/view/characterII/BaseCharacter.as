package ddt.view.characterII
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ddt.data.player.PlayerInfo;
	import ddt.data.player.PlayerPropertyEvent;

	public class BaseCharacter extends Sprite implements ICharacter
	{
		public static const DISPOSE:String = "dispose";
		
		protected var _info:PlayerInfo;
		
		protected var _frames:Array;
		protected var _loader:ICharacterLoader;
		protected var _characterWidth:Number;
		protected var _characterHeight:Number;
		protected var _factory:ICharacterLoaderFactory;	
		protected var _dir:int;
		protected var _container:Sprite;
		protected var _body:Bitmap;
		protected var _currentframe:int;
		protected var _loadCompleted:Boolean;
		
		private var _picLines:int;
		private var _picsPerLine:int;		
		private var _autoClearLoader:Boolean;
		protected var _characterBitmapdata:BitmapData;
		protected var _bitmapChanged:Boolean;
		private var _lifeUpdate:Boolean;
		
		protected var _staticBmp:Sprite;
		
		public function get characterWidth():Number
		{
			return _characterWidth;
		}
		
		public function get characterHeight():Number
		{
			return _characterHeight;
		}
		
		public function BaseCharacter(info:PlayerInfo,lifeUpdate:Boolean)
		{
			_info = info;
			_lifeUpdate = lifeUpdate;
			super();
			init();
			initEvent();
		}
		
		protected function init():void
		{
			_currentframe = -1;
			initSizeAndPics();
			createFrames();
			_container = new Sprite();
			addChild(_container);
			_body = new Bitmap(new BitmapData(_characterWidth,_characterHeight,true,0),"auto",true);
			_container.addChild(_body);
			mouseChildren = mouseEnabled = false;
		}
		
		protected function initSizeAndPics():void
		{
			setCharacterSize(120,165);
			setPicNum(1,3);
		}
		
		protected function initEvent():void
		{
			_info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__propertyChange);
			addEventListener(Event.ADDED_TO_STAGE,__addToStage);
			addEventListener(Event.REMOVED_FROM_STAGE,__removeFromStage);
		}
		
		private function __addToStage(event:Event):void
		{
			if(_lifeUpdate)
			{
				addEventListener(Event.ENTER_FRAME,__enterFrame);
			}
		}
		
		private function __removeFromStage(event:Event):void
		{
			removeEventListener(Event.ENTER_FRAME,__enterFrame);
		}
		
		private function __enterFrame(event:Event):void
		{
			update();
		}
		
		public function update():void
		{	
		}
		
		private function __propertyChange(evt:PlayerPropertyEvent):void
		{
			if(evt.changedProperties[PlayerInfo.STYLE])
			{
				if(_loader == null)
				{
					show(_autoClearLoader,_dir);
				}
				else
				{
					_loader.update();
				}
			}
		}
		
		protected function setCharacterSize(w:Number,h:Number):void
		{
			_characterWidth = w;
			_characterHeight = h;
		}
		
		protected function setPicNum(lines:int,perline:int):void
		{
			_picLines = lines;
			_picsPerLine = perline;
		}
		
		public function setColor(color:*):Boolean
		{
			return false;
		}
		
		public function get info():PlayerInfo
		{
			return _info;
		}
		
		public function get currentFrame():int
		{
			return _currentframe;
		}
		
		public function set characterBitmapdata(value:BitmapData):void
		{
			if(value == _characterBitmapdata) return;
			_characterBitmapdata = value;
			_bitmapChanged = true;
		}
		
		public function get characterBitmapdata():BitmapData
		{
			return _characterBitmapdata;
		}
		
		public function get completed():Boolean
		{
			return _loadCompleted;
		}
		
		public function doAction(actionType:*):void
		{
		}
		
		public function setDefaultAction(actionType:*):void
		{
		}
		
		final public function show(clearLoader:Boolean = true,dir:int = 1):void
		{
			_dir = dir > 0 ? 1 : -1;
			scaleX = _dir;
			_autoClearLoader = clearLoader;
			if(_factory != null && _info != null && _info.Style != null && _loader == null)
				initLoader();
			_loader.load(__loadComplete);
			_loadCompleted = false;
		}
		
		protected function __loadComplete(loader:ICharacterLoader):void
		{
			_loadCompleted = true;
			setContent();
			if(_autoClearLoader && _loader != null)
			{
				_loader.dispose();
				_loader = null;
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function setContent():void
		{
			if(_loader != null)
			{
				if(_characterBitmapdata && _characterBitmapdata != _loader.getContent()[0])
					_characterBitmapdata.dispose();
				characterBitmapdata = _loader.getContent()[0];
			}
			drawFrame(_currentframe);
		}
			
		public function setFactory(factory:ICharacterLoaderFactory):void
		{
			_factory = factory;
			if(_factory != null && _info != null && _loader == null)
				initLoader();
		}
		
		protected function initLoader():void
		{
			_loader = _factory.createLoader(_info,CharacterLoaderFactory.SHOW);
		}
		
		public function drawFrame(frame:int):void
		{
			if(_characterBitmapdata != null)
			{
				if(frame < 0 || frame >= _frames.length)frame = 0;
				if(frame != _currentframe || _bitmapChanged )
				{
					_bitmapChanged = false;
					_currentframe = frame;
					_body.bitmapData.dispose();
					_body.bitmapData = new BitmapData(_characterWidth,_characterHeight,true,0);
					_body.smoothing = true;
					_body.pixelSnapping = "auto";
					_body.bitmapData.copyPixels(_characterBitmapdata,_frames[_currentframe],new Point(0,0));
				}
			}
		}
		
		private function createFrames():void
		{
			_frames = [];
			for(var j:int = 0; j < _picLines; j++)
			{
				for(var i:int = 0; i < _picsPerLine; i++)
				{
					var m:Rectangle = new Rectangle(i * _characterWidth, j * _characterHeight, _characterWidth, _characterHeight);
					_frames.push(m);
				}
			}
		}
		
		public function set showGun(value:Boolean):void
		{
		}
		
		public function setShowLight(b:Boolean,p:Point = null):void
		{
		}
		
		public function get currentAction():*
		{
			return "";
		}
		
		public function actionPlaying():Boolean
		{
			return false;
		}
		
		public function dispose():void
		{
			if(_info)_info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__propertyChange);
			_info = null;

			removeEventListener(Event.ADDED_TO_STAGE,__addToStage);
			removeEventListener(Event.ENTER_FRAME,__enterFrame);
			removeEventListener(Event.REMOVED_FROM_STAGE,__removeFromStage);
			if(_loader)
			{
				_loader.dispose();
				_loader = null;
			}
			
			_factory = null;
			
			dispatchEvent(new Event(DISPOSE));
			
			if(parent)parent.removeChild(this);
				
			if(_body && _body.bitmapData)_body.bitmapData.dispose();
			_body = null;
			
			if(_characterBitmapdata)_characterBitmapdata.dispose();
			_characterBitmapdata = null;
		}
	}
}