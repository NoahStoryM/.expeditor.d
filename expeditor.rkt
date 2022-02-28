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

(define ee-switch-paste-mode
  (let ([ee-paste-mode? (make-parameter #t)])
    (λ (ee entry c)
      (define ee-insert
        (if (ee-paste-mode?)
            ee-insert-paren
            ee-insert-self/paren))
      (for ([(k v) (in-hash ee-parens)])
        (expeditor-bind-key! k ee-insert))
      (ee-paste-mode? (not (ee-paste-mode?)))
      entry)))

(define ee-bothward-delete-char
  (λ (ee entry c)
    (ee-delete-char ee entry c)
    (ee-backward-delete-char ee entry c)))


(begin
  ;; set keybinding.
  (expeditor-bind-key! "^J"   ee-accept)
  (expeditor-bind-key! "\\ew" ee-bothward-delete-char)

  (hash-set! ee-parens #\( "[]")
  (hash-set! ee-parens #\[ "()")

  (expeditor-bind-key! "^V" ee-switch-paste-mode))

(begin
  ;; set color.
  (expeditor-set-syntax-color! 'identifier 'white)
  (expeditor-set-syntax-color! 'paren      'light-gray)
  (expeditor-set-syntax-color! 'literal    'light-green))
