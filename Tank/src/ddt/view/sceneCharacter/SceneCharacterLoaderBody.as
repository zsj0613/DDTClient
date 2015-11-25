package ddt.view.sceneCharacter
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	
	import ddt.data.player.PlayerInfo;
	import ddt.manager.ItemManager;
	import ddt.view.characterII.ILayer;
	
	/**
	 * 玩家身体形象
	 */	
	public class SceneCharacterLoaderBody
	{
		private var _loaders:Array;
		private var _recordStyle:Array;
		private var _recordColor:Array;
		private var _content:BitmapData;
		private var _completeCount:int;	
		private var _playerInfo:PlayerInfo;
		private var _sceneCharacterLoaderPath:SceneCharacterLoaderPath;
		private var _isAllLoadSucceed:Boolean=true;//是否全部加载成功
		private var _callBack:Function;
		
		public function SceneCharacterLoaderBody(playerInfo:PlayerInfo, sceneCharacterLoaderPath:SceneCharacterLoaderPath=null)
		{
			_playerInfo=playerInfo;
			_sceneCharacterLoaderPath=sceneCharacterLoaderPath;
		}
		
		public function load(callBack:Function=null):void
		{
			_callBack = callBack;
			if(_playerInfo == null || _playerInfo.Style == null)
			{
				return;
			}
			initLoaders();
			for(var i:int = 0; i < _loaders.length;  i++)
			{
				var iLayer:ILayer = _loaders[i];
				iLayer.load(layerComplete);
			}
		}
		
		private function initLoaders():void
		{			
			_loaders = [];
			_recordStyle = _playerInfo.Style.split(",");
			_recordColor = _playerInfo.Colors.split(",");
			
			_loaders.push(new SceneCharacterLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[4])),_recordColor[4], 1, _playerInfo.Sex, _sceneCharacterLoaderPath));//正面CLOTH(衣服)
			_loaders.push(new SceneCharacterLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[4])),_recordColor[4], 2, _playerInfo.Sex, _sceneCharacterLoaderPath));//背面CLOTH(衣服)
		}
		
		private function drawCharacter():void
		{
			var picWidth:Number = (_loaders[0] as ILayer).width;
			var picHeight:Number = (_loaders[0] as ILayer).height;
			if(picWidth == 0 || picHeight == 0)return;
			
			_content = new BitmapData(picWidth,picHeight,true,0);
			
			for(var i:uint = 0;i<_loaders.length;i++)
			{
				var layer:SceneCharacterLayer = _loaders[i] as SceneCharacterLayer;
				if(!layer.isAllLoadSucceed)
				{//当前项如果存在加载失败
					_isAllLoadSucceed=false;//设置全部加载是否成功为假
				}
				_content.draw(layer.getContent(),null,null, BlendMode.NORMAL);
			}
		}
		
		private function layerComplete(layer:ILayer):void
		{
			_completeCount ++;
			if(_completeCount >= _loaders.length)
			{
				drawCharacter();
				loadComplete();
			}			
		}
		
		private function loadComplete():void
		{
			if(_callBack != null)
				_callBack(this, _isAllLoadSucceed);
		}
		
		public function getContent():Array
		{
			return [_content];
		}
		
		public function dispose():void
		{
			for each(var iLayer:ILayer in _loaders)
			{
				iLayer.dispose();
			}
			_loaders=null;
			_recordStyle=null;
			_recordColor=null;
			_playerInfo = null;
			_callBack = null;
			_sceneCharacterLoaderPath=null;
		}
	}
}