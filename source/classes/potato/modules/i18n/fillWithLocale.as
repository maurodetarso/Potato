package potato.modules.i18n
{	
import flash.display.DisplayObjectContainer;
	
	/**
	* Searches for TextFields in the haystack using the miner function
	* 
	* The miner function always receives the TextField as a parameter and should return an String
	* which is the id of the localized string in the I18n locale file, other miner function parameters
	* can be passed using the rest parameters
	* 
	* Ex matching by instance:
	* function(s:TextField):String {
	* 	return s.name;
	* }
	* 
	* @param haystack DisplayObjectContainer Where to search
	* @param miner Function How to search
	* @param ... Array Miner parameters
	* @private 
	* 
	* @example
	* 
	* <b>Default mining function (MATCH_BY_TEXT):</b><br />
	* fillWithLocale(this);
	* 
	* <b>Function with no parameters:</b><br />
	* fillWithLocale(this, I18nMatch.MATCH_BY_TEXT);
	* 
	* <b>Functions with parameters:</b><br />
	* fillWithLocale(this, I18nMatch.MATCH_BY_INSTANCE_WITH_PREFIX, "prefix_");
	* fillWithLocale(this, I18nMatch.MATCH_BY_INSTANCE_WITH_SUFFIX, "_suf");
	* 
	* <b>Important note:<b><br />
	* MATCH_BY_TEXT searches for {my_text}, between braces
	* 
	* @see	potato.modules.i18n.I18nMatch
	* 
	**/
	
	public function fillWithLocale(haystack:DisplayObjectContainer, miner:Function = null, ...rest):void
	{
		if(rest.length > 0){	
			I18nMatch.fillWithLocale(haystack, miner, rest);
		}
		else
		{
			I18nMatch.fillWithLocale(haystack, miner);
		}
	}	
	
}
