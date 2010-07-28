package potato.modules.parameters
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import potato.core.config.ObjectConfig;
	import potato.core.config.IConfig;
	import flash.utils.Dictionary;
	import br.com.stimuli.string.printf;
	import potato.core.IDisposable;
	
	use namespace flash_proxy;
	
	/**
	 * Description
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author Lucas Dupin
	 * @since  16.06.2010
	 */
	dynamic public class Parameters extends Proxy implements IDisposable
	{
		
		//My config
		protected var _parameters:IConfig;
		//Defaults
		protected var _defaults:Dictionary;
		//Inheritance
		public var inherit:Parameters;
		
		//Cached parameter keys
		protected var _allKeys:Array=[];
		protected var _updateKeys:Boolean = true;
		
		public function Parameters(config:IConfig=null)
		{
			
			_parameters = config ? config : new ObjectConfig();
			_parameters.init();
			
			_defaults = new Dictionary();
		}
	
		/**
		 * Gets the value in the config, if there is none, fallbacks to defaults
		 */
		override flash_proxy function getProperty(name:*):*
		{
			var val:* = _parameters.hasProperty(name) ? _parameters.getProperty(name) : _defaults[name];
			
			//None found, trying to get inherited
			if(val == undefined && inherit)
			{
				val = inherit[name];
			}
				
				
			if (val is String)
				val = printf(val, this);
			
			return val;
		}
		
		/**
		 * adds a value to the view parameters config
		 */
		override flash_proxy function setProperty(name:*, value:*):void
		{
			_updateKeys = true;
			
			////Verify if it was inherited
			//if(inherit && inherit[name])
			//	inherit[name] = value;
			////No.. only set
			//else
				_parameters.setProperty(name, value);
			
			return;
		}
		
		/*
		Functions used for iteration
		*/
		flash_proxy override function nextNameIndex(index:int):int
		{
			return (index+1) % keys.length;
		}  
		flash_proxy override function nextName(index:int):String
		{
			return keys[index-1];
		}
		public function get keys():Array
		{
			if (_updateKeys)
			{
				_allKeys = _parameters.keys;
				for (var s:String in _defaults)
					_allKeys.push(s)
				_updateKeys = false;
			}
			
			return _allKeys;
		}
		
		/**
		 * Defaults are values which will be overwritten whem parameters are set
		 */
		public function get defaults():Dictionary
		{
			_updateKeys = true;
			return _defaults;
		}
		
		/**
		 * @param otherConfig IConfig 
		 * Adds another config to parameters.
		 * Using this method, you can load or create configs and later add them to the parameters
		 */
		public function inject(otherConfig:IConfig):void
		{
			for each (var key:Object in otherConfig.keys)
			{
				//Do not override parameters already set
				if(!_parameters.hasProperty(key))
					_parameters.setProperty(key, otherConfig.getProperty(key));
			}
			_updateKeys = true;
			
		}
		
		/**
		 * @private
		 */
		public function toString():String
		{
			return "[Parameters] " + keys.toString();
		}
		
		/**
		 * @private
		 */
		public function dispose():void
		{
			_parameters = null;
			_allKeys = null;
			_defaults = null;
		}
	}

}
