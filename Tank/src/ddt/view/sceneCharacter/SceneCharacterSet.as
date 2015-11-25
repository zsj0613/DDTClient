package ddt.view.sceneCharacter
{
	

	/**
	 *形象图集 
	 * @author Devin
	 */	
	public class SceneCharacterSet
	{
		private var _dataSet:Vector.<SceneCharacterItem>;
		
		/**
		 * 形象图集
		 */		
		public function SceneCharacterSet()
		{
			_dataSet=new Vector.<SceneCharacterItem>();
		}
		
		/**
		 * 增加形象单元至末位
		 */		
		public function push(sceneCharacterItem:SceneCharacterItem):void
		{
			_dataSet.push(sceneCharacterItem);
		}
		
		/**
		 * 集长度
		 */		
		public function get length():uint
		{
			return _dataSet.length;
		}
		
		/**
		 *取得形象集(为了减少内存消耗，在处理过程中未进行集克隆，经过合成处理后，相同的组项将会合并，并删除掉被合成的项，最后会改变当前形象集长度)
		 */
		public function get dataSet():Vector.<SceneCharacterItem>
		{
			return _dataSet.sort(sortOn);
		}
		
		private function sortOn(a:SceneCharacterItem, b:SceneCharacterItem):Number
		{ 
			if (a.sortOrder < b.sortOrder)
			{
				return -1; 
			}
			else if(a.sortOrder > b.sortOrder)
			{
				return 1; 
			}
			else
			{
				return 0;
			}
		}
		
		public function dispose():void
		{
			while(_dataSet && _dataSet.length>0)
			{
				_dataSet[0].dispose();
				_dataSet.shift();
			}
			_dataSet=null;
		}
	}
}