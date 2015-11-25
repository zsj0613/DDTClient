package ddt.view.items
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.utils.Dictionary;
	
	import game.crazyTank.view.*;
	
	import ddt.data.goods.PropInfo;

	public class PropItemView extends Sprite
	{
		public static var _prop:Dictionary;
		
		private var _info:PropInfo;
		private var _asset:Bitmap;
		private var _bg:PropContainerAsset;
		private var _isExist:Boolean;
			
		public function get info():PropInfo
		{
			return _info;
		}
		
		public function PropItemView(info:PropInfo,$isExist:Boolean = true)
		{
			_info = info;
			_isExist = $isExist;
			_asset = PropItemView.createView(_info.Template.Pic,40,40);
			_asset.x = 1;
			_asset.y = 1;
			_asset.width = 38;
			_asset.height = 38;
			if(!_isExist) filters = [new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0])];
			addChild(_asset);
		}
		
		public function get isExist():Boolean
		{
			return _isExist;
		}
		
		public static function createView(id:String,width:int = 62,height:int = 62):Bitmap
		{
			if(_prop == null)
			{
				_prop = new Dictionary();
				_prop["1"] = Prop1Asset;
				_prop["2"] = Prop2Asset;
				_prop["3"] = Prop3Asset;
				_prop["4"] = Prop4Asset;
				_prop["5"] = Prop5Asset;
				_prop["6"] = Prop6Asset;
				_prop["7"] = Prop7Asset;
				_prop["8"] = Prop8Asset;
				_prop["9"] = Prop9Asset;
				_prop["10"] = Prop10Asset;
				_prop["11"] = Prop11Asset;
				_prop["12"] = Prop12Asset;
				_prop["13"] = Prop13Asset;
				_prop["14"] = Prop14Asset;
				_prop["15"] = Prop15Asset;
				_prop["16"] = Prop16Asset;
				_prop["17"] = Prop17Asset;
				_prop["18"] = Prop18Asset;
				_prop["19"] = Prop19Asset;
				_prop["20"] = Prop20Asset;
				_prop["21"] = Prop21Asset;
				_prop["22"] = Prop22Asset;
				_prop["23"] = Prop23Asset;
				_prop["24"] = Prop24Asset;
				_prop["25"] = Prop25Asset;
				_prop["26"] = Prop26Asset;
				
			}
			if(_prop[id] == null)return new Bitmap();
			var t:Bitmap = new Bitmap(new _prop[id](width,height) as BitmapData);
			t.smoothing = true;
			t.width = width;
			t.height = height;
			return t;
		}
		
		public function dispose():void
		{
			if(_bg && _bg.parent)
				_bg.parent.removeChild(_bg);
			_bg = null;
			
			if(_asset && _asset.parent)
				_asset.parent.removeChild(_asset);
			_info = null;
			
			if(parent)
				parent.removeChild(this);
		}
	}
}