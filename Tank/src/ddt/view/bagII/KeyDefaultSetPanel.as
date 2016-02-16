package ddt.view.bagII
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.bagII.KeyDefaultSetBgAccect;
	
	import road.manager.SoundManager;
	
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.manager.ItemManager;
	import ddt.manager.SharedManager;
	import ddt.view.items.ItemEvent;
	import ddt.view.items.PropItemView;
	public class KeyDefaultSetPanel extends KeyDefaultSetBgAccect
	{
		private var alphaClickArea:Sprite;
		private var _icon:Array;
		public var selectedItemID:int = 0;
		
		public function KeyDefaultSetPanel()
		{
			initView();
		}
	
		private function initView():void
		{
			addEventListener(Event.ADDED_TO_STAGE,__addToStage);
			addEventListener(Event.REMOVED_FROM_STAGE,__removeToStage);
			alphaClickArea = new Sprite();
			
			_icon = [];
			var sets:Array = SharedManager.KEY_SET_ABLE;
			for(var i:int = 0;i<sets.length;i++)
			{
				var temp:ItemTemplateInfo = ItemManager.Instance.getTemplateById(sets[i]);
				if(temp)
				{
					var icon:KeySetItem = new KeySetItem(sets[i],PropItemView.createView(temp.Pic,40,40));
					icon.addEventListener(ItemEvent.ITEM_CLICK,onItemClick);
					icon.x = this["set"+String(i+1)].x;
					icon.y = this["set"+String(i+1)].y;
					icon.setClick(true,false,true);
					this["set"+String(i+1)].visible = false;
					icon.height = icon.width = 36;
					icon.setBackgroundVisible(false);
					addChild(icon);
					_icon.push(icon);
				}
			}
		}
		
		private function __addToStage(e:Event):void
		{
			alphaClickArea.graphics.beginFill(0xff00ff,0);
			alphaClickArea.graphics.drawRect(-3000,-3000,6000,6000);
			addChildAt(alphaClickArea,0);
			alphaClickArea.addEventListener(MouseEvent.CLICK,clickHide);
		}
		
		private function __removeToStage(e:Event):void
		{
			alphaClickArea.graphics.clear();
			alphaClickArea.removeEventListener(MouseEvent.CLICK,clickHide);
		}
		
		
		private function clickHide(e:MouseEvent):void
		{
			hide();
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		public function dispose():void
		{
			removeEventListener(Event.ADDED_TO_STAGE,__addToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE,__removeToStage);
			
			while(_icon.length > 0)
			{
				var icon:KeySetItem = _icon.shift() as KeySetItem;
				if(icon)
				{
					icon.removeEventListener(ItemEvent.ITEM_CLICK,onItemClick);
					icon.dispose();
				}
				icon = null;
			}
			_icon = null;
			
			if(alphaClickArea)
			{
				alphaClickArea.removeEventListener(MouseEvent.CLICK,clickHide);
				alphaClickArea.graphics.clear();
				if(alphaClickArea.parent)
				{
					alphaClickArea.parent.removeChild(alphaClickArea);
				}
			}
			alphaClickArea = null;
			
			if(parent) parent.removeChild(this);
		}
		
		private function onItemClick(e:ItemEvent):void
		{
			SoundManager.Instance.play("008");
			
			selectedItemID = e.index;
			hide();
			dispatchEvent(new Event(Event.SELECT));
		}

	}
}