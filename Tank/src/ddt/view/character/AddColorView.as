package ddt.view.character
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	
	public class AddColorView extends Bitmap
	{
		private var _source:BitmapData;
		private var _color:uint;
		
		public function AddColorView(source:BitmapData,color:uint)
		{
			super(source.clone());
			_source = source;
			_color = color;
			createColorLayer();
		}
		
		public function set color(value:uint):void
		{
			if(_color == value) return;
			_color = value;
			createColorLayer();
		}
		
		public function get color():uint
		{
			return _color;
		}
		
		public function createColorLayer():void
		{
			var t:BitmapData = _source.clone();
			
			var r:uint = ((_color >> 16) & 255);
            var g:uint = ((_color >> 8) & 255);
            var b:uint = (_color & 255);
            var a:uint = ((_color >> 24) & 255);
            
            var r1:int = r;
            var g1:int = g;
            var b1:int = b;
            var d:Boolean = false;
            if(!(r1 == g1 || r1 == b1 || g1 == b1))
            {
	            if(r1 > g1)
	            {
	            	if(r1 > b1)
	            	{
	            		r1 = 50;
	            		g1 = 0;
	            		b1 = 0;
	            		d = true;
	            	}
	            	else
	            	{
	            		r1 = 0;
	            		g1 = 0;
	            		b1 = 50;
	            		d = true;
	            	}
	            }
	            else 
	            {
	            	if(g1 > b1)
	            	{
	            		r1 = 10;
	            		g1 = 30;
	            		b1 = 30;
	            		d = true;
	            	}
	            	else
	            	{
	            		r1 = 0;
	            		g1 = 0;
	            		b1 = 50;
	            		d = true;
	            	}
	            }
            }
            
            if(d)
            {
            	t.draw(_source,null,new ColorTransform(1,1,1,1,r1,g1,b1,0),null,null,true);
            }
			
            if(!(r == g || r == b || g == b))
            {
            	if(r < g && r < b)
            	{
            		if(g < b)
            		{
            			g += 40;
            			b += 10;
            		}
            		else 
            		{
            			g += 40;
            			b += 10;
            		}
            	}
            	else if(g < r && g < b)
            	{
            		if(r < b)
            		{
            			r += 40;
            			b += 10;
            		}
            		else 
            		{
            			r += 40;
            			b += 10;
            		}
            	}
            	else if(b < g && b < r)
            	{
            		if(g < r)
            		{
            			g += 40;
            			r += 10;
            		}
            		else
            		{
            			g += 40;
            			r += 10;
            		}
            	}
            }
            
            //bitmapData.fillRect(new Rectangle(0,0,_source.width,_source.height),0);
            bitmapData.draw(_source,null,new ColorTransform(0,0,0,1,r,g,b,0),null,null,true);
            bitmapData.draw(t,null,null,BlendMode.HARDLIGHT);
            
//			var ttt:BitmapData = new BitmapData(_source.width,_source.height,true,0x00000000);
//			ttt.draw(_source,null,new ColorTransform(0,0,0,1,r,g,b,0),null,null,true);
//			ttt.draw(t,null,null,BlendMode.HARDLIGHT);
//		
//            target = new Bitmap(ttt,"auto",true);
		}
	}
}