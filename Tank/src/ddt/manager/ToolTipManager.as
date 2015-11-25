package ddt.manager
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import ddt.view.common.Tooltip;
	
	
	public class ToolTipManager
	{
		private static var tipTar:Array = [];
		private static var currentTipTar:DisplayObject;
		private static var registerPoint:Point;
		private static var offPoint:Point;
		public function ToolTipManager()
		{
			super();
		}
		
		public static function addTip(tar:DisplayObject,msg:String,offsetPoint:Point = null):void
		{
			tipTar.push({target:tar,message:msg,point:offsetPoint});
			tar.addEventListener(MouseEvent.ROLL_OVER,popUp);
			tar.addEventListener(MouseEvent.ROLL_OUT,popDown);
		}
		
		public static function removeTip(tar:DisplayObject):void
		{
			for(var i:uint = 0;i<tipTar.length;i++){
				if(tipTar[i].target == tar){
					tipTar[i].target.removeEventListener(MouseEvent.ROLL_OVER,popUp);
					tipTar[i].target.removeEventListener(MouseEvent.ROLL_OUT,popDown);
					tipTar.splice(i,1);
				}
				
			}
		}
		
		private static function popUp(e:MouseEvent):void
		{
			currentTipTar = e.target as DisplayObject;
			
			for(var i:uint = 0;i<tipTar.length;i++){
				if(tipTar[i].target == currentTipTar){
					Tooltip.Instance.refresh(tipTar[i].target,tipTar[i].message);
					offPoint = tipTar[i].point;
					Tooltip.Instance.show();
					tipTar[i].target.stage.addEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
					moveHandler(e);
				}
				
			}
		}
		
		private static function popDown(e:MouseEvent):void
		{
			for(var i:uint = 0;i<tipTar.length;i++){
				if(tipTar[i].target == e.target){
					Tooltip.Instance.hide();
					tipTar[i].target.stage.removeEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
				}
			}
		}
		
		private static function moveHandler(e:MouseEvent):void
		{
			registerPoint = currentTipTar.parent.localToGlobal(new Point(currentTipTar.x,currentTipTar.y));
			Tooltip.Instance.x = e.localX+registerPoint.x+offPoint.x;
			Tooltip.Instance.y = e.localY+registerPoint.y+offPoint.y;
		}
	}
}