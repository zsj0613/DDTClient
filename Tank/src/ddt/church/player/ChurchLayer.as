package ddt.church.player
{
	import ddt.data.EquipType;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.manager.PathManager;
	import ddt.view.characterII.BaseLayer;

	public class ChurchLayer extends BaseLayer
	{
		private var isFront:Boolean; 
		private var isAdmin:Boolean;
		private var _sex:Boolean;
		public function ChurchLayer(info:ItemTemplateInfo,sex:Boolean ,color:String="",isFront:Boolean = false,isAdmin:Boolean = false)
		{
			this.isFront = isFront;
			this.isAdmin = isAdmin;
			_sex = sex;
			super(info, color); 
		}
		
		override protected function getUrl(layer:int):String
		{
			if(_info.CategoryID ==  EquipType.CLOTH)
			{
				return PathManager.solveChurchCharacterPath(_info.CategoryID,_info.Pic,_sex,String(layer),isFront,isAdmin);
			}else
			{
				return PathManager.solveChurchCharacterPath(_info.CategoryID,_info.Pic,_info.NeedSex == 1,String(layer),isFront,isAdmin);
			}
		}
	}
}