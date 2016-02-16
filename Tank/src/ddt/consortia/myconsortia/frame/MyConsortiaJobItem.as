package ddt.consortia.myconsortia.frame
{
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	
	import road.manager.SoundManager;
	import road.utils.StringHelper;
	
	import tank.consortia.accect.MyConsortiaJobItemAsset;
	import ddt.consortia.data.ConsortiaDutyInfo;
	import ddt.consortia.event.ConsortiaDataEvent;
	import ddt.manager.FilterWordManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.SocketManager;

	public class MyConsortiaJobItem extends MyConsortiaJobItemAsset
	{
//		private var _ejiggerBtn : HBaseButton;
		private var _index      : int;
		private var _info       : ConsortiaDutyInfo;
		private var _jobName    : String;
		private var _nameItems  : Array;
		public function MyConsortiaJobItem()
		{
			super();
			init();
			addEvent();
		}
		private function init() : void
		{
			this.selectAsset.alpha = 0;
			ejiggerBtn.buttonMode = true;
			ejiggerBtn.gotoAndStop(1);
			this.txtBg.alpha = 0;
			this.buttonMode = true;
			addChildAt(txtBg,this.numChildren);
			
		}
		public function addEvent() : void
		{
			this.jobNameTxt.addEventListener(TextEvent.TEXT_INPUT, __textInputHandler);
			ejiggerBtn.addEventListener(MouseEvent.CLICK,     __ejiggerClickHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,        __mouseOutHandler);
			this.addEventListener(MouseEvent.MOUSE_OVER,       __mouseOverHandler);
			this.addEventListener(MouseEvent.CLICK,            __mouseClickHandler);
		}
		public function removeEvent() : void
		{
			this.jobNameTxt.removeEventListener(TextEvent.TEXT_INPUT, __textInputHandler);
			ejiggerBtn.removeEventListener(MouseEvent.CLICK,     __ejiggerClickHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT,        __mouseOutHandler);
			this.removeEventListener(MouseEvent.MOUSE_OVER,       __mouseOverHandler);
			this.removeEventListener(MouseEvent.CLICK,            __mouseClickHandler);
		}
		public function set info(i : ConsortiaDutyInfo) : void
		{
			this._info = i;
			upView();
		}
		public function get info() : ConsortiaDutyInfo
		{
			return this._info;
		}
		public function defaultStatus() : void
		{
			this.txtBg.alpha = 0;
			ejiggerBtn.gotoAndStop(1);
			this.selectAsset.alpha = 0;
			addChildAt(txtBg,this.numChildren);
			_isSelect = false; 
			this.jobNameTxt.stage.focus = null;
			upView();
		}
		
		public function set nameItems($list : Array) : void
		{
			this._nameItems = $list;
		}
		
		private function upView() : void
		{
			this.jobNameTxt.text = _info.DutyName;
		
		}
		private function __mouseOverHandler(evt : MouseEvent) : void
		{
			this.selectAsset.alpha = 1;
		}
		private function __mouseOutHandler(evt : MouseEvent) : void
		{
			if(_isSelect)
			{
				this.selectAsset.alpha = 1;
			}
			else
			{
				this.selectAsset.alpha = 0;
			}
			
		}
		private var _isSelect : Boolean = false;
		private function __textInputHandler(evt : TextEvent) : void
		{
			StringHelper.checkTextFieldLength(this.jobNameTxt,8);
		}
		
		
		private function __ejiggerClickHandler(evt : MouseEvent) : void
		{
			
	    	SoundManager.Instance.play("008");
			evt.stopPropagation();
			if(ejiggerBtn.currentFrame == 1)
			{
				ejiggerBtn.gotoAndStop(2);
				this.txtBg.alpha = 1;
				addChildAt(txtBg,0);
				this.jobNameTxt.stage.focus = this.jobNameTxt;
				
			}
			else
			{
				ejiggerBtn.gotoAndStop(1);
				this.txtBg.alpha = 0;
				addChildAt(txtBg,this.numChildren);
				sendUpData();
			}
			_isSelect = true;
			this.dispatchEvent(new ConsortiaDataEvent(ConsortiaDataEvent.SELECT_CLICK_ITEM,this));
			
		}
		private function __mouseClickHandler(evt : MouseEvent) : void
		{
			evt.stopPropagation();
			SoundManager.Instance.play("008");
			selectItem();
		}
		public function selectItem() : void
		{
			_isSelect = true;
			this.selectAsset.alpha = 1;
			this.dispatchEvent(new ConsortiaDataEvent(ConsortiaDataEvent.SELECT_CLICK_ITEM,this));
		}
		private function sendUpData() : void
		{
			if(upText != "")
			SocketManager.Instance.out.sendConsortiaUpdateDuty(info.DutyID,_jobName,info.Level);
			
			
		}
		public function get upText() : String
		{
			_jobName = StringHelper.trim(this.jobNameTxt.text);
			if(_jobName == "")
			MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaJobItem.null"));
			//MessageTipManager.getInstance().show("名称不能为空!");
			if(_jobName == _info.DutyName)
			{
//				MessageTipManager.getInstance().show("您没有更改名字");
				return "";
			}
			for(var i:int=0;i<this._nameItems.length;i++)
			{
				if(this._nameItems[i] == _jobName)
				{
					this.jobNameTxt.text = _info.DutyName;
					jobNameTxt.setSelection(0,jobNameTxt.text.length);
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaJobItem.diffrent"));
					//MessageTipManager.getInstance().show("不同权限的职位名不能相同");
					return "";
				}
			}
			if(FilterWordManager.isGotForbiddenWords(jobNameTxt.text.toString()))
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaJobItem.duty"));
				//MessageTipManager.getInstance().show("职位名含非法字符!");
				return "";
			}
			return _jobName;
		}
		public function dispose() : void
		{
			_info = null;
			removeEvent();
			if(this.parent)this.parent.removeChild(this);
		}
		
		public function set index(i : int) : void
		{
			_index = i;
		}
		public function get index() : int
		{
			return _index;
		}
		
	}
}