package ddt.view.common
{
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	
	import road.utils.StringHelper;

	public class ChatBallViewII extends ChatBallBase
	{
		protected var _timer:Timer;
		private var paopaomc:MovieClip;
		private var _currentPaopaoType:int = 0;
		
		protected var maxTxtWidth:int = 140;
		protected var _size:int;
		protected var _bold:Boolean = true;
		protected var _align:String = "left";
		private var _originalWidth:Number;
		private var _originalHeight:Number;
		private var _verPos:Number;
		private var _horPos:Number;
		private var _verScale:Number;
		private var _horScale:Number;
		protected var _string:String;
		protected var _plainString:String
		
		protected function get field():TextField{
			return (paopao.lineText as TextField);
		};
		public function set textWidth(value:int):void{
			if(value<20)
				return;
			maxTxtWidth = value;
		}
		private function get _paopao():MovieClip{
			if(paopao)
				return paopao.background;
			return null;
		}
		
		protected var sizeOffset:Number = 1;
		
		private static var chatBallClass:Array = [ChatBallII001];
		public function ChatBallViewII()
		{
			super();
			_timer = new Timer(3000,1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE,__timerComplete,false,0,true);

			hideBall();
		}
		protected function setFormat():void{
			var style:StyleSheet = new StyleSheet();
			style.parseCSS(
				"p{font-size:12px;text-align:center;font-weight:normal;}" + 
				".red{color:#FF0000}" + 
				".blue{color:#0000FF}" + 
				".green{color:#00FF00}"
			)
			field.styleSheet = style;
		}
		protected function timeReset():void{
			_timer.reset();
			_timer.start();
		}
		private function init():void
		{
			_timer.reset();
			_timer.start();
			hideBall();
			if(paopao && paopao.parent)
			{
				removeChild(paopao);
			}
		}
		
		protected function hideBall():void
		{
			this.visible = false;
			_string = "";
			_plainString = "";
			if(field)field.text = "";
		}

		public function setBallSize(width:int = 0,height:int = 0):void{
			if(width>0){
				field.width = width;
			}
			if(height>0){
				field.height = height;
			}
		}
		protected function fitScale():void{
			var count:int = 0;
			var line:int = field.numLines;
			for(var i:int =0;i<line;i++){
				var length:int = field.getLineLength(i)
				if(count< length){
					count = length;
				}
			}
			if(count < 8){
				setBallSize(count * 17+4,0);
			}
			
			_paopao.scaleX = field.width/_originalWidth;
			field.x = _paopao.width * _horPos;
			field.x += (_originalWidth * _paopao.scaleX - field.width)/2
			
			_paopao.scaleY = field.height/_originalHeight;
			if(_paopao.scaleY<_paopao.scaleX){
				_paopao.scaleY = _paopao.scaleX;
			}
			field.y = _paopao.height * _verPos;
			field.y += (_originalHeight * _paopao.scaleY - field.height)/2
			
		}
		private function get paopao():MovieClip{
			if(paopaomc == null){
				paopaomc = new chatBallClass[_currentPaopaoType]();
				_originalWidth = paopaomc.textArea.width;
				_originalHeight = paopaomc.textArea.height;
				_horPos = paopaomc.textArea.x/paopaomc.width;
				_verPos = paopaomc.textArea.y/paopaomc.height;
			}
			return paopaomc
		}
		private function newPaopao(type:int):MovieClip{
			_currentPaopaoType = type;
			paopaomc = null;
			return paopao;
		}
		/**
		 * option: 	0,resize,display;
		 * 			1,resize,no display;
		 * 			2,no resize,display;
		 * 			3,no resize,no display;
		 */ 
		override public function setText(s:String,paopaoType:int = 0,option:int = 0):void
		{
			changePaopao(paopaoType);
			_string = s;
			_string = "<p>"+_string+"</p>";
			_plainString = StringHelper.rePlaceHtmlTextField(_string);
			
			
			setFormat();
			field.autoSize = TextFieldAutoSize.LEFT;
			(paopao.textArea as MovieClip).visible = false;
			setBallSize(maxTxtWidth,0)
			
			
			addChild(paopao);
			field.htmlText = _string;
			
			if(option != 2 && option != 3){
				fitScale();
			}
			if(option == 1 || option == 3){
				return;
			}
			this.visible = true;
		}
		protected function changePaopao(paopaoType:int):void{
			if(_currentPaopaoType != paopaoType){
				newPaopao(paopaoType);
			}
			init();
		}
		public function clear():void
		{
			__timerComplete(null);
		}
		
		private function __timerComplete(evt:TimerEvent):void
		{
			_timer.stop();
			hideBall();
		}
		
		override public function dispose():void
		{
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,__timerComplete);
			_timer = null;
			if(paopao && paopao.parent)
			{
				this.removeChild(paopao);
			}
			if(parent)parent.removeChild(this);
		}
	}
}