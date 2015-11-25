package ddt.church.churchScene.fire
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	import tank.church.FireItemAsset;
	import tank.church.fireAcect.icons.*;
	import tank.church.over_mc;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.data.goods.ShopItemInfo;
	import ddt.utils.DisposeUtils;
	import ddt.view.cells.BaseCell;
	
	public class FireItem extends BaseCell
	{
		public static var FireIcons:Array = [FireIcon01,FireIcon02,FireIcon03,FireIcon04,FireIcon05,FireIcon06];
		private var textField:TextField;
		private var _over:over_mc = new over_mc();
		
		public function FireItem()
		{
			init();
			super(new FireItemAsset());
			_over.x = (_bg as FireItemAsset).over.x;
			_over.y = (_bg as FireItemAsset).over.y;
			(_bg as FireItemAsset).over.visible = false;
//			addChild(_over);
			_over.visible = false;
		}
		
		override protected function createChildren():void
		{
			addChildAt(_bg,0);
			_bg["figure_pos"].alpha = 0;
			_contentWidth = _bg["figure_pos"].width;
			_contentHeight = _bg["figure_pos"].height;
		}
		
		private function init():void
		{
			this.buttonMode = true;
			textField = new TextField();
			var tf:TextFormat = new TextFormat();
			tf.color = 0xffff00;
			tf.bold = true;
			textField.defaultTextFormat = tf;
			textField.filters = [new GlowFilter(0x000000,10,2,2)];
			textField.width = 54;
			textField.y = 33;
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
		}
	
		public function setInfo($shopItemInfo:ShopItemInfo):void
		{
			info = $shopItemInfo.TemplateInfo;
			if(_info)
			{
				textField.text = String($shopItemInfo.getItemPrice(1).goldValue)+"G";
				addChild(textField);
			}else
			{
				textField.text = "";
			}
			addChild(_over);
		}
		
		override protected function onMouseClick(evt:MouseEvent):void
		{
		}
		
		override protected function onMouseOver(evt:MouseEvent):void
		{
			super.onMouseOver(evt);
			_over.visible = true;
		}
		
		override protected function onMouseOut(evt:MouseEvent):void
		{
			super.onMouseOut(evt);
			_over.visible = false;
		}
		
		override public function set info(value:ItemTemplateInfo):void
		{
			if(_info == value && !_info)return;
			if(_info)
			{
				clearCreatingContent();
				if(_pic && _pic.parent)
					_pic.parent.removeChild(_pic);
				_pic = null;
				locked = false;
			}
			_info = value;
			if(_info)
			{
				_pic = createContent();
				createContentComplete();
				addChild(_pic);
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		override protected function createContent():Sprite
		{
			var iconClass:Class = FireIcons[int(info.Pic) - 1];
			var container:Sprite
			if(iconClass)
			{
				container = new iconClass();
			}
			return container;
		}
		
		override protected function clearCreatingContent():void
		{
			
		}
		
		override public function setColor(color:*):Boolean
		{
			return false;
		}
		
		override public function get editLayer():int
		{
			return 0;
		}
		override public function dispose():void
		{
			super.dispose();
			DisposeUtils.disposeDisplayObject(textField);
			if(this.parent)this.parent.removeChild(this);
		}
		
	}
}