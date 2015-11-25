package ddt.view.sceneCharacter
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * 人物状态项
	 * @author Devin
	 */	
	public class SceneCharacterStateItem
	{
		private var _type:String;
		private var _sceneCharacterSet:SceneCharacterSet;
		private var _sceneCharacterActionSet:SceneCharacterActionSet;
		private var _sceneCharacterSynthesis:SceneCharacterSynthesis;
		private var _sceneCharacterBase:SceneCharacterBase;//行为人物形象
		private var _frameBitmap:Vector.<Bitmap>;//合成的形像图帧
		private var _sceneCharacterActionItem:SceneCharacterActionItem;//当前动作
		private var _sceneCharacterDirection:SceneCharacterDirection;//当前方向	
		
		/**
		 * @param type 人物状态项类型ID，唯一值
		 * @param sceneCharacterSet 形象图集
		 * @param sceneCharacterActionSet 动作集 
		 */		
		public function SceneCharacterStateItem(type:String, sceneCharacterSet:SceneCharacterSet, sceneCharacterActionSet:SceneCharacterActionSet)
		{
			_type=type;
			_sceneCharacterSet=sceneCharacterSet;
			_sceneCharacterActionSet=sceneCharacterActionSet;
		}
		
		/**
		 * 更新或生成形象状态
		 */		
		public function update():void
		{
			if(!_sceneCharacterSet || !_sceneCharacterActionSet) return;
			
			if(_sceneCharacterSynthesis) _sceneCharacterSynthesis.dispose();
			_sceneCharacterSynthesis=null;
			
			_sceneCharacterSynthesis=new SceneCharacterSynthesis(_sceneCharacterSet, sceneCharacterSynthesisCallBack);
		}
		
		/**
		 * 生成形象帧回调
		 */		
		private function sceneCharacterSynthesisCallBack(frameBitmap:Vector.<Bitmap>):void
		{
			_frameBitmap=frameBitmap;
			if(_sceneCharacterBase) _sceneCharacterBase.dispose();
			_sceneCharacterBase=null;
			
			_sceneCharacterBase=new SceneCharacterBase(_frameBitmap);
			_sceneCharacterBase.sceneCharacterActionItem=_sceneCharacterActionItem=_sceneCharacterActionSet.dataSet[0];//指定首序号动作为默认动作
		}
		
		/**
		 * 形象动作类型
		 */		
		public function set setSceneCharacterActionType(type:String):void
		{
			var item:SceneCharacterActionItem=_sceneCharacterActionSet.getItem(type);
			if(item) _sceneCharacterActionItem = item;
			_sceneCharacterBase.sceneCharacterActionItem=_sceneCharacterActionItem;
		}
		
		/**
		 * 形象动作类型
		 */		
		public function get setSceneCharacterActionType():String
		{
			return	_sceneCharacterActionItem.type;
		}
		
		/**
		 * 设置方向
		 */		
		public function set sceneCharacterDirection(value:SceneCharacterDirection):void
		{
			if(_sceneCharacterDirection==value) return;
			_sceneCharacterDirection = value;
		}
		
		/**
		 * 取得人物状态项类型ID，唯一值
		 */		
		public function get type():String
		{
			return _type;
		}
		
		/**
		 * 设置人物状态项类型ID，唯一值
		 */
		public function set type(value:String):void
		{
			_type = value;
		}
		
		/**
		 * 取得形象图集 
		 */
		public function get sceneCharacterSet():SceneCharacterSet
		{
			return _sceneCharacterSet;
		}
		
		/**
		 * 设置形象图集 
		 */
		public function set sceneCharacterSet(value:SceneCharacterSet):void
		{
			_sceneCharacterSet = value;
		}
		
		/**
		 * 取得形象
		 */		
		public function get sceneCharacterBase():SceneCharacterBase
		{
			return _sceneCharacterBase;
		}
		
		public function dispose():void
		{
			if(_sceneCharacterSet) _sceneCharacterSet.dispose();
			_sceneCharacterSet=null;
			
			if(_sceneCharacterActionSet) _sceneCharacterActionSet.dispose();
			_sceneCharacterActionSet=null;
			
			if(_sceneCharacterSynthesis) _sceneCharacterSynthesis.dispose();
			_sceneCharacterSynthesis=null;
			
			if(_sceneCharacterBase) _sceneCharacterBase.dispose();
			_sceneCharacterBase=null;
			
			if(_sceneCharacterActionItem) _sceneCharacterActionItem.dispose();
			_sceneCharacterActionItem=null;			

			_sceneCharacterDirection=null;				
			
			while(_frameBitmap && _frameBitmap.length>0)
			{
				_frameBitmap[0].bitmapData.dispose();
				_frameBitmap[0].bitmapData=null;
				_frameBitmap.shift();
			}
			_frameBitmap=null;
		}
	}
}