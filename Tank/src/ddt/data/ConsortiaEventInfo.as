package ddt.data
{
	public class ConsortiaEventInfo
	{
		public function ConsortiaEventInfo()
		{
		}
		
		public var ID:int;
		public var ConsortiaID:int;
		public var Date:String;
		public var Remark:String;
		/*1.宣战，2.议和，3.结盟，4,解盟，5.捐献*/
		public var Type : int;
	}
}