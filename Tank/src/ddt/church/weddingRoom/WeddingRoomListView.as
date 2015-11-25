package ddt.church.weddingRoom
{
	import ddt.church.weddingRoom.frame.AddWeddingRoomFrame;
	
	import fl.controls.ScrollPolicy;
	
	import flash.events.MouseEvent;
	
	import road.data.DictionaryData;
	import road.data.DictionaryEvent;
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.HFrameButton;
	import road.ui.controls.SimpleGrid;
	import road.ui.manager.TipManager;
	import road.utils.ComponentHelper;
	
	import tank.church.AttendWeddingBGAsset;
	import ddt.data.ChurchRoomInfo;
	import ddt.utils.DisposeUtils;
	
	public class WeddingRoomListView extends AttendWeddingBGAsset
	{
		private var _controler:WeddingRoomControler;
		private var _model:WeddingRoomModel;
		
		private var _list:SimpleGrid;
		
		private var nextBtn:HBaseButton;
		private var nextMoreBtn:HBaseButton;
		private var preBtn:HBaseButton;
		private var preMoreBtn:HBaseButton;
		
		private var currentPage:int = 1;
		
		public function WeddingRoomListView(controler:WeddingRoomControler,model:WeddingRoomModel)
		{
			this._controler = controler;
			this._model = model;
			
			init();
			addEvent();
		}
		
		private function init():void
		{
			_list = new SimpleGrid(334,30,1);
			_list.verticalScrollPolicy = ScrollPolicy.OFF;
			_list.horizontalScrollPolicy = ScrollPolicy.OFF;
			_list.cellPaddingHeight = 1;
			
			ComponentHelper.replaceChild(this,list_pos,_list);
			
			nextBtn = new HFrameButton(nextBtnAsset,"");
			nextBtn.useBackgoundPos = true;
			addChild(nextBtn);
			
			nextMoreBtn = new HFrameButton(leastBtnAsset,"");
			nextMoreBtn.useBackgoundPos = true;
			addChild(nextMoreBtn);
			
			preBtn = new HFrameButton(preBtnAsset,"");
			preBtn.useBackgoundPos = true;
			addChild(preBtn);
			
			preMoreBtn = new HFrameButton(firstBtnAsset,"");
			preMoreBtn.useBackgoundPos = true;
			addChild(preMoreBtn);
			
			//TODO
			updatePageText();
			updatePageBtnEnable();
		}
		
		private function addEvent():void
		{
			nextBtn.addEventListener(MouseEvent.CLICK,__nextClick);
			nextMoreBtn.addEventListener(MouseEvent.CLICK,__nextMoreClick);
			preBtn.addEventListener(MouseEvent.CLICK,__preClick);
			preMoreBtn.addEventListener(MouseEvent.CLICK,__preMoreClick);
			
			_model.roomList.addEventListener(DictionaryEvent.ADD,__addRoomItem);
			_model.roomList.addEventListener(DictionaryEvent.REMOVE,__removeRoomItem);
			_model.roomList.addEventListener(DictionaryEvent.UPDATE,__updateRoomItem);
		}
		
		private function removeEvent():void
		{
			nextBtn.removeEventListener(MouseEvent.CLICK,__nextClick);
			nextMoreBtn.removeEventListener(MouseEvent.CLICK,__nextMoreClick);
			preBtn.removeEventListener(MouseEvent.CLICK,__preClick);
			preMoreBtn.removeEventListener(MouseEvent.CLICK,__preMoreClick);
		}
		
		private function __addRoomItem(event:DictionaryEvent):void
		{
			updatePage(currentPage);
		}
		
		private function __removeRoomItem(event:DictionaryEvent):void
		{
			updatePage(currentPage);
		}
		
		private function __updateRoomItem(event:DictionaryEvent):void
		{
			updatePage(currentPage);
		}
		
		private function __nextClick(event:MouseEvent):void
		{
			SoundManager.instance.play("008");
			updatePage(currentPage+1);
		}
		
		private function __nextMoreClick(event:MouseEvent):void
		{
			SoundManager.instance.play("008");
			updatePage(totalPage);
		}
		
		private function __preClick(event:MouseEvent):void
		{
			SoundManager.instance.play("008");
			updatePage(currentPage-1);
		}
		
		private function __preMoreClick(event:MouseEvent):void
		{
			SoundManager.instance.play("008");
			updatePage(1);
		}
		
		private function updatePage(page:int):void
		{
			if(page<1) return;
			
			var roomlist:DictionaryData = _model.roomList;
			if(roomlist.length > ((page-1) * 8))
			{
				currentPage = page;
				updatePageText();
			}else
			{
				return;
			}
			updateList();
			updatePageBtnEnable();
		}
		
		private function updatePageBtnEnable():void
		{
			currentPage = (currentPage < 1 ? 1 : currentPage)
			preBtn.enable = currentPage > 1;
			preMoreBtn.enable = preBtn.enable;

			nextBtn.enable = (totalPage - currentPage)>=1;
			nextMoreBtn.enable = nextBtn.enable;
		}
		
		public function get totalPage():int
		{
			if(currentDataList.length == 0)
			{
				return 1;
			}
			return Math.ceil(currentDataList.length/8);
		}
		
		private function updatePageText():void
		{
			if(currentPage >totalPage)
			{
				updatePage(1);
			}
			page_txt.text = currentPage+"/"+totalPage.toString();
		}

		public function updateList():void
		{
			_list.clearItems();
			if(!currentDataList)
			{
				return;
			}
			var roomlist:Array = currentDataList;
			var j:int = 0;
			for each(var i:ChurchRoomInfo in roomlist)
			{
				if(j< (currentPage-1)*8) 
				{
					j++;
					continue;
				}
				if(j> currentPage*8) break;
				
				var item:WeddingRoomListStrip = new WeddingRoomListStrip(i);
				_list.appendItem(item);
				item.addEventListener(MouseEvent.CLICK,__itemClick);
				j++;
			}
		}
		
		private function __itemClick(event:MouseEvent):void
		{
			SoundManager.instance.play("008");
			event.stopImmediatePropagation();
			var item:WeddingRoomListStrip = event.currentTarget as WeddingRoomListStrip;
			
			var joinRoomPanel:AddWeddingRoomFrame = new AddWeddingRoomFrame(_controler);
			joinRoomPanel.setRoomInfo(item.info);
			TipManager.AddTippanel(joinRoomPanel,true);
			joinRoomPanel.setFoucs();
		}

		public function get currentDataList():Array
		{
			if(_model && _model.roomList)
			{
				var arr:Array = _model.roomList.list;
				arr.sortOn("id",Array.NUMERIC);
				return arr;
			}else
			{
				return null;
			}
			
		}
		
		public function dispose():void
		{
			removeEvent();
			DisposeUtils.disposeHBaseButton(nextBtn);
			nextBtn = null;
			DisposeUtils.disposeHBaseButton(nextMoreBtn);
			nextMoreBtn = null;
			DisposeUtils.disposeHBaseButton(preBtn);
			preBtn = null;
			DisposeUtils.disposeHBaseButton(preMoreBtn);
			preMoreBtn = null;
			if(parent)parent.removeChild(this);
		}
	}
}