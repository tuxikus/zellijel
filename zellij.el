;;; zellij.el --- -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(defvar zellij-ssh-config-file "~/.ssh/config"
  "The location of the ssh config file.")

(defun zellij-delete-all-session ()
  "Delete all running Zellij sessions."
  (interactive)
  (shell-command "zellij delete-all-sessions -y"))

(defun zellij-kill-all-session ()
  "Kill all running Zellij sessions."
  (interactive)
  (shell-command "zellij kill-all-sessions -y"))

(defun zellij-new-tab (name)
  "Create a new tab named NAME in the selected session."
  (interactive "sTab Name: ")
  (let ((session (zellij-select-session)))
    (shell-command (format "zellij --session %s action new-tab --name %s" session name))))

(defun zellij-ssh-in-new-tab ()
  "Open a ssh connection in a new tab."
  (interactive)
  (let ((session (zellij-select-session))
	(machine (zellij-select-machine)))
    (shell-command (format "zellij --session %s action new-tab --name %s && zellij --session %s run -- ssh %s" session (format "ssh:%s" machine) session machine))))

(defun zellij-select-machine ()
  "Prompt the user to select a machine from the SSH config file."
  (let ((hosts '()))
    (with-temp-buffer
      (insert-file-contents "~/.ssh/config")
      (goto-char (point-min))
      (while (re-search-forward "^Host.*" nil t)
        (push (cdr (split-string (match-string 0) " ")) hosts)))
    (completing-read "Host: " hosts)))

(defun zellij-select-session ()
  "Prompt the user to select a running zellij session."
  (completing-read
   "Zellij session: "
   (split-string (shell-command-to-string "zellij list-sessions -s") "\n")))

(provide 'zellij)

;;; zellij.el ends here
