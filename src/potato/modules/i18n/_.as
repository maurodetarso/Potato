package potato.modules.i18n {

    import br.com.stimuli.string.printf;

	/**
	* Localization helper
	* */
	public function _(s:String, ...args):String {
		return printf.apply(this, [I18n.instance.textFor(s)].concat(args));
	}

}

