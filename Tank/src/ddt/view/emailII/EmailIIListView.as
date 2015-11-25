package ddt.view.emailII
{
	import flash.events.Event;
	
	import road.ui.controls.SimpleGrid;
	
	import ddt.data.EmailInfo;
	import ddt.manager.LanguageMgr;

	public class EmailIIListView extends SimpleGrid
	{
		private var _strips:Array;
		
		public function EmailIIListView(cellWidth:uint=300, cellHeight:uint=47, column:uint=1)
		{
			super(cellWidth, cellHeight, column);
			initView();
			addEvent();
		}
		
		private function initView():void
		{
			_strips = new Array();
			verticalScrollPolicy = "off";
		}
		
		private function addEvent():void{}
		
		private function removeEvent():void{}
		
		internal function dispose():void
		{
			removeEvent();
			clearElements();
		}
		/**
		 * 更新列表 
		 * @param emails
		 * 
		 */		
		internal function update(emails:Array,isSendedMail:Boolean = false):void
		{
			clearItems();
			clearElements();
			for(var i:uint = 0; i < emails.length; i ++)
			{
				var strip:EmailIIStrip;
				
				if(isSendedMail)
				{
					strip = new EmailIIStripSended();
				}else
				{
					strip = new EmailIIStrip();
				}
				strip.addEventListener(EmailIIStrip.SELECT,__select);
				strip.info = emails[i] as EmailInfo;
				//防止本过期，却显示未过期的情况出现
				if(strip.info.Title == LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionCellView.Object") && strip.info.Type == 9) { 
					if(strip.info.Annex1) {
						strip.info.Annex1.ValidDate = -1;
					}
				}
				appendItem(strip);
				
				_strips.push(strip);
			}
		}
		
		/**
		 * 全选 / 全非选
		 * @param info
		 * 
		 */
		public function switchSeleted():void
		{
			if(allHasSelected())
			{
				changeAll(false);
				return;
			}
			changeAll(true);
		}
		
		/**
		 * 是否全选 
		 * @param info
		 * 
		 */
		private function allHasSelected():Boolean
		{
			for(var i:uint = 0;i<_strips.length;i++)
			{
				if(!EmailIIStrip(_strips[i]).selected)
				{
					return false;
				}
			}
			return true;
		}
		/**
		 * 更改所有邮件状态 
		 * @param value
		 */		
		private function changeAll(value:Boolean):void
		{
			for(var i:uint = 0;i<_strips.length;i++)
			{
				EmailIIStrip(_strips[i]).selected = value;
			}
		}
		/**
		 * 获取所有选中的邮件 
		 * @param info
		 */		
		public function getSelectedMails():Array
		{
			var tempArr:Array = [];
			
			for(var i:uint = 0;i<_strips.length;i++)
			{
				if(EmailIIStrip(_strips[i]).selected)
				{
					tempArr.push(EmailIIStrip(_strips[i]).info);
				}
			}
			
			return tempArr;
		}
			
		internal function updateInfo(info:EmailInfo):void
		{
			if(info == null) return;
			for each(var strip:EmailIIStrip in _strips)
			{
				if(info == strip.info)
				{
					strip.info = info;
					break;
				}
			}
		}
		
		private function clearElements():void
		{
			for each(var strip:EmailIIStrip in _strips)
			{
				strip.removeEventListener(EmailIIStrip.SELECT,__select);
				strip.dispose();
			}
			_strips = new Array();
		}
		
		private function __select(event:Event):void
		{
			var strip:EmailIIStrip = event.target as EmailIIStrip;
			for each(var i:EmailIIStrip in _strips)
			{
				if(i == strip)
				{
					continue;
				}else
				{
					i.isReading = false;
				}
			}
		}

		internal function canChangePage() : Boolean
		{
			for each(var i:EmailIIStrip in _strips)
			{
				if(i.emptyItem)
				return false;
			}
			return true;
		}
		
	}
}