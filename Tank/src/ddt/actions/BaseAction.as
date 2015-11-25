package ddt.actions
{
	public class BaseAction
	{
		protected var _isFinished:Boolean;
		
		public function BaseAction()
		{
			_isFinished = false;
		}
		
		public function connect(action:BaseAction):Boolean
		{
			return false;
		}
		
		public function canReplace(action:BaseAction):Boolean
		{
			return false;
		}
		
		public function get isFinished():Boolean
		{
			return _isFinished;
		}
		
		protected var _isPrepare:Boolean;
		public function prepare():void
		{
			if(_isPrepare) return;
			_isPrepare = true;
		}
				
		public function execute():void
		{
			executeAtOnce();
			_isFinished = true;
		}
		
		public function executeAtOnce():void
		{
			prepare();
			_isFinished = true;
		}
		
		public function cancel():void
		{
		}
		
	}
}