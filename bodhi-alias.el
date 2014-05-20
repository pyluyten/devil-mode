; this is a bare trial.

; core

(defun bodhi-alias-from-strings (alname funame &optional docstr)
  "Make an alias from strings."
  (interactive)
  (defalias
    (intern alname)
    (symbol-function (intern-soft funame))
    docstr))


(defun bodhi-read-lines (filePath)
  "Return a list of lines of a file at filePath."
  (interactive)
  (with-temp-buffer
    (insert-file-contents filePath)
    (split-string (buffer-string) "\n" t)))


(defun bodhi-parse-aliases (&optional filename)
  "Parses bodhi-alias.alias in current directory.
For each row, try to create an alias from this row."
  (interactive)
  (setq parser
    (read-lines "bodhi-alias.alias"))
  (while parser
    (setq row (split-string (car parser)))
    (bodhi-alias-from-strings (nth 0 row) (nth 1 row))
    (setq parser (cdr parser))))


; major mode for .alias
; this major mode should
; 1. allow to edit a .alias with convenience, mostly completion. Maybe org.
; 2. distribute a default .alias
; 3. use a variable to lookup for the file?
