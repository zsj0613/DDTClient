package ddt.view.cells
{
	import ddt.data.goods.ItemTemplateInfo;

	public class CellFactory implements ICellFactory
	{
		private static var _instance:ICellFactory;
		
		public static function get instance():ICellFactory
		{
			if(_instance == null)
				_instance = new CellFactory();
			return _instance;
		} 
		
		public function CellFactory()
		{
		}

		public function createBagCell(place:int, info:ItemTemplateInfo = null,showLoading:Boolean = true):ICell
		{
			return new BagCell(place,info,showLoading);
		}
		
		public function createPersonalInfoCell(place:int, info:ItemTemplateInfo = null,showLoading:Boolean = true):ICell
		{
			return new PersonalInfoCell(place,info,showLoading);
		}
		
	}
}