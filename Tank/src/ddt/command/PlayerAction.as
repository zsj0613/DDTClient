package ddt.command
{
	import ddt.view.characterII.GameCharacter;
	
	public class PlayerAction
	{
		public var type:String;
		
		public var stopAtEnd:Boolean;
		
		public var frames:Array;
		
		public var repeat:Boolean;
		
		public var replaceSame:Boolean;
		
		public function PlayerAction(type:String,frames:Array,replaceSame:Boolean,repeat:Boolean,stopAtEnd:Boolean)
		{
			this.type = type;
			
			this.frames = frames;
			
			this.replaceSame = replaceSame;
			
			this.repeat = repeat;

			this.stopAtEnd = stopAtEnd;
		}
		
		public function canReplace(action:PlayerAction):Boolean
		{
			return action.type != this.type || replaceSame;
		}
		
		public function toString():String
		{
			return type;
		}
	}
}