package ddt.church.action
{
	public class ActionType
	{
		public static const STAND:ActionType = new ActionType("Stand Action");
		public static const WALK:ActionType = new ActionType("Walk Action");
		
		private var _name:String;
		
		public function ActionType(name:String)
		{
			_name = name;
		}
		
		public function toString():String
		{
			return _name;
		}
	}
}