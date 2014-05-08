 =As of today, all of this is work in progress=

* DEVIL-MODE

  When a mark is set, add a temporary map to operate on this selection.
  This map allows to navigate, extend selection + operate without modifiers.

  Advantage: a temporary map does not influence other modes.
  Drawback: as long as the map does not contain *everything*,
            user should be able to break it and be surprised to replace
            active selection with input.


* BODHI-MODE

  Main goal is to provide
  - easy keys, cua + paddle based
  - efficient editing


  * paddle : each key is a move. Control moves. Alt kills.
    This might go to its own mode.


  * ^f (find), ^r (replace), cua-based keys, should
    prompt the user for advanced feature they want.
    Eg, replace-string or regexp-backward search.
    Goal is to extend this, make features more discoverable
    and easier to memorize and use.


  * selections: do not use modifiers.
     There are two ways to go
     - depend on devil-mode (or bundle it).
     - use own keymap for this. But then other modes are impacted


  * define some aliases + some keys to easily toggle minibuffer
    Memory is easier. Shortcuts might be efficient.


* DETAILS-MODE

  evil-based mode to use only two states:
  emacs state for inserting
  evil normal state for other parts.

  normal state has a little change comparing to evil:
  i j k l is used for navigating instead of hjkl

  (another way would be to nillify any evil-insert-state key
   plus, ensure each mode starts in emacs-state
   but my way is actually better...)

  
* CONCLUSION

  - selection should remain into a separated mode

  - aliases should go in a distinct feature to load aliases
    from a .txt (eg <function>:<alias>\n)

  - prompts _functions_ should go in a distinct
    commands .el

  - bodhi-mode should depend on selection+prompts+aliases
    and implement its paddle keymap.

    Optionnaly, details-mode can be added to have a consistent
    evil based editor on top of it if needed.
    But bodhi-mode should not depend on it.
