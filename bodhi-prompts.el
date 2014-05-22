

(defun bodhi-prompt (&optional title message)
 (interactive)
 (setq curb (current-buffer))
 (unless title (setq title "Enter:"))
 (setq buf (generate-new-buffer title))
 (view-buffer-other-window buf)
 (read-only-mode t)
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
           "k: isearch-forward-regexp\n"
           "l: evil-find-char\n"
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
    ;; TODO - don't use evil- in this file.
    (call-interactively 'evil-find-char))
   ((eq c ?b)
    (regexp-builder))
   (t
    (keyboard-quit))))


(defun bodhi-replace-prompt ()
  (interactive)
  (setq c (bodhi-prompt "Search"
   (concat "r: query-replace-regexp\n"
           "i: query-replace\n"
           "j: replace-string\n"
           "k: replace-string\n"
           "l: replace-regexp")))
  (cond
   ((eq c ?r)
    (call-interactively 'query-replace-regexp))

   ((eq c ?i)
    (call-interactively 'query-replace))
   ((eq c ?k)
    (call-interactively 'replace-string))
   ((eq c ?j)
    (call-interactively 'replace-string))
   ((eq c ?l)
    (call-interactively 'replace-regexp))
   (t
    (keyboard-quit))))

(provide 'bodhi-prompts)
