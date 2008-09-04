(setq FIRST "/home/ggmon/scrapsilos/NEWTEMPLATES_HOME")
(setq SECD "/home/ggmon/scrapsilos/NEWTEMPLATES_OFFICE")
(setq RSLT "/home/ggmon/scrapsilos/RESULT")
(defun is-in-list (list1 val)
  (catch 'break
  (while (car list1)
    (if (equal val (car list1))
        (throw 'break t))
      (setq list1 (cdr list1))
  )
  nil
  ))

(defun join-list(list1 list2) 
    (while (car list2)
      (if (not (is-in-list list1 (car list2)))
      (setq list1 (cons (car list2) list1)))
      (setq list2 (cdr list2)))
    list1)



(setq completelist (join-list (directory-files FIRST nil "[^\\.*]") (directory-files SECD nil "[^\\.*]") ))


(mapcar (lambda (nm) (if (not (file-exists-p (concat RSLT "/" nm)))
                          (make-directory (concat RSLT "/" nm)))) completelist)


(defun copy-tpl-files(dir)
  (let ((topdirs (directory-files dir nil  "[^\\.*]")))
    (while (car topdirs)
      (copy-tpls-if-not-exists dir (car topdirs))
      (setq topdirs (cdr topdirs))
      )
    ))

(defun copy-tpls-if-not-exists (dir tpldir )
  (let ((tplfiles (directory-files (concat dir "/" tpldir) nil "[^\\.*]")))
    (while (car tplfiles)
      (if (not (file-exists-p (concat RSLT "/" tpldir "/" (car tplfiles))))
          (copy-file (concat dir "/" tpldir "/" (car tplfiles))
                     (concat RSLT "/" tpldir "/" (car tplfiles)))
        )
      (setq tplfiles (cdr tplfiles)))))
 


(copy-tpl-files FIRST)
(copy-tpl-files SECD)







        
        