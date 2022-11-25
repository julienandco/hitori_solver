;;; IC: Trabajo (2022/2023)
;;; ResoluciÃ³n deductiva del puzle Hitori
;;; Departamento de Ciencias de la ComputaciÃ³n e Inteligencia Artificial 
;;; Universidad de Sevilla
;;;============================================================================


;;;============================================================================
;;; IntroducciÃ³n
;;;============================================================================

;;;   Hitori es uno de los pasatiempos lÃ³gicos popularizados por la revista
;;; japonesa Nikoli. El objetivo del juego consiste en, dada una cuadrÃ­cula
;;; con cifras, determinar cuales hay que quitar para conseguir que no haya
;;; elementos repetidos ni en las filas ni en las columnas. TambiÃ©n hay otras
;;; restricciones sobre la forma en que se puede eliminar estos elementos y las
;;; veremos un poco mÃ¡s adelante.
;;;
;;;   En concreto vamos a considerar cuadrÃ­culas de tamaÃ±o 9x9 con cifras del 1
;;; al 9 como la siguiente:
;;;
;;;                  â•”â•â•â•â•¤â•â•â•â•¤â•â•â•â•¤â•â•â•â•¤â•â•â•â•¤â•â•â•â•¤â•â•â•â•¤â•â•â•â•¤â•â•â•â•—
;;;                  â•‘ 2 â”‚ 9 â”‚ 8 â”‚ 7 â”‚ 4 â”‚ 6 â”‚ 4 â”‚ 7 â”‚ 6 â•‘
;;;                  â•Ÿâ”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â•¢
;;;                  â•‘ 7 â”‚ 4 â”‚ 9 â”‚ 2 â”‚ 8 â”‚ 3 â”‚ 4 â”‚ 3 â”‚ 5 â•‘
;;;                  â•Ÿâ”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â•¢
;;;                  â•‘ 4 â”‚ 7 â”‚ 5 â”‚ 3 â”‚ 6 â”‚ 5 â”‚ 6 â”‚ 6 â”‚ 5 â•‘
;;;                  â•Ÿâ”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â•¢
;;;                  â•‘ 6 â”‚ 1 â”‚ 3 â”‚ 7 â”‚ 6 â”‚ 9 â”‚ 7 â”‚ 2 â”‚ 4 â•‘
;;;                  â•Ÿâ”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â•¢
;;;                  â•‘ 1 â”‚ 3 â”‚ 3 â”‚ 7 â”‚ 2 â”‚ 8 â”‚ 6 â”‚ 5 â”‚ 1 â•‘
;;;                  â•Ÿâ”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â•¢
;;;                  â•‘ 9 â”‚ 8 â”‚ 6 â”‚ 2 â”‚ 3 â”‚ 8 â”‚ 5 â”‚ 5 â”‚ 2 â•‘
;;;                  â•Ÿâ”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â•¢
;;;                  â•‘ 8 â”‚ 4 â”‚ 7 â”‚ 9 â”‚ 3 â”‚ 3 â”‚ 2 â”‚ 1 â”‚ 6 â•‘
;;;                  â•Ÿâ”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â•¢
;;;                  â•‘ 6 â”‚ 2 â”‚ 4 â”‚ 1 â”‚ 7 â”‚ 4 â”‚ 4 â”‚ 9 â”‚ 3 â•‘
;;;                  â•Ÿâ”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â•¢
;;;                  â•‘ 8 â”‚ 4 â”‚ 1 â”‚ 3 â”‚ 5 â”‚ 1 â”‚ 9 â”‚ 8 â”‚ 1 â•‘
;;;                  â•šâ•â•â•â•§â•â•â•â•§â•â•â•â•§â•â•â•â•§â•â•â•â•§â•â•â•â•§â•â•â•â•§â•â•â•â•§â•â•â•â•
;;;
;;;   El puzle resuelto es el siguiente:
;;;
;;;                  â•”â•â•â•â•¤â•â•â•â•¤â•â•â•â•¤â•â•â•â•¤â•â•â•â•¤â•â•â•â•¤â•â•â•â•¤â•â•â•â•¤â•â•â•â•—
;;;                  â•‘ 2 â”‚ 9 â”‚ 8 â”‚â–“â–“â–“â”‚ 4 â”‚ 6 â”‚â–“â–“â–“â”‚ 7 â”‚â–“â–“â–“â•‘
;;;                  â•Ÿâ”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â•¢
;;;                  â•‘ 7 â”‚â–“â–“â–“â”‚ 9 â”‚ 2 â”‚ 8 â”‚â–“â–“â–“â”‚ 4 â”‚ 3 â”‚ 5 â•‘
;;;                  â•Ÿâ”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â•¢
;;;                  â•‘ 4 â”‚ 7 â”‚â–“â–“â–“â”‚ 3 â”‚â–“â–“â–“â”‚ 5 â”‚â–“â–“â–“â”‚ 6 â”‚â–“â–“â–“â•‘
;;;                  â•Ÿâ”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â•¢
;;;                  â•‘â–“â–“â–“â”‚ 1 â”‚ 3 â”‚â–“â–“â–“â”‚ 6 â”‚ 9 â”‚ 7 â”‚ 2 â”‚ 4 â•‘
;;;                  â•Ÿâ”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â•¢
;;;                  â•‘ 1 â”‚ 3 â”‚â–“â–“â–“â”‚ 7 â”‚ 2 â”‚ 8 â”‚ 6 â”‚ 5 â”‚â–“â–“â–“â•‘
;;;                  â•Ÿâ”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â•¢
;;;                  â•‘ 9 â”‚ 8 â”‚ 6 â”‚â–“â–“â–“â”‚ 3 â”‚â–“â–“â–“â”‚ 5 â”‚â–“â–“â–“â”‚ 2 â•‘
;;;                  â•Ÿâ”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â•¢
;;;                  â•‘ 8 â”‚â–“â–“â–“â”‚ 7 â”‚ 9 â”‚â–“â–“â–“â”‚ 3 â”‚ 2 â”‚ 1 â”‚ 6 â•‘
;;;                  â•Ÿâ”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â•¢
;;;                  â•‘ 6 â”‚ 2 â”‚â–“â–“â–“â”‚ 1 â”‚ 7 â”‚ 4 â”‚â–“â–“â–“â”‚ 9 â”‚ 3 â•‘
;;;                  â•Ÿâ”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â•¢
;;;                  â•‘â–“â–“â–“â”‚ 4 â”‚ 1 â”‚â–“â–“â–“â”‚ 5 â”‚â–“â–“â–“â”‚ 9 â”‚ 8 â”‚â–“â–“â–“â•‘
;;;                  â•šâ•â•â•â•§â•â•â•â•§â•â•â•â•§â•â•â•â•§â•â•â•â•§â•â•â•â•§â•â•â•â•§â•â•â•â•§â•â•â•â•
;;;
;;;   Se deben cumplir dos restricciones adicionales sobre los elementos
;;; eliminados:
;;; 1) No pueden eliminarse elementos en celdas colindantes horizontal o
;;;    verticalmente. 
;;; 2) Todas las celdas cuyo valor se mantiene deben formar una Ãºnica
;;;    componente conectada horizontal o verticalmente
;;;
;;;   La primera restricciÃ³n impide que se puedan hacer cosas como esta:
;;;
;;;                  â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼
;;;                  â”‚ 3 â”‚â–“â–“â–“â”‚â–“â–“â–“â”‚ 6 â”‚
;;;                  â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼
;;;
;;;   La segunda restricciÃ³n impide que se puedan hacer cosas como esta:
;;;
;;;                  â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼
;;;                  â”‚ 3 â”‚â–“â–“â–“â”‚ 7 â”‚
;;;                  â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼
;;;                  â”‚â–“â–“â–“â”‚ 3 â”‚â–“â–“â–“â”‚
;;;                  â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼
;;;                  â”‚ 9 â”‚â–“â–“â–“â”‚ 3 â”‚
;;;                  â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼â”€â”€â”€â”¼
;;;
;;;   TambiÃ©n es importante tener en cuenta que el puzle tiene soluciÃ³n Ãºnica,
;;; algo que puede ayudar a obtener dicha soluciÃ³n.
;;;
;;;   Para ello se proporciona un fichero de ejemplos que contiene 50 puzles
;;; Hitori con soluciÃ³n Ãºnica de tamaÃ±o 9x9 representados como una Ãºnica lÃ­nea
;;; en la que tambiÃ©n se indica la soluciÃ³n. Si se transcribe esta lÃ­nea 
;;; separando las 9 filas tendrÃ­amos lo siguiente:
;;;
;;;     w2 w9 w8 b7 w4 w6 b4 w7 b6 
;;;     w7 b4 w9 w2 w8 b3 w4 w3 w5 
;;;     w4 w7 b5 w3 b6 w5 b6 w6 b5 
;;;     b6 w1 w3 b7 w6 w9 w7 w2 w4 
;;;     w1 w3 b3 w7 w2 w8 w6 w5 b1 
;;;     w9 w8 w6 b2 w3 b8 w5 b5 w2 
;;;     w8 b4 w7 w9 b3 w3 w2 w1 w6 
;;;     w6 w2 b4 w1 w7 w4 b4 w9 w3 
;;;     b8 w4 w1 b3 w5 b1 w9 w8 b1 
;;;
;;; donde cada nÃºmero se corresponde con la cifra que originalmente hay en cada
;;; celda y las letras w y b representan si en la soluciÃ³n dicho nÃºmero se
;;; mantiene (w) o se elimina (b).

