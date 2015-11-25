package ddt.view.common
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	

	
	public class GradientText extends Sprite
	{
		private var field:TextField;
		public static var RandomColors:Array=[0x00ffe4,0xff0066,0xffcc00,0xe48f51,0x96ff00,0xdcff19,0x9eb3ff,0xff7689,0x00c6ff,0xcc52ff];
		private var _textFormat:TextFormat;
		
		/**
		 *随机字体  
		 */		
		public static var randomFont:Array=["AdLib BT", "Arial Black", "Britannic Bold", "Berlin Sans FB", "Benguiat Bk BT", "Tw Cen MT Condensed Extra Bold",  "Copperplate Gothic Bold", "CastleTUlt", "FrnkGothITC Hv BT"];
		
		/**
		 * 随机在原字体大小上再增加的字体大小
		 * （不同的字体在视觉上相同大小的情况下，其实际字体大小将会有3个点大小的区别，所以采用在原字体大小上进行大小增加）
		 */	
		public static var randomFontSize:Array=[0, 2];
		private var graidenBox:Sprite;//底纹
		
		private var currentMatix:Matrix;
		private var currentColors:Array;
		private var randomColor:Array;



		
		 
		public function GradientText(randomColor:Array = null)
		{
			super();
			this.randomColor = randomColor ? randomColor : RandomColors;
			
			field = creatTextField();
			field.selectable=false;
			addChild(field);
			graidenBox = new Sprite();
			addChild(graidenBox);
		}
		
		
		private var _text:String = "";
		
	
		public function setText (s:String, randerColor:Boolean = true, randerFont:Boolean=false):void
		{
			_text = s;
			render(randerColor, randerFont);
		}
		
	
		public function get text ():String
		{
			return _text;
		}
		
		public function set autoSize(align:String):void
		{
			field.autoSize = align;
		}
		
		public function setTextFormat(tf:TextFormat):void
		{
			field.defaultTextFormat = tf;
			field.setTextFormat(tf);
		}
		
		private function render(isChangeColor:Boolean, isChangeFont:Boolean):void
		{
			field.text=_text;
			graidenBox.x = field.x;
			graidenBox.y = field.y;
			
			if(isChangeColor)
			{
				drawBox();//绘制显示文本底纹 
			}else
			{
				drawBoxWithCurrent();
			}
			
			if(isChangeFont) setTextStyle(getRandomFont());
			field.cacheAsBitmap = true;
			graidenBox.cacheAsBitmap = true;
			graidenBox.mask = field;
		}
		
		
		 //绘制显示文本底纹 
		 	
		private function drawBox():void
		{
			var alphas:Array = [1, 1];
			var ratios:Array = [0, 255];
			
			currentMatix = new Matrix();
			currentMatix.createGradientBox(field.width/2, field.height, Math.PI/4, 0, 0);
			currentColors = getRandomColors();
			graidenBox.graphics.clear();
			graidenBox.graphics.beginGradientFill(GradientType.LINEAR, currentColors, alphas, ratios, currentMatix);
			graidenBox.graphics.drawRect(0,0,field.width/2,field.height);
			graidenBox.graphics.endFill();
			
			currentMatix = new Matrix();
			currentMatix.createGradientBox(field.width/2, field.height, Math.PI/4, 0, 0);
			currentColors = getRandomColors();
			graidenBox.graphics.beginGradientFill(GradientType.LINEAR, currentColors, alphas, ratios, currentMatix);
			graidenBox.graphics.drawRect(field.width/2,0,field.width/2,field.height);
			graidenBox.graphics.endFill();
		}
		
		private function drawBoxWithCurrent():void
		{
			var alphas:Array = [1, 1];
			var ratios:Array = [0, 255];
			graidenBox.graphics.clear();
			graidenBox.graphics.beginGradientFill(GradientType.LINEAR, currentColors, alphas, ratios, currentMatix);
			graidenBox.graphics.drawRect(0,0,field.width,field.height);
			graidenBox.graphics.endFill();
		}
		
		
		//随机取得一组用来绘制显示文本底纹的渐变颜色
		 		
		private function getRandomColors():Array
		{
			var cs:Array = [];
			cs = randomColor[int(Math.random()*10000%16)]
			var c1:int = cs[0];
			var c2:int = cs[1];
			return [c1,c2];
		}
		
		
		 //随机取得已嵌入字体名称
		 	
		private function getRandomFont():String
		{
			return randomFont[int(Math.random()*10000%randomFont.length)];
		}
		
		
		 //随机取得要增加的字体大小
			
		private function getRandomFontSize():int
		{
			return randomFontSize[int(Math.random()*10000%randomFontSize.length)];
		}
		
		
		 //根据不同字体设置字体样式
		 	
		private function setTextStyle(ftName:String):void
		{
			_textFormat=new TextFormat();
			_textFormat.align=TextFormatAlign.LEFT;
			_textFormat.bold = true;
			_textFormat.font = ftName;
			var addFontSize:int=getRandomFontSize();
			//trace(addFontSize);
			switch (ftName)
			{
				case "AdLib BT" :
					_textFormat.size = 16 + addFontSize;
					field.x = 5.5;
					field.y = 3.5;
					break;
				case "Arial Black" :
					_textFormat.size = 18 + addFontSize;
					field.x = 5.2;
					field.y = 0.4;
					break;
				case "VAG Rounded Std Thin" :
					_textFormat.size = 18 + addFontSize;
					field.x = 7.4;
					field.y = 3;
					break;
				case "Britannic Bold" :
					_textFormat.size = 19 + addFontSize;
					field.x = 5.9;
					field.y = 2.7;
					break;
				case "Berlin Sans FB Demi" :
					_textFormat.size = 21 + addFontSize;
					field.x = 5.4;
					field.y = 0.3;
					break;
				case "Benguiat Bk BT" :
					_textFormat.size = 19 + addFontSize;
					field.x = 4.7;
					field.y = 1.6;
					break;
				case "Kabel Ult BT" :
					_textFormat.size = 18 + addFontSize;
					field.x = 7.3;
					field.y = 2.3;
					break;
				case "Tw Cen MT Condensed Extra Bold" :
					_textFormat.size = 20 + addFontSize;
					field.x = 7.7;
					field.y = 1.7;
					break;		
				case "Cooper Std Black" :
					_textFormat.size = 18 + addFontSize;
					field.x = 6.1;
					field.y = 0.4;
					break;
				case "Copperplate Gothic Bold" :
					_textFormat.size = 19 + addFontSize;
					field.x = 3.8;
					field.y = 2.9;
					break;
				case "CastleTUlt" :
					_textFormat.size = 19 + addFontSize;
					field.x = 5.9;
					field.y = 2.1;
					break;
				case "FrnkGothITC Hv BT" :
					_textFormat.size = 18 + addFontSize;
					field.x = 6.2;
					field.y = 1.9;
					break;
			}
			
			field.setTextFormat(_textFormat);
		}
		
		
		 //创建TextField
		 	
		private function creatTextField():TextField
		{
			var tf:TextField = new TextField();
			tf.autoSize = "left";
			tf.selectable=false;
			return tf;
		}
	}
}