(setq org "/mnt/sda7/RESOURCES/HELPMYSELF/TEMPLATES/")
(setq new "/mnt/sda7/RESOURCES/HELPMYSELF/NEWTEMPLATES/")

(defun recreate-templates()
  (interactive)
  (save-excursion
    (let ((tpls  (directory-files org nil "\\.tpl$")) tpl)
      (while (car tpls)
        (progn
          (setq tpl (car tpls))
          (setq tpls (cdr tpls))
          (migrate-template tpl)
          )
        )
      )
    )
  )

(defun migrate-template (tpl)
  (let ((tpldir (substring tpl 0 -4)) tpl-list)
    (progn
      (if (not (file-directory-p (concat new tpldir)))
          (dired-create-directory (concat new tpldir)))
      (with-temp-buffer
        (insert-file-contents (concat org tpl))
        (setq tpl-list (list-current-entries))
        )
      (create-template-pages tpl tpl-list)
      )
    )
  )

(defun create-template-pages (tpl tpl-list)
  (let (beg end  match  match-str tpl-string)
    (while (car tpl-list)
      (with-temp-buffer
        (insert-file-contents (concat org tpl))
        (setq match (car (car tpl-list)))
        (setq tpl-list (cdr tpl-list))
        (setq match-str (concat "----" match "----"))
        (setq beg (re-search-forward match-str))
        (re-search-forward match-str)
        (setq end (re-search-backward match-str))
        (setq tpl-string (buffer-substring beg end))
        )
      (switch-to-buffer (find-file (concat new (substring tpl 0 -4)"/" match ".tpl")))
      (insert tpl-string)
      (save-buffer)
      (kill-buffer (current-buffer))
      )
    )
  )

(defun search-and-list (searchstr)
  ;; seach for the list and give the list of 1'st subexp matches
  (save-excursion
    (goto-char (point-min))
    (let ((str-list '()))
      (while (re-search-forward searchstr nil t)
        (setq str-list (cons (list (buffer-substring-no-properties (match-beginning 1) (match-end 1))) str-list)))
      str-list )
    )
  )

(defun wrap-for-template ()
  ;; wrap search-and-list for mytemplates
  (interactive)
  (search-and-list "----\\\(.*\\\)----"))

(defun remove-double (str-list)
  ;; remove the double list which occur in the list
  (let ((newlist '()) (templist str-list))
    (while (car templist)
      (progn
        (setq newlist (cons (car templist) newlist))
        (setq templist (cdr (cdr templist)))))
    newlist
    ))

(defun list-current-entries ()
  (interactive)
  ;; get the list of entries for auto completion
  (remove-double (wrap-for-template)))


