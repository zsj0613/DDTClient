package ddt.auctionHouse.view
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import game.crazyTank.view.AuctionHouse.StripAsset;
	
	import road.manager.SoundManager;
	import road.utils.StringHelper;
	
	import ddt.auctionHouse.event.AuctionHouseEvent;
	import ddt.data.auctionHouse.AuctionGoodsInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.manager.LanguageMgr;

	[Event(name = "selectStrip",type = "ddt.auctionHouse.event.AuctionHouseEvent")]
	internal class BaseStripView extends StripAsset
	{
		protected var _info:AuctionGoodsInfo;
		protected var _state : int;//0,正常 状态。1，清空状态
		internal function get info():AuctionGoodsInfo
		{
			return _info;
		}
		internal function set info(value:AuctionGoodsInfo):void
		{
			_info = value;
			update();
			updateInfo();
		}
		
		private var _isSelect:Boolean;
		internal function get isSelect():Boolean{
			return _isSelect;
		}
		internal function set isSelect(value:Boolean):void{
			_isSelect = value;
			if(_state != 1)update();
			
			
		}
		
		private var _cell:AuctionCellViewII;
		
		protected var _name:TextField;
		
		protected var _count:TextField;
		
		protected var _leftTime:TextField;
		
		private var _cleared:Boolean;
		
		public function BaseStripView()
		{
			initView();
			addEvent();
		}
		
		protected function initView():void
		{
			_cleared = false;
			buttonMode = true
			stripSelect_mc.visible = false;
		
			_name = createText();
			addChild(_name);
			_count = createText();
			addChild(_count);
			_leftTime = createText();
			addChild(_leftTime);
			
			_cell = new AuctionCellViewII();
			_cell.x = goodPos_mc.x-1;
			_cell.y = goodPos_mc.y;
			_cell.width = goodPos_mc.width;
			_cell.height = goodPos_mc.height;
			goodPos_mc.visible = false;
			addChild(_cell);
//			ComponentHelper.replaceChild(this,goodPos_mc,_cell);
			
		}
		
		
		protected function updateInfo():void
		{
			removeEvent();
			_cell.info = _info.BagItemInfo as ItemTemplateInfo;
			_name.text = _cell.info.Name;
			_cell.allowDrag = false;
			_count.text = _info.BagItemInfo.Count.toString();
			_leftTime.text = _info.getTimeDescription();
			_leftTime.htmlText = "<a href='event:#'>"+StringHelper.rePlaceHtmlTextField(_info.getTimeDescription())+"</a>";
			this.addChild(_cell);
//			goodPos_mc.visible = true;
//			this.stripSelect_mc.visible = true;
			this.mouseEnabled = true;
			this.buttonMode = true;
			addEvent();
			
		}
		
		private function addEvent():void
		{
			addEventListener(MouseEvent.MOUSE_OVER,__over);
			addEventListener(MouseEvent.MOUSE_OUT,__out);
			addEventListener(MouseEvent.CLICK,__click);
		}
		private function removeEvent() : void
		{
			removeEventListener(MouseEvent.MOUSE_OVER,__over);
			removeEventListener(MouseEvent.MOUSE_OUT,__out);
//			removeEventListener(MouseEvent.CLICK,__click);
		}
		
	
		internal function clearSelectStrip() : void
		{
			_cleared = true;
			removeEvent();
			_name.text = "";
			_count.text = "";
			_leftTime.text = "";
			if(_cell && _cell.parent)_cell.parent.removeChild(_cell);
//			_cell.dispose();
	//		if(stripSelect_mc.parent)stripSelect_mc.parent.removeChild(stripSelect_mc);
			if(goodPos_mc.parent)goodPos_mc.parent.removeChild(goodPos_mc);
			this.mouseEnabled = false;
			this.buttonMode = false;
			this.mouseChildren = false;
			if(hot_btn.parent)hot_btn.parent.removeChild(hot_btn);
			stripSelect_mc.visible = false;
			_isSelect = false
			_state = 1;
		}
		
		private function update():void
		{
			if(_cleared){
				initView();
				addEvent();
			}
			if(_isSelect)
			{
				stripSelect_mc.visible = true;
			}
			else
			{
				stripSelect_mc.visible = false;
			}	
		}
		
		protected function createText(x:int = 0,y:int = 19):TextField
		{
			var format:TextFormat = new TextFormat();
			
			format.font = LanguageMgr.GetTranslation("Arial");
			//format.font = "宋体";
			format.size = 14;
			format.color = 0xffffff;
			format.bold = true;
			var txt:TextField = new TextField();
			txt.defaultTextFormat = format;
			txt.selectable = false;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.x = x;
			txt.y = y;
			txt.mouseEnabled = false;
			return txt;
		}
		
		internal function dispose():void
		{
			removeEventListener(MouseEvent.MOUSE_OVER,__over);
			removeEventListener(MouseEvent.MOUSE_OUT,__out);
			removeEventListener(MouseEvent.CLICK,__click);
			_info = null;
			if(_cell && _cell.parent)_cell.parent.removeChild(_cell);
			if(_cell)_cell.dispose();
			_cell = null;
			
			if(_name &&  _name.parent)_name.parent.removeChild(_name);
			_name = null;
			if(_count && _count.parent)_count.parent.removeChild(_count);
			_count = null;
			if(_leftTime && _leftTime.parent)_leftTime.parent.removeChild(_leftTime);
			_leftTime = null;
			if(this.parent)this.parent.removeChild(this);
		}
		
		private function __over(event:MouseEvent):void
		{
			if(_isSelect)
			{	
				return;
			}
			else
			{
				stripSelect_mc.visible = true;
			}
			
		}
		
		private function __out(event:MouseEvent):void
		{
			if(_isSelect)
			{
				return;
			}
			else
			{
				stripSelect_mc.visible = false;
			}
		}
		
		private function __click(event:MouseEvent):void
		{
			if(!_isSelect)	
			{
				SoundManager.Instance.play("047");
				dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.SELECT_STRIP));
			}
			isSelect = true;	
		}
		
	}
}