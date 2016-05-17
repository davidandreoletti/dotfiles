; Org-mode
;; Quick access to Org-Mode major commands
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(setq org-enforce-todo-dependencies t)
(setq org-enforce-todo-checkbox-dependencies t)
(setq org-log-done 'time)

(setq org-todo-keywords
	'((sequence "TODO(t)" "WIP(w)" "|" "DONE(d)")
	(sequence "WAITFOR" "DELEGATETO" "CHECKING" "|" "COMPLETED")
	(sequence "ASK" "ASKING" "|" "ASKED")
	(sequence "TODO_MAYBE" "|" "DONE")
	(sequence "|" "CANCELED")))
