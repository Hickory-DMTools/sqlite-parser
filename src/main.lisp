(defpackage #:sqlite-parser
  (:use #:cl #:esrap)
  (:shadow #:defrule))

(in-package #:sqlite-parser)

(defmacro defrule (symbol expr &body options)
  "Don't permit rules using inherited symbols."
  (unless (eql (symbol-package symbol) *package*)
    (error "~a from outside package." symbol))
  `(esrap:defrule ,symbol ,expr
     ,@options))

(defrule _NULL (~ "null") (:constant :null))
(defrule _TRUE (~ "true") (:constant :true))
(defrule _FALSE (~ "false") (:constant :false))
(defrule _CURRENT_TIME (~ "current_time") (:constant :current-time))
(defrule _CURRENT_DATE (~ "current_date") (:constant :current-date))
(defrule _CURRENT_TIMESTAMP (~ "current_timestamp") (:constant :current-timestamp))

(defrule digit (character-ranges (#\0 #\9)))
(defrule hexdigit (character-ranges (#\0 #\9) (#\a #\f) (#\A #\F)))

(defrule literal-value
    (or numeric-literal
        string-literal
        blob-literal
        _NULL
        _TRUE
        _FALSE
        _CURRENT_TIMESTAMP
        _CURRENT_TIME
        _CURRENT_DATE))

(defrule numeric-literal
    (or (and (~ "0x") (+ hexdigit))
        (and (+ digit) (? (and "." (* digit))) #1=(? (and (or "e" "E") (? (or "-" "+")) (+ digit))))
        (and "." (+ digit) #1#))
  (:lambda (match)
    (cons :number-literal (text match))))

(defrule |'escape| "''" (:constant #\'))

(defrule string-literal (and "'" (* (or (not "'") |'escape|)) "'")
  (:destructure (open match close)
    (declare (ignore open close))
    (cons :string-literal (text match))))

(defrule blob-literal (and (~ "x") "'" (* hexdigit) "'")
  (:destructure (prefix open match close)
    (declare (ignore prefix open close))
    (cons :blob-literal (text match))))
