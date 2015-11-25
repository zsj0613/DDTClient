package ddt.data.goods
{	

	/**
	 * 道具模板 
	 * @author SYC
	 * 
	 */
	public class PropInfo
	{
		private var _template:ItemTemplateInfo;
		
		public function get Template():ItemTemplateInfo
		{
			return _template;
		}
		
		public function PropInfo(info:ItemTemplateInfo):void
		{
			_template = info;
		}
		
		/**
		 * 所需要的移动力 
		 * @return 
		 * 
		 */		
		public function get needEnergy():Number
		{
			return Number(_template.Property4);
		}
		
		/**
		 * 我的道具	 
		 */		
		public var Place:int;
		
		/**
		 * 数量,-1 表示包时无限
		 */		
		public var Count:int;	

		
		public function equal(info:PropInfo):Boolean
		{
			return info.Template == this.Template && info.Place == this.Place;
		}
		
		
	}
}