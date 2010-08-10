package potato.modules.navigation
{

	import flash.events.EventDispatcher;
	import potato.core.config.IConfig;
	import potato.modules.navigation.View;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import potato.modules.dependencies.IDependencies;
	import flash.utils.getDefinitionByName;
	import potato.core.config.ObjectConfig;
	import ReferenceError;
	import potato.core.IDisposable;
	import potato.modules.navigation.events.NavigationEvent;
	import potato.utils.getInstanceByName;

	// Potato Navigation module namespace
	import potato.modules.navigation.potato_navigation;
	use namespace potato_navigation;
	
	/**
	 * Loads the view and notifies progress or completion
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Lucas Dupin
	 * @since  17.06.2010
	 */
	public class ViewLoader extends EventDispatcher implements IDisposable
	{
		//@private
		private var viewOrConfig:Object;
		
		//Internal: view to be loaded
		protected var _viewId:String;
		
		//Config to be attached to the view
		public var _viewConfig:IConfig;
		
		//View loaded
		public var view:View;
		
		//This parent
		public var parentView:View;
		
		//Dependency
		public var chain:ViewLoader;
		
		/**
		 * Receives a view to load or an IConfig.
		 * The second parameter is a chain we must load before
		 * @return  
		 */
		public function ViewLoader(viewOrConfig:Object, chain:ViewLoader=null){
			this.viewOrConfig = viewOrConfig;
			this.chain = chain;
		}
		
		public function start():void
		{
			/*
			Checking the type, maybe it's a view, maybe not
			*/
			if (viewOrConfig is View)
			{
				_viewId = viewOrConfig.id;
				trace("[ViewLoader] ", _viewId, " load start");
				handleViewLoading(viewOrConfig as View)
			} 
			else if (viewOrConfig is IConfig)
			{
				_viewId = viewOrConfig.getProperty("id");
				trace("[ViewLoader] ", _viewId, " load start");
				handleConfigLoading(viewOrConfig as IConfig)
			} else
			{
				throw new Error("[ViewLoader] doesn't know how to load " + viewOrConfig);
			}
		}
		
		/**
		 * @param v View 
		 * Setup listeners and start to load
		 */
		protected function handleViewLoading(v:View):void
		{
			//View reference
			view = v;
			
			//i18n?
			if(view.config.hasProperty("localeFile"))
			{
				//Check if the module was included
				with(getDefinitionByName("potato.modules.i18n.I18n")){
					inject(new parser(view.config.getProperty("localeFile")));
					instance.addEventListener(Event.COMPLETE, continueViewLoading, false, 0, true);
				}
			} else {
				continueViewLoading();
			}
		}
		/**
		 * @param e Event 
		 * Runs after i18n verifications (Loading View instance)
		 */
		public function continueViewLoading(e:Event=null):void
		{
			//Check if there is something else to load
			if(view.dependencies)
			{
				view.dependencies.addEventListener(Event.COMPLETE, onViewLoadComplete);
				view.dependencies.addEventListener(ProgressEvent.PROGRESS, onViewLoadProgress, false, 0, true);
				view.dependencies.load();
			} else
			{
				onViewLoadComplete();
			}
		}
		
		/**
		 * @param viewConfig Object Default object from IConfig
		 * Setup listeners, create dependencies and start to load
		 */
		protected function handleConfigLoading(viewConfig:IConfig):void
		{
			//Reference
			_viewConfig = viewConfig;
			
			//Do we need to load localization stuff?
			if (_viewConfig.hasProperty("localeFile"))
			{
				//Check if the module was included
				with(getDefinitionByName("potato.modules.i18n.I18n")){
					inject(new parser(_viewConfig.getProperty("localeFile")));
					instance.addEventListener(Event.COMPLETE, continueConfigLoading);
				}
			} else {
				//Nothing to load
				continueConfigLoading();
			}
			
		}
		
		/**
		 * @param e Event 
		 * Runs after i18n verifications
		 * (Loading IConfig instance)
		 */
		public function continueConfigLoading(e:Event=null):void
		{
			if(e)
				getDefinitionByName("potato.modules.i18n.I18n").instance.removeEventListener(Event.COMPLETE, continueConfigLoading);
			
			//Do we have dependencies?
			if (_viewConfig.hasProperty("dependencies"))
			{
				//Getting a dependencies instance
				var dependencies:IDependencies = getDependenciesInstance(_viewConfig.configForKey("dependencies"));
				
				//Setup listeners
				dependencies.addEventListener(Event.COMPLETE, onViewReadyToCreate);
				dependencies.addEventListener(ProgressEvent.PROGRESS, onViewLoadProgress, false, 0, true);
				
				//Start loading
				dependencies.load();
			} else
			{
				onViewReadyToCreate();
			}
		}
		
		protected function getDependenciesInstance(config:IConfig):IDependencies
		{
			var dependencies:IDependencies = getInstanceByName("potato.modules.dependencies.Dependencies", config);
			
			if(!dependencies) throw new Error("[ViewLoader] potato.modules.dependencies.Dependencies was not found.");
			
			return dependencies;
		}
		
		/**
		 * @param e Event 
		 * passing events
		 */
		protected function onViewLoadProgress(e:Event):void
		{
			dispatchEvent(e.clone());
		}
		/**
		 * @param e Event 
		 * All depencendies are loaded.
		 * Creates the view instance
		 */
		protected function onViewReadyToCreate(e:Event=null):void
		{
			view = getInstanceByName(_viewConfig.getProperty("class") || "potato.modules.navigation.View");
			view.startup(_viewConfig);
			
			if(e)
			{
				e.target.removeEventListener(Event.COMPLETE, onViewReadyToCreate);
				view.dependencies = e.target as IDependencies;
			}
			
			onViewLoadComplete();
		}
		/**
		 * @param e Event 
		 * View loaded, check if there is something else to load
		 */
		protected function onViewLoadComplete(e:Event=null):void
		{
			if(e) e.target.removeEventListener(Event.COMPLETE, onViewLoadComplete);
			trace("[ViewLoader] ", _viewId, " load complete:", view);
			
			if(chain) {
				chain.addEventListener(Event.COMPLETE, view.nav.onViewLoaded, false, 0, true);
				chain.addEventListener(ProgressEvent.PROGRESS, onChainProgress, false, 0, true);
				chain.addEventListener(Event.COMPLETE, onChainLoaded);
                chain.parentView = view;
				chain.start();
			} else {
				continueFromChain();
			}
		}
		
		public function onChainLoaded(e:Event):void
		{
			e.target.removeEventListener(Event.COMPLETE, onChainLoaded);			
			
			//TODO this is ugly
			//Telling the nav we should show this view (cascade)
			view.nav._viewsToShow.push(chain.view);
			
			continueFromChain();
		}
		
		public function continueFromChain():void
		{
            view.nav.parent = parentView;
			dispatchEvent(new NavigationEvent(Event.COMPLETE, view));
		}
		
		public function onChainProgress(e:Event):void
		{
			dispatchEvent(e.clone());
		}
		
		/**
		 * @private
		 */
		public function dispose():void
		{
			_viewId      = null;
			_viewConfig  = null;
			view         = null;
			viewOrConfig = null;

		}
	
	}

}