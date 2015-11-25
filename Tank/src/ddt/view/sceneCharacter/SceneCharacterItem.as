package ddt.view.sceneCharacter
{
	import flash.display.BitmapData;
	import flash.geom.Point;

	/**
	 * 单行形象类，用与组合整个形象集
	 * @author Devin
	 */
	public class SceneCharacterItem
	{
		private var _type:String;
		private var _groupType:String;
		private var _sortOrder:int;
		private var _source:BitmapData;
		private var _points:Vector.<Point>;
		private var _cellWitdh:Number;
		private var _cellHeight:Number;
		private var _rowNumber:int;
		private var _rowCellNumber:int;
		private var _isRepeat:Boolean;
		private var _repeatNumber:int;
		
		
		/**
		 * 单行形象类，用与组合整个形象集 
		 * @param type 名称ID，唯一值，不可重复
		 * @param groupType 组名称ID，相同组将会执行叠加合成，在合成过程中对于相同组ID将会以首排序的项做为基项，
		 * 其它相同组项将会向基项叠加合成，最终合成后的项的各属性将以基项为准
		 * @param source 形象源图
		 * @param rowNumber 源图总行数
		 * @param rowCellNumber 源图每行图个数
		 * @param points 单个形象坐标，是指组合生成图片时有时需要改变图片上下或左右的坐标位置，需对应形象个
		 * 数，如有7个图，只改变Y坐标，格式为：
		 * new Point(0,0),new Point(0,-1),new Point(0,2),new Point(0,0),new Point(0,-1),new Point(0,2),new Point(0,0)
		 * 则生成的图就有上下起伏的效果
		 * @param cellWitdh 单个图片宽 
		 * @param cellHeight 单个图片高
		 * @param isRepeat 是否重复，指是否将当前项源图横向复制
		 * @param repeatNumber 重复数量
		 */
		public function SceneCharacterItem(type:String, groupType:String, source:BitmapData, rowNumber:int, rowCellNumber:int, cellWitdh:Number, cellHeight:Number, sortOrder:int=0, points:Vector.<Point>=null, isRepeat:Boolean=false, repeatNumber:int=0)
		{
			_type=type;
			_groupType=groupType;
			_source=source;
			_rowNumber=rowNumber;
			_rowCellNumber=rowCellNumber;
			_cellWitdh=cellWitdh;
			_cellHeight=cellHeight;
			_points=points;
			_sortOrder=sortOrder;
			_isRepeat=isRepeat;
			_repeatNumber=repeatNumber;
		}

		/**
		 *名称 
		 */
		public function get type():String
		{
			return _type;
		}

		/**
		 * 组名称ID，相同组将会执行叠加合成
		 */		
		public function get groupType():String
		{
			return _groupType;
		}
		
		/**
		 *形象源图
		 */
		public function get source():BitmapData
		{
			return _source;
		}
		
		/**
		 *形象源图
		 */
		public function set source(value:BitmapData):void
		{
			_source=value;
		}

		/**
		 * 单个形象坐标，是指组合生成图片时有时需要改变图片上下或左右的坐标位置，需对应形象个数
		 * 如有7个图，只改变Y坐标，格式为：
		 * new Point(0,0),new Point(0,-1),new Point(0,2),new Point(0,0),new Point(0,-1),new Point(0,2),new Point(0,0)
		 * 那么生成的图就有上下起伏的效果
		 */
		public function get points():Vector.<Point>
		{
			return _points;
		}

		/**
		 * 单个图片宽 
		 */
		public function get cellWitdh():Number
		{
			return _cellWitdh;
		}

		/**
		 * 单个图片高
		 */
		public function get cellHeight():Number
		{
			return _cellHeight;
		}

		/**
		 * 取得形象图片行数 
		 */		
		public function get rowNumber():int
		{
			return _rowNumber;
		}
		
		/**
		 * 设置形象图片行数 
		 */		
		public function set rowNumber(value:int):void
		{
			_rowNumber=value;
		}

		/**
		 *取得单行图片个数
		 */		
		public function get rowCellNumber():int
		{
			return _rowCellNumber;
		}
		
		/**
		 *设置单行图片个数
		 */		
		public function set rowCellNumber(value:int):void
		{
			_rowCellNumber=value;
		}

		/**
		 * 取得项设置在集中的排序
		 */		
		public function get sortOrder():int
		{
			return _sortOrder;
		}
		
		/**
		 * 是否重复，指是否将当前项源图横向复制
		 */		
		public function get isRepeat():Boolean
		{
			return _isRepeat;
		}
		
		/**
		 * 重复数量
		 */		
		public function get repeatNumber():int
		{
			return _repeatNumber;
		}
		
		public function dispose():void
		{
			if(_source) _source.dispose();
			_source=null;
			
			while(_points && _points.length>0)
			{
				_points.shift();
			}
			_points=null;
		}
	}
}