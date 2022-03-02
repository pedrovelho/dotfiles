(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

; If your are having problems finding your package call refresh below
;(package-refresh-contents)

; list the packages you want
(setq package-list '(nix-mode yaml-mode python-mode markdown-mode))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

;; Tell emacs where is your personal elisp lib dir
(add-to-list 'load-path "~/.emacs.d/lisp/")

(add-hook 'yaml-mode-hook
  '(lambda ()
     (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

;; Fuck you bell
(setq ring-bell-function 'ignore)

(add-to-list 'load-path "~/.emacs.d/site-lisp/nix-mode/")

(with-eval-after-load 'info
  (info-initialize)
  (add-to-list 'Info-directory-list
               "~/.emacs.d/site-lisp/nix-mode/"))


;; Set ident as n spaces everywhere
(defun my-setup-indent (n)
  ;; java/c/c++
  (setq-local c-basic-offset n)
  ;; web development
  (setq-local coffee-tab-width n) ; coffeescript
  (setq-local javascript-indent-level n) ; javascript-mode
  (setq-local js-indent-level n) ; js-mode
  (setq-local js2-basic-offset n) ; js2-mode, in latest js2-mode, it's alias of js-indent-level
  (setq-local web-mode-markup-indent-offset n) ; web-mode, html tag in html file
  (setq-local web-mode-css-indent-offset n) ; web-mode, css in html file
  (setq-local web-mode-code-indent-offset n) ; web-mode, js code in html file
  (setq-local css-indent-offset n) ; css-mode
  (setq-local python-mode-indent-offset n) ; css-mode
  (setq-local yaml-mode-indent-offset n) ; yaml-mode
  (setq-local markdown-mode-indent-offset n) ; css-mode
  (setq-local nix-mode-indent-offset n) ; css-mode
  )

;; Use 2 spaces instead of tabs
(setq-default indent-tabs-mode nil)
(my-setup-indent 2)

;; Show trailing whitespaces
(setq-default show-trailing-whitespace t)

(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))

(setq inhibit-startup-screen t)