;;;============================================================================
;;; RepresentaciÃ³n del Hitori
;;;============================================================================

;;;   Utilizaremos la siguiente plantilla para representar las celdas del
;;; Hitori. Cada celda tiene los siguientes campos:
;;; - fila: NÃºmero de fila en la que se encuentra la celda
;;; - columna: NÃºmero de columna en la que se encuentra la celda
;;; - valor: Valor numÃ©rico de la celda
;;; - estado: Estado de la celda. Puede ser 'desconocido', que indica que
;;;   todavÃ­a no se ha tomado ninguna decisiÃ³n sobre la celda; 'asignado', que
;;;   incida que el valor de la celda se mantiene en la soluciÃ³n; y
;;;   'eliminado', que indica que el valor de la celda es eliminado en la
;;;   soluciÃ³n. El valor por defecto es 'desconocido'.

(deftemplate celda
  (slot fila)
  (slot columna)
  (slot valor)
  (slot estado
	(allowed-values desconocido asignado eliminado)
	(default desconocido)))

;;;============================================================================
;;; Estrategias de resoluciÃ³n
;;;============================================================================

;;;   El objetivo de este trabajo es implementar un programa CLIPS que resuelva
;;; un Hitori de forma deductiva, es decir, deduciendo si el nÃºmero de una
;;; celda debe eliminarse o debe mantenerse a partir de reglas que analicen los
;;; valores y situaciones de las celdas relacionadas.


