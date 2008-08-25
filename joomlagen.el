(setq joomla-admin-files '("admin.%%.html.php" "admin.%%.php"
"%%_items.xml" "%%.xml"
                          "index.html" "toolbar.%%.html.php" "toolbar.%%.php"))



(defun joomla-admin()
 (interactive)
 (let (module-name)
 (setq module-name (completing-read (concat "module-name:") '()))
 (mapcar (lambda (file) (make-files file) )  (mapcar (lambda (str)
(replace-regexp-in-string "%%" module-name str)) joomla-admin-files))
 )
 )



(defun make-files (file)
 (switch-to-buffer (find-file (concat "./" file)))
 (insert (concat "/* file : " file  "*/"))
 (save-buffer)
 (kill-buffer (current-buffer))
 )