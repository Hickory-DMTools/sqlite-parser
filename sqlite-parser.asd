(defsystem "sqlite-parser"
  :version "0.1.0"
  :author "Jonas Rodrigues"
  :license "MIT"
  :description "Parser for SQLite DDL, DML and DQL"
  :depends-on ("esrap")
  :components ((:module "src"
                :components
                ((:file "main"))))
  :in-order-to ((test-op (test-op "sqlite-parser/tests"))))

(defsystem "sqlite-parser/tests"
  :author "Jonas Rodrigues"
  :license "MIT"
  :depends-on ("sqlite-parser" "fiveam")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for sqlite-parser"
  :perform (test-op (op c) (symbol-call :5am :run! :sqlite-parser)))
