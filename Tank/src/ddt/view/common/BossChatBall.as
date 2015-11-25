package ddt.view.common
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import road.manager.SoundManager;
	import road.utils.StringHelper;
	
	public class BossChatBall extends ChatBallViewII
	{
		private const 	TYPEDLENGTH:int = 1;
		private const	TYPEINTERVAL:int = 80;
		private var _paopaoType:int;
		private var _typeTimer:Timer;
		private var _typedText:String;
		private var _text:String;
		private var _invisibleTF:TextField;
		private var _finalWidth:Number;
		private var _finalHeight:Number;
		private var _maskMC:Sprite;
		private var _count:int;
		private var _bmdata:BitmapData;
		private var _bmp:Bitmap;
		public function BossChatBall()
		{
			super();
			_typeTimer = new Timer(TYPEINTERVAL);
			_typeTimer.addEventListener(TimerEvent.TIMER,__onTypeTimerTick);
			
		}
		override protected function setFormat():void{
			var style:StyleSheet = new StyleSheet();
			style.parseCSS(
				"p{font-size:16px;text-align:left;font-weight:bold;leading:3px;}" + 
				".red{color:#FF0000;}" + 
				".blue{color:#0000FF;}" + 
				".green{color:#00FF00;}"
			)
			field.styleSheet = style;
		}
		override public function setText(s:String,paopaoType:int = 0,option:int = 0):void{
			_paopaoType = paopaoType;
			hideBall();
			
			
			
			super.setText(s,0,0);
			
			_maskMC = new Sprite();
			
			addChild(_maskMC);
			_text = StringHelper.rePlaceHtmlTextField(s);
			
			
			_maskMC.x = field.x-2;
			_maskMC.y = field.y-2;
			
			_bmdata = new BitmapData(field.width,field.height);
			_bmdata.draw(field);
			_bmp = new Bitmap(_bmdata);
			_bmp.x = field.x;
			_bmp.y = field.y;
			this.addChild(_bmp);
			_bmp.mask = _maskMC; 
			
			_count = 0;
			field.visible = false;
			timeReset();
			_typeTimer.start();
			
			if(paopaoType == 1){
				SoundManager.instance.play("008");
				_typeTimer.stop();
				drawFullMask();
			}
		}
		override protected function timeReset():void{
			super.timeReset();
			_typeTimer.reset();
		}
		private function getFinalSize(_typedText:String):void{
			super.setText(_typedText,0,1);
			_finalWidth = super.width;
			_finalHeight = super.height;
		}
		private function __onTypeTimerTick(e:TimerEvent):void{
			if(_count<15)
			SoundManager.instance.play("120");
			while(!_text.charAt(_count)){
				_count--;
				_typeTimer.stop();
			}
			redrawMask(_count);
			super.timeReset();
			_count+=TYPEDLENGTH;
		}
		private function drawFullMask():void{
			_bmp.mask = null;
		}
		private function redrawMask(location:int):void{
			if(!_text.charAt(_count)){
				return;
			}
			var debug:Boolean = false;
			var t:String = _text.charAt(location);
			var rec:Rectangle = field.getCharBoundaries(location);
			if(rec == null){
				return;
			}
			if(debug){
				_bmp.mask = null;
				_maskMC.graphics.clear();
				_maskMC.graphics.beginFill(0xcccccc);
				_maskMC.graphics.drawRect(rec.x,rec.y,rec.width,rec.height);
				_maskMC.graphics.endFill();
				this.addChild(_maskMC);
				return;
			}
			_maskMC.graphics.clear();
			_maskMC.graphics.lineStyle(0);
			_maskMC.graphics.beginFill(0xcccccc);
			_maskMC.graphics.moveTo(0,-2);
			_maskMC.graphics.lineTo(0,rec.y+rec.height);
			_maskMC.graphics.lineTo(rec.x+rec.width,rec.y+rec.height);
			_maskMC.graphics.lineTo(rec.x+rec.width,rec.y-2);
			_maskMC.graphics.lineTo(field.width,rec.y-2);
			_maskMC.graphics.lineTo(field.width,-2);
			_maskMC.graphics.lineTo(0,-2);
			_maskMC.graphics.endFill();
			
			this.addChild(_maskMC);
		}
		
		override public function dispose():void
		{
			_typeTimer.removeEventListener(TimerEvent.TIMER,__onTypeTimerTick);
			super.dispose();
			hideBall();
		}
		
		override protected function hideBall():void{
			if(_bmdata)_bmdata.dispose();
			_bmdata = null;
			if(_bmp && _bmp.parent){
				_bmp.bitmapData.dispose();
				_bmp.parent.removeChild(_bmp);
			}
			_bmp = null;
			if(_maskMC && _maskMC.parent){
				_maskMC.parent.removeChild(_maskMC);
			}
			_maskMC = null;
			super.hideBall();
		}
		
	}
}