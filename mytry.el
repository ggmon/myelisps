;;common replacement list
(defvar my-common-replacement-alist
  '(("%filename%" . (lambda() (file-name-nondirectory (buffer-file-name))))
    ("%creator%" . user-full-name)
    ("%author%" . user-full-name)
    ("%date%". current-time-string)
))

;;java replacement list
(defvar my-java-replacement-alist
  '(("%classname%" . (lambda () (get-from-user "classname")))
    ("%superclass%" . (lambda () (get-from-user "superclass")))
    ("%interface%" . (lambda () (get-from-user "interface")))
))

;; perl replacement list
(defvar my-perl-replacement-alist
  '(("".(lambda () (get-from-user "")))
))

;; mambo replacement list
(defvar my-mambo-replacement-alist
  '(("".(lambda () (get-from-user "")))
))


;; get the value from the user
(defun get-from-user (prompt)
  (completing-read (concat prompt ":" )'()))


;; replace the holders 
(defun template-repalce-holders (from)
  (goto-char (point-min))
   (let ((the-list (append my-common-replacement-alist
   (cond ((equal from "java") my-java-replacement-alist)
         ((equal from "perl") my-perl-replacement-alist))) ))
       (while the-list
       (if (search-forward (car (car the-list)) (point-max) t)
       (progn
       (goto-char (point-min))  
       (replace-string (car (car the-list))
       (funcall (cdr (car the-list)))  nil)
       (setq the-list (cdr the-list)))
       (setq the-list (cdr the-list))))))


(defun cutme (to-cut-string)
;function to cut between the lines
  (let
     (beg end)
    (progn
      (re-search-backward to-cut-string)
      (setq beg (re-search-forward to-cut-string))
      (re-search-forward to-cut-string)
      (setq end (re-search-backward to-cut-string))
      (kill-region beg end)
      )))


(defun get-template ()
  (interactive)
  (let (beg end (file (concat "/mnt/sda7/RESOURCES/HELPMYSELF/TEMPLATES/" 
                              (completing-read "from:"
                                               (mapcar (lambda(str)(list (substring str 0 -4)))(directory-files "/mnt/sda7/RESOURCES/HELPMYSELF/TEMPLATES" nil "\\.tpl$"))) ".tpl"))
            (match (concat "----" (completing-read "what:" (list-current-entries)) "----")))
    (progn
      (with-temp-buffer 
        (message "%s" file)
        (insert-file-contents file)
        (setq beg (re-search-forward match))
        (re-search-forward match)
        (setq end (re-search-backward match))
        (copy-region-as-kill beg end))
      (yank)    
      (template-repalce-holders (substring (file-name-nondirectory file) 0 -4)))))



(defun write-template ()
  (interactive )
  (save-excursion
   (condition-case err
    (progn               
    (kill-ring-save (mark) (point))
    (switch-to-buffer (find-file (concat "/mnt/sda7/RESOURCES/HELPMYSELF/TEMPLATES/" (completing-read "To:"
                                               (mapcar (lambda(str)(list (substring str 0 -4)))(directory-files "/mnt/sda7/RESOURCES/HELPMYSELF/TEMPLATES" nil "\\.tpl$")))  ".tpl")))
      (goto-char (point-max))
      (let ((delimiter (concat "----" (completing-read "what: " '()) "----")))
      (insert delimiter)
      (yank)
      (insert delimiter))
      (insert  (kill-ring beg end))
      (save-buffer)
      (kill-buffer (current-buffer)))
    (mark-inactive ; condition
     (message "%s" (error-message-string err))))))




(defun search-and-list (searchstr)
  ;; seach for the list and give the list of 1'st subexp matches
  (save-excursion
  (goto-char (point-min))
  (let ((str-list '()))
    (while (re-search-forward searchstr nil t)
      (setq str-list (cons (list (buffer-substring-no-properties (match-beginning 1) (match-end 1))) str-list))) 
    str-list )))
  

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

