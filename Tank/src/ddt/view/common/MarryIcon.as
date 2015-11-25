package ddt.view.common
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import road.BitmapUtil.ScaleBitmap;
	import road.ui.controls.hframe.bitmap.BlackTipBG;
	import road.ui.manager.TipManager;
	
	import tank.church.MarryIconAsset;
	import tank.church.MarryIconTipAsset;
	import ddt.data.player.PlayerInfo;
	import ddt.manager.LanguageMgr;
	
	public class MarryIcon extends Sprite
	{
		private var _info:PlayerInfo;
		private var _icon:MarryIconAsset;
		
		private var _tip:Sprite;
		
		private var _bg:ScaleBitmap;
		private var _label:MarryIconTipAsset;
		
		public function MarryIcon(info:PlayerInfo)
		{
			this._info = info;
			init();
			addEvent();
		}
		
		private function init():void
		{
			_icon = new MarryIconAsset();
			addChild(_icon);
			
			_bg = new BlackTipBG();
			_bg.height = 25;
		
			_label = new MarryIconTipAsset();
			_label.name_txt.text = _info.SpouseName?_info.SpouseName:"";
			_label.name_txt.autoSize = TextFieldAutoSize.LEFT;
			_label.nameSub_txt.text = _info.Sex ? LanguageMgr.GetTranslation("MarryIcon.hubby") : LanguageMgr.GetTranslation("MarryIcon.wife");
			//_label.nameSub_txt.text = _info.Sex ? "的老公" : "的老婆";
			_label.nameSub_txt.autoSize = TextFieldAutoSize.LEFT;
			_label.nameSub_txt.x = _label.name_txt.x +_label.name_txt.width+2;

			_label.nameSub_txt.setTextFormat(new TextFormat("Arial",16,0xffffff,true));
			
			_tip = new Sprite();
			_tip.addChild(_bg);
			_tip.addChild(_label);
			
			setCenter();
		}
		
		private function addEvent():void
		{
			_icon.addEventListener(MouseEvent.MOUSE_OVER,__showTip);
			_icon.addEventListener(MouseEvent.MOUSE_OUT,__hideTip);
		}
		
		private function removeEvent():void
		{
			_icon.removeEventListener(MouseEvent.MOUSE_OVER,__showTip);
			_icon.removeEventListener(MouseEvent.MOUSE_OUT,__hideTip);
		}
		
		private function setCenter():void
		{
			_bg.width = _label.width+10;
			_label.x = 5;
			_label.y = (_bg.height - _label.height)/2;
			
			_tip.x = _icon.x + 15;
			_tip.y = _icon.y + 15;
			addChild(_tip);
			
			_tip.visible = false;                    
			TipManager.setCurrentTarget(null,_tip);  //bret 09.8.21
		}
		
		public function dispose ():void
		{
			removeEvent();
			_info = null;
			_tip = null;
			_bg.bitmapData.dispose();
			_bg = null;
			if(parent) parent.removeChild(this);
			
		}
		
		
		private function __showTip(event:MouseEvent):void
		{
			_tip.visible = true;                    
			TipManager.setCurrentTarget(_icon,_tip);//bret 09.8.21
		}
		
		private function __hideTip(event:MouseEvent):void
		{
			_tip.visible = false;                  
			TipManager.setCurrentTarget(null,_tip);//bret 09.8.21
		}
	}
}