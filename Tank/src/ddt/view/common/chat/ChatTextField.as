package ddt.view.common.chat
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import tank.view.ChatTextfieldAsset;
	
	public class ChatTextField extends MovieClip
	{
		private var YaHei : Class;
		
		private static const _SMALL_W:int = 80;
		private static const _MIDDLE_W:int = 100;
		private static const _BIG_H:int = 70;
		private static const _BIG_W:int = 120;
		
		protected var hiddenTF:TextField;
		protected var tf:TextField;
		
		private var _textWidth:int;
		private var _indexOfEnd:int;
		public function ChatTextField(textfield:TextField)
		{
			super();
			tf = textfield;
			initView();
		}
		private function initView():void{
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.multiline = true;
			tf.wordWrap = true;
			this.addChild(tf);
			
			
			tf.x = 0;
			tf.y = 0;
			
		};
		protected function chooseSize(message:String):void{
			_indexOfEnd = -1;
			var format:TextFormat = tf.defaultTextFormat;
			hiddenTF = new TextField();
			setTextField(hiddenTF);
			
			format.letterSpacing = 1;
			hiddenTF.defaultTextFormat = format;//tf.defaultTextFormat;
			tf.defaultTextFormat = format;
			hiddenTF.text = message;
			var _width:int = (hiddenTF.textWidth);
			if (_width < _SMALL_W){
				_textWidth = _SMALL_W;
				return;
			}
			if (_width < (_SMALL_W * 2)+10){
				_textWidth = _MIDDLE_W;
				return;
			}
			_textWidth = _BIG_W;
			return;
		}
		public function setText(text:String):void{
			tf.htmlText = text;
			text = tf.text;
			
			chooseSize(text);
			
			tf.text = text;
			
			tf.width = _textWidth;
			if (tf.height >= _BIG_H){
				tf.height = _BIG_H;
			};
			_indexOfEnd = 0;
			if(tf.numLines>4){
				_indexOfEnd = tf.getLineOffset(4)-3
				text = text.substring(0,_indexOfEnd)+"...";
			}
			tf.text = text;
			//drawEdge();
		}
		public function set text(value:String):void{
			setText(value)
		}
		/** 绘制边缘，用于调试。 */
		public function drawEdge():void{
			this.graphics.clear();
			this.graphics.moveTo(tf.x,tf.y);
			this.graphics.lineStyle(1,0xffcc11);
			this.graphics.lineTo(tf.x+tf.width,tf.y);
			this.graphics.lineTo(tf.x+tf.width,tf.y+tf.height);
			this.graphics.lineTo(tf.x,tf.y+tf.height);
			this.graphics.lineTo(tf.x,tf.y)
		}
		public function setTextField(tf:TextField):void{
			tf.autoSize = TextFieldAutoSize.LEFT;
		}
		
	}
}