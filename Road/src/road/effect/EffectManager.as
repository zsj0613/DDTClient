package road.effect
{
	public final class EffectManager
	{
		
		private static var _instance:EffectManager;

		public static function get Instance ():EffectManager
		{
			if(_instance == null)
			{
				_instance = new EffectManager();
			}
			return _instance;
		}

		public function EffectManager()
		{
			_effects = new Vector.<IEffect>();
		}
		
		private var _effects:Vector.<IEffect>;
		
		
	}
}