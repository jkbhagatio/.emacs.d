;; Profile emacs startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "*** Emacs loaded in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))
(load-theme 'wombat)

;; Set some UI elements and settings
;(menu-bar-mode -1)                         ; disable menu bar
(tool-bar-mode -1)                         ; disable tool bar
(setq visible-bell t)                      ; set visible bell (disable audio bell)
(set-fringe-mode '(10 . 10))               ; add some pixels to left and right edge of screen
(setq history-length 25)                   ; Turn on minibuffer history
(savehist-mode 1)
(save-place-mode 1)                        ; Turn on save place mode for navigating in place to reopened file
(column-number-mode 1)

;; Set a location for customization variables so they don't get set here
(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)

;; Update files in buffers when they've been changed outside of Emacs
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)

;; Use minibuffer area over pop up UI dialogs for some Emacs prompts
;(setq use-dialog-box nil)

;; Turn on recent file mode
(recentf-mode 1)
(global-set-key (kbd "C-c C-f") 'recentf-open-files)

;; Enable windmove `shift + <arrow>` keybindings
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;; Keybind commenting
(global-set-key (kbd "C-x /") 'comment-or-uncomment-region)

;; Initialize package sources
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents  
  (package-refresh-contents))
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

(use-package command-log-mode)  ; log commands into a buffer: `M-x clm/open-command-log-buffer`
(setq global-command-log-mode t)

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :init (ivy-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-switch-buffer)
	 ("C-x C-i" . ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil))  ; don't start searches with `^`

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

					;(use-package all-the-icons)  ; Run at new config: M-x all-the-icons-install-fonts
(use-package vscode-icon)

(use-package which-key
  :init (which-key-mode)
  :diminish
  :config
  (setq which-key-idle-delay 0.5))

(use-package multiple-cursors)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; Dired settings
(require 'dired-x)  ; allows for ext finding
(setq delete-by-moving-to-trash t)
(setq dired-kill-when-opening-new-dired-buffer t)
(setq dired-recursive-copies 'always)
(setq dired-recursive-deletes 'always)
(setq dired-listing-switches  "-agho --group-directories-first --time-style=long-iso")
(setq dired-dwim-target t)
(use-package dired-hacks-utils)
(use-package dired-hide-dotfiles) ; hide dot files hook in dired
;; (use-package dired-open
;;   :config
;;   (setq dired-open-extensions '(("png" . "feh")
;;                                 ("mkv" . "mpv"))))
(use-package pdf-tools)
(use-package dirvish
  :init
  (dirvish-override-dired-mode)
  :custom
  (dirvish-quick-access-entries ; It's a custom option, `setq' won't work
   '(("h" "/c/Users/jai"                   "home")
     ("g" "/d/google_drive"                "g_drive")))
  :config
  ;; (dirvish-peek-mode) ; Preview files in minibuffer
  ;; (dirvish-side-follow-mode) ; similar to `treemacs-follow-mode'
  (setq dirvish-mode-line-format
        '(:left (sort symlink) :right (omit yank index file-size file-time)))
  (setq dirvish-attributes
	'(file-time file-size collapse subtree-state vc-state git-msg))
       ;'(vscode-icon file-time file-size collapse subtree-state vc-state git-msg))
  (setq delete-by-moving-to-trash t)
  (setq dired-listing-switches
        "-l --almost-all --human-readable --group-directories-first --no-group")
  (setq dirvish-enable-preview t)
  (setq dirvish-use-mode-line t)
  (setq dirvish-hide-details nil))
(global-set-key (kbd "C-x M-d") 'dirvish)
(global-set-key (kbd "C-x M-s") 'dirvish-side)
;; (require 'dirvish-minibuffer-preview)
;; (dirvish-minibuf-preview-mode)
;; Initialize without hiding anything
(setq dired-hode-dotfiles-mode -1)
(setq dired-hide-details-mode -1)
(define-key dired-mode-map (kbd "z") 'dired-hide-dotfiles-mode)
(define-key dired-mode-map (kbd "b") 'dired-hide-details-mode)
(define-key dired-mode-map (kbd "% C-g") 'dired-do-query-replace-regexp)

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package ace-window
  :bind ("M-o" . ace-window)
  :config
  (setq aw-dispatch-always t))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(use-package doom-themes)

;; Ripgrep
(use-package wgrep)
(use-package transient)
(use-package rg
  :bind ("C-c r" . rg))

(use-package emacsql-sqlite-builtin)

(use-package magit)
  ;:custom
  ;(magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))
(setq magit-auto-revert-mode t)

(use-package forge)
