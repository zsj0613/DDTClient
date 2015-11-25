package ddt.view.common
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import game.crazyTank.view.GoodsTipBgAsset;
	import game.crazyTank.view.roomII.RoomIIPropTipAsset;
	
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.ShopManager;

	public class RoomIIPropTip extends RoomIIPropTipAsset
	{
		private var _info:ItemTemplateInfo;
		private var _count:int = 0;
		private var _showPrice:Boolean;
		private var _showCount:Boolean;
		private var _showThew:Boolean;
		private var bg:Sprite;
		
		public function RoomIIPropTip(showPrice:Boolean,showCount:Boolean,showThew:Boolean)
		{
			_showCount = showCount;
			_showPrice = showPrice;
			_showThew = showThew;
			bg=new GoodsTipBgAsset;
			addChildAt(bg,0);
		}
		
		
		private var context : TextField;
		private var f : TextFormat = new TextFormat(null,13,0xffffff);
		public function changeStyle(info:ItemTemplateInfo,$width:int,$wordWrap:Boolean=true) : void
		{
			thew_txt.width = gold_txt.width = description_txt.width = name_txt.width = 0;
			thew_txt.y = gold_txt.y = description_txt.y = name_txt.y = 0;
			thew_txt.text = gold_txt.text = description_txt.text = name_txt.text = "";
			
			if(!context)
			{
				context = new TextField();
				context.width = $width-2;
	//			context.wordWrap = true;
				context.autoSize = TextFieldAutoSize.CENTER;
				addChild(context);
				
				context = new TextField();
				context.width = $width-2; 
				if($wordWrap)
				{
					context.wordWrap = true;
				    context.autoSize = TextFieldAutoSize.LEFT;
					context.x = 2;
					context.y = 2;
				}
				else
				{
					context.wordWrap = false;
					context.autoSize = TextFieldAutoSize.CENTER;
					context.y = 4;
				}
				
				addChild(context);
			}
			_info = info;
			if(_info)context.text = _info.Description;
			context.setTextFormat(f);
			bg.height=0;
			drawBG($width);
		}
		public function update(info:ItemTemplateInfo,count:int):void
		{
			_info = info;
			_count = count;
			
			/* 是否显示数量 */
			name_txt.autoSize = TextFieldAutoSize.LEFT;
			
			if(_showCount)
			{
				if(_count > 1)
				{
					name_txt.text = String(_info.Name) + "(" + String(_count) + ")";
				}
				else if(_count == -1)
				{
					name_txt.text = String(_info.Name) + LanguageMgr.GetTranslation("ddt.view.common.RoomIIPropTip.infinity");
					//name_txt.text = String(_info.Name) + "(无限)";
				}
				else
				{
					name_txt.text = String(_info.Name);
				}
			}
			else
			{
				name_txt.text = String(_info.Name);
			}
			
			/* 是否显示消耗体力 */
			if(_showThew){
				thew_txt.text = LanguageMgr.GetTranslation("ddt.view.common.RoomIIPropTip.consume")+ String(_info.Property4);
				
//				var t:TextFormat = new TextFormat();
//				t.bold = true;
//				thew_txt.setTextFormat(t);
				//thew_txt.text = "消耗体力"+ String(_info.Property4);
			}else{
				thew_txt.visible = false;
				description_txt.y =thew_txt.y; 
			}
			
			/* 描述 */
			description_txt.width = 120;
			description_txt.wordWrap = true;
			description_txt.autoSize = TextFieldAutoSize.LEFT;
			description_txt.text = String(_info.Description);
			
			/* 是否显示价格 */
			if(_showPrice)
			{
				gold_txt.visible = true;
				gold_txt.y = description_txt.y+description_txt.height+5;
				gold_txt.text = String(ShopManager.Instance.getShopItemByTemplateIDAndShopID(_info.TemplateID,2).getItemPrice(1).goldValue) + "G";
			}
			else
			{
				gold_txt.visible = false;
				gold_txt.y = 0;
			}
			drawBG();
		}
		private function reset():void
		{
			bg.height=0;
			bg.width=0;
		}
		/**
		 * 绘制背景
		 */
		private function drawBG($width:int=0):void
		{
			reset();
			if($width == 0)
			{
				bg.width=this.width+10;
				bg.height=this.height+5;
			}
			else
			{
				bg.width=$width+2;
				bg.height=this.height+5;
			}
		}
		
		public function dispose() : void
		{
			if(context && context.parent)context.parent.removeChild(context);
			context = null;
			_info = null;
			if(this.parent)this.parent.removeChild(this);
		}
	}
}