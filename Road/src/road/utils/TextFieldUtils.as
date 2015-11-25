package road.utils
{
	import flash.text.TextField;
	
	public class TextFieldUtils
	{
		public static function enabledTextField(txt : TextField):void
		{
			txt.mouseEnabled = false;
			txt.selectable   = false;
			txt.text         = "";
		}

	}
}