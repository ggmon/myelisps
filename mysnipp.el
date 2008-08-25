(defun ee (s e)
  "Save the region in a temprory script"
  (interactive "r")
  (write-region s e "~/ee.sh"))


(defun  eev (s e)
  "Like 'ee', but the script executes in verbose mode"
(interactive "r")
(write-region 
 (concat "set -v\n" (buffer-substring s e)
         "\nset +v")
 nil "~/ee.sh"))