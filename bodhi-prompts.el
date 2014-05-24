

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


(defun bodhi-global-prompt ()
  "Access global functions."
  (interactive)
  (setq c (bodhi-prompt "Global"
     "
     ==== GOTO ==========        === GLOBAL ===
     i: beginning of buffer      r: revert-buffer
     g: goto line                t: transpose-frame
     k: end of buffer
                                 n: evil-normal-state
     $: next buffer              v: evil-visual-line
     o: other window             V: evil-visual-block

     j: bookmark-jump            b: bookmark-set"))
  (cond
   ((eq c ?i)
    (beginning-of-buffer))
   ((eq c ?k)
    (end-of-buffer))
   ((eq c ?g)
    (goto-line))
   ((eq c ?$)
    (next-buffer))
   ((eq c ?o)
    (other-window 1))
   ((eq c ?n)
    (evil-normal-state))
   ((eq c ?v)
    (evil-visual-line))
   ((eq c ?V)
    (evil-visual-block))
   ((eq c ?r)
    (revert-buffer))
   ((eq c ?b)
    (call-interactively 'bookmark-set))
   ((eq c ?j)
    (call-interactively 'bookmark-jump))
   ((eq c ?t)
    (transpose-frame))
   (t
    (keyboard-quit))))



(defun bodhi-find-prompt ()
  (interactive)
  (setq c (bodhi-prompt "Search"
   "
    f: isearch-forward
    r: isearch-backward

    j: isearch-backward-regexp
    k: isearch-forward-regexp
    l: evil-find-char

    b: regexp-builder"))
  (cond
   ((eq c ?f)
    (if mark-active
      (progn
	(call-interactively 'isearch-forward)
	(isearch-yank-string (buffer-substring-no-properties (region-beginning) (region-end))))
      (isearch-forward)))
   ((eq c ?r)
    (isearch-backward))
   ((eq c ?k)
    (if mark-active
      (progn
	(call-interactively 'isearch-forward-regexp)
	(isearch-yank-string (buffer-substring-no-properties (region-beginning) (region-end))))
    (isearch-forward-regexp)))
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
    l: replace-regexp

    k: overwrite-mode

    j: join-line (following)
    J: join-line (previous)

    z: zap-to-char

    u: UPCASE-WORD
    d: downcase-word
    c: Capitalize-Word"))
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
   ((eq c ?u)
    (call-interactively 'upcase-word))
   ((eq c ?d)
    (call-interactively 'downcase-word))
   ((eq c ?c)
    (call-interactively 'capitalize-word))
   (t
    (keyboard-quit))))


(defun bodhi-replace-prompt ()
  (interactive)
  (if (or (eq overwrite-mode 'overwrite-mode-textual)
	  (eq overwrite-mode 'overwrite-mode-binary))
    (overwrite-mode -1)
    (bodhi-replace-do-prompt)))

(provide 'bodhi-prompts)
