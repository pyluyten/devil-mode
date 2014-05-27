;;   This file is part of Bodhi.
;;
;;   Bodhi is free software: you can redistribute it and/or modify
;;   it under the terms of the GNU General Public License as published by
;;   the Free Software Foundation, either version 3 of the License, or
;;   (at your option) any later version.
;;
;;   Bodhi is distributed in the hope that it will be useful,
;;   but WITHOUT ANY WARRANTY; without even the implied warranty of
;;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;   GNU General Public License for more details.
;;
;;   You should have received a copy of the GNU General Public License
;;   along with Bodhi.  If not, see <http://www.gnu.org/licenses/>.
;;

(require 'ergoemacs-mode)

(add-to-list 'load-path "./")
(require 'bodhi-common)


; ------------- COMPONENTS ---------------------------

(ergoemacs-theme-component bodhi-prompters ()
  "Use cua-inspired prompters to deploy emacs"
  (global-set-key (kbd "C-s") 'save-buffer)
  (global-set-key (kbd "C-z") 'undo)

  (global-set-key (kbd "C-f") 'bodhi-find-prompt)
  (global-set-key (kbd "C-r") 'bodhi-replace-prompt)
  (global-set-key (kbd "C-g") 'bodhi-global-prompt)
)


(ergoemacs-theme-component operator-motion ()
  "Use operator motion commands."
  (global-set-key (kbd "C-c c") 'body-copy-line)
  (global-set-key (kbd "C-x x") 'kill-whole-line))


(ergoemacs-theme-component bodhi-perl-motions ()
  "Use $ and 0 to move to eol bol."
  (global-set-key (kbd "$")   'end-of-line)
  (global-set-key (kbd "C-$") 'kill-line)

  (global-set-key (kbd "M-0") 'ergoemacs-beginning-of-line-or-what)
  (global-set-key (kbd "C-à") 'bodhi-backward-kill-line))

; -------------- THEME ----------------------------

(ergoemacs-theme bodhi ()
  "Bodhi Ergoemacs Theme"
  :components   '(bodhi-prompters
                  ergoemacs-remap
                  move-char
                  bodhi-perl-motions)
  :optional-on  '(operator-motion)
  :optional-off '(guru no-backspace)
  :options-menu '(("Extreme ErgoEmacs" (guru no-backspace)
		   ("Operator>Motion" (operator-motion))))
)

(provide 'ee-bodhi)

