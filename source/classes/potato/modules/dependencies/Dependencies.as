package potato.modules.dependencies
{
	import potato.core.config.IConfig;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import com.greensock.loading.*
	import com.greensock.loading.core.*;
	import com.greensock.events.LoaderEvent;
	import flash.display.BitmapData;

	/**
	 * Implements IDependencies with GreenSock's LoaderMax.
	 * 
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Fernando França, Lucas Dupin
	 * @since  10.08.2010
	 */
	public class Dependencies extends EventDispatcher implements IDependencies
	{
		protected var _queue:LoaderMax;
		
		public function Dependencies(config:IConfig = null)
		{
			LoaderMax.activate([ImageLoader, SWFLoader]);
			
			// Create a new LoaderMax instance (an unique name is automatically assigned)
			_queue = new LoaderMax({onProgress:onLoaderProgress, onComplete:onLoaderComplete, onError:onLoaderError});
			
			// Populate the loader
			if (config)
				inject(config);
		}
		
		public function onLoaderProgress(e:LoaderEvent):void
		{
			
		}
		
		public function onLoaderComplete(e:LoaderEvent):void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function onLoaderError(e:LoaderEvent):void
		{
			trace("error");
		}
		
		/**
		 * Adds configuration items to the loading queue.
		 * @param config IConfig 
		 */
		public function inject(config:IConfig):void
		{
			var keys:Array = config.keys;
			
			for each (var key:String in keys)
			{
				// Dependency item parameters (e.g. id, type, domain, etc)
				var params:Object = {};
				
				// Get the id
				if (config.hasProperty(key, "id"))
					params.name = config.getProperty(key, "id");
				
				// Get the type
				if (config.hasProperty(key, "type"))
					params.type = config.getProperty(key, "type");
				
				// Key for choosing an ApplicationDomain (SWFLoader)
				if (config.hasProperty(key, "domain"))
				{
					var customLoaderContext:LoaderContext = new LoaderContext(); 
					if (config.getProperty(key, "domain") == "current")
						customLoaderContext.applicationDomain = ApplicationDomain.currentDomain;
					params.context = customLoaderContext;
				}
				
				// Add additional keys from config
				mergeProperties(params, config.configForKey(key), ["id", "type", "domain", "url"]);
				
				// All a loader item really needs is an URL
				if (!config.hasProperty(key, "url"))
					throw new Error("[Dependencies] " + key + " has no 'url'");
				 
				var url:String = config.getProperty(key, "url")
				
				// Add item to queue
				this.addItem(url, params);
			}
		}
		
		/**
		 * Merges properties of an object and a configuration. Ignores some keys if necessary.
		 * 
		 * @param obj Object 
		 * @param config IConfig 
		 * @param ignoreKeys Array An Array containing keys to be ignored from the merge.
		 * 
		 * @private
		 */
		protected function mergeProperties(obj:Object, config:IConfig, ignoreKeys:Array):void
		{			
			var keys:Array = config.keys;
			
			for each(var ignoredKey:String in ignoreKeys)
			{
				var pos:int = keys.indexOf(ignoredKey);
				if(pos != -1){
					keys.splice(pos, 1);
				}
				
			}
			
			for each(var key:String in keys)
			{
				if(!obj.hasOwnProperty(key))
				{
					obj[key] = config.getProperty(key);
				}
			}
		}
		
		/**
		 * Adds a new item to the loading queue.
		 * 
		 * @param url * The item's URL.
		 * @param props Object (optional) Properties object for LoaderMax's item loader (useful!).
		 */
		public function addItem(url : *, props : Object= null ):void
		{
			// Create correct type of loader from the given URL.
			var itemLoader:LoaderCore = LoaderMax.parse(url, props);
			_queue.append(itemLoader);
		}
		
		/**
		 * Starts loading the queued items.
		 */
		public function load():void
		{
			if(_queue.numChildren > 0){
				_queue.load();
			}
			else{
				dispatchEvent(new Event(Event.COMPLETE));
			}		
		}
		
		// ----------------------- Content getters -------------------------
		
		public function getBitmap(key:String):Bitmap
		{
			return _queue.getContent(key).rawContent;
		}
		
		public function getBitmapData(key:String):BitmapData
		{
			return _queue.getContent(key).rawContent.bitmapData;
		}
		
		/**
		 * IDisposable implementation
		 * @private
		 */
		public function dispose():void
		{
			// TODO verify if flushContent == true is interfering with projects (removing DisplayObjects or not) 
			_queue.dispose(true);
			_queue = null;
		}
	}

}