;;; Si un número x esta en una celda y ambos celdas adyacentes en una fila
;;; contienen el mismo número y != x, entonces x debe ser asignado.
;;; 
;;; Ejemplo:
;;;
;;;   2 3 2 -> el 3 esta asignado
;;;

(defrule sandwich-fila    
  ?h <- (celda (fila ?f) (columna ?c1) (estado desconocido))
  (celda (fila ?f) (columna ?c2) (valor ?v))
  (celda (fila ?f) (columna ?c3) (valor ?v))
  (test (= ?c2 (+ ?c1 1)))
  (test (= ?c3 (- ?c1 1)))
  =>
  (modify ?h (estado asignado))
)

;;; Si un número x esta en una celda y ambos celdas adyacentes en una columna
;;; contienen el mismo número y != x, entonces x debe ser asignado.
;;; 
;;; Ejemplo:
;;;
;;;     4
;;;     2   -> el 2 esta asignado
;;;     4
;;;

(defrule sandwich-columna
  ?h <- (celda (columna ?c) (fila ?f1) (estado desconocido))
  (celda (columna ?c) (fila ?f2) (valor ?v))
  (celda (columna ?c) (fila ?f3) (valor ?v))
  (test (= ?f2 (+ ?f1 1)))
  (test (= ?f3 (- ?f1 1)))
  =>
  (modify ?h (estado asignado)) 
)

;;; Si hay una pareja de un número x en una fila y hay una otra celda con x en la misma
;;; fila NON adyacente a la pareja, entonces el x soltero debe ser eliminado.
;;; 
;;; Ejemplo:
;;;
;;;   1 2 2 3 4 4 2 8 
;;;               ^
;;;               este 2 se elimina
;;;
(defrule pareja-y-soltero-fila
  ?h <- (celda (fila ?f) (columna ?c1) (valor ?v) (estado desconocido))
  (celda (fila ?f) (columna ?c2) (valor ?v))
  (celda (fila ?f) (columna ?c3) (valor ?v))
  (test (= ?c2 (- ?c3 1))) ;comprobar que los dos celdas sean una pareja
  (test (or (> ?c1 (+ ?c3 1)) (< ?c1 (- ?c2 1)))) ;comprobar que la celda soltera esta en una celda non adyacente
  => 
  (modify ?h (estado eliminado)) 
)

;;; Si hay una pareja de un número x en una columna y hay una otra celda con x en la 
;;; misma columna NON adyacente a la pareja, entonces el x soltero debe ser eliminado.
;;; 
;;; Ejemplo:
;;;
;;;   1 
;;;   2 
;;;   2
;;;   3
;;;   4
;;;   2 <- este 2 se elimina
;;;   8 
;;;

(defrule pareja-y-soltero-columna
  ?h <- (celda (columna ?c) (fila ?f1) (valor ?v) (estado desconocido))
  (celda (columna ?c) (fila ?f2) (valor ?v))
  (celda (columna ?c) (fila ?f3) (valor ?v))
  (test (= ?f2 (- ?f3 1))) ;comprobar que los dos celdas sean una pareja
  (test (or (> ?f1 (+ ?f3 1)) (< ?f1 (- ?f2 1)))) ;comprobar que la celda soltera esta en una celda non adyacente
  => 
  (modify ?h (estado eliminado)) 
)

;;; Si una celda esta amarcada como eliminada, entonces cada celda adyacente
;;; esta asignada, porque no puede haber dos celdas adyacentes eliminadas.
;;;
(defrule asignar-entorno-de-eliminado
  (celda (fila ?f1) (columna ?c1) (estado eliminado))
  ?h <- (celda (fila ?f2) (columna ?c2) (estado desconocido))
  (test (or (and (= ?f2 (+ ?f1 1)) (= ?c1 ?c2)) ;celda abajo
           (and (= ?f2 (- ?f1 1)) (= ?c1 ?c2)) ;celda arriba
           (and (= ?c2 (+ ?c1 1)) (= ?f1 ?f2)) ;celda derecha
           (and (= ?c2 (- ?c1 1)) (= ?f1 ?f2)))) ;celda izquierda
  => 
  (modify ?h (estado asignado)) 
)

;;; Si una celda que contiene x esta amarcada como asignado, entonces cada celda 
;;; en la misma fila que también contiene x, tiene que estar eliminada.
;;;
(defrule eliminar-dobles-fila
  (celda (fila ?f) (columna ?c1) (valor ?v) (estado asignado))
  ?h <- (celda (fila ?f) (columna ?c2&~?c1) (valor ?v) (estado desconocido))
  => 
  (modify ?h (estado eliminado))
)

;;; Si una celda que contiene x esta amarcada como asignado, entonces cada celda 
;;; en la misma columna que también contiene x, tiene que estar eliminada.
;;;
(defrule eliminar-dobles-columna
  (celda (fila ?f1) (columna ?c) (valor ?v) (estado asignado))
  ?h <- (celda (fila ?f2&~?f1) (columna ?c) (valor ?v) (estado desconocido))
  => 
  (modify ?h (estado eliminado))
)

