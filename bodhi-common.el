
(add-to-list 'load-path "./")

(require 'transpose-frame)
(require 'bodhi-tile)

(require 'bodhi-prompts)
(require 'bodhi-commands)

(require 'bodhi-alias)

(bodhi-alias-add-file "bodhi-alias.org")

(provide 'bodhi-common)
