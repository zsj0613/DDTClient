package ddt.view.sceneCharacter
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	 * 行为人物形象构成
	 * @author Devin
	 */
	public class SceneCharacterBase extends Sprite
	{
		private var _frameBitmap:Vector.<Bitmap>;//单帧形象集
		private var _sceneCharacterActionItem:SceneCharacterActionItem;//玩家当前动作
		private var _frameIndex:int = 0;//当前帧索引
		
		/**
		 * 人物形象构成
		 * @param frameBitmap 形象集
		 * @param characterHeight 形象高度
		 * @param characterWitdh 形象宽度
		 * @param callBack 成功后的返回函数
		 */	
		public function SceneCharacterBase(frameBitmap:Vector.<Bitmap>)
		{
			_frameBitmap=frameBitmap;
			initialize();
		}
		
		/**
		 * --------测试用，用与输出所有帧，方便核对（正式使用前注释掉）----------
		 */		
//		public function testGetFrameBitmap():Vector.<Bitmap>
//		{
//			return _frameBitmap;
//		}
		//--------------------测试用结束----------------------------
		
		private function initialize():void
		{
		}
		
		/**
		 * 更新形象显示
		 */		
		public function update():void
		{
			if(_frameIndex < _sceneCharacterActionItem.frames.length)
			{
				loadFrame(_sceneCharacterActionItem.frames[_frameIndex++]);
			}
			else 
			{
				if(_sceneCharacterActionItem.repeat)
				{
					_frameIndex = 0;
				}
			}
		}
		
		/**
		 * 加载指定帧
		 */
		private function loadFrame(frameIndex:int):void
		{
			if(frameIndex>=_frameBitmap.length)
			{
				frameIndex=_frameBitmap.length-1;
			}
			
			if(_frameBitmap && _frameBitmap[frameIndex])
			{
				if(this.numChildren>0 && this.getChildAt(0))
				{
					removeChildAt(0);
				}
				
				addChild(_frameBitmap[frameIndex]);
			}
		}

		/**
		 * 设置形象动作
		 */		
		public function set sceneCharacterActionItem(value:SceneCharacterActionItem):void
		{
			_sceneCharacterActionItem = value;
			_frameIndex=0;
		}
		
		/**
		 * 人物动作
		 */		
		public function get sceneCharacterActionItem():SceneCharacterActionItem
		{
			return _sceneCharacterActionItem;
		}
		
		public function dispose():void
		{
			while(numChildren>0)
			{
				removeChildAt(0);
			}
			
			while(_frameBitmap && _frameBitmap.length>0)
			{
				_frameBitmap[0].bitmapData.dispose();
				_frameBitmap[0].bitmapData=null;
				_frameBitmap.shift();
			}
			_frameBitmap=null;
			
			if(_sceneCharacterActionItem) _sceneCharacterActionItem.dispose();
			_sceneCharacterActionItem=null;
		}
	}
}