;;; Si una celda es la unica que contiene un número x en una fila y columna, 
;;; o si es la unica que contiene x con el estado desconocido y todas las otras
;;; celdas con un x son eliminadas, entonces esta celda debe estar asignada. 
;;; No hay nada que podría forzarla a estar eliminada.
;;;
;;; Asignamos a la regla una salienca de -5, porque sea ejecutada antes de las reglas
;;; para imprimir la solucion, pero despues de las reglas eliminar-dobles-fila y 
;;; eliminar-dobles-columna. Asi no tenemos que checkear por el valor asignado, porque
;;; sabemos que si había una celda en la misma fila o columna con x y el valor asignado,
;;; la celda ?h de la regla asignar-solteros ya hubiera estado eliminada por una de las 
;;; reglas eliminar-dobles y la regla asignar-solteros ni siquiera se activaría.
(defrule asignar-solteros
  (declare (salience -5))
  ?h <- (celda (fila ?f) (columna ?c) (valor ?v) (estado desconocido))
  (not (celda (fila ?f) (columna ?c1&~?c) (valor ?v) (estado desconocido)))
  (not (celda (fila ?f1&~?f) (columna ?c) (valor ?v) (estado desconocido)))
  => 
  (modify ?h (estado asignado))
)

;;; Si una celda en una esquina de tablero esta eliminada, lo otra tiene que ser 
;;; asignada, porque no se puede encerrar una celda en una esquina.
;;;
;;; Ejemplo:
;;;
;;; 1 2 <- si el 2 esta eliminado, el 3 tiene que ser asignado
;;; 3
;;;
(defrule no-encerrar-esquina
  (celda (fila ?f1) (columna ?c1) (estado eliminado))
  ?h <- (celda (fila ?f2) (columna ?c2) (estado desconocido))
  (test (or 
          (and (= ?f1 1) (= ?c1 2) (= ?f2 2) (= ?c2 1)) ;esquina arriba izquierda
          (and (= ?f1 2) (= ?c1 1) (= ?f2 1) (= ?c2 2))
          (and (= ?f1 1) (= ?c1 8) (= ?f2 2) (= ?c2 9)) ;esquina arriba derecha
          (and (= ?f1 2) (= ?c1 9) (= ?f2 1) (= ?c2 8))
          (and (= ?f1 8) (= ?c1 1) (= ?f2 9) (= ?c2 2)) ;esquina abaja izquierda
          (and (= ?f1 9) (= ?c1 2) (= ?f2 8) (= ?c2 1))
          (and (= ?f1 8) (= ?c1 9) (= ?f2 9) (= ?c2 8)) ;esquina abaja derecha
          (and (= ?f1 9) (= ?c1 8) (= ?f2 8) (= ?c2 9))
        ))
  => 
  (modify ?h (estado asignado))
)

;;; Una celda no puede ser encerrada de todos los cuatros lados por celdas eliminadas.
;;;
;;; Ejemplo:
;;;   5
;;; 4 1 2 <- si el 2,3 y 4 estan eliminados, el 5 tiene que ser asignado
;;;   3
;;;
(defrule no-encerrar-cuadro
  (celda (fila ?f1) (columna ?c1) (estado eliminado))
  (celda (fila ?f2) (columna ?c2) (estado eliminado))
  (celda (fila ?f3) (columna ?c3) (estado eliminado))
  ?h <- (celda (fila ?f4) (columna ?c4) (estado desconocido))
  (test (or 
          (and (= ?f2 ?f1) (= ?c2 (+ ?c1 2)) (= ?f3 (+ ?f1 1)) (= ?c3 (+ ?c1 1)) (= ?f4 (- ?f1 1)) (= ?c4 (+ ?c1 1))) ;la de arriba esta desconocida
          (and (= ?f2 (- ?f1 1)) (= ?c2 (+ ?c1 1)) (= ?f3 (+ ?f1 1)) (= ?c3 (+ ?c1 1)) (= ?f4 ?f1) (= ?c4 (+ ?c1 2))) ;la de derecha esta desconocida
          (and (= ?f2 (- ?f1 1)) (= ?c2 (+ ?c1 1)) (= ?f3 ?f1) (= ?c3 (+ ?c1 2)) (= ?f4 (+ ?f1 1)) (= ?c4 (+ ?c1 1))) ;la de abajo esta desconocida
          (and (= ?f2 (+ ?f1 1)) (= ?c2 (+ ?c1 1)) (= ?f3 (+ ?f1 2)) (= ?c3 ?c1) (= ?f4 (+ ?f1 1)) (= ?c4 (- ?c1 1))) ;la de izquierda esta desconocida
        ))
  => 
  (modify ?h (estado asignado))
)

;;; Una celda al lado del tablero no puede ser encerrada de todos los tres lados 
;;; por celdas eliminadas.
;;;
;;; Ejemplo:
;;; | 4
;;; | 1 2 <- si el 2 y 3 estan eliminados, el 4 tiene que ser asignado
;;; | 3
;;;
;;;   2
;;; 4 1 3  <- si el 2 y 3 estan eliminados, el 4 tiene que ser asignado
;;; _____

