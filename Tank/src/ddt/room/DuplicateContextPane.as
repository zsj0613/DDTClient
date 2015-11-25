package ddt.room
{
	import fl.controls.BaseButton;
	import fl.controls.TextArea;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	
	import game.crazyTank.view.roomII.DuplicateContextAsset;
	
	import road.utils.ComponentHelper;
	
	import ddt.manager.LanguageMgr;
	
	public class DuplicateContextPane extends DuplicateContextAsset
	{
		private var _text    : TextArea;
		private var _shape   : Shape;
		private var _context : String= LanguageMgr.GetTranslation("ddt.room.RoomMapSetPanelDuplicate.choiceMap");
		public function DuplicateContextPane()
		{
			super();
			_text = new TextArea();
			_text.horizontalScrollPolicy = "off";
			_text.verticalScrollPolicy = "on";
			_text.setStyle("upSkin",new Sprite());
			_text.setStyle("disabledSkin",new Sprite());
			var format:TextFormat = new TextFormat();
			format.font = "Arial";
			format.size = 16;
			format.color = 0xfed700;
			format.bold  = true;
			format.leading = 4;
			_text.setStyle("disabledTextFormat",format);
			_text.setStyle("textFormat",format);
			_text.setSize(270,180);
			_text.editable = false;
			_text.textField.defaultTextFormat = new TextFormat("Arial",16,0xfed700);
			_text.textField.filters = [new GlowFilter(0x000000,1,2,2,10)];
			
			ComponentHelper.replaceChild(affiche_mc.afficheBoard_mc,affiche_mc.afficheBoard_mc.explainTxt_mc,_text);
			addEventListener(MouseEvent.CLICK , __duplicateContextClick);
			
			_shape=  new Shape();
			_shape.graphics.beginFill(0);
			_shape.graphics.drawRect(-7,0,310,390);
			_shape.graphics.endFill();
			affiche_mc.addChild(_shape);
			affiche_mc.afficheBoard_mc.mask = _shape;
		} 
	
		private function __duplicateContextClick(evt:Event):void
		{
			if(this.affiche_mc.currentFrame == 19 && !(evt.target is BaseButton) && (evt.target.name != "pos_1") && (evt.target.name != "pos_2"))
			{
				this.affiche_mc.gotoAndPlay("out");
			}
		}
		
		public function switchPane() : void
		{
			if(affiche_mc.currentFrame == 19)
			{
				affiche_mc.gotoAndPlay("out");
			}
			else if(affiche_mc.currentFrame == 1)
			{
				affiche_mc.gotoAndPlay("in");
				affiche_mc.addEventListener(Event.ENTER_FRAME, __enterFrameHandler);
			}
			this.visible = true;
		}
		
		private function __enterFrameHandler(evt :Event) : void
		{
			if(affiche_mc && affiche_mc.currentFrame > 5)
			{
				_text.textField.text = _context;
				affiche_mc.removeEventListener(Event.ENTER_FRAME, __enterFrameHandler);
				_text.setSize(270,180);
			}
			
		}
		public function set context(msg : String) : void
		{
			_context = msg;
			_text.textField.text = msg;
		}
		public function dispose() : void
		{
			if(affiche_mc)
				affiche_mc.removeEventListener(Event.ENTER_FRAME, __enterFrameHandler);
			removeEventListener(MouseEvent.CLICK , __duplicateContextClick);
			
			if(_text && _text.parent)
			{
				_text.parent.removeChild(_text);
			}
			_text = null;
			
			if(_shape && _shape.parent)
			{
				_shape.graphics.clear();
				_shape.parent.removeChild(_shape);
			}
			_shape = null;
			
			affiche_mc = null;
			
			if(this.parent)this.parent.removeChild(this);
			
		}

	}
}