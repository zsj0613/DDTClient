package road.ui.controls
{
	import fl.controls.TextInput;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.text.TextFormat;
	
	public class LabelField extends UIComponent
	{
		private var _padding:Number = 6;
		
		private var _label:SimpleLabel;
		private var _input:TextInput;
		private var _labeltxt:String;
		private var _labelFormat:TextFormat;
		
		public function LabelField(labelTxt:String = "Label",labelFormat:TextFormat = null)
		{
			_labeltxt = labelTxt;
			_labelFormat = labelFormat;
			super();
		}
		
		public function get padding():Number
		{
			return _padding;
		}
		
		public function set padding(value:Number):void
		{
			if(_padding == value)return;
			_padding = value;
			invalidate(InvalidationType.SIZE);
		}
		
		public function get text():String
		{
			return _input.text;
		}
		
		public function set text(value:String):void
		{
			_input.text = value;
		}
		
		public function get textInput():TextInput
		{
			return _input;
		}
		
		public function setInputSize(w:Number,h:Number):void
		{
			_input.setSize(w,h);
			invalidate(InvalidationType.SIZE);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			_label = new SimpleLabel(_labeltxt,_labelFormat);
			addChild(_label);
			_input = new TextInput();
			_input.setSize(100,22);
			addChild(_input);
		}
		
		override protected function draw():void
		{
			if(isInvalid(InvalidationType.SIZE))
			{
				drawLayout();
			}
			super.draw();
		}
		
		protected function drawLayout():void
		{
			_label.drawNow();
			_input.move(_label.width + _padding,_label.y);
			setSize(_label.width + _input.width + _padding,_input.height);
		}
	}
}