package potato.modules.dependencies
{
	import potato.core.config.IConfig;
	
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.events.Event;
	
	import com.greensock.loading.*

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
	public class Dependencies implements IDependencies
	{
		protected var _queue:LoaderMax;
		
		public function Dependencies(config:IConfig = null)
		{
			LoaderMax.activate([ImageLoader, SWFLoader]);
			
			_queue = new LoaderMax();//{name:"mainQueue", onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler});
			
			// Populate the loader
			if (config)
			{
				var keys:Array = config.keys;
				
				for each (var key:String in keys)
				{
					// Dependency item parameters (e.g. id, type, domain, etc)
					var params:Object = {};
					
					// Get the id
					if (config.hasProperty(key, "id"))
						params.id = config.getProperty(key, "id");
					
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
					
					// All a loader item really needs is an URL
					if (!config.hasProperty(key, "url"))
						throw new Error("[Dependencies] " + key + " has no 'url'");
					 
					var url:String = config.getProperty(key, "url")
					
					// Add item to queue
					this.addItem(url, params);
				}
			}
		}
		
		
		
		public function load():void
		{
			if(_queue.numChildren > 0){
				_queue.load();
			}
			else{
				dispatchEvent(new Event(Event.COMPLETE));
			}
				
		}
		
		public function addItem(url : *, props : Object= null ):void
		{
			// Create correct type of loader from the given URL.
			var itemLoader:LoaderCore = LoaderMax.parse(url, props);
			_queue.append(itemLoader);
		}
		
		public function dispose():void
		{
			// TODO verify if flushContent == true is interfering with projects (removing DisplayObjects or not) 
			_queue.dispose(true);
		}
		
		// ------------------------------------------------------
		//   IEventDispatcher implementation through delegation
		// ------------------------------------------------------
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			_queue.addEventListener(type, listener, useCapture, priority, userWeakReference);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			_queue.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			_queue.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean
		{
			willTrigger(type);
		}	
	}

}