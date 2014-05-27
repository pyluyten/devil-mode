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

(require 'cua-base)
(require 'rect)

 ;;          VARS
;; --------------------------------------------
(defvar devil-mode-map nil "Keymap for devil-mode")


;; -----------COMMANDS -----------------
(defun devil-search-foward ()
 (interactive)
 (isearch-forward-regexp)
 (devil-add-selection-keymap)
)


(defun devil-search-backward ()
 (interactive)
 (isearch-backward-regexp)
 (devil-add-selection-keymap)
)


(defun devil-back-to-indentation ()
  (interactive)
  (if (= (point) (progn (back-to-indentation) (point)))
    (beginning-of-line))
)



;; to support inserting space into cua rectanlges
;; while still quitting with space
(defun devil-space ()
  (interactive)
  (if cua--rectangle
    (cua-insert-char-rectangle 32) ;SPC
    (keyboard-quit))
)


;-----------------------------------------------

(defun devil-add-selection-keymap ()
  (when (not devil-mode-map)
  (setq devil-mode-map (make-sparse-keymap))

  ;------------------ moves -------------------------
  (define-key devil-mode-map (kbd "l") 'forward-char)
  (define-key devil-mode-map (kbd "j") 'backward-char)
  (define-key devil-mode-map (kbd "k") 'next-line)
  (define-key devil-mode-map (kbd "i") 'previous-line)
  (define-key devil-mode-map (kbd "$") 'end-of-line)
  (define-key devil-mode-map (kbd "0") 'beginning-of-line)
  (define-key devil-mode-map (kbd "^") 'devil-back-to-indentation)
  (define-key devil-mode-map (kbd "w") 'forward-word)
  (define-key devil-mode-map (kbd "b") 'backward-word)

  (define-key devil-mode-map (kbd "s") 'devil-search-foward)
  (define-key devil-mode-map (kbd "r") 'devil-search-backward)

  ;------------------ operators -------------------------
  (define-key devil-mode-map (kbd "c") 'kill-ring-save)  
  (define-key devil-mode-map (kbd "x") 'kill-region)
  (define-key devil-mode-map (kbd "d") 'kill-region)


  ;------------------- others -----------------------------
  (define-key devil-mode-map (kbd "TAB") 'exchange-point-and-mark)
  (define-key devil-mode-map (kbd "h k") 'describe-key)
  (define-key devil-mode-map (kbd "h f") 'describe-function)
  (define-key devil-mode-map (kbd "RET") 'keyboard-quit)
  (define-key devil-mode-map (kbd "SPC") 'devil-space)
  )

  (set-temporary-overlay-map devil-mode-map t)
)


  ;-------------- hooks, mode ----------------

(defun devil-activate-selection-state ()
   (devil-add-selection-keymap)
)

(defun devil-deactivate-selection-state ()
)

(add-hook 'activate-mark-hook 'devil-activate-selection-state)

(add-hook 'activate-mark-hook 'devil-deactivate-selection-state)



(define-minor-mode devil-mode
  "Easily navigate while text is selected"
 :lighter " dev"
)


(provide 'devil-mode)
