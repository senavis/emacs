
(defun run-current-file ()
  "Execute or compile the current file.
For example, if the current buffer is the file x.pl,
then it'll call “perl x.pl” in a shell.
The file can be php, perl, python, ruby, javascript, bash, ocaml, java.
File suffix is used to determine what program to run."
  (interactive)
  (let (extention-alist fname suffix progName cmdStr)
    (setq extention-alist ; a keyed list of file suffix to comand-line program to run
          '(
            ("php" . "php")
            ("pl" . "perl")
            ("py" . "python")
            ("rb" . "ruby")
            ("js" . "js")
            ("sh" . "bash")
            ("ml" . "ocaml")
            ("vbs" . "cscript")
            ("java" . "javac")
            )
          )
    (setq fname (buffer-file-name))
    (setq suffix (file-name-extension fname))
    (setq progName (cdr (assoc suffix extention-alist)))
    (setq cmdStr (concat progName " \""   fname "\""))

    (if (string-equal suffix "el")
        (load-file fname)
      (if progName                      ; is not nil
          (progn
            (message "Running...")
            (shell-command cmdStr))
        (message "No recognized program file suffix for this file.")
        ) )))