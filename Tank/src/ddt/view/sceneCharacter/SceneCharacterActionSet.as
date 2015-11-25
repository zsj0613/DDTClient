package ddt.view.sceneCharacter
{
	/**
	 * 动作集
	 * @author Devin
	 */	
	public class SceneCharacterActionSet
	{
		private var _dataSet:Vector.<SceneCharacterActionItem>;
		
		/**
		 * 动作集
		 */		
		public function SceneCharacterActionSet()
		{
			_dataSet=new Vector.<SceneCharacterActionItem>();
		}
		
		/**
		 * 增加形象单元至末位
		 */		
		public function push(sceneCharacterActionItem:SceneCharacterActionItem):void
		{
			_dataSet.push(sceneCharacterActionItem);
		}
		
		/**
		 * 集长度
		 */		
		public function get length():uint
		{
			return _dataSet.length;
		}
		
		/**
		 *取得动作集
		 */
		public function get dataSet():Vector.<SceneCharacterActionItem>
		{
			return _dataSet;
		}
		
		/**
		 *从动作集中取得指定的动作
		 */
		public function getItem(type:String):SceneCharacterActionItem
		{
			if(_dataSet && _dataSet.length>0)
			{
				for(var i:int=0;i<_dataSet.length;i++)
				{
					if(_dataSet[i].type==type)
					{
						return _dataSet[i];
					}
				}
			}
			
			return null;
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