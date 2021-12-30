#lang racket/base

(require (submod expeditor configure))


(define ee-parens
  (hash-copy
   #hasheq([#\( . "[]"]
           [#\[ . "()"]
           [#\{ . "{}"])))

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
  ;; set keybind.
  (expeditor-bind-key! "^J"   ee-accept)
  (expeditor-bind-key! "\\ew" ee-bothward-delete-char)
  (expeditor-bind-key! "("    ee-insert-paren)
  (expeditor-bind-key! "["    ee-insert-paren)
  (expeditor-bind-key! "{"    ee-insert-paren))

(begin
  ;; set color.
  (expeditor-set-syntax-color! 'paren      'white)
  (expeditor-set-syntax-color! 'identifier 'light-cyan)
  (expeditor-set-syntax-color! 'literal    'light-green))
