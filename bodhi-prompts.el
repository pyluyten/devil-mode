

(defun bodhi-prompt (&optional title message)
 (interactive)
 (setq curb (current-buffer))
 (unless title (setq title "Enter:"))
 (setq buf (generate-new-buffer title))
 (read-only-mode t)
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
           "l: isearch-forward-regexp\n"
           "\nb: regexp-builder")))
  (cond
   ((eq c ?f)
    (isearch-forward))
   ((eq c ?r)
    (isearch-backward))
   ((eq c ?i)
    (isearch-backward))
   ((eq c ?k)
    (isearch-forward))
   ((eq c ?j)
    (isearch-backward-regexp))
   ((eq c ?l)
    (isearch-forward-regexp))
   ((eq c ?b)
    (regexp-builder))
   (t
    (keyboard-quit))))


(provide 'bodhi-prompts)
