package ddt.view.bagII
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextFormat;
	
	import game.crazyTank.view.GoodsTipItemAsset;
	import game.crazyTank.view.GoodsTipItemRecoverAsset;
	import game.crazyTank.view.GoodsTipItemRestTimeAsset;

	public class GoodsTipItem extends Sprite
	{
		private var _names:String;
		private var _value:String;
		private var _color:uint;
		private var _addColorBlock:Boolean;
		private var _blockColor:uint;
		private var _block:TipColorBlock;
		private var _align:String;
		private var _isBold:Boolean;
		
		private var _asset:Object;
		
		private static const type:Array=[GoodsTipItemAsset,GoodsTipItemRestTimeAsset];
		
		public function GoodsTipItem(name:String,value:String,color:uint = 0xffffff,align:String = "left",addColorBlock:Boolean = false,blockColor:uint = 0x000000,isBold:Boolean = true,type:uint=0)
		{
			_names = name;
			_value = value;
			_color = color;
			_addColorBlock = addColorBlock;
			_blockColor = blockColor;
			_isBold = isBold;
			_align = align;
			var assetClass:Class=Class(GoodsTipItem.type[type])
			_asset = new assetClass();
			addChild(DisplayObject(_asset));
			super();
			init();
		}
		
		private function init():void
		{
			if(_names != "")_names = _names + ":";
			_asset.name_txt.text = _names + _value;
			_asset.name_txt.width += 45;
			_asset.name_txt.textColor = _color;
			if(_isBold)
			{
				var t:TextFormat = new TextFormat();
				t.bold = true;
				t.align = _align;
				_asset.name_txt.setTextFormat(t);
			}
			
			if(_addColorBlock)
			{
				_block = new TipColorBlock(_blockColor);
				addChild(_block);
			}
		}
		
		public function getTextWidth():int
		{
			var w:int = 0;
			var reg:RegExp = /[^\x00-\xff]{1,}/g;
			
			var charCount:int = _asset.name_txt.text.match(reg).join("").length + _asset.name_txt.text.length;
			
			w = charCount * 8;
			return w;
		}
		
		public function setTextColor(color:uint):void
		{
			_asset.name_txt.textColor = color;
		}
		
		public function setText(str:String):void
		{
			_asset.name_txt.text = str;
		}
		
		public function dispose():void
		{
			if(_block)
			{
				_block.dispose();
			}
			_block = null;
			
			if(parent)
			{
				parent.removeChild(this);
			}
		}
	}
}