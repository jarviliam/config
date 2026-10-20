;;; config.el --- Doom emacs configuration
;;
;; This file contains configuration for Doom Emacs
;;

;; Display settings
(setq doom-font (font-spec :family "Monospace" :size 14)
      doom-variable-pitch-font (font-spec :family "Monospace" :size 14)
      doom-big-font (font-spec :family "Monospace" :size 16))

;; Theme
(setq doom-theme 'doom-one)

;; Line numbers
(setq display-line-numbers-type t)

;; Org mode settings
(setq org-directory "~/Documents/org/")

;;; config.el ends here
