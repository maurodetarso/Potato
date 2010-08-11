package potato.modules.dependencies
{
	import flash.display.*;
	import flash.media.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	
	import potato.core.IDisposable;
	import potato.core.config.IConfig;

	public interface IDependencies extends IEventDispatcher, IDisposable
	{
		/**
		 * Start loading the dependencies
		 * 
		 * dispatches <code>Event.COMPLETE</code> when done
		 */
		function inject(config:IConfig):void;
		function addItem(url:*, props:Object = null):void;
		function load():void;
		
		// Related to content fetching
		function getBitmap(key:String):Bitmap;
		function getBitmapData(key:String):BitmapData;
			//	
			//function getByteArray(key:String):ByteArray;
			//function getMovieClip(key:String):MovieClip;
			//function getNetStream(key:String):NetStream;
		
		//TODO implement a nice interface here
		//function getContent(key : String, clearMemory : Boolean = false) : *;
		//        function getXML(key : *, clearMemory : Boolean = false) : XML;
		//        function getText(key : *, clearMemory : Boolean = false) : String;
		//        function getSound(key : *, clearMemory : Boolean = false) : Sound;
		//        function getBitmap(key : String, clearMemory : Boolean = false) : Bitmap;
		//function getBitmapData(key : *,  clearMemory : Boolean = false) : BitmapData;
		//
		//        function getDisplayObjectLoader(key : String, clearMemory : Boolean = false) : Loader;
		//        function getMovieClip(key : String, clearMemory : Boolean = false) : MovieClip;
        //function getAVM1Movie(key : String, clearMemory : Boolean = false) : AVM1Movie;
        //function getNetStream(key : String, clearMemory : Boolean = false) : NetStream;
        //function getNetStreamMetaData(key : String, clearMemory : Boolean = false) : Object;
        //function getBinary(key : *, clearMemory : Boolean = false) :ByteArray;
        //function getSerializedData(key : *,  clearMemory : Boolean = false, encodingFunction : Function = null) : *;
        //function getHttpStatus(key : *) : int;
	
	}

}

