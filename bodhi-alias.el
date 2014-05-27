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

Call bodhi-alias-list-aliases to display existing aliases
     currently it just 'message ()
Call xxx to edit existing aliases and maybe save it to a file.
     to be done
Call bodhi-alias-add-file to reload aliases from the file.
     ok.")



(defvar bodhi-alias-files-list nil
"List of files containing aliases, as to be parsed per
bodhi-alias-parse-aliases.

User and modes can add files to this list. A custom func
is provided to both add a file to this list & rebuild aliases.")


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



(defun bodhi-alias-defalias-from-strings (alname funame &optional docstr)
  "Make an alias from strings.

Do not call this directly, this is made to be called by others."
  (interactive)
  (setq el (list (intern alname) (intern-soft funame) docstr))
  (setq newl (cons el bodhi-aliases))
  (setq bodhi-aliases newl)
  (defalias (nth 0 el) (nth 1 el) (nth 2 el)))


(defun bodhi-alias-read-lines (fullname)
  "Return a list of lines of a file <fullname>."
  (interactive)
  (with-temp-buffer
    (insert-file-contents fullname)
    (split-string (buffer-string) "\n" t)))


(defun bodhi-alias-parse-aliases (&optional filename)
  "Parses bodhi-alias.alias in current directory.
For each row, try to create an alias from this row."
  (interactive)
  (setq i 0) ; 0 is "list", 1 is first value.
  (setq curfile (nth i bodhi-alias-files-list))
  (while curfile
    (setq parser
     (bodhi-alias-read-lines curfile))
  (while parser
    (setq row (split-string (car parser) "|"))
    (bodhi-alias-defalias-from-strings
      (replace-regexp-in-string " " "" (nth 1 row))
      (replace-regexp-in-string " " "" (nth 2 row))
      (nth 3 row))
    (setq parser (cdr parser))
  (setq i (+ 1 i))
  (setq curfile (nth i bodhi-alias-files-list)))))


(defun bodhi-alias-add-file (filenamestr)
  (interactive)
  (setq item (cons filenamestr nil))
  (if (eq bodhi-alias-files-list nil)
      (setq bodhi-alias-files-list item)
      (add-to-list bodhi-alias-files-list item))
  (bodhi-alias-parse-aliases))

;(intern "orgal")

;(setq orgal "bodhi-alias.org")

;(setq toto orgal)

;(bodhi-alias-add-file orgal)

(provide 'bodhi-alias)
