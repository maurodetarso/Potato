package
{	
	import flash.display.Sprite;
	import potato.modules.dependencies.Dependencies;
	import potato.core.config.ObjectConfig;
	import flash.events.Event;
	
	public class dependencies extends Sprite
	{

		public function dependencies()
		{
			dependenciesFromConfig();
			dependenciesFromManuallyAdding();
			dependenciesFromConfigAndAdd();
			dependenciesEmpty();
		}
		
		public function dependenciesFromConfig():void
		{
			var cfg:ObjectConfig = new ObjectConfig([
				{
					"id":"main",
					"url":"%(basePath)s/dummy.swf",
					"domain":"current"
				}
			]);
			cfg.interpolationValues = {basePath: "."};
			
			var dep:Dependencies = new Dependencies(cfg);
			dep.addEventListener(Event.COMPLETE, onDepsLoadComplete);
			dep.load();
		}
		
		public function dependenciesFromManuallyAdding():void
		{
			var dep:Dependencies = new Dependencies();
			dep.addEventListener(Event.COMPLETE, onDepsLoadComplete);
			dep.addItem("./dummy.swf");
			dep.addItem("./dummy.swf", {id: "dummy2"});
			dep.load();
		}
		
		public function dependenciesFromConfigAndAdd():void
		{
			var cfg:ObjectConfig = new ObjectConfig([
				{
					"id":"main",
					"url":"%(basePath)s/dummy.swf",
					"domain":"current"
				}
			]);
			cfg.interpolationValues = {basePath: "."};
			
			var dep:Dependencies = new Dependencies(cfg);
			dep.addEventListener(Event.COMPLETE, onDepsLoadComplete);
			dep.addItem("./dummy.swf");
			dep.addItem("./dummy.swf", {id: "dummy2"});
			dep.load();
		}
		
		public function dependenciesEmpty():void
		{
			var dep:Dependencies = new Dependencies();
			dep.addEventListener(Event.COMPLETE, onDepsLoadComplete);
			dep.load();
		}
		
		public function onDepsLoadComplete(e:Event):void
		{
			trace("tester::onDepsLoadComplete()", "COMPLETE: ", e.target);
		}

	}
}