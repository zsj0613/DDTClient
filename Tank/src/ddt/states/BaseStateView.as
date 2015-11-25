package ddt.states
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import road.ui.manager.TipManager;

	public class BaseStateView extends Sprite
	{
		private var _prepared:Boolean;
		
		public function get prepared():Boolean
		{
			return _prepared;
		}
		
		public function check(type:String):Boolean
		{
			return true;
		}
		
		public function prepare():void
		{
			_prepared = true;
		}
		
		public function enter(prev:BaseStateView,data:Object = null):void
		{
			
		}
		
		public function addedToStage():void
		{
		}
		
		public function leaving(next:BaseStateView):void
		{
			
			
		}
		
		public function removedFromStage():void
		{
			
		}
		
		public function getView():DisplayObject
		{
			return this;
		}
		
		public function getType():String
		{
			return StateType.DEAFULT;
		}
		
		public function getBackType():String
		{
			return "";
		}
		
		public function goBack():Boolean
		{
			return false;
		}
		
		public function fadingComplete():void
		{
		}
		
		public function dispose():void
		{
		}	
	}
}