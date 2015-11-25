package road.math
{
	public function getColor(red:uint,green:uint,blue:uint):uint
	{
		return ((red & 255) << 16) | ((green & 255) << 8) | (blue & 255);
	}
}