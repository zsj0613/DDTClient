package ddt.serverlist
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import game.crazyTank.view.ServerAsset;
	
	import road.ui.controls.ISelectable;
	
	import ddt.data.ServerInfo;
	import ddt.view.SimpleSelectableButton;

	public class ServerStrip extends ServerAsset implements ISelectable
	{
		private var _info:ServerInfo;
		private var barMask:Sprite;
		
		public function get info():ServerInfo
		{
			return _info;
		}
		
		private var _back:SimpleSelectableButton;
		
		private function initView() : void
		{
//			this.addEventListener(MouseEvent.MOUSE_OVER, __over);
//			this.addEventListener(MouseEvent.MOUSE_OUT, __out);
		}
		/**
		 * 
		 * 服务器状态 : 2　低　3　中　4　高　1　维护　5　负载
		 */		
		public function ServerStrip(info:ServerInfo,id:int)
		{
			var severName : String = info.Name ? info.Name : "";
			var i : int = severName.indexOf("(");
			i = i == -1 ? severName.length : i;
			name_txt.autoSize = TextFieldAutoSize.LEFT;
			name_txt.text = severName.substr(0,i);
			name_txt.mouseEnabled = false;
			
			
			level_txt.text = severName.substr(i);
			level_txt.x = name_txt.x + name_txt.textWidth + 10;
			level_txt.mouseEnabled = false;
			level_txt.selectable = false;
			
			index.text = String(id);
			index.mouseEnabled = false;
			_info = info;
			state_mc.mouseEnabled = false;
			buttonMode = true;
			doubleClickEnabled = true;
			_back = new SimpleSelectableButton(back_mc);
			addChildAt(_back,0);
			
			switch(_info.State)
			{
				case 1:
				state_mc.gotoAndStop(_info.State);
				setLength(0);
				break;
				case 2:
				state_mc.gotoAndStop(_info.State);
				setLength(0.5);
				break;
				case 5:
				state_mc.gotoAndStop(4);
				setLength(1)
				break;
				case 3:
				state_mc.gotoAndStop(3);
				setLength(0.75)
				break;
				case 4:
				state_mc.gotoAndStop(3);
				setLength(0.75)
				break;
			}
			stateBar_mc.mouseChildren = false;
			stateBar_mc.mouseEnabled = false;
			//state_mc.gotoAndStop(_info.State);
		}
		
		private function setLength(value:Number):void {
			if(barMask) {
				barMask.parent.removeChild(barMask);
				barMask = null;
			}
			barMask = new Sprite();
			barMask.graphics.beginFill(0x000000);
			barMask.graphics.drawRoundRectComplex(0,0,stateBar_mc.width * value, stateBar_mc.height,0,8,0,8);
			barMask.graphics.endFill();
			barMask.x = stateBar_mc.x;
			barMask.y = stateBar_mc.y;
			stateBar_mc.mask = barMask;
			stateBar_mc.parent.addChild(barMask);
		}

		public function set selected(value:Boolean):void
		{
			_back.selected = value;
		}
		
		public function get selected():Boolean
		{
			return _back.selected;
		}

	}
}