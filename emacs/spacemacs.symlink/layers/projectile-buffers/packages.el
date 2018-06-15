;;; packages.el --- projectile-buffers layer packages file for Spacemacs.

(defconst projectile-buffers-packages
  '(
    ibuffer-projectile
    ))

(defun projectile-buffers/init-ibuffer-projectile()
  (use-package ibuffer-projectile :ensure t))

;;; packages.el ends here
