package ddt.view.sceneCharacter
{
	/**
	 * 人物形象图形路径
	 * @author Devin
	 */	
	public class SceneCharacterLoaderPath
	{
		/**
		 * 玩家衣服路径
		 */		
		private var _clothPath:String;
		
		/**
		 * 设置玩家衣服的路径
		 */	
		public function set clothPath(value:String):void
		{
			_clothPath=value;
		}
		
		/**
		 * 取得玩家衣服的路径
		 */		
		public function get clothPath():String
		{
			return _clothPath;
		}
	}
}