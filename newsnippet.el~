(defvar TEMPLATE-DIR "/home/ggmon/emacs/NEWTEMPLATES/")

(defun get-from-user (prompt)
  ;; get the value from user
  (completing-read (concat prompt ":")' ()))


(defvar my-common-replacement-alist
  ;;common replacement list
  '(("%filename%" . (lambda() (file-name-nondirectory (buffer-file-name))))
    ("%creator%" . user-full-name)
    ("%author%" . user-full-name)
    ("%date%". current-time-string)
))


(defun template-replace-holders ()
  ;; replace all the templates
  (goto-char (point-min))
  (let ((the-list (append my-common-replacement-alist '())))
        (while the-list
          (if (search-forward (car (car the-list)) (point-max) t)
              (progn
                (goto-char (point-min))
                (replace-string (car (car the-list))
                                (funcall (cdr (car the-list))) nil)
                (setq the-list (cdr the-list)))
            (setq the-list (cdr the-list))))))


(defun replace-potential-holders()
  ;; find and replace all the templates from the template
  (goto-char (point-min))
  (let (start end potential-holder)
    (while (search-forward-regexp "%.*%" (point-max) t)
      (progn
        (setq end (point))
        (setq start (search-backward-regexp "%.*%" (point-min) t))
        (goto-char (point-min))
        (setq potential-holder (buffer-substring start end))
        (replace-holder potential-holder)))))


(defun replace-holder (potential-holder)
  (replace-string potential-holder (get-from-user (substring potential-holder 1 -1))))


(defun get-template()
  (interactive)
  (let (beg end 
	    (file (concat TEMPLATE-DIR
			  (completing-read "from:"
					   (directory-files TEMPLATE-DIR)))) match)
    (progn
      (insert-file-contents
       (concat file "/" (completing-read "what:"(mapcar (lambda (str) (list (substring str 0 -4))) 
						     (directory-files (concat file "/" ) nil "\\.tpl$"))) ".tpl" ))
      (template-replace-holders )
      (replace-potential-holders))))


(defun write-template-old()
;;deprecated
  (interactive)
  (condition-case err
      (progn
	(kill-ring-save (mark) (point))
	(find-file 
	 (concat TEMPLATE-DIR 
		 (completing-read "To:"									 
				  (directory-files TEMPLATE-DIR )) "/"
		 (completing-read "what: " '()) ".tpl" ))
	(if (= (point-max) 1)
	    (yank)
	  (progn
	    (kill-buffer (current-buffer))
	    (error "Template by the same name already exists.")
	    ))
	(save-buffer))
	 (mark-inactive ; condition
     (message "%s" (error-message-string err)))))
		 


(defun write-template()
  (interactive)
  (condition-case err
      (let (where what)
	(progn
	  (kill-ring-save (mark) (point))
	  (setq where (completing-read "To:" (directory-files TEMPLATE-DIR)))
	  (setq what (completing-read "what:" '()))
	  (if (not (file-directory-p (concat TEMPLATE-DIR where)))
	      (make-directory (concat TEMPLATE-DIR where)))
	  (find-file 
	   (concat TEMPLATE-DIR where "/" what ".tpl"))
	  (if (= (point-max) 1)
	      (yank)
	    (progn
	      (kill-buffer (current-buffer))
	      (error "Template by the same name already exists.")
	      ))
	  (save-buffer)))
    (mark-inactive
     (message "%s" (error-message-string err)))))



(defun generate-template-list()
  (interactive)
  (let ((topdirs (directory-files TEMPLATE-DIR)) tempdir )
    (while ( car topdirs)
      (progn
      (setq tempdir (car topdirs))
      (setq topdirs (cdr topdirs))
      (insert (concat "\n+" tempdir))
      (printpl tempdir)
      )
      )
    )
  )

(defun printpl (dir)
  (let ((tpl-files (directory-files (concat TEMPLATE-DIR "/") nil "\\.tpl$")) tpl)
    (while (car tpl-files)
      (progn
        (setq tpl (car tpl-files))
        (setq tpl-files (cdr tpl-files))
        (insert (concat "\n  " tpl))
        )
      )
    )
  )



