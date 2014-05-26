;; emacsd-tile.el -- tiling windows for emacs
;; original emacsd-tile.el defined its keybind. What i want here is functions


(defun bodhi-swap-with (dir)
  (interactive)
  (let ((other-window (windmove-find-other-window dir)))
    (when other-window
      (let* ((this-window  (selected-window))
             (this-buffer  (window-buffer this-window))
             (other-buffer (window-buffer other-window))
             (this-start   (window-start this-window))
             (other-start  (window-start other-window)))
        (set-window-buffer this-window  other-buffer)
        (set-window-buffer other-window this-buffer)
        (set-window-start  this-window  other-start)
        (set-window-start  other-window this-start)))))



(defun bodhi-win-down () (interactive) (bodhi-swap-with 'down))
(defun bodhi-win-up   () (interactive) (bodhi-swap-with 'up))
(defun bodhi-win-left () (interactive) (bodhi-swap-with 'left))
(defun bodhi-win-right () (interactive) (bodhi-swap-with 'right))

(provide 'bodhi-tile)
