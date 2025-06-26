;;; latex-send-python.el --- Run lstlisting / lstinline Python code -*- lexical-binding: t; -*-
;;;
;;; Commentary:
;;; When editing a latex document containing Python code
;;; provide latex-send-python that sends the Python listing
;;; to the python interpreter.
;;
;; Install:  Add this file to a directory in `load-path`, or
;;           `(add-to-list 'load-path "~/.emacs.d/lisp")`
;;
;; Usage:    `M-x latex-send-python` inside LaTeX buffers
;;              * this will send the marked block
;;              * or this will send the current lstlisting
;;              * or this will send the current lstinline
;;            to the running python process
;;
;;; Code:

(require 'cl-lib)
(require 'python)
(require 'latex nil t)

(defun ensure-python-shell ()
  "When no python shell is running, start it."
  (save-selected-window
    (unless (python-shell-get-process)
      (run-python nil nil t))))

(defun latex--inside-lstinline-p ()
  "Return t when we are inside \\lstinline."
  (save-excursion
    (let ((pos (point)))
      (when (re-search-backward
             "\\\\lstinline\\(?:\\[[^]]*\\]\\)?\\(.\\)" nil t)
        (let* ((delim (match-string 1))
               (beg (match-end 0))
               (end (save-excursion
                      (goto-char beg)
                      (search-forward delim nil t))))
          (and end (<= beg pos) (< pos end)))))))

(defun latex--lstinline-bounds ()
  "Return the bounds of the \\lstinline latex."
  (save-excursion
    (re-search-backward "\\\\lstinline\\(?:\\[[^]]*\\]\\)?\\(.\\)" nil t)
    (let* ((delim (match-string 1))
           (beg (match-end 0))
           (end (search-forward delim nil t)))
      (cons beg (1- end)))))

;;;###autoload
(defun latex-send-python ()
  "Send region, \\lstinline, or \\lstlisting at point to the inferior Python."
  (interactive)
  (ensure-python-shell)
  (cond
   ((use-region-p)
    (python-shell-send-region (region-beginning) (region-end)))
   ((latex--inside-lstinline-p)
    (cl-destructuring-bind (beg . end) (latex--lstinline-bounds)
      (python-shell-send-string
       (buffer-substring-no-properties beg end))))
   (t
    (save-excursion
      (LaTeX-find-matching-begin)
      (re-search-forward
       "\\\\begin{lstlisting}\\(\\[[^]\n]*\\]\\)?[ \t]*\n")
      (let ((beg (point)))
        (re-search-forward "\\\\end{lstlisting}")
        (python-shell-send-region beg (match-beginning 0)))))))

(provide 'latex-send-python)
;;; latex-send-python.el ends here
