(defpackage dasa
  (:use :cl :websocket-driver))

(in-package :dasa)

(defvar *connections* (make-hash-table))
(defparameter servidor nil)

(defun handle-new-connection (con)
  (setf (gethash con *connections*)
        (format nil "user-~a" (random 100000))))

(defun handle-close-connection (connection)
  (let ((message (format nil " .... ~a has left."
                         (gethash connection *connections*))))
    (remhash connection *connections*)
    (loop :for con :being :the :hash-key :of *connections* :do
      (send con message))))

(defparameter *echo-server*
  (lambda (env)
    (let ((ws (make-server env)))
      (on :open    ws (lambda () (handle-new-connection ws)))
      (on :message ws (lambda (message)
			(print ws)
			(print message)
			(send ws message)))
      (on :close   ws (lambda (&key code reason)
                        (declare (ignore code reason))
                        (handle-close-connection ws)))
      (lambda (responder)
        (declare (ignore responder))
        (start-connection ws)))))

(defparameter handler (clack:clackup *echo-server* :server :hunchentoot :port 5000))
;; to stop: (clack:stop handler)


(defun state-of-latest-connection ()
  (ready-state (car (nth 0 (alexandria:hash-table-alist *connections*)))))

(defun send-to-latest-connection (thing)
  (websocket-driver:send (car (nth 0 (alexandria:hash-table-alist *connections*))) thing))

(defparameter botão "<button type=\"button\" onclick=\"document.body.style.backgroundColor = 'black'\">
Click me to change the background color to black</button>")