(defrule no-encerrar-lado-vertical
  (celda (fila ?f1) (columna ?c1) (estado eliminado))
  (celda (fila ?f2) (columna ?c2) (estado eliminado))
  ?h <- (celda (fila ?f3) (columna ?c3) (estado desconocido))
  (test (or 
          ; lado izquierdo del tablero (columna 1)
          (and (= ?c1 1) (= ?f2 (- ?f1 1)) (= ?c2 (+ ?c1 1)) (= ?f3 (- ?f1 2)) (= ?c3 ?c1)) ;la celda de arriba esta desconocida
          (and (= ?c1 1) (= ?f2 (+ ?f1 2)) (= ?c2 ?c1) (= ?f3 (+ ?f1 1)) (= ?c3 (+ ?c1 1))) ;la de derecho esta desconocida
          (and (= ?c1 1) (= ?f2 (+ ?f1 1)) (= ?c2 (+ ?c1 1)) (= ?f3 (+ ?f1 2)) (= ?c3 ?c1)) ;la de abajo esta desconocida
          ; lado derecho del tablero (columna 9)
          (and (= ?c1 9) (= ?f2 (- ?f1 1)) (= ?c2 (- ?c1 1)) (= ?f3 (- ?f1 2)) (= ?c3 ?c1)) ;la de arriba esta desconocida
          (and (= ?c1 9) (= ?f2 (+ ?f1 2)) (= ?c2 ?c1) (= ?f3 (+ ?f1 1)) (= ?c3 (- ?c1 1))) ;la de izquierda esta desconocida
          (and (= ?c1 9) (= ?f2 (+ ?f1 1)) (= ?c2 (- ?c1 1)) (= ?f3 (+ ?f1 2)) (= ?c3 ?c1)) ;la de abajo esta desconocida
         ))
  => 
  (modify ?h (estado asignado))
)

(defrule no-encerrar-lado-horizontal
  (celda (fila ?f1) (columna ?c1) (estado eliminado))
  (celda (fila ?f2) (columna ?c2) (estado eliminado))
  ?h <- (celda (fila ?f3) (columna ?c3) (estado desconocido))
  (test (or 
          ; lado arriba del tablero (fila 1)
          (and (= ?f1 1) (= ?f2 ?f1) (= ?c2 (+ ?c1 2)) (= ?f3 (+ ?f1 1)) (= ?c3 (+ ?c1 1))) ;la celda de abajo esta desconocida
          (and (= ?f1 1) (= ?f2 (+ ?f1 1)) (= ?c2 (- ?c1 1)) (= ?f3 ?f1) (= ?c3 (- ?c1 2))) ;la de izquierda esta desconocida
          (and (= ?f1 1) (= ?f2 (+ ?f1 1)) (= ?c2 (+ ?c1 1)) (= ?f3 ?f1) (= ?c3 (+ ?c1 2))) ;la de derecha esta desconocida
          ; lado abajo del tablero (fila 9)
          (and (= ?f1 9) (= ?f2 ?f1) (= ?c2 (+ ?c1 2)) (= ?f3 (- ?f1 1)) (= ?c3 (+ ?c1 1))) ;la de arriba esta desconocida
          (and (= ?f1 9) (= ?f2 (- ?f1 1)) (= ?c2 (- ?c1 1)) (= ?f3 ?f1) (= ?c3 (- ?c1 2))) ;la de izquierda esta desconocida
          (and (= ?f1 9) (= ?f2 (- ?f1 1)) (= ?c2 (+ ?c1 1)) (= ?f3 ?f1) (= ?c3 (+ ?c1 2))) ;la de derecha esta desconocida
         ))
  => 
  (modify ?h (estado asignado))
)

;;;TODO: this rule does not help at all
; (defrule m-pair-col
;   (celda (fila ?f1) (columna ?c1) (valor ?v1))
;   (celda (fila ?f1) (columna ?c2) (valor ?v2))
;   (test(= ?c2 (+ ?c1 1)))
;   (celda (fila ?f2) (columna ?c1) (valor ?v1))
;   (celda (fila ?f2) (columna ?c2) (valor ?v2))
;   (test(neq ?f1 ?f2))
;   ?h <- (celda (fila ?f3) (columna ?c3) (estado desconocido) (valor ?v3))
;   (test (or 
;           (and (= ?c1 ?c3) (eq ?v1 ?v3) (neq ?f1 ?f3) (neq ?f2 ?f3)) 
;           (and (= ?c2 ?c3) (eq ?v2 ?v3) (neq ?f1 ?f3) (neq ?f2 ?f3)) 
;         ))
;   => 
;   (printout t "m-pair-col hecha" crlf)
;   (modify ?h (estado eliminado))
; )

; (defrule m-pair-fila
;   (celda (fila ?f1) (columna ?c1) (valor ?v1))
;   (celda (fila ?f2) (columna ?c1) (valor ?v2))
;   (test(= ?f2 (+ ?f1 1)))
;   (celda (fila ?f1) (columna ?c2) (valor ?v1))
;   (celda (fila ?f2) (columna ?c2) (valor ?v2))
;   (test(neq ?c1 ?c2))
;   ?h <- (celda (fila ?f3) (columna ?c3) (estado desconocido) (valor ?v3))
;   (test (or 
;           (and (= ?f1 ?f3) (eq ?v1 ?v3) (neq ?c1 ?c3) (neq ?c2 ?c3)) 
;           (and (= ?f2 ?f3) (eq ?v2 ?v3) (neq ?c1 ?c3) (neq ?c2 ?c3)) 
;         ))
;   => 
;   (printout t "m-pair-fila hecha" crlf)
;   (modify ?h (estado eliminado))
; )

