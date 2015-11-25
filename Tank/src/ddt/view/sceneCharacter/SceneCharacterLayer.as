package ddt.view.sceneCharacter
{
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.manager.PathManager;
	import ddt.view.characterII.BaseLayer;
	
	public class SceneCharacterLayer extends BaseLayer
	{
		private var _direction:int; //方向：1=正面;2=背面
		private var _sceneCharacterLoaderPath:SceneCharacterLoaderPath;
		private var _sex:Boolean;//玩家性别:true=男,false=女
		
		public function SceneCharacterLayer(info:ItemTemplateInfo, color:String="", direction:int = 1, sex:Boolean=true, sceneCharacterLoaderPath:SceneCharacterLoaderPath=null)
		{
			_direction = direction;
			_sceneCharacterLoaderPath = sceneCharacterLoaderPath;
			_sex=sex;
			super(info, color); 
		}
		
		override protected function getUrl(layer:int):String
		{
			return PathManager.solveSceneCharacterLoaderPath(_info.CategoryID, _info.Pic, _sex, _info.NeedSex==1, String(layer), _direction, _sceneCharacterLoaderPath);
		}
	}
}