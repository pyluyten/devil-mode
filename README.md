 =As of today, all of this is work in progress=

*Prompts*
 CUA keys like ^f should raise a prompter to offer
 the whole emacs power.
 with ^f one can find-char (to move on) or search,
 or build a regexp.
 with ^r one can enter overwrite mode, replace-regexp

 Also use ^s, ^z, ^w.
 ^g  G[lobal|oto] is a specific prompt because we have so many funtions...



* BODHI-ALIAS: ultimate goal: offer a mode
  dedicated to edit an alias file.
  This file is parsed, creates your aliases.
  Also, it shall provide a command to display
  all available alias (I mean, the one created
  thanks to bodhi-alias).
  Currently, file parsing works but the format
  is too poor.



*Paddle*
 Use ijkl to move. Like ergoemacs. A bit like vim.
 backward word and forward word are also common.
 Thus, use u & o.
 $ for end of line is a perl one, and has an advantage:
 is not commonly used, so we can use this without modifier
 to go to end of line.


* EE-BODHI: implement BODHI on top of ErgoEmacs.


* BODHI-EVIL: implement BODHI on top of EvilMode.
   But implement "normal" mode a-la "god-mode", ie,
   do not offer a completely different keybidning.

