package ddt.view.common
{
	import flash.display.Sprite;
	
	public class ChatBallBase extends Sprite
	{
		function ChatBallBase(){
			super();
		}
		public function setText(content:String,chatball:int = 0,option:int = 0):void{
			
		}
		public function dispose():void
		{
			if(parent)
				parent.removeChild(this);
		}
		
	}
}