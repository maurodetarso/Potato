package potato.modules.dependencies
{
	import flash.display.*;
	import flash.media.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	
	import potato.core.IDisposable;

	public interface IDependencies extends IEventDispatcher, IDisposable
	{
		/**
		 * Start loading the dependencies
		 * 
		 * dispatches <code>Event.COMPLETE</code> when done
		 */
		function load():void;
		function addItem(url : *, props : Object= null ):void;
		
		//TODO implement a nice interface here
		function getContent(key : String, clearMemory : Boolean = false) : *;
        function getXML(key : *, clearMemory : Boolean = false) : XML;
        function getText(key : *, clearMemory : Boolean = false) : String;
        function getSound(key : *, clearMemory : Boolean = false) : Sound;
        function getBitmap(key : String, clearMemory : Boolean = false) : Bitmap;
        function getDisplayObjectLoader(key : String, clearMemory : Boolean = false) : Loader;
        function getMovieClip(key : String, clearMemory : Boolean = false) : MovieClip;
        function getAVM1Movie(key : String, clearMemory : Boolean = false) : AVM1Movie;
        function getNetStream(key : String, clearMemory : Boolean = false) : NetStream;
        function getNetStreamMetaData(key : String, clearMemory : Boolean = false) : Object;
        function getBitmapData(key : *,  clearMemory : Boolean = false) : BitmapData;
        function getBinary(key : *, clearMemory : Boolean = false) :ByteArray;
        function getSerializedData(key : *,  clearMemory : Boolean = false, encodingFunction : Function = null) : *;
        function getHttpStatus(key : *) : int;
	
	}

}

