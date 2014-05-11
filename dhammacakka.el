
; wikipedia.org/wiki/Dharmachakra
;
; This code performs the common setup.
; This is lighter than other starter kits.
; Also, this is way more mouse-friendly
; There are very good reasons for this.
;
;
; Keymap is not there.
; keymap might be evil-mode, ergoemacs,
; or one of my bodhi implementation.



; ~~~~
; ~~~~ Lighter startup
; See als http://ergoemacs.org/emacs/emacs_make_modern.html

  (setq inhibit-splash-screen t)
  (setq inhibit-startup-message t)
  (setq initial-scratch-message "~~~~~~~~~~~~~\n")


; ~~~~
; ~~~~ Display

  (global-linum-mode 1) ;; line number
  (column-number-mode t) ;; column number
  (global-visual-line-mode 1) ; wrap line

  (setq frame-title-format '("%b")) ; lighter title


; GUI-friendly, not GUIlty.

  (if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
  (if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
  ;(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))




; ~~~~
; ~~~~ Behaviour

  (setq make-backup-files nil)
  (setq auto-save-default nil)



; ~~~~
; ~~~~ Friends

  (require 'package)
  (add-to-list 'package-archives
   '("melpa" . "http://melpa.milkbox.net/packages/") t)
  (add-to-list 'package-archives
   '("marmalade" . "http://marmalade-repo.org/packages/") t)


(provide 'dhammacakka)
