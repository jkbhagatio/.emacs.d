;; Profile emacs startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "*** Emacs loaded in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))
(load-theme 'wombat)

;; Enable windmove `shift + <arrow>` keybindings
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;; Set some UI elements
(tool-bar-mode -1)     ; disable tool-bar
(setq visible-bell t)  ; set visible bell (disable audio bell)

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

(require 'command-log-mode)
(use-package command-log-mode)  ; log commands into a buffer: `M-x clm/open-command-log-buffer`

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

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-switch-buffer)
	 ("C-x C-i" . ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil))  ; don't start searches with `^`

(use-package all-the-icons)  ; Run at new config: M-x all-the-icons-install-fonts

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(use-package doom-themes)

(use-package which-key
  :init (which-key-mode)
  :diminish
  :config
  (setq which-key-idle-delay 0.5))

(require 'multiple-cursors)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

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

;; Ripgrep
(use-package wgrep)
(use-package transient)
(use-package rg
  :bind ("C-c r" . rg))

(use-package magit
  :custom
  ;(magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; Turn on recent file mode
(recentf-mode 1)
(global-set-key (kbd "C-c C-f") 'recentf-open-files)

;; Turn on minibuffer history
(setq history-length 25)
(savehist-mode 1)

;; Turn on save place mode for navigating in place to reopened file
(save-place-mode 1)

;; Set a location for customization variables so they don't get set here
(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)

;; Update files in buffers when they've been changed outside of Emacs
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)

;; Use minibuffer area over pop up UI dialogs for some Emacs prompts
;(setq use-dialog-box nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(magit which-key use-package rg multiple-cursors ivy-rich helpful doom-themes doom-modeline counsel command-log-mode all-the-icons ace-window)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
