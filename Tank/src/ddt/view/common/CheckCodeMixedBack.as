package ddt.view.common
{
	import flash.display.Sprite;

	public class CheckCodeMixedBack extends Sprite
	{
		private var _width:Number;
        private var _height:Number;
        
        private var _color:uint;
        
        private var _renderBox:Sprite;
		
		private var masker:Sprite;
		
		private static const CUVER_MAX:int = 10;
		
		private static const PointNum:int = 20;
		
		private static const CuverNum:int = 20;
		
		public function CheckCodeMixedBack($width:Number,$height:Number,$color:Number)
		{
			super();
            _color = $color;
            _height = $height;
            _width = $width;
            
            
            _renderBox = new Sprite();
            
            addChild(_renderBox);
            createPoint();
            creatCurver();
            render();

		}
		private function createPoint ():void
        {
            _renderBox.graphics.beginFill(_color,0.5);
            for(var i:int = 0;i<PointNum;i++)
            {
                _renderBox.graphics.drawCircle(Math.random()*_width,Math.random()*_height,Math.random()*1.5);
            }
            _renderBox.graphics.endFill();
        }
        
        private function creatCurver ():void
        {
            _renderBox.graphics.lineStyle(1,_color,0.5);
            for(var i:int = 0;i<CuverNum;i++)
            {
                var rW:Number = Math.random()*_width;
                var rH:Number = Math.random()*_height;
                _renderBox.graphics.moveTo(rW+(Math.random()*CUVER_MAX-CUVER_MAX),rH+(Math.random()*CUVER_MAX-CUVER_MAX));
                _renderBox.graphics.curveTo(rW+(Math.random()*CUVER_MAX-CUVER_MAX),rH+(Math.random()*CUVER_MAX-CUVER_MAX),rW,rH);
            }
            _renderBox.graphics.endFill();
        }
       
        private function render():void
        {
            addChild(_renderBox);
        }

		
	}
}