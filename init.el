;;; パッケージの設定
(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)
;;; 右から左に読む言語に対応させないことで描画高速化
(setq-default bidi-display-reordering nil)
;;; splash screenを無効にする
(setq inhibit-splash-screen t)
;;; 同じ内容を履歴に記録しないようにする
(setq history-delete-duplicates t)
;; C-u C-SPC C-SPC …でどんどん過去のマークを遡る
(setq set-mark-command-repeat-pop t)
;;; 複数のディレクトリで同じファイル名のファイルを開いたときのバッファ名を調整する
(require 'uniquify)
;; filename<dir> 形式のバッファ名にする
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-ignore-buffers-re "[^*]+")
;;; ファイルを開いた位置を保存する
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (concat user-emacs-directory "places"))
;;; 釣合う括弧をハイライトする
(show-paren-mode 1)
;;; インデントにTABを使わないようにする
(setq-default indent-tabs-mode nil)
;;; 現在行に色をつける
;(global-hl-line-mode 1)
;;; ミニバッファ履歴を次回Emacs起動時にも保存する
(savehist-mode 1)
;;; シェルに合わせるため、C-hは後退に割り当てる
(global-set-key (kbd "C-h") 'delete-backward-char)
;;; モードラインに時刻を表示する
(display-time)
;;; 行番号・桁番号を表示する
(line-number-mode 1)
(column-number-mode 1)
;;; GCを減らして軽くする
(setq gc-cons-threshold (* 10 gc-cons-threshold))
;;; ログの記録行数を増やす
(setq message-log-max 10000)
;;; 履歴をたくさん保存する
(setq history-length 1000)
;;; メニューバーとツールバーとスクロールバーを消す
;(menu-bar-mode -1)
;(tool-bar-mode -1)
;(scroll-bar-mode -1)
;;; バッファの左側に行番号を表示する
;(global-nlinum-mode t)
;;; 5桁分の表示領域を確保
(setq nlinum-format "%5d ")
;;; テーマの設定(load-theme 'soft-charcoal)(load-theme soft-charcoal)
(load-theme 'soft-charcoal t)
;;;バックアップファイルを作成しない
(setq make-backup-files nil) 


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("62408b3adcd05f887b6357e5bd9221652984a389e9b015f87bbc596aba62ba48" default)))
 '(package-selected-packages
   (quote
    (function-args deferred soft-charcoal-theme nlinum company color-theme-railscasts c-eldoc))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; -*- mode: emacs-lisp -*-

;; This file contains code to set up Emacs to edit PostgreSQL source
;; code.  Copy these snippets into your .emacs file or equivalent, or
;; use load-file to load this file directly.
;;
;; Note also that there is a .dir-locals.el file at the top of the
;; PostgreSQL source tree, which contains many of the settings shown
;; here (but not all, mainly because not all settings are allowed as
;; local variables).  So for light editing, you might not need any
;; additional Emacs configuration.


;;; C files

;; Style that matches the formatting used by
;; src/tools/pgindent/pgindent.  Many extension projects also use this
;; style.
(c-add-style "postgresql"
             '("bsd"
               (c-auto-align-backslashes . nil)
               (c-basic-offset . 4)
               (c-offsets-alist . ((case-label . +)
                                   (label . -)
                                   (statement-case-open . +)))
               (fill-column . 78)
               (indent-tabs-mode . t)
               (tab-width . 4)))

(add-hook 'c-mode-hook
          (defun postgresql-c-mode-hook ()
            (when (string-match "/postgres\\(ql\\)?/" buffer-file-name)
              (c-set-style "postgresql")
              ;; Don't override the style we just set with the style in
              ;; `dir-locals-file'.  Emacs 23.4.1 needs this; it is obsolete,
              ;; albeit harmless, by Emacs 24.3.1.
              (set (make-local-variable 'ignored-local-variables)
                   (append '(c-file-style) ignored-local-variables)))))


;;; Perl files

;; Style that matches the formatting used by
;; src/tools/pgindent/perltidyrc.
(defun pgsql-perl-style ()
  "Perl style adjusted for PostgreSQL project"
  (interactive)
  (setq perl-brace-imaginary-offset 0)
  (setq perl-brace-offset 0)
  (setq perl-continued-brace-offset 4)
  (setq perl-continued-statement-offset 4)
  (setq perl-indent-level 4)
  (setq perl-label-offset -2)
  (setq indent-tabs-mode t)
  (setq tab-width 4))

(add-hook 'perl-mode-hook
          (defun postgresql-perl-mode-hook ()
             (when (string-match "/postgres\\(ql\\)?/" buffer-file-name)
               (pgsql-perl-style))))


;;; documentation files

(add-hook 'sgml-mode-hook
          (defun postgresql-sgml-mode-hook ()
             (when (string-match "/postgres\\(ql\\)?/" buffer-file-name)
               (setq fill-column 78)
               (setq indent-tabs-mode nil)
               (setq sgml-basic-offset 1))))


;;; Makefiles

;; use GNU make mode instead of plain make mode
(add-to-list 'auto-mode-alist '("/postgres\\(ql\\)?/.*Makefile.*" . makefile-gmake-mode))
(add-to-list 'auto-mode-alist '("/postgres\\(ql\\)?/.*\\.mk\\'" . makefile-gmake-mode))

;;; gtags
(add-to-list 'load-path "/home/vagrant/\.emacs.d/lisp")
(require 'gtags)
(global-set-key "\M-t" 'gtags-find-tag)
(global-set-key "\M-r" 'gtags-find-rtag)
(global-set-key "\M-s" 'gtags-find-symbol)
(global-set-key "\C-t" 'gtags-pop-stack)
(global-set-key "\M-p" 'gtags-find-pattern)
(global-set-key "\C-cf" 'gtags-find-file)    ;ファイルにジャンプ
;(define-key gtags-select-mode-map "\C-m" 'gtags-select-tag)
;(setq gtags-rootdir "/usr/home/osada/ns-allinone-2.35")
; 以下を追加
(setq gtags-select-mode-hook
      '(lambda ()
         (local-set-key "\C-m" 'gtags-select-tag)
         ))
;;; compliation
(require 'company)
(global-company-mode)
;(add-hook 'after-init-hook 'global-company-mode)

;; irony
(require 'irony)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)
;(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
;(add-to-list 'company-backends 'company-irony 'company-gtags 'company-clang) ; backend追加
(add-to-list 'company-backends 'company-gtags)
;;; c-eldoc
(require 'c-eldoc)
(add-hook 'c-mode-hook 'c-turn-on-eldoc-mode)
(setq c-eldoc-buffer-regenerate-time 60)

;;; function-args
;(fa-config-default)

;; cedet
;(require 'semantic)

;(global-semanticdb-minor-mode 1)
;(global-semantic-idle-scheduler-mode 1)
;(semantic-load-enable-code-helpers)
;(semantic-mode 1)
;(defun my:add-semantic-to-autocomplete()
  ;(add-to-list 'ac-sources ac-souce-semantics)
 ; )
;(add-hook 'c-mode-common-hook 'my:add-semantic-to-autocomplete)
;(global-ede-mode 1)

;(ede--detect-scan-directory-for-project-root '("/home/vagrant/postgresql/src" 1))
