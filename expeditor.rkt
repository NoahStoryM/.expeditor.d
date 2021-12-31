#lang racket/base

(require (submod expeditor configure))


(define ee-parens
  (hash-copy
   #hasheq([#\( . "()"]
           [#\[ . "[]"]
           [#\{ . "{}"]
           [#\" . "\"\""]
           [#\| . "||"])))

(define ee-insert-paren
  (λ (ee entry c)
    (cond
      [(hash-has-key? ee-parens c)
       ((make-ee-insert-string (hash-ref ee-parens c)) ee entry c)
       (ee-backward-char ee entry c)]
      [else (ee-insert-self ee entry c)])))

(define ee-bothward-delete-char
  (λ (ee entry c)
    (ee-delete-char ee entry c)
    (ee-backward-delete-char ee entry c)))


(begin
  ;; set keybinding.
  (expeditor-bind-key! "^J"   ee-accept)
  (expeditor-bind-key! "\\ew" ee-bothward-delete-char)

  (hash-set! ee-parens #\( "[]")
  (expeditor-bind-key! #\) (make-ee-insert-string "]"))
  (hash-set! ee-parens #\[ "()")
  (expeditor-bind-key! #\] (make-ee-insert-string ")"))
  (for ([(k v) (in-hash ee-parens)])
    (expeditor-bind-key! (string k) ee-insert-paren)))

(begin
  ;; set color.
  (expeditor-set-syntax-color! 'identifier 'white)
  (expeditor-set-syntax-color! 'paren      'light-gray)
  (expeditor-set-syntax-color! 'literal    'light-green))
