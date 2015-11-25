﻿package ddt.view.common
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import ddt.view.common.chat.ChatTextField;

	public class ChatBallView extends ChatBallBase
	{
		protected var _timer:Timer;
		private var paopao:MovieClip;
		private var _field:ChatTextField;
		private var _currentPaopaoType:int = 0;
		
		private static var chatBallClass:Array = [ChatBall16000,ChatBall16001,ChatBall16002,ChatBall16003,ChatBall16004,ChatBall16005,ChatBall16006,ChatBall16007,ChatBall16008,SpecificBall001];
		public function ChatBallView()
		{
			super();
			_timer = new Timer(4000,1);

			hideBall();
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
		
		private function hideBall():void
		{
			if(_field && _field.parent == this){
				removeChild(_field);
			}
			this.visible = false;
		}
		
		override public function setText(s:String,paopaoType:int = 0,option:int = 0):void
		{
			clear()
			if(paopaoType == 9){
				_timer = new Timer(2700,1);
			}else{
				_timer = new Timer(4000,1);
			}
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE,__timerComplete,false,0,true);
			init();
			if(_currentPaopaoType != paopaoType || paopao == null)
			{
				paopao = new chatBallClass[paopaoType]();
				_currentPaopaoType = paopaoType;
				_field = new ChatTextField(paopao.tf);
			}
			addChild(paopao);
			
			
			
			_field.text = s;
			
			fitSize(_field);
			
			

			this.visible = true;
		}
		
		protected function fitSize(field:MovieClip):void{
			var oriWidth:int = paopao.bg.rtTopPoint.width;
			var oriHeight:int = paopao.bg.rtTopPoint.height;
			var scaleX:Number = field.width/oriWidth;
			var scaleY:Number = field.height/oriHeight;
			var scale:Number = scaleX>scaleY?scaleX:scaleY;
			paopao.scaleX = scale;
			paopao.scaleY = scale;
			field.x = paopao.x + paopao.bg.rtTopPoint.x*scale + (paopao.bg.rtTopPoint.width*scale - field.width)/2;
			field.y = paopao.y + paopao.bg.rtTopPoint.y*scale + (paopao.bg.rtTopPoint.height*scale - field.height)/2;
			addChild(field);
			
			paopao.bg.rtTopPoint.visible = false;
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
		
		public override function dispose():void
		{
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,__timerComplete);
			_timer = null;
			
			if(paopao && paopao.parent)
			{
				this.removeChild(paopao);
			}
			paopao = null;
			
			
			super.dispose();
		}
	}
}