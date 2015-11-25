package road.ui.tip
{
	import road.geom.InnerRectangle;
	import road.ui.Component;
	import road.ui.ComponentFactory;
	import road.ui.text.Text;
	import road.utils.ClassUtils;
	import road.utils.ObjectUtils;
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	/**
	 * 
	 * @author Herman
	 * 简单的tip 只实现了背景与文本框
	 */	
	public class SimpleTip extends BaseTip
	{
		public static const P_backgoundInnerRect:String = "backOutterRect";
		
		public static const P_tipTextField:String = "tipTextField";

		public function SimpleTip()
		{
			_backInnerRect = new InnerRectangle(0,0,0,0,-1);
			super();
		}

		protected var _backInnerRect:InnerRectangle;
		protected var _backgoundInnerRectString:String;
		protected var _tipTextField:Text;
		protected var _tipTextStyle:String;

		/**
		 * 
		 * @param value 背景外框的矩形
		 * 详细请看 OuterRectangle
		 * 
		 */		
		public function set backgoundInnerRectString(value:String):void
		{
			if(_backgoundInnerRectString == value)return ;
			_backgoundInnerRectString = value;
			_backInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE,ComponentFactory.parasArgs(_backgoundInnerRectString));
			onPropertiesChanged(P_backgoundInnerRect);
		}
		
		override public function dispose():void
		{
			if(_tipTextField)ObjectUtils.disposeObject(_tipTextField);
			_tipTextField = null;
			super.dispose();
		}
		
		public function set tipTextField(field:Text):void
		{
			if(_tipTextField == field)return;
			ObjectUtils.disposeObject(_tipTextField);
			_tipTextField = field;
			onPropertiesChanged(P_tipTextField);
		}
		
		public function set tipTextStyle(stylename:String):void
		{
			if(_tipTextStyle == stylename)return;
			_tipTextStyle = stylename;
			tipTextField = ComponentFactory.Instance.creat(_tipTextStyle);
		}
		
		override protected function addChildren():void
		{
			super.addChildren();
			if(_tipTextField)addChild(_tipTextField);
			if(_tipData is DisplayObject) addChild(_tipData as DisplayObject);
		}
		
		override protected function onProppertiesUpdate():void
		{
//			super.onProppertiesUpdate();
			if(_changedPropeties[Component.P_tipData] ||_changedPropeties[P_backgoundInnerRect])
			{
				var rectangle:Rectangle;
				if(_tipData is String)
				{
					_tipTextField.text = String(_tipData);
					rectangle = _backInnerRect.getInnerRect(_tipTextField.width,_tipTextField.height);
					_width = _tipbackgound.width = rectangle.width;
					_height = _tipbackgound.height = rectangle.height;
				}
				else if(_tipData is DisplayObject)
				{
					rectangle = _backInnerRect.getInnerRect(_tipData.width,_tipData.height);
					_width = _tipbackgound.width = rectangle.width;
					_height = _tipbackgound.height = rectangle.height;
					_tipData.x = _backInnerRect.leftGape;
					_tipData.y = _backInnerRect.topGape;
				}
				_tipTextField.x = _backInnerRect.leftGape;
				_tipTextField.y = _backInnerRect.topGape;
			}
		}
	}
}