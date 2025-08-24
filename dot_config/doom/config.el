;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "ujvaln"
       user-mail-address "ujval.nallur@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-city-lights)
;; (setq fancy-splash-image "/home/ujvalnallur/dotfiles/wallpapers/banner.png")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-roam-graph-executable "/usr/bin/dot")
(setq org-roam-graph-viewer "xdg-open")
(setq org-roam-capture-templates
      '(("d" "default" plain
         "%?"
         :target (file+head "${slug}.org"
                            "#+title: ${title}\n")
         :unarrowed t)))
(setq org-directory "/home/ujvalnallur/notes/")
(setq org-roam-directory "/home/ujvalnallur/notes/")

;; latex
(setq org-preview-latex-process-alist
      '((dvipng :programs ("latex" "dvipng")
                :description "dvi > png"
                :message "you need to install the programs: latex and dvipng."
                :image-input-type "dvi"
                :image-output-type "png"
                :image-size-adjust (1.0 . 1.0)
                :latex-compiler ("latex -interaction nonstopmode -output-directory %o %f")
                :image-converter ("dvipng -D %D -T tight -o %O %f"))))

;; org-roam-ui
(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          ))

(use-package magit
  :ensure t
  :config
  ;; Auto-sync function with added safety checks
  (defun auto-sync-org-files ()
    (interactive)
    (let ((default-directory "/home/ujvalnallur/notes/")) ;; Replace with your org directory path
      ;; Pull changes first with rebase
      (if (magit-anything-modified-p)
          (progn
            (magit-call-git "pull" "--rebase")
            (message "Rebase completed."))
        (message "No changes to pull."))

      ;; Stage all changes
      (magit-call-git "add" ".")

      ;; Commit if there are changes
      (when (magit-anything-modified-p)
        (magit-call-git "commit" "-m"
                        (format-time-string "Auto-sync: %Y-%m-%d %H:%M:%S")))

      ;; Push changes after checking status
      (if (magit-anything-modified-p)
          (magit-call-git "push")
        (message "No changes to push."))

      (message "Auto-sync completed")))

  ;; Function to revert to the previous commit with confirmation
  (defun revert-to-previous-commit ()
    (interactive)
    (let ((default-directory "/home/ujvalnallur/notes/"))
      (when (yes-or-no-p "Are you sure you want to revert to the last commit? This will discard uncommitted changes!")
        (magit-call-git "reset" "--hard" "HEAD~1")
        (magit-call-git "push" "--force")
        (message "Reverted to the previous commit"))))

  ;; Function to move forward in commit history with confirmation
  (defun move-forward-in-history ()
    (interactive)
    (let ((default-directory "/home/ujvalnallur/notes/"))
      (if (yes-or-no-p "Move forward to the next commit? This will discard uncommitted changes!")
          (progn
            (magit-call-git "reset" "--hard" "@{1}") ;; Moves forward using reflog
            (magit-call-git "push" "--force")
            (message "Moved forward to the next commit"))
        (message "Cancelled"))))

  ;; Sync before Emacs exits
  (add-hook 'kill-emacs-hook #'auto-sync-org-files)

  ;; Keybindings
  (bind-keys
   ("C-c s" . auto-sync-org-files)  ;; Auto-sync
   ("C-c r" . revert-to-previous-commit) ;; Revert to previous commit
   ("C-c f" . move-forward-in-history)) ;; Move forward in commit history
)

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
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
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