;;; TODO: those roles do not help in solving
; ;;; Si dos dobles son en "sandwich" en una fila/columna, todos los singulos de la 
; ;;; misma fila/columna tienen que estar eliminados.
; ;;;
; ;;; 2 3 3 2 1 5 6 3 4 2
; ;;;               ^   ^ (el singulo 3 y 2 ambos tienen que estar eliminados)
; ;;;

; (defrule isolacion-flancada-fila-1
;   (celda (fila ?f) (columna ?c1) (valor ?v1))
;   (celda (fila ?f) (columna ?c2) (valor ?v2))
;   (celda (fila ?f) (columna ?c3) (valor ?v2))
;   (celda (fila ?f) (columna ?c4) (valor ?v1))
;   (test(and (= ?c2 (+ ?c1 1)) (= ?c3 (+ ?c1 2)) (= ?c4 (+ ?c1 3))))
;   ?h <- (celda (fila ?f) (columna ?c5) (estado desconocido) (valor ?v1))
;   (test (or (< ?c5 ?c1) (> ?c5 ?c4)))
;   => 
;   (printout t "flancada 1 hecha" crlf)
;   (modify ?h (estado eliminado))
; )
; (defrule isolacion-flancada-fila-2
;   (celda (fila ?f) (columna ?c1) (valor ?v1))
;   (celda (fila ?f) (columna ?c2) (valor ?v2))
;   (celda (fila ?f) (columna ?c3) (valor ?v2))
;   (celda (fila ?f) (columna ?c4) (valor ?v1))
;   (test(and (= ?c2 (+ ?c1 1)) (= ?c3 (+ ?c1 2)) (= ?c4 (+ ?c1 3))))
;   ?h <- (celda (fila ?f) (columna ?c5) (estado desconocido) (valor ?v2))
;   (test (or (< ?c5 ?c1) (> ?c5 ?c4)))
;   => 
;   (printout t "flancada 2 hecha" crlf)
;   (modify ?h (estado eliminado))
; )
; (defrule isolacion-flancada-columna-1
;   (celda (fila ?f1) (columna ?c) (valor ?v1))
;   (celda (fila ?f2) (columna ?c) (valor ?v2))
;   (celda (fila ?f3) (columna ?c) (valor ?v2))
;   (celda (fila ?f4) (columna ?c) (valor ?v1))
;   (test(and (= ?f2 (+ ?f1 1)) (= ?f3 (+ ?f1 2)) (= ?f4 (+ ?f1 3))))
;   ?h <- (celda (fila ?f5) (columna ?c) (estado desconocido) (valor ?v1))
;   (test (or (< ?f5 ?f1) (> ?f5 ?f4)))
;   => 
;   (printout t "flancada-col 1 hecha" crlf)
;   (modify ?h (estado eliminado))
; )
; (defrule isolacion-flancada-columna-2
;   (celda (fila ?f1) (columna ?c) (valor ?v1))
;   (celda (fila ?f2) (columna ?c) (valor ?v2))
;   (celda (fila ?f3) (columna ?c) (valor ?v2))
;   (celda (fila ?f4) (columna ?c) (valor ?v1))
;   (test(and (= ?f2 (+ ?f1 1)) (= ?f3 (+ ?f1 2)) (= ?f4 (+ ?f1 3))))
;   ?h <- (celda (fila ?f5) (columna ?c) (estado desconocido) (valor ?v2))
;   (test (or (< ?f5 ?f1) (> ?f5 ?f4)))
;   => 
;   (printout t "flancada-col 2 hecha" crlf)
;   (modify ?h (estado eliminado))
; )

;;;TODO: es fehlt noch eine generelle regel für no islands, nur die rand-regel
;;; reicht net.

;;; Template para el backtracking
; (deftemplate backtracking-step
;   (slot step-number)
;   (slot fila)
;   (slot columna)
; )

; (defrule backtrack-inicio
;  (declare (salience -8))
;  (not (puzle-resuelto))
;  (not (backtracking-step (step-number ?)))
;  ?h <- (celda (fila ?f) (columna ?c) (estado desconocido))
;  => 
;  (printout t "backtrack-inicio" crlf)
;  (assert (backtracking-step (step-number 0) (fila ?f) (columna ?c)))
;  (modify ?h (estado eliminado))
; )

; (defrule backtrack-paso
;  (declare (salience -8))
;  (not (puzle-resuelto))
;  ?s <- (backtracking-step (step-number ?n))
;  (not (backtracking-step (step-number ?n2&:(> ?n2 ?n))))
;  ?h <- (celda (fila ?f) (columna ?c) (estado desconocido))
;  => 
;  (printout t "backtrack-paso" crlf)
;  (assert (backtracking-step (step-number (+ ?n 1)) (fila ?f) (columna ?c)))
;  (modify ?h (estado eliminado))
; )

; (defrule undo-backtrack 
;  (declare (salience -8))
;  (not (puzle-resuelto))
;  (undo-backtrack)
;  ?s <- (backtracking-step (step-number ?n) (fila ?f) (columna ?c))
;  ?h <- (celda (fila ?f) (columna ?c))
;  => 
;  (printout t "undo-backtrack" crlf)
;  (retract ?s)
;  (modify ?h (estado desconocido))
; )

