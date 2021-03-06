package potato.modules.i18n {

	import flash.events.EventDispatcher;
	import potato.core.config.IConfig;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * Default i18n implementation
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Lucas Dupin, Fernando França
	 * @since  26.07.2010
	 */
	public class I18n extends EventDispatcher {
		
		private var configs:Vector.<IConfig> = new Vector.<IConfig>();
		
		/**
		 * @private
		 */
		private static var _instance:I18n;

        /**
         * Class used to parse configs
         * */
        public static var parser:Class;

		/**
		 * Get I18n instance (Singleton)
		 */
		public static function get instance():I18n
		{
			if(!_instance)
				_instance = new I18n(new SingletonEnforcer());
			
			return _instance;
		}
		
		/**
		 * Constructor (Singleton, access is only allowed through the I18n.instance)
		 */
		public function I18n(singleton:SingletonEnforcer):void {}
		
		/**
		 * @param config IConfig config with localization text
		 */
		public function inject(config:IConfig):void
		{
			config.addEventListener(Event.INIT, onConfigInit);
			config.init();
		}
		
		protected function onConfigInit(e:Event):void
		{
			var config:IConfig = e.target as IConfig;
			config.removeEventListener(Event.INIT, onConfigInit);
			configs.push(config);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * Shortcut
		 * @see inject
		 */
		public static function inject(config:IConfig):void
		{
			instance.inject(config);
		}
		
		/**
		 * Clears all config references.
		 */
		public function flush():void
		{
			configs.length = 0;
		}
		
		public function textFor(id:String):String
		{
			//Revese to enable override
			for each (var config:IConfig in configs.reverse())
			{
				if (config.hasProperty(id))
				{
					return config.getProperty(id);
				}
				
			}
			return "NOT FOUND: '" + id + "'";
		}
		
		/**
		 * Generates a proxy for acessing config properties...
		 * This makes our life much easier
		 */
		public function get proxy():ConfigProxy
		{
			return new ConfigProxy(configs);
		}
	
	}

}


import flash.utils.Proxy;
import flash.utils.flash_proxy;
import potato.core.config.IConfig;
use namespace flash_proxy;
internal class ConfigProxy extends Proxy
{
	private var configs:Vector.<IConfig>;
	public function ConfigProxy(configs:Vector.<IConfig>)
	{
		this.configs = configs;
	}
	override flash_proxy function getProperty(name:*):*
	{
		for each (var config:IConfig in configs.reverse())
			if (config.hasProperty(name))
				return config.getProperty(name);
				
		return undefined
	}
	override flash_proxy function hasProperty(name:*):Boolean
	{
		for each (var config:IConfig in configs)
			if (config.hasProperty(name))
				return true

		return false;
	}

}

/**
 * Enforces the Singleton design pattern.
 */
internal class SingletonEnforcer{}
