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

(defparameter handler (clack:clackup *echo-server* :server :wookie :port 5000))
;; (clack:stop handler)

;; WHY DOESN’T THIS WORK?
;; (websocket-driver:send-text (car (nth 0 (alexandria:hash-table-alist *connections*))) "tralala")


;; (ready-state (car (nth 0 (alexandria:hash-table-alist *connections*))))
