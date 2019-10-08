;;; mcrl2-mode.el --- Major mode for editing mCRL2. -*- lexical-binding: t -*-

;;; Commentary:

;; Emacs integration for mCRL2
;;
;; Inspired by:
;; - Erik Post's mCRL2 mode: https://github.com/epost/mcrl2-mode
;; - Robert Kornacki's mCRL2 Spacemacs Layer: https://github.com/robkorn/mCRL2-spacemacs-layer

(defun mcrl2-unindent ()
  "remove 2 spaces from beginning of of line"
  (interactive)
  (save-excursion
    (save-match-data
      (beginning-of-line)
      ;; get rid of tabs at beginning of line
      (when (looking-at "^\\s-+")
        (untabify (match-beginning 0) (match-end 0)))
      (when (looking-at "^  ")
        (replace-match "")))))

(setq mcrl2-font-lock-keywords
      (let* (
             (x-keywords '("sort" "act" "proc" "init" "struct" "sum" "eqn" "map"
                           "in" "mu" "nu" "forall" "exists"))
             (x-types '("Bool" "Nat"))
             (x-functions '("allow" "comm" "hide"))

             (x-keywords-regexp (regexp-opt x-keywords 'symbols))
             (x-types-regexp (regexp-opt x-types 'symbols))
             (x-functions-regexp (regexp-opt x-functions 'symbols))
             )
        `(
          (,x-keywords-regexp . font-lock-keyword-face)
          (, "\\(true\\|false\\)[^_]" (1 font-lock-keyword-face))
          (,x-types-regexp . font-lock-type-face)
          (,x-functions-regexp . font-lock-function-name-face)
          (";\\|:\\|\\.\\|,\\|=\\|+\\|->\\|-\\|*\\|\|\\|!\\|#\\|\<\>\\|(\\|)\\|{\\|}\\|\\[\\|\\]\\|<\\|>\\|&&" . font-lock-constant-face)

          )))

(defconst mcrl2-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?% "< 1" table)
    (modify-syntax-entry ?\n "> " table)
    table))

(progn
  (setq mcrl2-mode-map (make-sparse-keymap))
  (define-key mcrl2-mode-map (kbd "C-c C-l") 'mcrl2-create-lps-reg)
  (define-key mcrl2-mode-map (kbd "C-c C-t") 'mcrl2-create-lts)
  (define-key mcrl2-mode-map (kbd "C-c C-g") 'mcrl2-lts-graph-current)
  (define-key mcrl2-mode-map (kbd "C-c C-s") 'mcrl2-lts-sim-current)
  )

(progn
  (setq mcf-mode-map (make-sparse-keymap))
  (define-key mcf-mode-map (kbd "C-c C-p") 'mcf-create-lps-pbes)
  (define-key mcf-mode-map (kbd "C-c C-b") 'mcf-pbes-bool)
  )

(define-derived-mode mcrl2-mode prog-mode "mCRL2 mode"
  "Major mode for editing mcrl2 and mcf files."
  
  :syntax-table mcrl2-mode-syntax-table

  (progn
    (setq-local font-lock-defaults '(mcrl2-font-lock-keywords))
    (setq-local comment-start "\%")
    (setq-local comment-end "")
    (setq major-mode 'mcrl2-mode)
    (setq mode-name "mCRL2")
    (use-local-map mcrl2-mode-map)
    (run-hooks 'mcrl2-mode-hook)
    (local-set-key (kbd "<backtab>") 'mcrl2-unindent)
    (setq-local tab-width 2)))

(define-derived-mode mcf-mode prog-mode "mCRL2 mode"
  "Major mode for editing mcrl2 and mcf files."
  
  :syntax-table mcrl2-mode-syntax-table

  (progn
    (setq-local font-lock-defaults '(mcrl2-font-lock-keywords))
    (setq-local comment-start "\%")
    (setq-local comment-end "")
    (setq major-mode 'mcrl2-mode)
    (setq mode-name "mCRL2")
    (use-local-map mcf-mode-map)
    (run-hooks 'mcrl2-mode-hook)
    (local-set-key (kbd "<backtab>") 'mcrl2-unindent)
    (setq-local tab-width 2)))

(provide 'mcrl2-mode)


(defun mcrl2-create-lps-reg (&optional set-line)
  (interactive)
  (async-shell-command (concat "mcrl22lps -l regular "
                               (shell-quote-argument buffer-file-name)
                               " > "
                               (shell-quote-argument (concat buffer-file-name
                                                             ".lps")))))

(defun mcrl2-create-lps-reg2 (&optional set-line)
  (interactive)
  (async-shell-command (concat "mcrl22lps -l regular2 "
                               (shell-quote-argument buffer-file-name) " > "
                               (shell-quote-argument (concat buffer-file-name ".lps")))))

(defun mcrl2-create-lps-stack (&optional set-line)
  (interactive)
  (async-shell-command (concat "mcrl22lps -l stack "
                               (shell-quote-argument buffer-file-name) " > "
                               (shell-quote-argument (concat buffer-file-name ".lps")))))

 ;; LTS Creation Functions
(defun mcrl2-create-lts (&optional set-line)
  (interactive)
  (async-shell-command (concat "lps2lts --verbose "
                               (shell-quote-argument (concat buffer-file-name ".lps"))
                               " "
                               (shell-quote-argument buffer-file-name) ".lts" )))

;; PBES Creation Functions
(defun mcf-create-lps-pbes (&optional set-line)
  (interactive)
  (async-shell-command (concat "lps2pbes -c "
                               (read-file-name "Enter .lps file name:")
                               " -f " (shell-quote-argument buffer-file-name)
                               " " (shell-quote-argument (concat buffer-file-name ".pbes")) )))

(defun mcf-pbes-bool (&optional set-line)
  (interactive)
  (async-shell-command (concat "pbes2bool --verbose "
                               (shell-quote-argument buffer-file-name) ".pbes")))

;; PBES Model Checking Functions
(defun mcrl2-check-pbes-lps (&optional set-line)
  (interactive)
  (async-shell-command (concat "pbessolve -v --file="
                               (shell-quote-argument (concat buffer-file-name ".lps"))
                               " "
                               (shell-quote-argument (concat buffer-file-name ".pbes")) )))
(defun mcrl2-check-pbes-lts (&optional set-line)
  (interactive)
  (async-shell-command (concat "pbessolve -v --file="
                               (shell-quote-argument (concat buffer-file-name ".lts"))
                               " "
                               (shell-quote-argument (concat buffer-file-name ".pbes")) )))

;; LTS Graph Functions
(defun mcrl2-lts-graph-current (&optional set-line)
  (interactive)
  (async-shell-command (concat "ltsgraph " (shell-quote-argument buffer-file-name) ".lts")))

(defun mcrl2-lts-graph-evidence (&optional set-line)
  (interactive)
  (async-shell-command (concat "ltsgraph "  (shell-quote-argument buffer-file-name) ".pbes.evidence.lts")))

(defun mcrl2-lts-sim-current (&optional set-line)
  (interactive)
  (async-shell-command (concat "lpssim " (shell-quote-argument buffer-file-name) ".lps")))
