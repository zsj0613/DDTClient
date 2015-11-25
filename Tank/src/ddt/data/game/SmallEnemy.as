package ddt.data.game
{
	import ddt.events.LivingEvent;
	
	[Event(name="modelChanged",type="ddt.events.LivingEvent")]
	public class SmallEnemy extends Living
	{
		public function SmallEnemy(id:int, team:int, maxBlood:int)
		{
			super(id, team, maxBlood);
		}
		
		private var _modelID:int;
		public function set modelID(value:int):void
		{
			var old:int = _modelID;
			_modelID = value;
			dispatchEvent(new LivingEvent(LivingEvent.MODEL_CHANGED,_modelID,old));
		}
		
		public function get modelID():int
		{
			return _modelID;
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}