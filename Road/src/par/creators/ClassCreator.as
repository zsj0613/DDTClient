package par.creators
{
	import flash.display.DisplayObject;

	public class ClassCreator implements IParticalCreator
	{
		private var _ator:Class;
		
		public function ClassCreator(cls:Class)
		{
			_ator = cls;
		}

		public function createPartical():DisplayObject
		{
			return new _ator() as DisplayObject;
		}
		
	}
}