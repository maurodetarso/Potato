package potato.modules.dependencies
{	
    import potato.modules.dependencies.Dependencies;
	import potato.core.config.ObjectConfig;
	import flash.events.*;
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	
	public class DependenciesTest
	{

		[Test(async)]
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
			Async.proceedOnEvent( this, dep, Event.COMPLETE );
			Async.failOnEvent( this, dep, IOErrorEvent.IO_ERROR );
			Async.failOnEvent( this, dep, ErrorEvent.ERROR );
			dep.load();
			
			
		}
		
		[Test(async)]
		public function dependenciesFromManuallyAdding():void
		{
			var dep:Dependencies = new Dependencies();
			Async.proceedOnEvent( this, dep, Event.COMPLETE );
			Async.failOnEvent( this, dep, IOErrorEvent.IO_ERROR );
			Async.failOnEvent( this, dep, ErrorEvent.ERROR );
			dep.addItem("./dummy.swf");
			dep.addItem("./dummy.swf", {id: "dummy2"});
			dep.load();
		}
		
		[Test(async)]
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
			
			var dep:Dependencies = new Dependencies(cfg);;
			Async.proceedOnEvent( this, dep, Event.COMPLETE );
			Async.failOnEvent( this, dep, IOErrorEvent.IO_ERROR );
			Async.failOnEvent( this, dep, ErrorEvent.ERROR );
			dep.addItem("./dummy.swf");
			dep.addItem("./dummy.swf", {id: "dummy2"});
			dep.load();
		}
		
		[Test(async)]
		public function dependenciesEmpty():void
		{
			var dep:Dependencies = new Dependencies();
			Async.proceedOnEvent( this, dep, Event.COMPLETE );
			Async.failOnEvent( this, dep, IOErrorEvent.IO_ERROR );
			Async.failOnEvent( this, dep, ErrorEvent.ERROR );
			dep.load();
		}
		
		public function onDepsLoadComplete(e:Event):void
		{
			Assert.assertEquals(1,1);
		}

	}
}
