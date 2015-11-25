package road.ui.text
{
	import road.ui.ComponentFactory;
	import road.utils.ObjectUtils;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.GradientMatrix;
	import flash.geom.Matrix;
	/**
	 * 
	 * @author Herman 渐变文本
	 * 
	 */	
	public class GradientText extends Text
	{
		public static const P_alphas:String = "alphas";
		public static const P_colors:String = "colors";
		public static const P_fillRotation:String = "fillRotation";
		public static const P_ratios:String = "ratios";

		public function GradientText()
		{
			super();
		}
		
		private var _alphaString:String;
		private var _alphas:Array;
		private var _colorString:String;
		private var _colors:Array;
		private var _fillRotation:Number;
		private var _gradientBox:Sprite;
		private var _matrix:Matrix;
		private var _ratios:Array;
		
		private var _ratiosString:String;

		/**
		 * 
		 * @param alphas 渐变的透明属性字符串
		 * 
		 */		
		public function set alphaString(alphas:String):void
		{
			if(_alphaString == alphas) return;
			_alphaString = alphas;
			_alphas = ComponentFactory.parasArgs(_alphaString);
			onPropertiesChanged(P_alphas);
		}
		/**
		 * 
		 * @param colors 渐变的颜色属性字符串
		 * 
		 */		
		public function set colorString(colors:String):void
		{
			if(_colorString == colors) return;
			_colorString = colors;
			_colors = ComponentFactory.parasArgs(_colorString);
			onPropertiesChanged(P_colors);
		}
		
		override public function dispose():void
		{
			if(_gradientBox)_gradientBox.graphics.clear();
			ObjectUtils.disposeObject(_gradientBox);
			_gradientBox = null;
			super.dispose();
		}
		/**
		 * 
		 * @param rota 渐变的旋转角度
		 * 
		 */		
		public function set fillRotation(rota:Number):void
		{
			if(_fillRotation == rota) return;
			_fillRotation = rota;
			onPropertiesChanged(P_fillRotation);
		}
		/**
		 * 
		 * @param ratios 渐变的比率属性字符串
		 * 
		 */		
		public function set ratiosString(ratios:String):void
		{
			if(_ratiosString == ratios) return;
			_ratiosString = ratios;
			_ratios = ComponentFactory.parasArgs(_ratiosString);
			onPropertiesChanged(P_ratios);
		}
		
		override protected function addChildren():void
		{
			addChild(_gradientBox);
			addChild(_field);
		}
		
		override protected function init():void
		{
			_gradientBox = new Sprite();
			addChild(_gradientBox);
			super.init();
			_field.cacheAsBitmap = true;
			_gradientBox.cacheAsBitmap = true;
			_gradientBox.mask = _field;
		}
		
		override protected function onProppertiesUpdate():void
		{
			super.onProppertiesUpdate();
			_matrix = GradientMatrix.getGradientBox(_width,_height,_fillRotation,0,0);
			_gradientBox.graphics.clear();
			_gradientBox.graphics.beginGradientFill(GradientType.LINEAR,_colors,_alphas,_ratios,_matrix);
			_gradientBox.graphics.drawRect(0,0,_width,_height);
			_gradientBox.graphics.endFill();
		}
	}
}