; (defrule undo-first-backtrack 
;  (declare (salience -9))
;  (not (puzle-resuelto))
;  (undo-backtrack)
;  ?s <- (backtracking-step (step-number 0) (fila ?f) (columna ?c))
;  (not (backtracking-step (step-number ?n&~0)))
;  ?h <- (celda (fila ?f) (columna ?c))
;  => 
;  (printout t "undo-first-backtrack" crlf)
;  (retract ?s)
;  (modify ?h (estado asignado))
; )

; (defrule error-dos-eliminadas-juntas
;  (celda (fila ?f1) (columna ?c1) (valor ?v1) (estado eliminado))
;  (celda (fila ?f2) (columna ?c2) (valor ?v2) (estado eliminado))
;  (test (or
;         (and (= ?f1 ?f2) (= ?c1 (+ ?c2 1)))
;         (and (= ?c1 ?c2) (= ?f1 (+ ?f2 1)))
;        ))
;  =>
;  (printout t "error-junta!" crlf)
;  (assert (undo-backtrack))
; )

(deftemplate particion
  (multislot miembros) ;;; Aqui se guardan las celdas que forman parte de la particion
)

;;; Determina si dos celda son vecinos o no
(deffunction son-vecinos (?f1 ?c1 ?f2 ?c2)
(return (or 
        (and (= ?f2 (- ?f1 1)) (= ?c1 ?c2)) ;vecino arriba
        (and (= ?f2 (+ ?f1 1)) (= ?c1 ?c2)) ;vecino abajo
        (and (= ?f1 ?f2) (= ?c2 (+ ?c1 1))) ;vecino derecho
        (and (= ?f1 ?f2) (= ?c2 (- ?c1 1))) ;vecino izquierdo
        ))
)

;;; No queremos dobles en los miembros
(defrule quitar-dobles-de-miembros-de-particion
  ?p <- (particion (miembros $?x ?c $?y ?c $?z))
  => 
  (modify ?p (miembros $?x ?c $?y $?z))
)

;;; Cuando una particion tiene como vecino un miembro de una otra particion, las particiones
;;; se unen y una de las dos particiones se elimina.
(defrule unir-dos-particiones
  ?h1 <- (celda (fila ?f1) (columna ?c1))
  ?h2 <- (celda (fila ?f2) (columna ?c2))
  (test (son-vecinos ?f1 ?c1 ?f2 ?c2))
  ?p1 <- (particion (miembros $?x1 ?h1 $?y1))
  ?p2 <- (particion (miembros $?x2 ?h2 $?y2))
  (test (neq ?p1 ?p2))
  =>
  (modify ?p1 (miembros $?x1 ?h1 $?y1 $?x2 ?h2 $?y2))
  (retract ?p2)
)

; ;;; Cada vez que una celda esta asignada, se une automaticamente a una particion. Si esta 
; ;;; vecina de una particion ya existente, se une a esa particion. Si no, se crea una nueva
; ;;; que solo contiene la celda que acaba de ser asignada.
(defrule añadir-asignado-a-particion-existente
  ?h1 <- (celda (fila ?f1) (columna ?c1) (estado asignado))
  ?h2 <- (celda (fila ?f2) (columna ?c2) (estado asignado))
  (test (son-vecinos ?f1 ?c1 ?f2 ?c2))
  (not (particion (miembros $?a ?h2 $?b)))
  ?p <- (particion (miembros $?x ?h1 $?y))
  => 
  (modify ?p (miembros $?x ?h1 ?h2 $?y))
)

(defrule añadir-asignado-a-particion-nueva
  ?h <- (celda (fila ?f) (columna ?c) (estado asignado))
  (not (particion (miembros $?x ?h $?y)))
  => 
  (assert (particion (miembros ?h)))
)

;;; Si una particion solo tiene un solo vecino, este vecino tiene que ser asignado:
;;;
;;; X
;;; 3 X La particion que contiene el 3 solo tiene un vecino, el 2. Por eso, el 2 tiene que
;;; 2   ser asignado, porque el 3 ne sea encerrado.
; (defrule asignar-solo-vecino
;   ?h1 <- (celda (fila ?f1) (columna ?c1) (estado desconocido))
;   ?h2 <- (celda (fila ?f2) (columna ?c2))
;   (particion (miembros $? ?h2 $?))
;   (test (son-vecinos ?f1 ?c1 ?f2 ?c2))
;   ;;TODO: es gibt nur ein einziges feld das nachbar von partition ist mit estado desconocido
;   ;;; sprich: alle anderen nachbarn sind eliminados -> alle nachbarn bestimmen how?

;   ;;;TODO: eventuell doch ein anadir-vecinos einbauen? jz wo dauerschleife gefixed ist
;   ;;; und ich fkt son-vecinos habe: x in part, y nicht in part, y nicht elim und x,y vecinos -> y in vecino
;   => 
;   (modify ?h1 (estado asignado))
; );;;TODO: eliminert das die ganzen encerrar regeln?

;;;============================================================================
;;; Reglas para imprimir el resultado
;;;============================================================================

;;;   Las siguientes reglas permiten visualizar el estado del hitori, una vez
;;; aplicadas todas las reglas que implementan las estrategias de resoluciÃ³n.
;;; La prioridad de estas reglas es -10 para que sean las Ãºltimas en aplicarse.

;;;   Para cualquier puzle se muestra a la izquierda el estado inicial del
;;; tablero y a la derecha la situaciÃ³n a la que se llega tras aplicar todas
;;; las estrategias de resoluciÃ³n. En el tablero de la derecha, las celdas que
;;; tienen un estado 'asignado' contienen el valor numÃ©rico asociado, las
;;; celdas que tienen un estado 'eliminado' contienen un espacio en blanco y
;;; las celdas con el estado 'desconocido' contienen un sÃ­mbolo '?'.

