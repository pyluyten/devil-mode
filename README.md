 =As of today, all of this is work in progress=

 / 1. Principles/

*Prompts*
 status: prompts are working fine, despite code is poor.
 rationale: we don't want to memorize one thousands functions,
 but we need them. The right way is to have one key offer
 several functions, like ^x, but prompting the user
 in order not to have to memorize every shortcut.
 roadmap: coding an automatic prompt for Ctrl-X-Prefix
 would be awesome. Making existing prompts richer.

 CUA keys like ^f should raise a prompter to offer
 the whole emacs power.
 with ^f one can find-char (to move on) or search,
 or build a regexp.
 with ^r one can enter overwrite mode, replace-regexp
 ^g  G[lobal|oto] is a specific prompt.

 
*More CUA*
 status: ok, that's simple!
 rationale: this point also wants to easier learning and usage,
 but does not imply prompting.
 
 Use ^s, ^z, ^w.

 
*Paddle*
 status: this is a spec, not an implementation
         but i think this spec is now done.
 rationale: most common moves/commands do not have
 to be based on mnemonics. The user can easily memorize
 6 keys!, especially if he's going to use these all the time.

 ErgoEmacs is totally right about this: ijkl should be use
 to move, and u/o for backward/forward word.
 I added 0 and $ for bol, eol.
 Also, a modifier is not necessary in the case of $, since
 the user do not need to type $ character as much as he needs
 to move to eol.


*Selecition state*
 status: prompts are mostly to-do
 rationale: when one is selecting text, typing keys should
 perform actions (move, prompt...) rather than enter chars.

 This is vim selection-mode. Additionally, we should have
 prompts functions work on regions when text is selected.
 I did it for ^f f, ie C-f prompt+f, isearch-forward
 which will use selected region as search string.


* ALIAS
  status: not done
  rationale: user should be avaiable to define
  its aliases in a dedicated file, and should
  have a func to display these at runtime.

  M-x should always be accessible more easily
  than typing M-x, and short aliases should be available
  as an alternative to keys.


* LIGHT AND SANE INIT
  status: more or less ok.
  rationale: it is better to separate settings
  that are probably pleasant in any case, even if this
  limits our actions.

  Things like "which global minor mode" should not be defined
  here.


 / 2. Implementations /

* bodhi-evil.el
  status: most have been done.
  rationale: this was the fastest way to check all these principles!

  bodhi-evil also offers a normal-state, which looks like god-mode
  ie, keybinding are not really altered, one just has to forget
  about modifiers...
  
* ee-bodhi.el
  status: still very ppor
  rationale: having ergoemacs components+layouts might be a good
  way to implement these principles.

  But i will have to handle the selection-state.
  And maybe god-state.