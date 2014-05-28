;
;    Pierre-Yves Luyten           2014.
;
;
;    This file is part of Bodhi.
; 
;    Bodhi is free software: you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation, either version 3 of the License, or
;    (at your option) any later version.
; 
;    Bodhi is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.
; 
;    You should have received a copy of the GNU General Public License
;    along with Bodhi.  If not, see <http://www.gnu.org/licenses/>.
;


(add-to-list 'load-path "./")

(require 'transpose-frame)
(require 'bodhi-tile)

(require 'bodhi-prompts)
(require 'bodhi-commands)

(require 'bodhi-alias)

(bodhi-alias-add-file
  (concat
    (file-name-directory (or load-file-name buffer-file-name))
    "bodhi-alias.org"))

(provide 'bodhi-common)
