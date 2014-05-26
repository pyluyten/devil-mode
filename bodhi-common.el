
(add-to-list 'load-path "./")

(require 'transpose-frame)
(require 'bodhi-tile)

(require 'bodhi-prompts)
(require 'bodhi-commands)


; ---- aliases -----------------------

; FIXME: rather we want a .alias file user could investigate
;        and customize.
; keep sorted per function (not alias).

(defalias 'bj      'bookmark-jump)
(defalias 'bk      'bookmark-set)
(defalias 'one     'delete-other-windows)
(defalias 'clo     'delete-window)
(defalias 'eb      'eval-buffer)
(defalias 'e!      'revert-buffer)
(defalias 'q       'save-buffers-kill-terminal)
(defalias 'vs      'split-window-right)
(defalias 'w       'save-buffer)

(provide 'bodhi-common)
