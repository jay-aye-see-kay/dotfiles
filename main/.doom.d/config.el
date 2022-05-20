;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Jack Rose"
      user-mail-address "user@jackrose.co.nz")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
;;
;; (setq doom-font (font-spec :family "Fira Mono" :size 22)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 22 :weight 'light))
;; (setq doom-font (font-spec :family "Fira Mono" :size 22)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 22 :weight 'light))
(setq doom-font (font-spec :size 16)
     doom-variable-pitch-font (font-spec :size 16))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'vscode-dark-plus)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; FIXME how do I disable this everywhere?
(setq rainbow-delimiters-mode nil)
;; (add-variable-watcher rainbow-delimiters-mode
;;   (unless ra)(setq rainbow-delimiters-mode nil))

(global-org-modern-mode)
(setq org-journal-file-format "%F-%A.org"
      org-journal-dir "~/Documents/org/logbook/")

(add-hook 'org-mode-hook 'org-variable-pitch-minor-mode)

;; Set faces for heading levels
(setq vscode-dark-plus-scale-org-faces nil)
(set-face-attribute 'org-default nil :weight 'light)
(dolist (face '((org-level-1 . 1.5)
                (org-level-2 . 1.3)
                (org-level-3 . 1.15)
                (org-level-4 . 1.1)
                (org-level-5 . 1.1)
                (org-level-6 . 1.1)
                (org-level-7 . 1.1)
                (org-level-8 . 1.1)))
  (set-face-attribute (car face) nil :weight 'light :height (cdr face)))

;; TODO why aren't the font sizes above getting applied?
;; TODO how can I make org body font light?
;; TODO what is the font face used by the TODOs? It's not getting the same font size as the heading it's in
;; TODO can I add spacing around org headings, so paragraphs aren't so close together?
;; TODO disable company mode in org files

;; lsp hover settings
(setq
 lsp-eldoc-enable-hover nil
 lsp-ui-sideline-show-hover t
 lsp-ui-sideline-show-code-actions t
 lsp-ui-sideline-show-hover nil
 lsp-ui-sideline-show-diagnostics nil
 lsp-ui-sideline-show-symbol t
)

(setq
 lsp-headerline-breadcrumb-enable t
 lsp-headerline-breadcrumb-enable-diagnostics nil
)
