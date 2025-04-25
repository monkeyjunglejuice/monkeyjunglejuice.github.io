;;;  Start the webserver from the commmand line via 'sbcl -l webserver.lisp'
;;;  or evaluate each toplevel form in the REPL.

(ql:quickload 'hunchentoot)

;; The webserver
(defvar *acceptor*
  (make-instance 'hunchentoot:easy-acceptor
                 :address "localhost"
                 :port 50081))

(setf (hunchentoot:acceptor-document-root *acceptor*)
      #P"~/Documents/monkeyjunglejuice/")

;; The main function
(defun main ()
  (hunchentoot:start *acceptor*)
  (handler-case (bt:join-thread
                 (find-if (lambda (th)
                            (search "hunchentoot" (bt:thread-name th)))
                          (bt:all-threads)))
    ;; Catch a user's C-c
    (#+sbcl sb-sys:interactive-interrupt
     #+ccl ccl:interrupt-signal-condition
     #+clisp system::simple-interrupt-condition
     #+ecl ext:interactive-interrupt
     #+allegro excl:interrupt-signal
     () (progn
          (format *error-output* "Aborting.~&")
          (hunchentoot:stop *acceptor*)
          (uiop:quit)))
    (error (c) (format t "Oopsie, an unknown error occured:~&~a~&" c))))

;; Start the webserver
(main)
