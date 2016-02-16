package ddt.roomlist
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.EatPropAsset;
	import game.crazyTank.view.roomlistII.TipFrameAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HCheckBox;
	import road.ui.controls.LabelField;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.ui.controls.hframe.HTipFrame;
	
	import ddt.data.SimpleRoomInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.SocketManager;
	import ddt.manager.StateManager;
	import ddt.states.StateType;

	public class RoomListIIFindRoomPanel extends HConfirmFrame
	{
		private var _model:IRoomListIIModel;
		private var _controller:IRoomListIIController;
		private var _text:LabelField;
		private var _asset:TipFrameAsset;
		private var _pass_check:HCheckBox;
		public function RoomListIIFindRoomPanel(controller:IRoomListIIController,model:IRoomListIIModel)
		{
			_model = model;
			_controller = controller;
			init()
			addEvent();
		}
		
		private function init():void
		{
			blackGound = false;
			alphaGound = false;
			this.showCancel = true;
			this.showClose  = true;
			_asset = new TipFrameAsset();
			_asset.id_input.restrict = "0-9";
			_asset.pass_input.displayAsPassword = true;
			addContent(_asset);
			_asset.pos_password.visible = false;
			_pass_check = new HCheckBox("");
			_pass_check.x = _asset.pos_password.x + 10;
			_pass_check.y = _asset.pos_password.y + 35;
			_pass_check.fireAuto = true;
			_pass_check.buttonMode= true;
			addChild(_pass_check);
			titleText = LanguageMgr.GetTranslation("ddt.roomlist.RoomListIIFindRoomPanel.search");
			setContentSize(260,105);
			okFunction = __okClick;
			cancelFunction = __cancelClick;
			_asset.tbx_password.visible = true;
			_asset.pass_input.visible = false;
		}
		
		private function addEvent():void
		{
			okFunction = __okClick;
			cancelFunction = __cancelClick;
			_asset.pass_mc.addEventListener(MouseEvent.CLICK,__checkChange,false,0,true);
			_pass_check.addEventListener(Event.CHANGE,__checkChange,false,0,true);
			addEventListener(Event.ADDED_TO_STAGE , __addStage);
		}
		
		private function __addStage(evt:Event):void
		{
			if(_asset && _asset.id_input)
			{
				this.stage.focus = _asset.id_input;
			}
		}
		
		private function __checkChange(evt:Event):void
		{
			SoundManager.Instance.play("008");
			if(evt.type == "click" )
			{
				_asset.pass_input.visible = _asset.pass_input.visible  ? false : true ;
				_pass_check.selected = _pass_check.selected ? false : true;
			}
			if(_pass_check.selected)
			{
				_asset.tbx_password.visible = false;
				_asset.pass_input.visible = true;
				_asset.pass_input.text = "";
				this.stage.focus = _asset.pass_input;
			}
			else
			{
				_asset.tbx_password.visible = true;
				_asset.pass_input.visible = false;
				this.stage.focus = _asset.id_input;
			}
		}
		
		private function removeEvent():void
		{
			okFunction = null;
			cancelFunction = null;
		}
		
		override protected function __addToStage(evt:Event):void
		{
			super.__addToStage(evt);

		}
		
		private function __okClick(evt:Event = null):void
		{
			if(stage)
			{
				if(_asset.id_input.text == "")
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.roomlist.RoomListIIFindRoomPanel.id"));
					return;
				}
				if(StateManager.currentStateType == StateType.DUNGEON)
				{
					SocketManager.Instance.out.sendGameLogin(2,-1,int(_asset.id_input.text),_asset.pass_input.text);
				}else
				{
					SocketManager.Instance.out.sendGameLogin(1,-1,int(_asset.id_input.text),_asset.pass_input.text);
				}
			}
		}
		

		private function checkRoomExist(id:int):SimpleRoomInfo
		{
			for each(var room:SimpleRoomInfo in _model.getRoomList())
			{
				if ( room != null )
				{
					if(room.ID == id)
					{
						return room;
					}
				}
			}
			return null;
		}
		
		private function __cancelClick(evt:MouseEvent = null):void
		{
			removeEvent();
			close();
			dispose();
		}
		
		override public function dispose():void
		{
			super.dispose();
			_model = null;
			_controller = null;
			close();
			removeEventListener(Event.ADDED_TO_STAGE , __addStage);
		}
	}
}