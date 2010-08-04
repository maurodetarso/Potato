package 
{
	import potato.modules.i18n.*;
	import flash.events.Event;
	import flash.display.Sprite;
	import potato.core.config.YAMLConfig;
	
	/**
	 * Simple example of i18n locale being loaded.
	 * 
	 * Remember to read the YAML locale configuration example:
	 * samples/i18n/data/locales/en_US/copydeck.yaml
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Fernando França
	 * @since  03.08.2010
	 */
	public class MainView extends Sprite
	{
		public function MainView()
		{
			super();
			
			// Start loading the locale file
			I18n.instance.addEventListener(Event.COMPLETE, onLocaleLoaded);
			I18n.instance.inject(new YAMLConfig("data/locales/en_US/copydeck.yaml"));
		}
		
		/**
		 * Initializes text fields with locale.
		 * Event.COMPLETE is dispatched after I18n configuration has been loaded.
		 * @param e Event 
		 */
		public function onLocaleLoaded(e:Event):void
		{
			// The "_" static function is a handy way to call our i18n instance
			addChild(new CustomTextField(20, 20, _("title")));
			addChild(new CustomTextField(20, 50, _("subtitle")));
			addChild(new CustomTextField(20, 80, _("my_html"), true));
			
			// The "_" shorthand also includes useful printf functionality (credit should go to Arthur Debert for that!)
			addChild(new CustomTextField(20, 110, _("dynamic_example", {product: "bicycle", cost: 100}), true));
			
			// Multilines are handled gracefully with YAML, but feel free to use the file format that suits you best
			addChild(new CustomTextField(20, 140, _("multiline_example")));
			
			// Custom DisplayObject asset exported from Flash CS4 (i18n_sample.swc)
			var myContainer:MyContainer = new MyContainer();
			myContainer.x = 20;
			myContainer.y = 210;
			
			// Let's use the fillWithLocale helper to automatically fill the asset's TextFields!
			fillWithLocale(myContainer, I18nMatch.MATCH_BY_TEXT);
			addChild(myContainer);
		}
	}
}

import flash.text.TextField;
import flash.text.TextFormat;
/**
 * Custom TextField, which will hopefully make the above example clearer.
 */
internal class CustomTextField extends TextField
{
	public function CustomTextField(x:Number, y:Number, text:String, htmlMode:Boolean = false)
	{
		this.x = x;
		this.y = y;
		this.autoSize = "left";
		this.multiline = true;
		this.selectable = false;
		
		if(htmlMode){
			this.htmlText = text;
		}
		else {
			this.text = text;
		}
		
		var tf:TextFormat = new TextFormat();
		tf.font = "Arial";
		tf.size = 12;
		this.setTextFormat(tf);
	}
}