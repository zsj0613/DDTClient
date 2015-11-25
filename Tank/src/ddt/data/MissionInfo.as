package ddt.data
{
	import ddt.data.gameover.BaseSettleInfo;
	
	/**
	 * 
	 * 关卡信息
	 * 
	 */	
	public class MissionInfo
	{
		public static const BIG_TACK_CARD:int = 2;
		public static const SMALL_TAKE_CARD:int = 1;
		public static const HAVE_NO_CARD:int = 0;
		
		public function MissionInfo()
		{
		}
		/**
		 *标识是第几关 
		 */		
		public var missionIndex:int;
		
		/**
		 * 标识下一关
		 */		
		public var nextMissionIndex:int;
		
		/**
		 * 标示关卡总数
		 * 为什么写在这里，因为总关数有可能改变（隐藏关卡）
		 */		 
		public var totalMissiton:int;		
		/**
		 *过关计数 达到这个数可以过关
		 * 可以是杀敌数， 可以是木板数
		 * 等等
		 */		
		public var totalCount:int;
		public var currentCount:int;
		
		public var title1 : String;
		public var title2 : String;
		public var title3 : String;
		public var title4 : String;
		
		public var currentValue1 : int;
		public var currentValue2 : int;
		public var currentValue3 : int;
		public var currentValue4 : int;
		
		public var totalValue1 : int;
		public var totalValue2 : int;
		public var totalValue3 : int;
		public var totalValue4 : int;
		/**
		 *显示资源的帧 
		 */		
		public var countAssetPlace:int = 1;
		
		public var currentTurn:int;
		public var totalTurn:int;
		
		public var name:String;
		public var success : String="";
		public var failure : String="";
		public var description:String="";
		
		public var missionOverPlayer:Array;
		
		public var missionOverNPCMovies:Array;		
		public var maxTime:int;
		public var canEnterFinall:Boolean;
		
		public var pic:String;
		
		public var param1:int;
		public var param2:int;
		/**
		 * 0没有翻牌
		 * 1小翻牌
		 * 2大翻牌 
		 */		
		public var tackCardType:int = HAVE_NO_CARD;
		
		public function findMissionOverInfo(playerid:int):BaseSettleInfo
		{
			if(missionOverPlayer == null) return null;
			for(var i:int = 0;i<missionOverPlayer.length;i++)
			{
				if(missionOverPlayer[i].playerid == playerid)
				{
					return missionOverPlayer[i];
				}
			}
			return null;
		}
		
		public function parseString(value:String):void
		{
			var array:Array = value.split(",");
			for (var i:int = 0 ; i < array.length ; i++)
			{
				if(array[i] != null )
				this["title"+(i+1)] = array[i].toString(); 
				else
				return;
			}
		}
	}
}