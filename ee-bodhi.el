; Principle
; - ErgoEmacs Component for ^x motion, ^c motion
; - ErgoEmacs Theme for paddle etc...

(require 'ergoemacs-mode)


; ----------- COMMANDS ---------------------

 (defun bodhi-copy-line (arg)
    "Copy lines (as many as prefix argument) in the kill ring.
      Ease of use features:
      - Move to start of next line.
      - Appends the copy on sequential calls.
      - Use newline as last char even on the last line of the buffer.
      - If region is active, copy its lines."
    (interactive "p")
    (let ((beg (line-beginning-position))
          (end (line-end-position arg)))
      (when mark-active
        (if (> (point) (mark))
            (setq beg (save-excursion (goto-char (mark)) (line-beginning-position)))
          (setq end (save-excursion (goto-char (mark)) (line-end-position)))))
      (if (eq last-command 'copy-line)
          (kill-append (buffer-substring beg end) (< end beg))
        (kill-ring-save beg end)))
    (kill-append "\n" nil)
    (beginning-of-line (or (and arg (1+ arg)) 2))
    (if (and arg (not (= 1 arg))) (message "%d lines copied" arg)))



; ------------- COMPONENTS ---------------------------


(ergoemacs-theme-component operator-motion ()
  "Use operator motion commands."
  (global-set-key (kbd "C-c c") 'body-copy-line)
  (global-set-key (kbd "C-x x") 'kill-whole-line)
  (global-set-key (kbd "C-x o") 'kill-word)
  (global-set-key (kbd "C-x $") 'kill-line)
  (global-set-key (kbd "C-x w") 'kill-word))


(ergoemacs-theme-component paddle ()
; This is not compatible with "backspace is back nor any backspace shorcuts.
; Since ^i stands for TAB. Which is an emacs bug (not a feature. Seriously)
  "Simple i j k l paddle."
  (global-set-key (kbd "C-i") 'previous-line)
  (global-set-key (kbd "C-j") 'backward-char)
  (global-set-key (kbd "C-l") 'forward-char)
  (global-set-key (kbd "C-k") 'next-line)
  
  (global-set-key (kbd "M-l") 'delete-forward-char)
  (global-set-key (kbd "M-j") 'delete-backward-char)
  (global-set-key (kbd "M-k") 'kill-whole-line)
  (global-set-key (kbd "M-i") 'open-line)
  
  (global-set-key (kbd "C-u") 'backward-word)
  (global-set-key (kbd "M-u") 'backward-kill-word)
  (global-set-key (kbd "C-o") 'forward-word)
  (global-set-key (kbd "M-o") 'kill-word))


(ergoemacs-theme-component perl-motions ()
  "Part of vim-like perl motions."
  (global-set-key (kbd "$")   'end-of-line)
  (global-set-key (kbd "C-$") 'end-of-line)
  (global-set-key (kbd "M-$") 'kill-line)

  (global-set-key (kbd "C-à") 'beginning-of-line)
  (global-set-key (kbd "C-^") 'beginning-of-line)
  (global-set-key (kbd "M-à") 'bodhi-backward-kill-line))

; -------------- THEME ----------------------------

(ergoemacs-theme bodhi ()
  "Bodhi Ergoemacs Theme"
  :components   '(paddle
                  perl-motions
                  ergoemacs-remap)
  :optional-on  '(operator-motion)
  :optional-off '(guru no-backspace)
  :options-menu '(("Extreme ErgoEmacs" (guru no-backspace)
		   ("Operator>Motion" (operator-motion))))
)

(provide 'ergo-bodhi)

