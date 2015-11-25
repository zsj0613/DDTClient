package road.ui.tip
{
	import road.ui.Component;
	import road.ui.ComponentFactory;
	import road.ui.image.Image;
	import road.ui.text.Text;
	import road.utils.ObjectUtils;
	/**
	 * 
	 * @author Herman
	 * 基础的tip只是实现了一个背景 以便扩展
	 */	
	public class BaseTip extends Component implements ITip
	{
		public static const P_tipbackgound:String = "tipbackgound";
		
		public function BaseTip()
		{
			super();
		}

		protected var _tipbackgound:Image;
		protected var _tipbackgoundstyle:String;
		
		override public function dispose():void
		{
			if(_tipbackgound)ObjectUtils.disposeObject(_tipbackgound);
			_tipbackgound = null;
			super.dispose();
		}
		/**
		 * 
		 * @param back tip的背景
		 * 
		 */		
		public function set tipbackgound(back:Image):void
		{
			if(_tipbackgound == back)return;
			ObjectUtils.disposeObject(_tipbackgound);
			_tipbackgound = back;
			onPropertiesChanged(P_tipbackgound);
		}
		/**
		 * 
		 * @param stylename tip的背景样式
		 * 
		 */		
		public function set tipbackgoundstyle(stylename:String):void
		{
			if(_tipbackgoundstyle == stylename) return;
			_tipbackgoundstyle = stylename;
			tipbackgound = ComponentFactory.Instance.creat(_tipbackgoundstyle);
		}
		
		override protected function addChildren():void
		{
			super.addChildren();
			if(_tipbackgound)addChild(_tipbackgound);
		}
	}
}