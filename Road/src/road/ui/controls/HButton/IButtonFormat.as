package road.ui.controls.HButton
{
	public interface IButtonFormat
	{
		function setOverFormat(b:HBaseButton):void;
		function setUpFormat(b:HBaseButton):void;
		function setDownFormat(b:HBaseButton):void;
		function setOutFormat(b:HBaseButton):void;
		function setEnable(b:HBaseButton):void;
		function setNotEnable(b:HBaseButton):void;
		function dispose():void;
	}
}