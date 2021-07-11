;;; titan.el --- a simple package                     -*- lexical-binding: t; -*-

;; Copyright (C) 2021  Jeet Ray

;; Author: Jeet Ray <aiern@protonmail.com>
;; Keywords: lisp
;; Version: 0.0.1

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Put a description of the package here

;;; Code:

(require 'yasnippet)
(require 'yankpad)
(require 'org)

(defvar ext-def '(org md))

(defun meq/ddm (name ext)
    (setq yankpad-file-backup yankpad-file)
    (setq yankpad-file
        ;; Adapted From: https://github.com/AndreaCrotti/yasnippet-snippets/blob/master/yasnippet-snippets.el#L35
        (expand-file-name
        "yankpad.org"
        (file-name-directory
            ;; Copied from ‘f-this-file’ from f.el.
            (cond
            (load-in-progress load-file-name)
            ((and (boundp 'byte-compile-current-file) byte-compile-current-file)
            byte-compile-current-file)
            (:else (buffer-file-name))))))
    (yankpad-append-category (concat name "-mode"))
    (setq yankpad-file yankpad-file-backup)
    (add-to-list 'auto-mode-alist '((concat "\\." name "." ext "\\'") . (intern (concat name "-mode")))))

(defun meq/mapc-ddm (name &optional ext-list) (mapc #'(lambda (ext*) (interactive)
    (let* ((ext (symbol-name ext*)))
        (eval `(define-derived-mode
            ,(intern (concat name "-" ext "-mode"))
            ,(intern (concat "titan-" ext "-mode"))
            (meq/ddm ,name ,ext))))) (or ext-list ext-def)))

(define-derived-mode titan-org-mode org-mode "titan-org" (meq/ddm "titan" "org"))
(define-derived-mode titan-md-mode markdown-mode "titan-md" (meq/ddm "titan" "md"))

(provide 'titan)
;;; titan.el ends here
