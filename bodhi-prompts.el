

(defun bodhi-prompt (&optional title message)
 (interactive)
 (setq curb (current-buffer))
 (unless title (setq title "Enter:"))
 (setq buf (generate-new-buffer title))
 (view-buffer-other-window buf)
 (funcall (and initial-major-mode))
 (setq message
   (concat "\n~~~ ☸ ~~~\n" ; U+2638
           "\n\n\n\n"
           message))
 (insert message)
 (setq x (read-char-exclusive))
 (quit-window)
 (kill-buffer buf)
 (switch-to-buffer curb)
 (setq x x))



(defun bodhi-find-prompt ()
  (interactive)
  (setq c (bodhi-prompt "Search"
   (concat "f: isearch-forward\n"
           "r: isearch-backward\n\n"
           "i: isearch-backward\n"
           "j: isearch-backward-regexp\n"
           "k: isearch-forward\n"
           "l: isearch-forward-regexp")
  ))
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
    (keyboard-quit))))


(provide 'bodhi-prompts)
