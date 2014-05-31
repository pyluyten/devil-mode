;
;    Pierre-Yves Luyten           2014.
;
;
;    This file is part of Bodhi.
; 
;    Bodhi is free software: you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation, either version 3 of the License, or
;    (at your option) any later version.
; 
;    Bodhi is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.
; 
;    You should have received a copy of the GNU General Public License
;    along with Bodhi.  If not, see <http://www.gnu.org/licenses/>.
;
;
;
;    ~~~ Principle
;    This was a bare trial but it appears its quite simple to
;    define aliases from strings. Thus, from a file.
;    Thus, from a list of files.
;
;    ~~~ Wishlist
;    This is already nice because even a dot.org file is better
;    to maintain than defalias list.
;    Also, we can leverage this to memorize alias which we're creating
;    Next step is to display it and allow user to add
;    its own file more dynamically...
;
;    function completion while editing is also important.


; core

(defvar bodhi-aliases (make-hash-table :test 'equal)
 "Hash table of bodhi aliases.

Each bodhi alias is a string of three elements,
the alias symbol, the function it's an alias for,
and the optional docstr.

Call bodhi-alias-list-aliases to display existing aliases
Call bodhi-alias-add-file to add a file to this table.
Call bodhi-alias-parse-aliases to reload every file (does not remove old ones yet.)")



(defvar bodhi-alias-files-list (make-hash-table :test 'equal)
"Hash table of files containing aliases.
See bodhi-aliases.")


(defun bodhi-alias-list-aliases ()
"List current bodhi aliases.

parse the full list of bodhi 'aliases' (which are themselves, list...)
this func is really ^n slow! does not matter, unless you want
ten thousands aliases, but you don't, dude."
  (interactive)
  (let ((buf (generate-new-buffer "Bodhi Aliases")))
    (switch-to-buffer buf)
    (maphash
      (lambda (key value)
        (insert (concat  "| " (symbol-name (nth 0 value))
	                 " | "  (symbol-name (nth 1 value))
	                 " | "  (nth 2 value)
			 " | "  (nth 3 value) "\n"))) bodhi-aliases)
    (org-mode)
    (previous-line)
    (org-table-align)))

(defun bodhi-alias-defalias-from-strings (filename alname funame &optional docstr)
  "Make an alias from strings.

Do not call this directly, this is made to be called by others."
  (interactive)
  (setq el (list (intern alname) (intern-soft funame) docstr filename))
  (puthash (nth 0 el) el bodhi-aliases)
  (defalias (nth 0 el) (nth 1 el) (nth 2 el)))


(defun bodhi-alias-read-lines (fullname)
  "Return a list of lines of a file <fullname>."
  (interactive)
  (with-temp-buffer
    (insert-file-contents fullname)
    (split-string (buffer-string) "\n" t)))


(defun bodhi-alias-parse-aliases ()
"Use bodhi-alias-files-list to parse aliases.

For each row, try to create an alias from this row."
  (interactive)
  (maphash
    (lambda (key value)
      (setq parser (bodhi-alias-read-lines key))
      (while parser
        (setq row (split-string (car parser) "|"))
        (bodhi-alias-defalias-from-strings
	  value
          (replace-regexp-in-string " " "" (nth 1 row))
          (replace-regexp-in-string " " "" (nth 2 row))
          (nth 3 row))
          (setq parser (cdr parser))))
    bodhi-alias-files-list))



(defun bodhi-alias-add-file (filenamestr)
  (interactive)
  (puthash filenamestr filenamestr bodhi-alias-files-list)
  (bodhi-alias-parse-aliases))


(defun bodhi-alias-remove-file (filenamestr)
  (interactive)
  (remhash filenamestr bodhi-alias-files-list)
  (bodhi-alias-parse-aliases))



(provide 'bodhi-alias)
