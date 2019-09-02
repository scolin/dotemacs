;;; init-spacetab.el --- Space and tabs preferences -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

;; Deactivate tabs. Local modes may still activate it
(setq-default indent-tabs-mode nil)

(global-whitespace-mode)
(setq whitespace-style '(face tabs tab-mark trailing))
(custom-set-faces
;; '(whitespace-tab ((t (:foreground "#636363")))))
 '(whitespace-tab ((t (:foreground "#c1c1c1")))))

(setq whitespace-display-mappings
  '((tab-mark 9 [124 9] [92 9])))

(provide 'init-spacetab)
;;; init-spacetab.el ends here
