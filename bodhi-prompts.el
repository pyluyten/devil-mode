

(defun bodhi-prompt (&optional message)
 (interactive)
 (unless message (setq message "Enter:"))
 (setq x (read-char-exclusive message)))



(defun bodhi-find-prompt ()
  (interactive)
  (setq c (bodhi-prompt "Search: f/r i/j/k/l ?"))
  (print (format "ur key is %s" c))
  (cond
   ((eq c 102) ;f
    (isearch-forward))
   ((eq c 114) ; r
    (isearch-backward))
   ((eq c 105) ; i
    (isearch-backward))
   ((eq c 107) ; k
    (isearch-forward))
   ((eq c 106) ; j
    (isearch-backward-regexp))
   ((eq c 108) ; l
    (isearch-forward-regexp))
   (t
    (bodhi-find-prompt))))



(provide 'bodhi-prompts)
