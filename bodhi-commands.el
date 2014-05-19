
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
