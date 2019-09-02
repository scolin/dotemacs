;;; init-paragraph.el --- Space and tabs preferences -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

;; Auto-fill for all text modes, at 80 columns
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(setq-default fill-column 80)

;;; Stefan Monnier <foo at acm.org>. It is the opposite of fill-paragraph    
(defun unfill-paragraph (&optional region)
  "Takes a multi-line paragraph and makes it into a single line of text."
  (interactive (progn (barf-if-buffer-read-only) '(t)))
  (let ((fill-column (point-max))
        ;; This would override `fill-column' if it's an integer.
        (emacs-lisp-docstring-fill-column t))
    (fill-paragraph nil region)))

;; Handy key definition
(define-key global-map "\M-Q" 'unfill-paragraph)

(provide 'init-paragraph)
;;; init-paragraph.el ends here
