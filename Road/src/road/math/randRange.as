package road.math
{
	public function randRange(min:Number, max:Number):Number
    {
        return Math.random() * (max - min) + min;
    }
}