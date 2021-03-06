(defvar auto-indent/delete-char-function 'delete-char)
(make-variable-buffer-local 'auto-indent/delete-char-function)
(defvar auto-indent/backward-delete-char-function 'backward-delete-char-untabify)
(make-variable-buffer-local 'auto-indent/backward-delete-char-function)

(defun auto-indent/backward-char ()
  (interactive)
  (if (auto-indent/point-at-beginning-of-line-text)
      (progn (beginning-of-line)
             (backward-char))
    (backward-char)))

(defun auto-indent/beginning-of-line ()
  (interactive)
  (beginning-of-line)
  (save-match-data
    (if (search-forward-regexp "[^ \t]" nil t)
        (backward-char)
      (indent-according-to-mode))))

(defun auto-indent/point-at-beginning-of-line-text ()
  (<= (point)
      (let ((old-p (point-marker)))
        (set-marker-insertion-type old-p t)
        (auto-indent/beginning-of-line)
        (let ((p (point)))
          (goto-char old-p)
          p))))

(defun auto-indent/delete-char ()
  (interactive)
  (if (= (point) (line-end-position))
      (progn
        (delete-region (point)
                       (progn (next-line)
                              (auto-indent/beginning-of-line)
                              (point)))

        (indent-according-to-mode))
    (apply auto-indent/delete-char-function '(1))))

(defun auto-indent/backward-delete-char ()
  (interactive)
  (if (auto-indent/point-at-beginning-of-line-text)
      (progn
        (delete-region (point)
                       (progn (previous-line)
                              (end-of-line)
                              (point)))
        (if (auto-indent/is-whitespace (line-beginning-position) (point))
            (indent-according-to-mode)))
    (apply auto-indent/backward-delete-char-function '(1))))


(defun auto-indent/open-line ()
  (interactive)
  (save-excursion
    (newline)
    (indent-according-to-mode)))

(defun auto-indent/yank ()
  (interactive)
  (setq this-command 'yank)
  (yank)
  (indent-region (mark t) (point)))

(defun auto-indent/yank-pop ()
  (interactive)
  (setq this-command 'yank)
  (yank-pop)
  (indent-region (mark t) (point)))

(defvar auto-indent/last-line 1)
(make-variable-buffer-local 'auto-indent/last-line)

(defvar auto-indent/line-change-hook '())

(defun auto-indent/pre-command ()
  (setq auto-indent/last-line (copy-marker (line-beginning-position))))

(defun auto-indent/is-whitespace (x y &optional no-empty)
  (string-match
   (concat "^[ \t]"
           (if no-empty "+" "*")
           "$")
   (buffer-substring x y)))

(defun auto-indent/post-command ()
  (unless undo-in-progress
    (let ((undo-list buffer-undo-list)
          (in-undo-block (car buffer-undo-list)))
      (let ((mod (buffer-modified-p))
            (buffer-undo-list (if in-undo-block
                                  buffer-undo-list
                                (cdr buffer-undo-list)))
            (inhibit-read-only t)
            (inhibit-point-motion-hooks t)
            before-change-functions
            after-change-functions
            deactivate-mark
            buffer-file-name
            buffer-file-truename)
        (if (and (/= auto-indent/last-line (line-beginning-position))
                 (not (eq this-command 'undo)))
            (progn
              (save-excursion
                (goto-char auto-indent/last-line)
                (if (auto-indent/is-whitespace (point) (line-end-position) t)
                    (delete-region (point) (line-end-position))))
              (if (auto-indent/is-whitespace (line-beginning-position) (point))
                  (if (auto-indent/is-whitespace (line-beginning-position) (line-end-position))
                      (indent-according-to-mode)
                    (auto-indent/beginning-of-line)))
              (run-hooks 'auto-indent/line-change-hook)))
        (and (not mod)
             (buffer-modified-p)
             (set-buffer-modified-p nil))
        (setq undo-list (if in-undo-block
                            buffer-undo-list
                          (cons nil buffer-undo-list))))
      (setq buffer-undo-list undo-list))))

(defun auto-indent-hook ()
  (interactive)
  (local-set-key [left] 'auto-indent/backward-char)
  (local-set-key [return] 'newline-and-indent)
  (local-set-key [delete] 'auto-indent/delete-char)
  (local-set-key (kbd "C-d") 'auto-indent/delete-char)
  (local-set-key [backspace] 'auto-indent/backward-delete-char)
  (local-set-key [home] 'auto-indent/beginning-of-line)
  (if (system-is-osx)
      (local-set-key (kbd "A-<left>") 'auto-indent/beginning-of-line))
  (local-set-key (kbd "C-o") 'auto-indent/open-line)
  (local-set-key (kbd "C-y") 'auto-indent/yank)
  (local-set-key (kbd "M-y") 'auto-indent/yank-pop)
  (add-hook 'pre-command-hook 'auto-indent/pre-command nil t)
  (add-hook 'post-command-hook 'auto-indent/post-command nil t))

(add-hook 'ruby-mode-hook 'auto-indent-hook)