;;; TODO: just for dev
(defrule marca-como-resuelto
  (declare (salience -9))
  (not (celda (estado desconocido)))
  => 
  (assert (puzle-resuelto))
)

(defrule imprime-solucion
  (declare (salience -10))
  =>
  (printout t " Original           Solución " crlf)  
  (printout t "+---------+        +---------+" crlf)
  (assert (imprime 1)))

(defrule imprime-fila
  (declare (salience -10))
  ?h <- (imprime ?i&:(<= ?i 9))
  (celda (fila ?i) (columna 1) (valor ?v1) (estado ?s1))
  (celda (fila ?i) (columna 2) (valor ?v2) (estado ?s2))
  (celda (fila ?i) (columna 3) (valor ?v3) (estado ?s3))
  (celda (fila ?i) (columna 4) (valor ?v4) (estado ?s4))
  (celda (fila ?i) (columna 5) (valor ?v5) (estado ?s5))
  (celda (fila ?i) (columna 6) (valor ?v6) (estado ?s6))
  (celda (fila ?i) (columna 7) (valor ?v7) (estado ?s7))
  (celda (fila ?i) (columna 8) (valor ?v8) (estado ?s8))
  (celda (fila ?i) (columna 9) (valor ?v9) (estado ?s9))
  =>
  (retract ?h)
  (bind ?fila1 (sym-cat ?v1 ?v2 ?v3 ?v4 ?v5 ?v6 ?v7 ?v8 ?v9))
  (bind ?w1 (if (eq ?s1 asignado) then ?v1
	      else (if (eq ?s1 eliminado) then " " else "?")))
  (bind ?w2 (if (eq ?s2 asignado) then ?v2
	      else (if (eq ?s2 eliminado) then " " else "?")))
  (bind ?w3 (if (eq ?s3 asignado) then ?v3
	      else (if (eq ?s3 eliminado) then " " else "?")))
  (bind ?w4 (if (eq ?s4 asignado) then ?v4
	      else (if (eq ?s4 eliminado) then " " else "?")))
  (bind ?w5 (if (eq ?s5 asignado) then ?v5
	      else (if (eq ?s5 eliminado) then " " else "?")))
  (bind ?w6 (if (eq ?s6 asignado) then ?v6
	      else (if (eq ?s6 eliminado) then " " else "?")))
  (bind ?w7 (if (eq ?s7 asignado) then ?v7
	      else (if (eq ?s7 eliminado) then " " else "?")))
  (bind ?w8 (if (eq ?s8 asignado) then ?v8
	      else (if (eq ?s8 eliminado) then " " else "?")))
  (bind ?w9 (if (eq ?s9 asignado) then ?v9
	      else (if (eq ?s9 eliminado) then " " else "?")))
  (bind ?fila2 (sym-cat ?w1 ?w2 ?w3 ?w4 ?w5 ?w6 ?w7 ?w8 ?w9))
  (printout t "|" ?fila1 "|        |" ?fila2 "|" crlf)
  (if (= ?i 9)
      then (printout t "+---------+        +---------+" crlf)
    else (assert (imprime (+ ?i 1)))))

;;;============================================================================
;;; Funcionalidad para leer los puzles del fichero de ejemplos
;;;============================================================================

;;;   Esta funciÃ³n construye los hechos que describen un puzle a partir de una
;;; lÃ­nea leida del fichero de ejemplos.

(deffunction procesa-datos-ejemplo (?datos)
  (loop-for-count
   (?i 1 9)
   (loop-for-count
    (?j 1 9)
    (bind ?s1 (* 2 (+ ?j (* 9 (- ?i 1)))))
    (bind ?v (sub-string ?s1 ?s1 ?datos))
    (assert (celda (fila ?i) (columna ?j) (valor ?v))))))

;;;   Esta funciÃ³n localiza el puzle que se quiere resolver en el fichero de
;;; ejemplos. 

(deffunction lee-puzle (?n)
  (bind ?res 0)
  (open "ejemplos.txt" data "r")
  (loop-for-count (?i 1 (- ?n 1))
                  (readline data))
  (bind ?datos (readline data))
  (reset)
  (procesa-datos-ejemplo ?datos)
  (run)
  (close data)
  (do-for-all-facts ((?fct particion)) TRUE
    (bind ?res (+ ?res 1)))
  (printout t "Particiones: " ?res crlf)
)

;;; Esta funciÃ³n comprueba todos los puzles de un fichero que se pasa como
;;; argumento. Se usa:
;;; CLIPS> (procesa-ejemplos)

(deffunction procesa-ejemplos ()
  (open "ejemplos.txt" data "r")
  (bind ?datos (readline data))
  (bind ?i 0)
  (bind ?res 0)
  (while (neq ?datos EOF)
   (bind ?i (+ ?i 1))
   (reset)
   (procesa-datos-ejemplo ?datos)
   (printout t "ejemplos.txt :" ?i crlf)
   (run)
   (bind ?datos (readline data))
   (do-for-fact ((?fct puzle-resuelto)) TRUE
    (bind ?res (+ ?res 1))))
  (printout t "Resueltos: " ?res " / " ?i crlf)
  (close data))

;;;============================================================================