package ddt.view.sceneCharacter
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import road.ui.manager.TipManager;
	
	/**
	 * 形象合成
	 * @author Devin
	 */	
	public class SceneCharacterSynthesis
	{
		/**
		 *形象数据集 
		 */		
		private var _sceneCharacterSet:SceneCharacterSet;
		
		/**
		 * 合成的形像图帧
		 */		
		private var _frameBitmap:Vector.<Bitmap>=new Vector.<Bitmap>();
		private var _callBack:Function;
		
		/**
		 * 形象合成
		 * @param sceneCharacterSet 形象数据集
		 * @param callBack 成功后回调方法
		 */
		public function SceneCharacterSynthesis(sceneCharacterSet:SceneCharacterSet, callBack:Function)
		{
			_sceneCharacterSet=sceneCharacterSet;
			_callBack=callBack;
			initialize();
		}
		
		private function initialize():void
		{
			characterSynthesis();
		}
		
		
		
		/**
		 * 形象图处理
		 */		
		private function characterSynthesis():void
		{
			var matrix:Matrix=new Matrix();
			var point:Point=new Point(0, 0);
			var rectangle:Rectangle=new Rectangle();
			
			//合成前相关属性处理
			for each(var sceneCharacterItem:SceneCharacterItem in _sceneCharacterSet.dataSet)
			{
				//对单项形象进行是否重复处理
				if(sceneCharacterItem.isRepeat)
				{//如果重复
					var bmp:BitmapData=new BitmapData(sceneCharacterItem.source.width*sceneCharacterItem.repeatNumber, sceneCharacterItem.source.height, true, 0x000000);
					for(var i:int=0;i<sceneCharacterItem.repeatNumber;i++)
					{
						matrix.tx=sceneCharacterItem.source.width*i;
						bmp.draw(sceneCharacterItem.source, matrix);
					}
					sceneCharacterItem.source.dispose();
					sceneCharacterItem.source=null;
					sceneCharacterItem.source=new BitmapData(bmp.width, bmp.height, true, 0x000000);
					sceneCharacterItem.source.draw(bmp);
					bmp.dispose();
					bmp=null;
				}
				
				//进行坐标位置调整
				if(sceneCharacterItem.points && sceneCharacterItem.points.length>0)
				{
					var bmp2:BitmapData=new BitmapData(sceneCharacterItem.source.width, sceneCharacterItem.source.height, true, 0x000000);
					bmp2.draw(sceneCharacterItem.source);
					
					sceneCharacterItem.source.dispose();
					sceneCharacterItem.source=null;
					sceneCharacterItem.source=new BitmapData(bmp2.width, bmp2.height, true, 0x000000);
					
					rectangle.width=sceneCharacterItem.cellWitdh;
					rectangle.height=sceneCharacterItem.cellHeight;
					for(var row:int=0;row<sceneCharacterItem.rowNumber;row++)
					{
						var cellCount:int=sceneCharacterItem.isRepeat ? sceneCharacterItem.repeatNumber : sceneCharacterItem.rowCellNumber;
						for(var j:int=0;j<cellCount;j++)
						{
							var sourcePoint:Point=sceneCharacterItem.points[row*cellCount+j];
							if(sourcePoint)
							{
								point.x=sceneCharacterItem.cellWitdh*j+sourcePoint.x;
								point.y=sceneCharacterItem.cellHeight*row+sourcePoint.y;
								rectangle.x=sceneCharacterItem.cellWitdh*j;
								rectangle.y=sceneCharacterItem.cellHeight*row;
								sceneCharacterItem.source.copyPixels(bmp2, rectangle, point);
							}
							else
							{
								point.x=rectangle.x=sceneCharacterItem.cellWitdh*j;
								point.y=rectangle.y=sceneCharacterItem.cellHeight*row;
								sceneCharacterItem.source.copyPixels(bmp2, rectangle, point);
							}
						}
					}
					bmp2.dispose();
					bmp2=null;
				}
			}
			
			for each(var sceneCharacterItemGroup:SceneCharacterItem in _sceneCharacterSet.dataSet)
			{
				//进行组叠加合成
				characterGroupDraw(sceneCharacterItemGroup);
			}
			
			characterDraw();//进行最终形象处理
		}
		
		/**
		 * 进行组叠加合成
		 */		
		private function characterGroupDraw(sceneCharacterItem:SceneCharacterItem):void
		{
			for each(var _sceneCharacterItem:SceneCharacterItem in _sceneCharacterSet.dataSet)
			{
				if(sceneCharacterItem.groupType==_sceneCharacterItem.groupType && _sceneCharacterItem.type!=sceneCharacterItem.type)
				{//如果找到相同组
					//进行叠加合成
					sceneCharacterItem.source.draw(_sceneCharacterItem.source);
					
					//进行属性转移
					sceneCharacterItem.rowNumber=_sceneCharacterItem.rowNumber>sceneCharacterItem.rowNumber ? _sceneCharacterItem.rowNumber : sceneCharacterItem.rowNumber;
					sceneCharacterItem.rowCellNumber=_sceneCharacterItem.rowCellNumber>sceneCharacterItem.rowCellNumber ? _sceneCharacterItem.rowCellNumber : sceneCharacterItem.rowCellNumber;
					
					//从形象集中去除已经被合成掉的项
					_sceneCharacterSet.dataSet.splice(_sceneCharacterSet.dataSet.indexOf(_sceneCharacterItem), 1);
				}
			}
		}
		
		/**
		 * 最终形象处理
		 */		
		private function characterDraw():void
		{
			var bmp:BitmapData;
			for each(var sceneCharacterItem:SceneCharacterItem in _sceneCharacterSet.dataSet)
			{
				for(var row:int=0;row<sceneCharacterItem.rowNumber;row++)
				{
					for(var i:int=0;i<sceneCharacterItem.rowCellNumber;i++)
					{
						bmp=new BitmapData(sceneCharacterItem.cellWitdh, sceneCharacterItem.cellHeight, true, 0);
						bmp.copyPixels(sceneCharacterItem.source, new Rectangle(i*sceneCharacterItem.cellWitdh, sceneCharacterItem.cellHeight*row, sceneCharacterItem.cellWitdh, sceneCharacterItem.cellHeight), new Point(0, 0));
						_frameBitmap.push(new Bitmap(bmp));
					}
				}
			}
			
			if(_callBack!=null) _callBack(_frameBitmap);
		}
		
		public function dispose():void
		{
			if(_sceneCharacterSet) _sceneCharacterSet.dispose();
			_sceneCharacterSet=null;
			
			while(_frameBitmap && _frameBitmap.length>0)
			{
				_frameBitmap[0].bitmapData.dispose();
				_frameBitmap[0].bitmapData=null;
				_frameBitmap.shift();
			}
			_frameBitmap=null;
			
			_callBack=null;
		}
	}
}