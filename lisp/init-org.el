;;; init-org.el --- Org-mode config -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

(setq org-startup-folded 'showeverything)
(setq org-todo-keywords
      '((sequence "TODO(t)" "IN-PROGRESS(p!)" "FOLLOW-UP(f@!)" "WAITING(w@/!)" "|" "DONE(d!)" "CANCELLED(c@)")
        (sequence "TASK(k)" "|" "DONE(d!)" "CANCELLED(c@)")
        ))
(setq org-todo-keyword-faces
    '(("TODO" :background "red1" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("IN-PROGRESS" :background "orange" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("FOLLOW-UP" :background "orange" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("WAITING" :background "yellow" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("TASK" :background "deep sky blue" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("DONE" :background "forest green" :weight bold :box (:line-width 2 :style released-button))
      ("CANCELLED" :background "lime green" :foreground "black" :weight bold :box (:line-width 2 :style released-button))))

(setq org-enforce-todo-dependencies t)
(setq org-log-done (quote time))
(setq org-log-into-drawer t)
(setq org-catch-invisible-edits (quote show))
;(setq org-log-redeadline (quote time))
;(setq org-log-reschedule (quote time))
;(setq org-blank-before-new-entry (quote ((heading) (plain-list-item))))

(setq org-refile-use-outline-path 'file)
(setq org-refile-targets '((org-agenda-files . (:maxlevel . 3))))

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-iswitchb)

(provide 'init-org)
;;; init-org.el ends here
