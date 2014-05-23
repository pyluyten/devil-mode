
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



(defun bodhi-backward-kill-line ()
  "Kill ARG lines backward."
  (interactive)
  (kill-line (- 0)))

(defun bodhi-yank-end-of-line ()
  "Copy up to end of line."
  (interactive)
  (kill-ring-save (point) (line-beginning-position 2)))



(defun bodhi-new-empty-buffer ()
  "Opens a new empty buffer."
  (interactive)
  (let ((buf (generate-new-buffer "untitled")))
    (switch-to-buffer buf)
    (funcall (and initial-major-mode))
    (setq buffer-offer-save t)))



(defun bodhi-close-tab ()
  "Closes Current tab.
If tab is the only one, closes window.
If window is the only one, kill buffer."
  (interactive)
  (setq win (next-window (next-window)))
  (if win
    (if (eq win (next-window))
         (kill-buffer)
         (delete-window))))

(provide 'bodhi-commands)
