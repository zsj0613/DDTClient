package ddt.data.goods
{
	import flash.events.EventDispatcher;
	
	/**
	 * 
	 * @author SYC
	 * 物品模板(商店)
	 */	
	public class ItemTemplateInfo extends EventDispatcher
	{
		/**
		 * 模板id 
		 */		
		public var TemplateID:int;
		
		/**
		 * 产品类型()  
		 */		
		public var CategoryID:Number;
		
		/**
		 * 名字 
		 */		
		public var Name:String;
		
				/**
		 * 描述 
		 */		
		public var Description:String;
		
		
		/**
		 * 攻击力 
		 */		
		public var Attack:int;
		
		/**
		 * 防御 
		 */		
		public var Defence:int;
		
		/**
		 * 幸运 
		 */		
		public var Luck:int;
		
		/**
		 * 敏捷 
		 */		
		public var Agility:int;
		
		/**
		 * 物品等级
		 */		
		public var Level:Number;
		
		/**
		 * 小图标地址 
		 */		
		public var Pic:String = "prop.png";
		
		/**
		 * 需要等级 (暂不用)
		 */		
		public var NeedLevel:Number;
		
		/**
		 * 0 不用性别　1　男　2　女 
		 */		
		public var NeedSex:Number;
		

		/**
		 * 填加时间 
		 */		
		public var AddTime:String;	
		
		/**
		 * 金币 
		 */		
		public var Gold:Number;
		
		/**
		 * 金额(券) 
		 */		
		public var Money:Number;
		
		/**
		 * 物品品质 
		 */		
		public var Quality:int;
		
		
		/**
		 * 付费类型：点券(1)，金币(0)
		 * 购买类型：按日期(0)，按件数(1)
		 * 价
		 * 类型值
		 * 折扣
		 */		
		public var PayType:int;
		public var BuyTyte:int;
		public var Price1:int;
		public var Value1:int;
		public var Agio1:Number;
		public var Price2:int;
		public var Value2:int;
		public var Agio2:Number;
		public var Price3:int;
		public var Value3:int;
		public var Agio3:Number;
		
		
		public var FusionType:int;
		public var FusionRate:int;
		public var FusionNeedRate:int;
		
		public var Sort:int;
		/**
		 * 最多叠加数量
		 */		
		public var MaxCount:int; 
		
		/**
		 * 扩展属性 
		 * Property1
		 * 头饰--帽子:"0",头花："1"
		 */		
		public var Property1:String;
		public var Property2:String;
		public var Property3:String;
		/* 消耗体力 */
		public var Property4:String;
		public var Property5:String;
		public var Property6:String;
		public var Property7:String;
		private var _property8:String;
		public function get Property8():String
		{
			return _property8;
		}
		public function set Property8(value:String):void
		{
			_property8 = value;
		}
		
		/**
		 * 能否被丢在场景上
		 */		
		public var CanDrop:Boolean;
		
		/**
		 * 能否被删除
		 */		
		public var CanDelete:Boolean;
		
		/**
		 * 能否装备
		 */		
		public var CanEquip:Boolean;
		
		/**
		 * 能否使用
		 */		
		public var CanUse:Boolean;
		
		/**
		 * 能否强化
		 */		
		public var CanStrengthen:Boolean;
		
		/**
		 * 能否合成
		 */		
		public var CanCompose:Boolean;
		
		/**
		 * 是否推荐
		 */		
		public var IsVouch:Boolean;
		
		/**
		 * 绑定类型
		 * 0表示不绑定,1 硬性绑定,2表示装备绑定,3 表示使用绑定
		 */		
		public var BindType:int;
		
		/**
		 * 备用的字符串字段
		 * */
		public var Data:String;
		
		public function getStyleIndex():String
		{
			return Property1;
		}
			
		public function getStyleClass():String
		{
			return Property2;
		}
		
		/**
		 * 镶嵌的孔的信息
		 * EX:3,1|6,2|0,-1|0,-1|0,-1|0,-1 代表3级强化开启一个1类型的孔，强化六级开启一个类型2的孔
		 * */
		public var Hole:String;
		
		/**
		 * 炼化等级
		 * */
		public var Refinery:int;

		/**
		 * 系统物品回收价值类型 :1=金币;2=礼券
		 */		
		public var ReclaimType:int;
		
		/**
		 * 系统物品回收价值 
		 */		
		public var ReclaimValue:int;
		/**
		 * 是否唯一
		 */
		public var IsOnly:Boolean;
	}
}