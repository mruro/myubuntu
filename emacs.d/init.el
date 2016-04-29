(require 'package)
(add-to-list 'package-archives
   '("melpa" . "http://melpa.milkbox.net/packages/") t)

(add-to-list 'load-path "~/.emacs.d/golang")
(require 'go-mode-autoloads)

(setq backup-directory-alist
  `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
  `((".*" ,temporary-file-directory t)))

; From http://tleyden.github.io/blog/2014/05/22/configure-emacs-as-a-go-editor-from-scratch/ below

