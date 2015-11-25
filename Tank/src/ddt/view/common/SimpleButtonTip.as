package ddt.view.common
{
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import road.ui.controls.HButton.TipBgAccect;

	public class SimpleButtonTip extends Sprite
	{
		
		private var asset:Sprite;
		
		private var _label:String = "";
		private var tipTF:TextField;
		private var tipFormat:TextFormat;
				
		public function SimpleButtonTip(label:String ="")
		{
			super();
			_label = label;
			
			init();
		}
		
		private function init():void
		{
			asset = new TipBgAccect();
			asset.scale9Grid = new Rectangle(29,3.8,2.5,18.3);
			
			creatTipTextField();
			creatTipFormat();
			
			addChild(asset);
			addChild(tipTF);
			
			centerTip();
		}
		
		private function creatTipTextField():void
		{
			tipTF = new TextField();
			tipTF.autoSize = "left";
			tipTF.selectable = false;
			tipTF.mouseEnabled = false;
			tipTF.textColor = 0xffffff;
			tipTF.text = _label;
		}
		
		private function creatTipFormat():void
		{
			tipFormat = new TextFormat();
			tipFormat.font = "Arial";
			tipFormat.size = 14;
			tipFormat.color = 0xFFFFFF;
			
			var tipGlowFilter:GlowFilter = new GlowFilter(0x000000,1,2,2,10);
			tipTF.defaultTextFormat = tipFormat;
			tipTF.filters = [tipGlowFilter];
		}
		
		private function centerTip():void
		{
			asset.width = tipTF.width+16;
			asset.height = tipTF.height+8;
			tipTF.x = 8;
			tipTF.y = 5;
		}

		public function set tipText (str:String):void
		{
			tipTF.text = str;
			tipTF.setTextFormat(tipFormat);
		}
	}
}