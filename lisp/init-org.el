;;; init-org.el --- Org-mode config -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

(setq calendar-week-start-day 1)

(require-package 'org)

;; recursively find .org files in provided directory
;; modified from an Emacs Lisp Intro example
(defun sa-find-org-file-recursively (&optional directory filext)
  "Return .org and .org_archive files recursively from DIRECTORY.
If FILEXT is provided, return files with extension FILEXT instead."
  (interactive "DDirectory: ")
  (let* (org-file-list
	 (case-fold-search t)	      ; filesystems are case sensitive
	 (file-name-regex "^[^.#].*") ; exclude dot, autosave, and backup files
	 (filext (or filext "org$\\\|org_archive"))
	 (fileregex (format "%s\\.\\(%s$\\)" file-name-regex filext))
	 (cur-dir-list (directory-files directory t file-name-regex)))
    ;; loop over directory listing
    (dolist (file-or-dir cur-dir-list org-file-list) ; returns org-file-list
      (cond
       ((file-regular-p file-or-dir) ; regular files
	(if (string-match fileregex file-or-dir) ; org files
	    (add-to-list 'org-file-list file-or-dir)))
       ((file-directory-p file-or-dir)
	(dolist (org-file (sa-find-org-file-recursively file-or-dir filext)
			  org-file-list) ; add files found to result
	  (add-to-list 'org-file-list org-file)))))))

;; You can use it like this:

;; (setq org-agenda-text-search-extra-files
;;       (append (sa-find-org-file-recursively "~/org/dir1/" "txt")
;;               (sa-find-org-file-recursively "~/org/dir2/" "tex")))


(setq org-directory "~/org")
(load-library "find-lisp")
(setq org-agenda-files
      (sa-find-org-file-recursively "~/org/" "org"))
; Do not add agenda files "by hand"
(add-hook 'org-mode-hook
          (lambda ()
            (org-defkey org-mode-map "\C-c["    'undefined)
            (org-defkey org-mode-map "\C-c]"    'undefined))
          'append)

;; TODO: do not take temporary org files (from editing) into account
(add-hook 'org-agenda-mode-hook (lambda () 
                                  (setq org-agenda-files 
                                        (sa-find-org-file-recursively "~/org/" "org"))
                                  ))


;; (setq org-agenda-files (list "~/org"))

;;(setq org-startup-folded 'showall)
(setq org-startup-folded 'showeverything)
(setq org-todo-keywords
      '((sequence "TODO(t)" "IN-PROGRESS(p!)" "FOLLOW-UP(f@!)" "WAITING(w@/!)" "|" "DONE(d!)" "NOTAVAILABLE(n!)" "CANCELLED(c@)")
        (sequence "TASK(k)" "|" "DONE(d!)" "CANCELLED(c@)")
        ))
(setq org-todo-keyword-faces
    '(("TODO" :background "red1" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("IN-PROGRESS" :background "orange" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("FOLLOW-UP" :background "orange" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("WAITING" :background "yellow" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("TASK" :background "deep sky blue" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("DONE" :background "forest green" :weight bold :box (:line-width 2 :style released-button))
      ("NOTAVAILABLE" :background "DarkOrchid1" :weight bold :box (:line-width 2 :style released-button))
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


(defun my-org-inline-css-hook (exporter)
  "Insert custom inline css"
  (when (eq exporter 'html)
    (let* ((dir (ignore-errors (file-name-directory (buffer-file-name))))
           (path (concat dir "style.css"))
           (homestyle (or (null dir) (null (file-exists-p path))))
           (final (if homestyle "~/.emacs.d/style.css" path))) ;; <- set your own style file path
      (setq org-html-head-include-default-style nil)
      (setq org-html-head (concat
                           "<style type=\"text/css\">\n"
                           "<!--/*--><![CDATA[/*><!--*/\n"
                           (with-temp-buffer
                             (insert-file-contents final)
                             (buffer-string))
                           "/*]]>*/-->\n"
                           "</style>\n")))))

(add-hook 'org-export-before-processing-hook 'my-org-inline-css-hook)


;; (require 'org-table)
;; (require 'org-clock)

;; (defun clocktable-by-tag/shift-cell (n)
;;   (let ((str ""))
;;     (dotimes (i n)
;;       (setq str (concat str "| ")))
;;     str))

;; (defun clocktable-by-tag/insert-tag (params)
;;   (let ((tag (plist-get params :tags)))
;;     (insert "|--\n")
;;     (insert (format "| %s | *Tag time* |\n" tag))
;;     (let ((total 0))
;; ;;      (mapcar
;;       (mapc
;;        (lambda (file)
;; 	 (let ((clock-data (with-current-buffer (find-file-noselect file)
;; 			     (org-clock-get-table-data (buffer-name) params))))
;; 	   (when (> (nth 1 clock-data) 0)
;; 	     (setq total (+ total (nth 1 clock-data)))
;; 	     (insert (format "| | File *%s* | %.2f |\n"
;; 			     (file-name-nondirectory file)
;; 			     (/ (nth 1 clock-data) 60.0)))
;; 	     (dolist (entry (nth 2 clock-data))
;; 	       (insert (format "| | . %s%s | %s %.2f |\n"
;; 			       (org-clocktable-indent-string (nth 0 entry))
;; 			       (nth 1 entry)
;; 			       (clocktable-by-tag/shift-cell (nth 0 entry))
;; 			       (/ (nth 3 entry) 60.0)))))))
;;        (org-agenda-files))
;;       (save-excursion
;; 	(re-search-backward "*Tag time*")
;; 	(org-table-next-field)
;; 	(org-table-blank-field)
;; 	(insert (format "*%.2f*" (/ total 60.0)))))
;;     (org-table-align)))

;; (defun org-dblock-write:clocktable-by-tag (params)
;;   (insert "| Tag | Headline | Time (h) |\n")
;;   (insert "|     |          | <r>  |\n")
;;   (let ((tags (plist-get params :tags)))
;;     (mapcar (lambda (tag)
;; 	      (setq params (plist-put params :tags tag))
;; 	      (clocktable-by-tag/insert-tag params))
;; 	    tags)))

;; (provide 'clocktable-by-tag)

(require 'org-table)
(require 'org-clock)
(require 'subr-x)

(defun clocktable-by-tag/shift-cell (n)
  (let ((str ""))
    (dotimes (i n)
      (setq str (concat str "| ")))
    str))

(defun clocktable-by-tag/insert-tag (params)
  (let ((tag (plist-get params :tags)) (total 0))
    (insert "|--\n")
    (insert (format "| %s | *Tag time* |\n" tag))
    (mapcar
     (lambda (file)
       (let ((clock-data (with-current-buffer (find-file-noselect file)
                           (org-clock-get-table-data (buffer-name) params))))
         (when (> (nth 1 clock-data) 0)
           (setq total (+ total (nth 1 clock-data)))
           (insert (format "| | File *%s* | %.2f |\n"
                           (file-name-nondirectory file)
                           (/ (nth 1 clock-data) 60.0)))
             (dolist (entry (nth 2 clock-data))
               (insert (format "| | . %s%s | %s %.2f |\n"
                               (org-clocktable-indent-string (nth 0 entry))
                               (nth 1 entry)
                               (clocktable-by-tag/shift-cell (nth 0 entry))
                               (/ (nth 4 entry) 60.0)))))))
       (org-agenda-files))
      
      (save-excursion
        (re-search-backward "*Tag time*")
        (if (= total 0)
            (progn
              (org-table-move-row-up)
              (org-table-kill-row)
              (org-table-kill-row)
              )
          (progn
            (org-table-next-field)
            (org-table-blank-field)
            (insert (format "*%.2f*" (/ total 60.0)))
          )
        ))
      (org-table-align) total))

(defun clocktable-by-tag/insert-only-tag (params)
  (let ((tag (plist-get params :tags)) (total 0))
    (mapcar
     (lambda (file)
       (let ((clock-data (with-current-buffer (find-file-noselect file)
                           (org-clock-get-table-data (buffer-name) params))))
         (when (> (nth 1 clock-data) 0)
           (setq total (+ total (nth 1 clock-data))))))

       (org-agenda-files))
        (unless(= total 0)
            (insert (format "| %s |%.2f|\n" tag (/ total 60.0))))
        (org-table-align) total))

(defun clocktable-by-tag/insert-percentage (total-sum time-column)
  (org-table-goto-line 0)
  (let*
      (
       (fields (org-split-string
               (buffer-substring (point-at-bol) (point-at-eol))
               "[ \t]*|[ \t]*"))
       (nfields (length fields))
       (percentage-column (+ nfields 1))
       )
    (org-table-goto-column percentage-column)
;;    (org-table-insert-column)
    (insert "%")
    (while (org-table-goto-line (+ (org-table-current-line) 1))
      (let* ((time-string (replace-regexp-in-string (regexp-quote "*") " " (org-table-get-field time-column)  nil 'literal))
             (current-time (string-to-number time-string)))
        (if (not (= current-time 0))
            (let ((percent-fmt (if (string-equal (string-trim (org-table-get-field 2)) "*Tag time*") "*%.2f*" "%.2f")))
              (org-table-goto-column percentage-column)
              (insert (format percent-fmt  (* (/ current-time total-sum) 6000))))
          )
        )
      
      )
  (org-table-align)))

(defun org-dblock-write:clocktable-by-tag (params)
  (insert "| Tag | Headline | Time (h) |\n")
  (insert "|     |          | <r>  |\n")
  (let ((tags (plist-get params :tags))(total-sum 0))
    (mapcar (lambda (tag)
              (setq params (plist-put params :tags tag))
              (setq total-sum (+ total-sum (clocktable-by-tag/insert-tag (plist-put (plist-put params :match tag) :tags tag)))))
            tags)
    (clocktable-by-tag/insert-percentage total-sum 3)
    ))

(defun org-dblock-write:clocktable-by-tag-percentage (params)
  (insert "| Tag | Time (h) |\n")
  (insert "|--\n")
  (let ((tags (plist-get params :tags))(total-sum 0))
    (mapcar (lambda (tag)
              (setq params (plist-put params :tags tag))
              (setq total-sum (+ total-sum (clocktable-by-tag/insert-only-tag (plist-put (plist-put params :match tag) :tags tag)))))
            tags)
    (clocktable-by-tag/insert-percentage total-sum 2)
    ))

(defun org-all-tags ()
  (setq comp_tag_list (sort (mapcar
                             (lambda (tag)
                               (substring-no-properties (car tag)))
                               (org-global-tags-completion-table))
                            'string<)
        ))

(provide 'clocktable-by-tag)



;; I use the following chunk of elisp to create a dynamic block containing a table where each row is a tag and number of use of that tag in the file. Add the block to your org file and hit C-c C-c to expand it:

;; #+BEGIN: tagblock
;; #+END:
;; If you only want to count certain tags you can add a :tags option to the block and to add a label to the resulting table use :label

;; #+BEGIN: tagblock :tags ("tag1" "tag2" "tag3") :label tag-counts
;; | tag1 | 2 |
;; | tag2 | 4 |
;; | tag3 | 8 |
;; #+END:
;; With the :todo option, only entries with a todo state (either any or in a list you specify) will be counted.

;; All the real work is done by the function org-freq-count which takes a parameterized search string (the same as an agenda tags search) and replaces %s in the search with each element of targets, counting the number of matches. If cmp is given, it will be used as a comparison function when sorting the output.

(require 's)
(require 'dash)

(defun org-freq-count (search targets &optional cmp)
  (let ((cmp (if (functionp cmp)
                 cmp
               (lambda (a b) nil))))
    
    (mapcar (lambda (x)
              (list x (length (org-map-entries t (format search x) nil))))
            (sort
             (delete-dups
              (-filter #'stringp targets))
             cmp)
            )
    ))

(defun org--tagblock-all-tags ()
  (-filter #'stringp (-map #'car (append
                                  (org-get-buffer-tags)
                                  org-tag-alist
                                  org-tag-persistent-alist))))

(defun org-write-freq-count (search targets name)
  (insert (s-concat
           (if name (insert (format "#+NAME: %s\n" name)))
           (mapconcat
            (lambda (x) (format "| %s | %s |" (nth 0 x) (nth 1 x)))
            (org-freq-count search targets)
            "\n")))
  (org-table-align)
  )

(defun org-dblock-write:tagblock (params)
  (let ((todo (plist-get params :todo))
        (tags (or (plist-get params :tags) (org--tagblock-all-tags)))
        (label (plist-get params :label))
        (caption (plist-get params :caption))
        )
    (when caption (insert (format "#+CAPTION: %s\n" caption)))
    (org-write-freq-count (cond ((equal todo t)
                                 (format "%%s/%s" (mapconcat 'identity
                                                             org-not-done-keywords
                                                             "|"
                                                             )))
                                ((listp todo)
                                 (format "%%s/%s" (mapconcat 'identity
                                                             todo
                                                             "|"
                                                             )))
                                (t "%s"))
                          tags
                          label
                          )))



(provide 'init-org)
;;; init-org.el ends here
