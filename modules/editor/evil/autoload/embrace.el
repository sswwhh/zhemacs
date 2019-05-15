;;; editor/evil/autoload/embrace.el -*- lexical-binding: t; -*-

;;;###autoload
(defun +evil--embrace-get-pair (char)
  (if-let* ((pair (cdr-safe (assoc (string-to-char char) evil-surround-pairs-alist))))
      pair
    (if-let* ((pair (assoc-default char embrace--pairs-list)))
        (if-let* ((real-pair (and (functionp (embrace-pair-struct-read-function pair))
                                  (funcall (embrace-pair-struct-read-function pair)))))
            real-pair
          (cons (embrace-pair-struct-left pair) (embrace-pair-struct-right pair)))
      (cons char char))))

;;;###autoload
(defun +evil--embrace-escaped ()
  "Backslash-escaped surround character support for embrace."
  (let ((char (read-char "\\")))
    (if (eq char 27)
        (cons "" "")
      (let ((pair (+evil--embrace-get-pair (string char)))
            (text (if (sp-point-in-string) "\\\\%s" "\\%s")))
        (cons (format text (car pair))
              (format text (cdr pair)))))))

;;;###autoload
(defun +evil--embrace-latex ()
  "LaTeX command support for embrace."
  (cons (format "\\%s{" (read-string "\\")) "}"))

;;;###autoload
(defun +evil--embrace-elisp-fn ()
  "Elisp function support for embrace."
  (cons (format "(%s " (or (read-string "(") "")) ")"))
