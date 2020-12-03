(defsystem "dasa"
  :version "1"
  :author "Edgard Bikelis <bikelis@gmail.com>"
  :depends-on ("clack" 
               "websocket-driver-server")
  :components ((:file "dasa"))
  :description "A minimal text for using websockets.")
