; this is a bare trial.
; ok now this works, but we miss
;
; 1. allow to edit a .alias with convenience, mostly completion.
;    now we have a .org file  but main features are to be coded.
; 2. distribute a default .alias
;    or, maybe make bodhi-common depend on this
;    & let it ship its aliases =)
; 3. use a defcustom to lookup for the file?
;    or not...
; 4. have a func do display current aliases
;    current one is just for debugging
;    this might be the same than 1...




; core

(defvar bodhi-aliases nil
 "List of bodhi aliases.

Each bodhi alias is a string of three elements,
the alias symbol, the function it's an alias for,
and the optional docstr.

Call xxx to display existing aliases
Call xxx to edit existing aliases and maybe save it to a file.
Call xxx to reload aliases from the file.")


(defun bodhi-alias-list-aliases ()
"List current bodhi aliases.

parse the full list of bodhi 'aliases' (which are themselves, list...)
this func is really ^n slow! does not matter, unless you want
ten thousands aliases, but you don't, dude."
  (interactive)
  (setq i 0)
  (setq cural (nth i bodhi-aliases))
  (while cural
    (message (format "Alias Nth. %s" i))
    (message (concat "ALIAS:" (symbol-name (nth 0 cural))
	             "\nFUNC:"  (symbol-name (nth 1 cural))
		     "\nDESC:"  (nth 2 cural)))
    (setq i (+ i 1))
    (setq cural (nth i bodhi-aliases))))



(defun bodhi-alias-from-strings (alname funame &optional docstr)
  "Make an alias from strings.

Do not call this directly, this is made to be called by others."
  (interactive)
  (setq el (list (intern alname) (intern-soft funame) docstr))
  (setq newl (cons el bodhi-aliases))
  (setq bodhi-aliases newl)
  (defalias (nth 0 el) (nth 1 el) (nth 2 el)))


(defun bodhi-read-lines (fullname)
  "Return a list of lines of a file <fullname>."
  (interactive)
  (with-temp-buffer
    (insert-file-contents fullname)
    (split-string (buffer-string) "\n" t)))


(defun bodhi-parse-aliases (&optional filename)
  "Parses bodhi-alias.alias in current directory.
For each row, try to create an alias from this row."
  (interactive)
  (setq parser
    (bodhi-read-lines "bodhi-alias.org"))
  (while parser
    (setq row (split-string (car parser) "|"))
    (bodhi-alias-from-strings
      (replace-regexp-in-string " " "" (nth 1 row))
      (replace-regexp-in-string " " "" (nth 2 row))
      (nth 3 row))
    (setq parser (cdr parser))))


