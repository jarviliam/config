;;; init.el --- Doom emacs configuration
;;
;; This file is used to configure Doom's behavior. For more information
;; about this file, see:
;; - https://docs.doomemacs.org/-/getting-started/configuring
;;
;; Note: You must restart Emacs for changes to take effect.

(doom! :completion
       company           ; the ultimate code completion backend
       (vertico +icons)           ; the search engine of the future

       :ui
       doom              ; what makes DOOM look the way it does
       doom-dashboard    ; a nifty splash screen for Emacs
       doom-quit         ; a little screen when you quit Emacs
       (emoji +unicode)  ; 🙂

       :editor
       (evil +everywhere); come to the dark side, we have cookies
       file-templates    ; auto-snippets when you create new files
       fold              ; (nigh) universal code folding
       (format +onsave)  ; automated prettification
       multiple-cursors  ; editing in many places at once
       ;; objed             ; text object editing for the innocent
       ;;parinfer          ; turn lisp into python, almost
       rotate-text       ; cycle region at point between text candidates
       snippets          ; my elves. They type so good
       word-wrap         ; soft wrapping with language-aware indent

       :emacs
       dired             ; making dired pretty [functional]
       electric          ; smarter, keyword-based electric-indent
       (ibuffer +icons)  ; interactive buffer management
       undo              ; persistent, smarter undo for your inevitable mistakes
       vc                ; version-control

       :term
       ;;eshell            ; the elisp shell that works everywhere
       ;;shell             ; simple shell REPL for Emacs
       ;;term              ; basic terminal emulator for Emacs
       vterm             ; the best terminal emulation in Emacs

       :checkers
       syntax              ; tasing you for every semicolon you forget
       (spell +flyspell) ; tasing you for misspelling mispelling
       grammar           ; tasing grammar mistake while you write

       :tools
       ansible
       direnv
       docker
       editorconfig      ; let someone else argue about tabs vs spaces
       ;;ein               ; thinly integrated jupyter notebooks
       (eval +overlay)     ; run code, run (also, repls)
       gist              ; interacting with github gists
       lookup              ; navigate your code and its documentation
       lsp               ; M-x vscode
       magit             ; a git porcelain for Emacs
       ;;make              ; run make tasks from Emacs
       pass              ; password manager for nerds
       pdf               ; tables of latex-rendered previews
       ;;prodigy           ; FIXME managing external services & code builders
       rgb               ; creating color strings
       ;;taskrunner        ; taskrunner for all your projects
       ;;terraform         ; infrastructure as code
       tmux              ; an API for interacting with tmux
       tree-sitter       ; syntax and parsing, sitting in a tree...
       upload            ; map local to remote server via tramp

       :lang
       ;;agda              ; types of types of types of types...
       ;;beancount         ; mind the GAAP
       (cc +lsp)         ; C > C++ == 1
       ;;clojure           ; java with a lisp
       ;;cmake
       ;;coq               ; feel dependent
       ;;csharp            ; unity, .NET, and mono shenanigans
       data              ; config/data formats
       ;;(dart +flutter)   ; paint ui and backend
       ;;dhall
       ;;elixir            ; erlang done right
       ;;elm               ; care for a cup of TEA?
       emacs             ; make *the* best editor even better
       ;;erlang            ; an elegant language for a parallel world
       ;;ess               ; emacs speaks statistics
       ;;factor
       ;;faust             ; dsp, but you get to keep your soul
       ;;fennel            ; lisp meets lua
       ;;forth             ; another language for writing word games
       ;;fortran           ; the FORTRAN language
       ;;fsharp            ; F# for the practical programmer
       ;;fstar             ; (dependent) types and (monadic) effects and Z3
       ;;gdscript          ; use Godot. Use GDScript.
       (go +lsp)         ; the hipster language
       ;;(graphql)         ; Give queries a REST
       ;;(groovy)          ; Java spinoff Apache so collective
       ;;(guile)           ; loving is easy
       ;;(haskell +dante)  ; a language that's lazier than I am
       ;;haxe              ; stay behind the times
       ;;hy                ; readability of scheme w/ speed of python
       ;;idris             ;
       ;;(java +meghanada) ; the poster child of carpal tunnel syndrome
       (javascript +lsp) ; all(hope(abandon(ye(who(enter(here))))))
       ;;julia             ; a better, faster MATLAB
       ;;kotlin            ; a better, slicker Java(Script)
       latex             ; writing papers in Emacs beats emacs writing papers
       ;;lean              ; for folks with too much to prove
       ;;ledger            ; be audit-happy
       ;;lua               ; one-based indices? one-based indices
       markdown          ; writing docs for people to ignore
       ;;nim               ; python + lisp at the speed of c
       ;;nix               ; I hereby declare "nix geht mehr!"
       ;;ocaml             ; an objective camel
       (org +pretty +present) ; organize your plain life in plain text
       ;;php               ; perl's insecure younger brother
       ;;plantuml          ; diagrams for confusing people more than they already are
       ;;purescript        ; javascript, but functional
       (python +lsp +poetry) ; beautiful is better than ugly
       ;;qt                ; the 'cutest' gui framework ever
       ;;racket            ; secrets of the carboard box
       ;;raku              ; the artist formerly known as perl6
       ;;rest              ; Emacs as a REST client
       ;;rst               ; ReST in peace
       ;;(ruby +rails)     ; 1.step { |i| p "Ruby is #{i.even? ? 'love' : 'life'}" }
       (rust +lsp)       ; Fe2O3.unwrap().unwrap().unwrap().unwrap()
       ;;(scala +metals)   ; java, but good
       ;;(scheme +guile)   ; turtles all the way down
       ;;sml
       ;;solidity          ; do you need a blockchain for that?
       ;;solitude          ; writing docs for people to ignore
       ;;spark             ; your bash files until they sparkle
       ;;sql               ; i.e. sequel
       ;;sqlite            ; sql until it hurts
       ;;swift             ; who asked for emoji variables?
       ;;swipl             ; logic programming consistency =>
       ;;tcl               ; basicaly unpendable
       ;;terra             ; writing terra in terra
       ;;tex               ; the Debian of the text editors
       ;;tidal             ; cycles of (c)ycles
       ;;typ               ; the elderly
       ;;(typescript +lsp) ; typescript TS TS ^TS
       ;;vala              ; GObjective, and
       ;;verilog           ; verify all the things
       ;;vhdl              ; one idea to spic them all
       ;;vim               ; Vi IMproved
       ;;vim               ; an editor for the god of vim
       ;;vlang             ; V as in V
       ;;vocano            ; rumble rumble
       ;;wast              ; web assembly
       ;;zig               ; your language, but rosted

       :os
       (:if IS-MAC macos)  ; improve compatibility with macOS
       tty             ; improved terminal compatibility

       :email
       ;;(mu4e +gmail)       ; WIP
       ;;notmuch             ; WIP
       ;;(wanderlust)        ; WIP

       ;; Applications are complex and opinionated modules that transform Emacs
       ;; into a productivity tool for a specific use-case. They may have additional
       ;; dependencies and should be loaded late.
       :app
       ;;calendar
       ;;emms
       ;;everywhere        ; *leave* Emacs!? You're insane!
       ;;irc               ; how neckbeards socialize
       ;;(mail +gmail)     ; Time to emacs, yet?
       ;;news              ; nb ipta letn hyreshuffaskerikHTARfap
       ;;(rss +org)        ; emacs as an RSS reader
       ;;twitter           ; twitter client https://twitter.com/anything

       :config
       ;;lispy             ; vim for lisp
       literate)           ; this file

;;; init.el ends here
