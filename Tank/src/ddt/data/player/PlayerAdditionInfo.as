package ddt.data.player
{
	/* 经验，功勋，财富加成信息 */
	public class PlayerAdditionInfo
	{
		/* 客户端经验加成 */
		private var _auncherExperienceAddition:Number = 1;
		public function get AuncherExperienceAddition():Number
		{
			return _auncherExperienceAddition;
		}
		public function set AuncherExperienceAddition(val:Number):void
		{
			_auncherExperienceAddition = val;
		}
		
//		/* 夫妻经验加成 */
//		private var _spouseExperienceAddition:Number = 1;
//		public function get SpouseExperienceAddition():Number
//		{
//			return _spouseExperienceAddition
//		}
//		public function set SpouseExperienceAddition(val:Number):void
//		{
//			_spouseExperienceAddition = val;
//		}
//		
//		/* 组队经验加成 */
//		private var _ranksExperienceAddition:Number = 1;
//		public function get RanksExperienceAddition():Number
//		{
//			return _ranksExperienceAddition;
//		}
//		public function set RanksExperienceAddition(val:Number):void
//		{
//			_ranksExperienceAddition = val;
//		}
		
		/* GM配置经验加成 */
		private var _gmExperienceAdditionType:Number = 1;
		public function get GMExperienceAdditionType():Number
		{
			return _gmExperienceAdditionType;
		}
		public function set GMExperienceAdditionType(val:Number):void
		{
			_gmExperienceAdditionType = val;
		}
		
		/* GM配置功勋加成 */
		private var _gmOfferAddition:Number = 1;
		public function get GMOfferAddition():Number
		{
			return _gmOfferAddition;
		}
		public function set GMOfferAddition(val:Number):void
		{
			_gmOfferAddition = val;
		}
		
		/* 客户端功勋加成 */
		private var _auncherOfferAddition:Number = 1;
		public function get AuncherOfferAddition():Number
		{
			return _auncherOfferAddition;
		}
		public function set AuncherOfferAddition(val:Number):void
		{
			_auncherOfferAddition = val;
		}
		
		/* GM配置财富加成 */
		private var _gmRichesAddition:Number = 1;
		public function get GMRichesAddition():Number
		{
			return _gmRichesAddition;
		}
		public function set GMRichesAddition(val:Number):void
		{
			_gmRichesAddition = val;
		}
		
		/* 客户端财富加成 */
		private var _auncherRichesAddition:Number = 1;
		public function get AuncherRichesAddition(): Number
		{
			return _auncherRichesAddition;
		}
		public function set AuncherRichesAddition(val:Number):void
		{
			_auncherRichesAddition = val;
		}
		
		public function resetAddition():void
		{
			_auncherExperienceAddition	= 1;
//			_spouseExperienceAddition 	= 1;
//			_ranksExperienceAddition  	= 1;
			_gmExperienceAdditionType		= 1;
			_gmOfferAddition			= 1;
			_auncherOfferAddition		= 1;
			_gmRichesAddition			= 1;
			_auncherRichesAddition		= 1;
		}
	}
}