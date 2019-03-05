;;;; package --- Summary: Main initialization for emacs

;;;; Commentary:

;; Emacs version >= 26.1 recommended

;;;;;;;;;;;;;INITIALIZATION;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; reduce the frequency of garbage collection by making it happen on
;; each 50MB of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold 50000000)

;; warn when opening files bigger than 100MB
(setq large-file-warning-threshold 100000000)

;;;; Code:
(load "~/.emacs.d/packages.el")
(load "~/.emacs.d/keybindings.el")
(load "~/.emacs.d/modeConfig.el")
(load "~/.emacs.d/org.el")

;;;;;;;;;;;;;GLOBAL MODES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(global-aggressive-indent-mode 1) ;; Force those indents hard!
(powerline-center-theme) ;; bar all the way, at the bottom of the screen 0.0
(ivy-mode 1) ;; autocomplete the M-x thingybar stuff
(ido-mode 1) ;; Even nicer autocomplete stuff
(global-hl-line-mode t) ; Highlight cursor line
(electric-pair-mode 1)

;;;;;;;;;;;;;VARIABLES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;; General UI

(tool-bar-mode 0)                              ; Don't need a toolbar...
(define-key menu-bar-tools-menu [games] 0)     ; Remove games menu
(setq inhibit-startup-message t)               ; No startup message
(blink-cursor-mode 0)                          ; I'm already agitated enough
(cua-mode t)                                   ; Regular classic copy-cut-paste and marking
(mouse-wheel-mode t)                           ; Mouse wheel enabled
(setq inhibit-compacting-font-caches t)        ; Prevents font caches from being gc'd

;;;;;; I'm a European, so...
(defvar european-calendar-style)
(defvar calendar-week-start-day)
(setq european-calendar-style 't)              ; European style calendar
(setq calendar-week-start-day 1)               ; Week starts monday
(setq ps-paper-type 'a4)                       ; Specify printing format

;;;;;; Files 'n stuff
(setq auto-save-timeout 60)                    ; Autosave every minute
(setq read-file-name-completion-ignore-case 't); Ignore case when completing file names

;;;;;; Tabs, spaces, indents, lines, parentheses, etc.
(defvar show-paren-style)
(setq indent-tabs-mode 0)
(setq-default c-basic-offset 4)                ; use 4 spaces as indentation instead of tabs
(show-paren-mode t)                            ; Highlight parenthesis pairs
(setq blink-matching-paren-distance 0)         ; Blinking parenthesis = no
(setq show-paren-style 'expression)            ; Highlight text between parentheses

;; No stupid backup/temporary files in every folder, but in a dedicated one
(setq
 version-control t
 kept-new-versions 6
 kept-old-versions 2
 backup-by-copying t
 backup-directory-alist '(("." . "~/.emacs.d/saves"))
 delete-old-versions t)

;; Font!
(set-face-attribute 'default nil :family "Fira Code" :height 130)

;;;;;;;;;;;;;FUNCTIONS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun vsplit-last-buffer ()
  "When opening a new split, open previous buffer instead of 2 identical ones.  Vertically."
  (interactive)
  (split-window-vertically)
  (other-window 1 nil)
  (switch-to-next-buffer)
  )
(defun hsplit-last-buffer ()
  "When opening a new split, open previous buffer instead of 2 identical ones.  Horizontally."
  (interactive)
  (split-window-horizontally)
  (other-window 1 nil)
  (switch-to-next-buffer)
  )

(global-set-key (kbd "C-x 2") 'vsplit-last-buffer)
(global-set-key (kbd "C-x 3") 'hsplit-last-buffer)

;; Weird theme workaround
(defvar my:theme 'rebecca)
(defvar my:theme-window-loaded nil)
(defvar my:theme-terminal-loaded nil)

(if (daemonp)
    (add-hook 'after-make-frame-functions(lambda (frame)
					   (select-frame frame)
					   (if (window-system frame)
					       (unless my:theme-window-loaded
						 (if my:theme-terminal-loaded
						     (enable-theme my:theme)
						   (load-theme my:theme t))
						 (setq my:theme-window-loaded t))
					     (unless my:theme-terminal-loaded
					       (if my:theme-window-loaded
						   (enable-theme my:theme)
						 (load-theme my:theme t))
					       (setq my:theme-terminal-loaded t)))))

  (progn
    (load-theme my:theme t)
    (if (display-graphic-p)
        (setq my:theme-window-loaded t)
      (setq my:theme-terminal-loaded t))))

;; Ivy, Counsel, Swiper Setup ;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;
;;
(ivy-mode 1) ;; Turn on ivy by default
(setq ivy-use-virtual-buffers t)  ;; no idea, but recommended by project maintainer
(setq enable-recursive-minibuffers t) ;; no idea, but recommended by project maintainer
(setq ivy-count-format "(%d/%d) ")  ;; changes the format of the number of results
(global-set-key (kbd "C-s") 'swiper)  ;; replaces i-search with swiper
(global-set-key (kbd "M-x") 'counsel-M-x) ;; Gives M-x command counsel features
(global-set-key (kbd "C-x C-f") 'counsel-find-file) ;; gives C-x C-f counsel features
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-find-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c C-r") 'ivy-resume)

(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag) ;; add counsel/ivy features to ag package
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
;;(define-key read-expression-map (kbd "C-r") 'counsel-expression-history)

;;set action options during execution of counsel-find-file
;; replace "frame" with window to open in new window
(ivy-set-actions
 'counsel-find-file
 '(("j" find-file-other-frame "other frame")
   ("b" counsel-find-file-cd-bookmark-action "cd bookmark")
   ("x" counsel-find-file-extern "open externally")
   ("d" delete-file "delete")
   ("r" counsel-find-file-as-root "open as root")))

;; set actions when running C-x b
;; replace "frame" with window to open in new window
(ivy-set-actions
 'ivy-switch-buffer
 '(("j" switch-to-buffer-other-frame "other frame")
   ("k" kill-buffer "kill")
   ("r" ivy--rename-buffer-action "rename")))

;;
;;
;; End Ivy, Swiper, Counsel

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(cua-mode t nil (cua-base))
 '(custom-enabled-themes (quote (rebecca)))
 '(custom-safe-themes
   (quote
    ("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "f633d825e380caaaefca46483f7243ae9a663f6df66c5fad66d4cab91f731c86" default)))
 '(font-latex-fontify-script nil)
 '(package-selected-packages
   (quote
    (aggressive-fill-paragraph aggressive-indent doom-modeline spaceline smart-mode-line yasnippet-snippets adoc-mode ascii company ac-clang auctex-lua dired-sidebar dired-single magit i3wm auctex ac-inf-ruby inf-ruby flymake-ruby flymake-lua flymake symon powerline paredit git-gutter smartparens auto-complete centered-cursor-mode ruby-end haml-mode lua-mode)))
 '(quote (load-theme (quote rebecca) t))
 '(show-paren-mode t)
 '(tool-bar-mode nil))

; Load org file
(find-file "~/.emacs.d/todo.org")

(provide 'init)
;;; init.el ends here
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
