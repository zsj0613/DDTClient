package ddt.view.sceneCharacter
{
	/**
	 * 人物形象行为动作
	 * @author Devin
	 */	
	public class SceneCharacterActionItem
	{
		/**
		 *动作类型 
		 */
		public var type:String;
		
		/**
		 * 动作集
		 */
		public var frames:Array;
		
		/**
		 * 是否重复动作
		 */		
		public var repeat:Boolean;
		
		public function SceneCharacterActionItem(type:String, frames:Array, repeat:Boolean)
		{
			this.type = type;
			this.frames = frames;
			this.repeat = repeat;
		}
		
		public function dispose():void
		{
			while(frames && frames.length>0)
			{
				frames.shift();
			}
			frames=null;
		}
	}
}