package ddt.loader
{
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	
	import road.loader.DisplayLoader;

	public class BitmapLoader extends DisplayLoader
	{
		private var _color:Number;
		private var _bitmap:Bitmap;
		private var _source:BitmapData;
		public var visible:Boolean;
		
		public function BitmapLoader(url:String)
		{
			super(0,url);
			_color = NaN;
			visible = false;
		}
		
		public function get color():Number
		{
			return _color;
		}
		public function set color(value:Number):void
		{
			if(_color == value) return;
			_color = value;
			if(_bitmap)
			{
				updateColor();
			}
			visible = !isNaN(_color);
		}
		public function get bitmap():Bitmap
		{
			return _bitmap;
		}
		
		override protected function onCompleted():void
		{
			if(isSuccess)
			{
				_bitmap = _displayLoader.content as Bitmap;
				_bitmap.smoothing = true;
				updateColor();
			}
			super.onCompleted();
		}
		
		protected function updateColor():void
		{
			if(!isNaN(_color))
			{
				if(_source == null)
				{
					_source = _bitmap.bitmapData.clone();
				}
				
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
	            _bitmap.bitmapData.draw(_source,null,new ColorTransform(0,0,0,1,r,g,b,0));
	            _bitmap.bitmapData.draw(t,null,null,BlendMode.HARDLIGHT);
	  		}
	  		else
	  		{
	  			if(_source)
	  			{
	  				_bitmap.bitmapData.draw(_source);
	  			}
	  		}	
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_bitmap)
				_bitmap.bitmapData.dispose();
			if(_source)
				_source.dispose();
		}
		
	}
}