package ddt.view.common
{
	import fl.containers.ScrollPane;
	import fl.controls.ScrollPolicy;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.roomII.DuplicatePreviewAsset;
	
	import road.ui.controls.SimpleGrid;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.ui.manager.TipManager;
	import road.ui.manager.UIManager;
	
	import ddt.manager.LanguageMgr;
	
	public class DuplicatePreview extends HConfirmFrame
	{
		private var _title:String;
		private var _displaycontent:DisplayObject;
		private var _panel:ScrollPane;
		private var __width:Number;
		private var __height:Number;
		
		public function DuplicatePreview(displaycontent:DisplayObject = null , title:String = null, width:Number=420, height:Number=525)
		{
			if(displaycontent)
			{
				_title = title;
				_displaycontent = displaycontent;
			}
			__width=width;
			__height=height;
			setSize(__width, __height);
			init();
		}
		
		private function init():void
		{
			showCancel=false;
			autoDispose = true;
			IsSetFouse=true;
			moveEnable = false;
			titleText = _title;
			
			_panel=new ScrollPane();
			var myBg:Shape = new Shape();
			myBg.graphics.beginFill(0x000000,0);
			myBg.graphics.drawRect(0,0,10,10);
			myBg.graphics.endFill();
			_panel.setStyle("upSkin",myBg);
			_panel.width=this.width-30;
			_panel.height=this.height-85;
			_panel.x=(this.width-_panel.width)/2;
			_panel.y=((this.height-81)-_panel.height)/2+33;//81=对话框标题高度+对话框底部确认条高度；33=对话框标题高度
			if(_panel.width>_displaycontent.width)
			{
				_panel.x+=(_panel.width-_displaycontent.width)/2;
			}
			if(_panel.height>_displaycontent.height)
			{
				_panel.y+=(_panel.height-_displaycontent.height)/2;
			}
			else
			{
				_panel.x-=10;
			}
			_panel.horizontalScrollPolicy = ScrollPolicy.OFF;
			_panel.source=_displaycontent;
		}
		
		override public function show():void
		{
			alphaGound = false;
			TipManager.AddTippanel(this, true);
			addChild(_panel);
			alphaGound = true;
		}
		
		override protected function __closeClick(e:MouseEvent):void
		{
			if(cancelFunction != null) cancelFunction();
			super.__closeClick(e);
		}
		
		override public function dispose():void
		{
			if(_displaycontent && _displaycontent.parent)
			{
				_displaycontent.parent.removeChild(_displaycontent);
			}
			_displaycontent = null;
			if(_panel && _panel.parent)
			{
				_panel.source=null;
				_panel.parent.removeChild(_panel);
			}
			_panel=null;
			super.dispose();
		}
	}
}