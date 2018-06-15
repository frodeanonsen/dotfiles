;;; packages.el --- multi-cursors layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: Frode Ånonsen <frode@Frodes-MacBook-Pro.local>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defconst multi-cursors-packages
  '(
    multiple-cursors
    smart-forward
    ))

(defun multi-cursors/init-multiple-cursors()
  (use-package multiple-cursors
  :ensure t
  :bind (
         ;; Experimental multiple-cursors
         ("C-S-c C-S-c" . mc/edit-lines)
         ("C-S-c C-e" . mc/edit-ends-of-lines)
         ("C-S-c C-a" . mc/edit-beginnings-of-lines)

         ;; Mark additional regions matching current region
         ("M-'" . mc/mark-all-dwim)
         ;;("C-[" . mc/mark-previous-like-this)
         ("s-n" . mc/mark-next-like-this)
         ("C-\"" . mc/mark-more-like-this-extended)
         ;;("M-\[" . mc/mark-all-in-region)

         ;; Symbol and word specific mark-more
         ("s-'" . mc/mark-next-word-like-this)
         ;;("s-\[" . mc/mark-previous-word-like-this)
         ("M-s-'" . mc/mark-all-words-like-this)
         ("s-\"" . mc/mark-next-symbol-like-this)
         ("s-{" . mc/mark-previous-symbol-like-this)
         ("M-s-\"" . mc/mark-all-symbols-like-this)

         ;; Extra multiple cursors stuff
         ("C-~" . mc/reverse-regions)
         ("M-~" . mc/sort-regions)
         ("H-~" . mc/insert-numbers)

         ("C-S-<mouse-1>" . mc/add-cursor-on-click))))

(defun multi-cursors/init-smart-forward ()
  (use-package smart-forward
    :ensure t
    :bind (("s-<up>" . smart-up)
           ("s-<down>" . smart-down)
           ("s-<left>" . smart-backward)
           ("s-<right>" . smart-forward))))

;;; packages.el ends here
