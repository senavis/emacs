(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/vendor")

;(server-start)

(load-library "visual")
(load-library "util")
(load-library "misc")
(load-library "show-paren-offscreen")
(load-library "auto-indent")
(load-library "site-c-esque")
(load-library "time-mode")
(load-library "notes-mode")

(load "haskell-mode-2.4/haskell-site-file.el")
(autoload 'cycle-buffer "cycle-buffer" "Cycle forward." t)
(require 'anything-config)
;(load "auctex.el" nil t t)
;(load "preview-latex.el" nil t t)
(load-library "site-yasnippet")
(load-library "site-rst")
(load-library "site-io")
(load-library "python-mode")
(load-library "site-cpp")
(load-library "site-lisp")
(load-library "site-compilation")
(load-library "site-org")
(load-library "runfile")
(load-library "compile")

(require 'haml-mode)
(require 'paredit)
(require 'no-word)
(add-to-list 'auto-mode-alist '("\\.doc\\'" . no-word))
(load-library "keys")

(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

(autoload 'csharp-mode "csharp-mode" "Major mode for editing C# code." t)
(autoload 'd-mode "d-mode" "Major mode for editing D code." t)
(require 'vbnet-mode)

;;display time
(display-time)

(add-to-list 'auto-mode-alist '("\\.d[i]?\\'" . d-mode))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.rb\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\work-hours\\'" . time-mode))
(add-to-list 'auto-mode-alist '("\\.cs$" . csharp-mode))
(add-to-list 'auto-mode-alist '("\\.vb$" . vbnet-mode))

(setq auto-mode-alist (append '() auto-mode-alist))

(global-set-key (kbd "<f7>") 'run-current-file)
(global-set-key (kbd "<f9>") 'my-compile)