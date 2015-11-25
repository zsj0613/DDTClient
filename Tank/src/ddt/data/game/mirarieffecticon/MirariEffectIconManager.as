package ddt.data.game.mirarieffecticon
{
	import road.data.DictionaryData;
	
	public class MirariEffectIconManager
	{
		private var _effecticons:DictionaryData;
		private static var _instance:MirariEffectIconManager;
		private var _isSetup:Boolean;
		
		public function MirariEffectIconManager(enforce:SingletonEnforce)
		{
			initialize();
		}
		
		private function initialize():void
		{
			_effecticons = new DictionaryData();
			_isSetup = false;
		}
		
		private function release():void
		{
			if(_effecticons)
				_effecticons.clear();
			_effecticons = null;
		}
		
		public function get isSetup():Boolean
		{
			return _isSetup;
		}
		
		public function setup():void
		{
			if(_isSetup == false)
			{
				_isSetup = true;
				
				//TODO: 添加宝珠效果到_effecticons里
				_effecticons.add(new TiredEffectIcon().MirariType, TiredEffectIcon);
				_effecticons.add(new FiringEffectIcon().MirariType, FiringEffectIcon);
				_effecticons.add(new LockAngleEffectIcon().MirariType, LockAngleEffectIcon);
				_effecticons.add(new WeaknessEffectIcon().MirariType, WeaknessEffectIcon);
				_effecticons.add(new NoHoleEffectIcon().MirariType, NoHoleEffectIcon);
				_effecticons.add(new DefendEffectIcon().MirariType, DefendEffectIcon);
			}
		}
		
		public function unsetup():void
		{
			if(_isSetup)
			{
				release();
				_isSetup = false;
			}
		}
		
		public function createEffectIcon(type:int):BaseMirariEffectIcon
		{
			if(!_isSetup)
			{
				setup();
			}
			
			var cls:Class = _effecticons[type] as Class;
			
			if(cls == null)
				return null;
			
			var bmei:BaseMirariEffectIcon = new cls() as BaseMirariEffectIcon;
			
			return bmei;
		}
		
		public static function getInstance():MirariEffectIconManager
		{
			if(_instance == null)
			{
				_instance = new MirariEffectIconManager(new SingletonEnforce());
			}
			
			return _instance;
		}
	}
}
class SingletonEnforce {}