;;; init-org.el --- Org-mode config -*- lexical-binding: t -*-
;;; Commentary: fixes for accessing files in wsl2 linux through \\wsl$ by emacs
;;; See: https://www.reddit.com/r/emacs/comments/j18dce/getting_acls_inputoutput_error_using_nextcloud/g6z6wzm/
;;;      https://github.com/microsoft/WSL/issues/6004


(defun file-extended-attributes (filename)
  "Return an alist of extended attributes of file FILENAME.
   Extended attributes are platform-specific metadata about
   the file, such as SELinux context, list of ACL entries, etc."
  (cond
   ((fboundp 'ignore-errors)
    (ignore-errors
      `((acl . ,(file-acl filename))
        (selinux-context .
                         ,(file-selinux-context filename) ) ) ) )
   (t
    `((acl . ,(file-acl filename))
      (selinux-context .
                       ,(file-selinux-context filename) ) ) ) ) )

(provide 'init-wsl2)
