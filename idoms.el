(setq IDOMS-DIR "/mnt/sda7/RESOURCES/HELPMYSELF/IDOMS/")

(defun get-idoms()
  (interactive)
  (let ((file (concat IDOMS-DIR
                              (completing-read "from:"
                                (mapcar (lambda (str) (list (substring str 0 -5)))
                                        (directory-files IDOMS-DIR nil "\\.idms$"))) ".idms")) match)
    (progn
      
      (pop-to-buffer "*idoms*")
      (setq buffer-read-only nil)
      (kill-region (point-min) (point-max))
      (insert-file-contents file)
      (muse-mode)
      (setq match (concat "^\*\* " (completing-read "what:" (list-entries))))
      (re-search-forward match)
      (setq buffer-read-only t)
      )))



(defun list-entries ()
  (interactive)
  (search-and-list "^\\*\\* \\\(.*\\\)$"))



(defun search-and-list (searchstr)
  ;; search for the list and give the lsit of 1'st subexp matches

  (save-excursion
  (goto-char (point-min))
  (let ((str-list '()))
    (while (re-search-forward searchstr nil t)
      (setq str-list (cons (list (buffer-substring-no-properties (match-beginning 1) (match-end 1))) str-list)))
    str-list)))


(defun write-idoms()
  (interactive)
  (condition-case err
      (progn
        (kill-ring-save (mark) (point))
        (switch-to-buffer (find-file (concat IDOMS-DIR
                                             (completing-read "to:"
                                                              (mapcar (lambda (str) (list (substring str 0 -5)))
                                                                      (directory-files IDOMS-DIR nil "\\.idms$"))) ".idms")))
        (init-idom-file)
        (write-idom-headers)
        (insert "<verse>")
        (newline)
        (yank)
        (newline)
        (insert "</verse>")
        (newline)
        (newline)
        (insert "----")
        (re-search-backward "%Please Fill your Description%")
        )
      (mark-inactive ; condition
       (message "%s" (error-message-string err)))))




(defun write-idom-headers()
  (progn
    (goto-char (point-max))
    (newline)
    (newline)
    (insert (concat "** " (completing-read "Title: " '())))
    (newline)
    (insert (concat "=" (current-time-string) "="))
    (newline)
    (newline)
    
    (insert "%Please Fill your Description%")
    (newline)
    (newline)))


(defun init-idom-file ()
  (if (eq (point-max) (point-min))
      (progn
        (insert "#author ggmon")
        (newline)
        (insert (concat "#title " (completing-read "Please Enter A Title for the File: " '())))
        (newline)
        (insert "<contents>")
        (newline)
        (insert (concat "* " (completing-read "Please Enter A Title for the File: " '())))
        
        (newline)
        (newline)
        
        )))
          


(defun read-idoms()
  (interactive)
  (let (beg end (file (concat IDOMS-DIR
                              (completing-read "from:"
                                (mapcar (lambda (str) (list (substring str 0 -5)))
                                        (directory-files IDOMS-DIR nil "\\.idms$"))) ".idms")) match)

    (progn
      (pop-to-buffer "*idoms*")
      (setq buffer-read-only nil)
      (kill-region (point-min) (point-max))
      (with-temp-buffer
        (insert-file-contents file)
        (message (int-to-string (point-max)))
        (setq match (concat "^\*\* " (completing-read "what:" (list-entries)) ))
        (re-search-forward match)
        (setq beg (re-search-backward match))
        (re-search-forward "^----")
        (setq end (re-search-backward "^----"))
        (copy-region-as-kill beg end))
      (yank)
      (muse-mode)
      (goto-char (point-min))
      (re-search-forward match)
      (setq buffer-read-only t)
      )))






