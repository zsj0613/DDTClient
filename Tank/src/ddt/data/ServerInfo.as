package ddt.data
{
	
	
	/**
	 *  
	 * @author SYC
	 * 服务器列表信息
	 */	
	public class ServerInfo
	{
		public var Name:String;
		public var ID:Number;
		public var IP:String;
		public var Port:Number;
		/**
		 * 服务器备注 
		 */		
		public var Remark:String;
		/**
		 * 服务器状态 
		 */		
		public var State:int;
		
		/**
		 * 大于或等于都可以进入 
		 */		
		public var MustLevel:int;
		
		/**
		 * 小于或等于都不可以进入 
		 */		
		public var LowestLevel:int;
	}
}