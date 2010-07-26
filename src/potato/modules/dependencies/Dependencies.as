package potato.modules.dependencies
{
	import br.com.stimuli.loading.BulkLoader;
	import potato.modules.dependencies.IDependencies;
	import potato.core.config.IConfig;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import br.com.stimuli.string.printf;
	import flash.events.Event;

	/**
	 * Default dependencies implementation
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author Lucas Dupin
	 * @since  26.07.2010
	 */
	public class Dependencies extends BulkLoader implements IDependencies
	{
	
		public function Dependencies(config:IConfig=null)
		{
			super(BulkLoader.getUniqueName());
			
			//Populating it
			if (config)
			{
				var keys:Array = config.keys;
				for each (var key:String in keys)
				{
					//Dependency parameters: type, domain, id...
					var params:Object = {};
					
					//Get the id
					if (config.hasProperty(key, "id"))
						params.id = config.getProperty(key, "id");
						
					//Get the type
					if (config.hasProperty(key, "type"))
						params.type = config.getProperty(key, "type");

					//Check if we are going to user another ApplicationDomain
					if (config.hasProperty(key, "domain"))
					{
						var lContext:LoaderContext = new LoaderContext(); 
						if (config.getProperty(key, "domain") == "current")
							lContext.applicationDomain = ApplicationDomain.currentDomain;
						params.context = lContext;
					}
					
					//URL presence
					if (!config.hasProperty(key, "url"))
						throw new Error("[Dependencies] " + key + " has no 'url'");
					
					//Dep location
					var url:String = config.getProperty(key, "url")
						
					//File extension
					if(url.lastIndexOf(".") > -1)
					{
						var tmpSplit:Array = url.split(".");
						var ext:String = tmpSplit[tmpSplit.length-1];
						
						//Videos will start paused
						if(ext == "flv" || ext == "f4v" || params.type == "video")
							params.pausedAtStart = true;
					}
					
					addItem(url, params);
				}
			}
		}
		
		public function load():void
		{
			if(items.length > 0){
				start();
			}
			else{
				dispatchEvent(new Event(Event.COMPLETE))
			}
				
		}
		
		public function addItem(url : *, props : Object= null ):void
		{
			add(url, props);
		}
		
		public function dispose():void
		{
			clear();
		}
	
	}

}