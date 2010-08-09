package 
{
	import potato.modules.dependencies.*;
	import flash.events.Event;
	import flash.display.Sprite;
	import potato.core.config.YAMLConfig;
	import potato.modules.dependencies.Dependencies;
	import flash.display.Bitmap;
	
	/**
	 * Simple example of dependencies being used as a separate module.
	 * 
	 * The dependencies module is pretty much and adapter for LoaderMax, but
	 * its strength relies on easier assets configuration management provided 
	 * by Potato's IConfig implementations.
	 * 
	 * In this example, we will use the YAML configuration file located at:
	 * samples/dependencies/data/gallery.yaml
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Fernando França
	 * @since  03.08.2010
	 */
	public class MainView extends Sprite
	{
		private var _configuration:YAMLConfig;
		private var _dependencies:Dependencies;
		
		public function MainView()
		{
			super();
			
			// In this example, we will load an external YAML configuration file.
			// Alternatively, you could use
			_configuration = new YAMLConfig("./data/gallery.yaml");
			_configuration.addEventListener(Event.INIT, onConfigurationInitialized);
			_configuration.init();
		}
		
		/**
		 * Configuration has been initialized (YAML file has been loaded and parsed)
		 * @param e Event 
		 */
		public function onConfigurationInitialized(e:Event):void
		{
			_dependencies = new Dependencies(_configuration);
			_dependencies.addEventListener(Event.COMPLETE, onDependenciesLoaded);
			_dependencies.load();
		}
		
		/**
		 * All items have been loaded.
		 * @param e Event 
		 */
		public function onDependenciesLoaded(e:Event):void
		{
			for (var i:int = 1; i <= 3; i++){
				var bitmap:Bitmap = _dependencies.getBitmap("picture"+i);
				bitmap.x = (i - 1) * 170;
				bitmap.y = 100;
				addChild(bitmap);
			}
		}
	}
}