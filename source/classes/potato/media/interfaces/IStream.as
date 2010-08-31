package potato.media.interfaces
{
	public interface IStream
	{
		function load(url:String):void;
		
		function close():void;
		
		function get bytesLoaded():uint;

		function get bytesTotal():uint;			
		
		function get loadRatio():Number;		
	}
}