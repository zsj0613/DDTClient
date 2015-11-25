package road.ui.vo
{
	import road.utils.Directions;
	public class AlertInfo
	{
		public static var CANCEL_LABEL:String = "取消";
		public static var SUBMIT_LABEL:String = "确定";
		/**
		 * 自动清除 
		 */		
		public var autoDispose:Boolean;
		/**
		 *确定按钮与取消按钮之间的间距 
		 */		
		public var buttonGape:int;
		/**
		 *取消按钮的文本 
		 */		
		public var cancelLabel:String = CANCEL_LABEL;
		/**
		 *用于显示的数据 
		 */		
		public var data:Object;
		/**
		 *是否是htmlText模式赋值 
		 */		
		public var enAbleHtml:Boolean;
		/**
		 *是否支持enter键 
		 */		
		public var enterEnable:Boolean = true;
		/**
		 *是否支持esc键 
		 */		
		public var escEnable:Boolean = true;
		/**
		 *弹出窗是否居中显示 
		 */		
		public var frameCenter:Boolean = true;
		/**
		 *窗体能否移动 
		 */		
		public var moveEnable:Boolean = true;
		/**
		 * 弹出窗是否支持多行显示
		 * 如果支持多行显示那么文本框的宽度长度将由
		 * textShowHeight和textShowWidth这两个属性决定
		 */		
		public var mutiline:Boolean;
		/**
		 *是否显示取消按钮 
		 */		
		public var showCancel:Boolean = true;
		/**
		 *是否显示确定按钮 
		 */		
		public var showSubmit:Boolean = true;
		/**
		 *确定按钮的文本 
		 */		
		public var submitLabel:String = SUBMIT_LABEL;
		/**
		 * 文本框的高度
		 * 当mutiline=true时启用
		 */		
		public var textShowHeight:int;
		/**
		 * 文本框的宽度
		 * 当mutiline=true时启用
		 */		
		public var textShowWidth:int;
		/**
		 *标题文本 
		 */		
		public var title:String;
	}
}