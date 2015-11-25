package ddt.view.sceneCharacter
{
	/**
	 *人物形象状态集合
	 * @author Devin
	 */	
	public class SceneCharacterStateSet
	{
		private var _dataSet:Vector.<SceneCharacterStateItem>;
		
		public function SceneCharacterStateSet()
		{
			_dataSet=new Vector.<SceneCharacterStateItem>();
		}
		
		/**
		 * 增加形象单元至末位
		 */		
		public function push(sceneCharacterStateItem:SceneCharacterStateItem):void
		{
			if(!sceneCharacterStateItem) return;
			sceneCharacterStateItem.update();
			_dataSet.push(sceneCharacterStateItem);
		}
		
		/**
		 * 集长度
		 */		
		public function get length():uint
		{
			return _dataSet.length;
		}
		
		/**
		 *取得形象状态集
		 */
		public function get dataSet():Vector.<SceneCharacterStateItem>
		{
			return _dataSet;
		}
		
		/**
		 *从动作集中取得指定的状态
		 */
		public function getItem(type:String):SceneCharacterStateItem
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