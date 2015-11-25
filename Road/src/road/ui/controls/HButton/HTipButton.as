package road.ui.controls.HButton
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import road.ui.manager.TipManager;

	public class HTipButton extends HBaseButton
	{
		private var _tip:String = "";
		private var tipBg:Sprite;
		private var tipTextField:TextField;
		private var tipContainer:Sprite;
		private static var TIP_GAPE:uint = 6;
		private var tipFormat:TextFormat;
		
		private var gape:Number;
		private var tipPos:Point;
		
		public function HTipButton($bg:DisplayObject, $label:String="",$tip:String = "")
		{
			_tip = $tip;
			super($bg, $label);
			tipText = $tip;
		}
		
		override protected function init():void
		{
			tipBg = new TipBgAccect();
			tipContainer = new Sprite();
			addChild(tipContainer)
			tipBg.scale9Grid = new Rectangle(8,8,44,10);
			creatTipTextField();
			tipContainer.addChild(tipBg);
			tipContainer.addChild(tipTextField);
			tipTextField.text = _tip;
			tipContainer.visible = false;
			tipPos = new Point();
			super.init();
			centerTip();
			creatTipFormat();
		}
		
		private function creatTipFormat():void
		{
			tipFormat = new TextFormat();
			tipFormat.font = "Arial";
			tipFormat.size = 14;
			tipFormat.color = 0xFFFFFF;
			
			var tipGlowFilter:GlowFilter = new GlowFilter(0x000000,1,2,2,10);
			tipTextField.defaultTextFormat = tipFormat;
			tipTextField.filters = [tipGlowFilter];
		}
		
		protected function centerTip():void
		{
			tipBg.width = tipTextField.width+16;
			tipBg.height = tipTextField.height+8;
			tipTextField.x = 8;
			tipTextField.y = 5;
			tipPos.y = container.y-TIP_GAPE - tipBg.height;
			tipPos.x = ((container.x+container.width) - tipContainer.width)/2;
		}
		
		private function creatTipTextField():void
		{
			tipTextField = new TextField();
			tipTextField.autoSize = "left";
			tipTextField.selectable = false;
			tipTextField.mouseEnabled = false;
			tipTextField.textColor = 0xffffff;
			tipTextField.text = _tip;
		}
		override public function center():void
		{
			super.center();
			centerTip();
		}
		
		
		override protected function overHandler(evt:MouseEvent):void
		{
			super.overHandler(evt);
			if(_tip == "")return;
			var temp:Point = this.localToGlobal(new Point(tipPos.x,tipPos.y));
			tipContainer.x = temp.x;
			tipContainer.y = temp.y;
			if(tipContainer.y < 0)
			{
				tipContainer.y = 0;
				tipContainer.x += tipContainer.width + 6;
			}
			if((tipContainer.x + tipContainer.width) > 1000)
			{
				tipContainer.x = 1000 - tipContainer.width;
				if(tipContainer.y == 0)
				{
					var tempI : Point = this.localToGlobal(new Point(this.x,this.y));
					tipContainer.y = tempI.y + container.height + 2;
				}
				
			}
			tipContainer.visible = true;
			TipManager.AddTippanel(tipContainer);
		}
		
		override public function set enable(b:Boolean):void
		{
			super.enable = b;
			if(_tip == "")return;
			tipContainer.visible = false;
			TipManager.RemoveTippanel(tipContainer);
		}
		
		override protected function outHandler(evt:MouseEvent):void
		{
			super.outHandler(evt);
			if(_tip == "")return;
			tipContainer.visible = false;
			TipManager.RemoveTippanel(tipContainer);
		}
	
		public function set tipText (s:String):void
		{
			tipTextField.text = s;
			if(s.indexOf("\\n") != -1)
			{
				var lineText:Array = s.split("\\n");
				var tempField:TextField = new TextField();
				tempField.autoSize = TextFieldAutoSize.CENTER;
				var maxLineWidth:Number = 0;
				for(var i:int = 0;i<lineText.length;i++)
				{
					tempField.text = lineText[i];
					maxLineWidth = Math.max(maxLineWidth,tempField.textWidth);
				}
				tipTextField.wordWrap = true;
				tipTextField.width = maxLineWidth;
				tipTextField.text = lineText.join("");
			}
			tipTextField.setTextFormat(tipFormat);
			centerTip();
		}
		
		public function set tipGape(g:Number):void
		{
			gape = g;
			centerTip();
		}
		
		public function set setX(num:Number):void
		{
			tipPos.x =((container.x+container.width) - tipContainer.width)/2 + num;
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(tipContainer && tipContainer.parent)
				tipContainer.parent.removeChild(tipContainer);
			tipBg = null;
			tipTextField = null;
			tipContainer = null;
			tipFormat = null;
		}
	}
}