

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
   "
    f: isearch-forward
    r: isearch-backward

    i: isearch-backward
    j: isearch-backward-regexp
    k: isearch-forward-regexp
    l: evil-find-char

    b: regexp-builder"))
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


(defun bodhi-replace-do-prompt ()
  (interactive)
  (setq c (bodhi-prompt "Search"
   "
    r: query-replace-regexp
    f: query-replace
    i: replace-string
    k: overwrite-mode
    l: replace-regexp
    j: join-line (following)
    J: join-line (previous)
    z: zap-to-char"))
  (cond
   ((eq c ?r)
    (call-interactively 'query-replace-regexp))

   ((eq c ?f)
    (call-interactively 'query-replace))
   ((eq c ?k)
    (call-interactively 'overwrite-mode))
   ((eq c ?i)
    (call-interactively 'replace-string))
   ((eq c ?l)
    (call-interactively 'replace-regexp))
   ((eq c ?j)
    (join-line 1))
   ((eq c ?J)
    (join-line))
   ((eq c ?z)
    (call-interactively 'zap-to-char))
   (t
    (keyboard-quit))))


(defun bodhi-replace-prompt ()
  (interactive)
  (if (or (eq overwrite-mode 'overwrite-mode-textual)
	  (eq overwrite-mode 'overwrite-mode-binary))
    (overwrite-mode -1)
    (bodhi-replace-do-prompt)))

(provide 'bodhi-prompts)
