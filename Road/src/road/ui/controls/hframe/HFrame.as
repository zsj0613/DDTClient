package road.ui.controls.hframe
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import road.BitmapUtil.ScaleBitmap;
	import road.manager.SoundManager;
	import road.ui.accect.BottomBitmapAccect;
	import road.ui.accect.CloseBtnAccect;
	import road.ui.accect.FrameBgAccect;
	import road.ui.controls.FrameEvent;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.manager.UIManager;
	public class HFrame extends Sprite
	{
		private var _bgBitmapData:BitmapData;
		private var _bgBitmap:ScaleBitmap;
		private var _bgContainer:Sprite;

		private var _bottomBitmapData:BitmapData;
		private var _bottomBtimap:ScaleBitmap;
		
		private var _closeBtn:HBaseButton;
		
		protected var _content:Sprite;
		
		private var _titleField:TextField;
		
		private var _titleText:String;
		
		private var _isCenterTitle:Boolean = false;
		
		private var _moveEnable:Boolean;
		
		private var _alphaDarger:Sprite;
		
		private var dragrt:Rectangle = new Rectangle(-3000,-3000,6000,6000);
		
		private var _blackGound:Boolean = true;
		
		private var _float:Sprite;
		
		private var _showClose:Boolean;
		
		private var _closeFunction:Function;
		public  var autoDispose : Boolean = false;//被remove时，是否自动调用dispose
		
		public var IsSetFouse:Boolean = true;
		public function HFrame()
		{
			init();
			initEvent();	
		}
		
		private function init():void
		{
			
			_alphaDarger = new Sprite();
			
			_float = new Sprite();
			
			_bgContainer = new Sprite();
			_content = new Sprite();
			addChild(_bgContainer);
			addChild(_content);
			_bgBitmapData = new FrameBgAccect(430,243);
			_bottomBitmapData = new BottomBitmapAccect(410,37);
			
			_bgBitmap = new ScaleBitmap(_bgBitmapData,"auto",true);
			var rt:Rectangle = new Rectangle();
			rt.left = 50;
			rt.right = 150;
			rt.top = 50;
			rt.bottom = 100;
			_bgBitmap.scale9Grid = rt;
			_bgContainer.addChild(_bgBitmap);
			
			_bottomBtimap = new ScaleBitmap(_bottomBitmapData,"auto",true);
			var rt1:Rectangle = new Rectangle();
			rt1.left = 64;
			rt1.right = 250;
			rt1.top = 11;
			rt1.bottom = 25;
			_bottomBtimap.scale9Grid = rt1;
			_bgContainer.addChild(_bottomBtimap);
			
			
			
			_closeBtn = new HBaseButton(new CloseBtnAccect());
			addChild(_closeBtn);
			
			_titleField = creatTitleField();
			addChild(_titleField);
			
			centerTitle = _isCenterTitle;
			addEventListener(Event.ADDED_TO_STAGE,__addToStage);
			addEventListener(Event.REMOVED_FROM_STAGE,__removeToStage);
			
			moveEnable = true;
			addChild(_alphaDarger);
		}
		protected var _width : int;
		public function set setCloseVisible(b : Boolean) : void
		{
			this._closeBtn.visible = b;
		}
		
		public function set moveEnable(b:Boolean):void
		{
			if(_moveEnable == b)return;
			_moveEnable = b;
			if(_alphaDarger)
			{
				if(b)
				{
					_alphaDarger.addEventListener(MouseEvent.MOUSE_DOWN,__mouseDownHandler);
					_alphaDarger.addEventListener(MouseEvent.MOUSE_UP,__mouseUpHandler);
				}else
				{
					_alphaDarger.removeEventListener(MouseEvent.MOUSE_DOWN,__mouseDownHandler);
					_alphaDarger.removeEventListener(MouseEvent.MOUSE_UP,__mouseUpHandler);
				}
			}
		}
		
		public function get moveEnable():Boolean
		{
			return _moveEnable;
		}
		
		private function __mouseDownHandler(e:MouseEvent):void
		{
			this.startDrag(false,dragrt);
		}
		
		private function __mouseUpHandler(e:MouseEvent):void
		{
			this.stopDrag();
			this.dispatchEvent(new FrameEvent(FrameEvent.STOP_DRAG));
		}
		
		
		public function get moveEvable():Boolean
		{
			return _moveEnable;
		}
		
		protected function __addToStage(e:Event):void
		{
			if(_blackGound)
			{
				graphics.clear();
				graphics.beginFill(0x000000,.7);
				graphics.drawRect(-3000,-3000,6000,6000);
				graphics.endFill();
			}
			if(_float)
			{
				addChildAt(_float,0);
			}
			if(IsSetFouse)
			{
				stage.focus  = this;
			}
			if(_fireEvent)
			{
				addEventListener(MouseEvent.CLICK,__onClickFocus);
			}else
			{
				removeEventListener(MouseEvent.CLICK,__onClickFocus);
			}
		}
		
		protected var _fireEvent:Boolean = false;
		public function  set fireEvent (b:Boolean):void
		{
			_fireEvent = b;
			if(_fireEvent)
			{
				addEventListener(MouseEvent.CLICK,__onClickFocus);
			}else
			{
				removeEventListener(MouseEvent.CLICK,__onClickFocus);
			}
		}
		
		protected function __removeToStage(e:Event):void
		{
			graphics.clear();
			removeEventListener(MouseEvent.CLICK,__onClickFocus);
			if(_float.parent)
				removeChild(_float);
			if(autoDispose)
			{
				removeEventListener(Event.REMOVED_FROM_STAGE,__removeToStage);
				dispose();
			}
		}
		protected function __onClickFocus(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			stage.focus  = this;
		}
		
		public function get frameWidth() : int
		{
			return _width;
		}
		
		protected var _height:Number;
		public function setSize($width:Number,$height:Number):void
		{
			_width = $width;
			_height = $height;
			_bgBitmap.width = $width;
			_bgBitmap.height = $height;
			
			
			_alphaDarger.graphics.beginFill(0xff00ff,0);
			_alphaDarger.graphics.drawRect(0,0,_bgBitmap.width - _closeBtn.width -10,31);
			_alphaDarger.graphics.endFill();
			
			
			_bottomBtimap.width = _bgBitmap.width - 18;
			_bottomBtimap.y = _bgBitmap.height - 48;
			_bottomBtimap.x = 9;
			_closeBtn.x = _bgBitmap.width - _closeBtn.width -5;
			_closeBtn.y = 2;
			
			center();
			centerTitle = _isCenterTitle;
		}
		
		public function addContent ($content:DisplayObject,$center:Boolean = false):void
		{
			_content.addChild($content);
			center();
		}
		
		public function setContentSize($width:Number,$height:Number):void
		{
			setSize($width+32,$height+56);
			_content.x = 14;
			_content.y = 36;
		}
		
		
		private function initEvent():void
		{
			_closeBtn.addEventListener(MouseEvent.CLICK,__closeClick);
		}
		
		public function getContent():DisplayObject
		{
			return _content;
		}
		
		public function set showBottom (b:Boolean):void
		{
			_bottomBtimap.visible = b;
		}
		
		public function get showBottom():Boolean
		{
			return _bottomBtimap.visible;
		}
		
		public function center():void
		{
			
		}
		
		protected function __closeClick(e:MouseEvent):void
		{
			SoundManager.instance.play("008");
			if(_closeFunction != null)
			{
				_closeFunction();
			}else
			{
				close();
			}
		}
		
		public function close ():void
		{
			if(parent)
			{
				parent.removeChild(this);
			}
		}
		
		public function set closeCallBack(fn:Function):void
		{
			_closeFunction = fn;
		}
		
		public function show():void
		{
			UIManager.AddDialog(this);
		}
		
		public function dispose ():void
		{
			_closeFunction = null;
			graphics.clear();
			if(!autoDispose && parent)
			{
				parent.removeChild(this);
			}
			
			if(_float)
			{
				if(_float.parent)_float.parent.removeChild(_float);
				_float.removeEventListener(MouseEvent.MOUSE_DOWN,__outsideMouseDown);
				_float.removeEventListener(MouseEvent.MOUSE_UP,__outsideMouseUp);
				_float = null;
			}
			
			if(_bgBitmap)
			{
				_bgBitmap.bitmapData.dispose();
				_bgBitmap.dispose();
			}
			_bgBitmap = null;
			if(_bgBitmapData)_bgBitmapData.dispose();
			_bgBitmapData = null;
			
			if(_bottomBtimap)
			{
				_bottomBtimap.bitmapData.dispose();
				_bottomBtimap.dispose();
			}
			_bottomBtimap = null;
			if(_bottomBitmapData)_bottomBitmapData.dispose();
			_bottomBitmapData = null;
			
			
			if(_closeBtn)_closeBtn.removeEventListener(MouseEvent.CLICK,__closeClick);
			if(_closeBtn)_closeBtn.dispose();
			if(_closeBtn && _closeBtn.parent)_closeBtn.parent.removeChild(_closeBtn);
			_closeBtn = null;
			_content = null;
			
			if(_alphaDarger)
			{
				_alphaDarger.removeEventListener(MouseEvent.MOUSE_DOWN,__mouseDownHandler);
				_alphaDarger.removeEventListener(MouseEvent.MOUSE_UP,__mouseUpHandler);
				_alphaDarger = null;
			}
			removeEventListener(MouseEvent.CLICK,__onClickFocus);
			removeEventListener(Event.ADDED_TO_STAGE,__addToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE,__removeToStage);
		}
		
		public function set titleText ($txt:String):void
		{
			_titleText = $txt;
			_titleField.text = _titleText;
			centerTitle = _isCenterTitle;
		}
		public function get titleText():String {return _titleText;}
		
		public function set centerTitle (b:Boolean):void
		{
			_isCenterTitle = b;
			_titleField.y = 5;
			if(b)
			{
				_titleField.x = (_width - _titleField.width)/2;
			}else
			{
				_titleField.x = 5;
			}
		}
		
		
		public function get centerTitle ():Boolean {return _isCenterTitle}
		
		public function set blackGound (b:Boolean):void
		{
			_blackGound = b;
			if(b)
			{
				graphics.clear();
				graphics.beginFill(0x000000,.7);
				graphics.drawRect(-500,-500,2000,2000);
				graphics.endFill();
			}else
			{
				graphics.clear();
			}
		}
		
		public function set alphaGound (b:Boolean):void
		{
			if(b)
			{
				_float.graphics.clear();
				_float.graphics.beginFill(0xffffff,0);
				_float.graphics.drawRect(-500,-500,2000,2000);
				_float.graphics.endFill();
				_float.addEventListener(MouseEvent.MOUSE_DOWN,__outsideMouseDown);
				_float.addEventListener(MouseEvent.MOUSE_UP,__outsideMouseUp);
			}else
			{
				_float.graphics.clear();
				_float.removeEventListener(MouseEvent.MOUSE_DOWN,__outsideMouseDown);
				_float.removeEventListener(MouseEvent.MOUSE_UP,__outsideMouseUp);
			}
		}
		
		private function creatTitleField():TextField
		{
			var tf:TextField = new TextField();
			var tformat:TextFormat = new TextFormat();
			tformat.size = 18;
			tformat.color = 0xffffff;
			tformat.bold = true;
//			tformat.letterSpacing = 2;
			tf.defaultTextFormat = tformat;
			tf.filters = [new GlowFilter(0x4D2600,1,3,3,10)];
			tf.mouseEnabled = false;
			tf.selectable = false;
			tf.autoSize = "left";
			return tf;
		}
		
		private function __outsideMouseDown(e:MouseEvent):void
		{
			if(_bgBitmap)
				_bgBitmap.filters = [new GlowFilter(0xffffff,1,3,3,10)];
		}
		private function __outsideMouseUp(e:MouseEvent):void
		{
			if(_bgBitmap)
				_bgBitmap.filters = null;
		}
		
		public function setFoucs():void
		{
			if(stage) stage.focus = this;
		}
		
		public function set showClose(b:Boolean):void
		{
			_showClose = b;
			_closeBtn.visible = _showClose;

		}
		public function get showClose():Boolean
		{
			return _showClose;
		}
		
		public function removeActiveEvent():void
		{
			_closeBtn.removeEventListener(MouseEvent.CLICK,__closeClick);
		}
		
		public function addActiveEvent():void
		{
			_closeBtn.addEventListener(MouseEvent.CLICK,__closeClick);
		}
	}
}