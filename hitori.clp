;;;============================================================================
;;; Representation of the Hitori
;;;============================================================================

;;; We'll use the following template to represent the cells of the Hitori.
;;; Every cell has the following fields:
;;; - row: The row number of the cell
;;; - column: The column number of the cell
;;; - cell-value: The numerical value of the cell
;;; - cell-state: The cell state. Can be 'unknown', which means that no decision has
;;;   been taken yet, 'assigned' which means that 'value' will be kept in the 
;;;   solution or 'eliminated', which means that the value of the cell is deleted
;;;   in the solution of the Hitori. The default value is 'unknown'.

(deftemplate cell
  (slot row)
  (slot column)
  (slot cell-value)
  (slot cell-state
	(allowed-values unknown assigned eliminated)
	(default unknown)))

;;;============================================================================
;;; Backtracking
;;;============================================================================

;;; Template for the backtracking. Level is a non-negative integer that describes
;;; the level of backtracking (the depth of the recursion) in which we have done
;;; the step. First is a boolean attribute that describes if the step was the first
;;; step of the backtracking process (TRUE) or if it was implied by the first step 
;;; (FALSE) (this value encodees whether the step is the root of the recursion tree 
;;; or not). Row and column are the coordinates of the cell that has changed its 
;;  cell-state in this step.
(deftemplate backtracking-step
  (slot level)
  (slot first (allowed-values FALSE TRUE) (default FALSE))
  (slot row)
  (slot column)
)

;;; Check whether we are currently doing backtrackingl If not, we do nothing, but if
;;; there currently is backtracking going on, add the backtracking step to the facts.
(deffunction make-backtracking-step (?r ?c)
  (bind ?i 0)
  ;;; We look for the highest currently active backtracking level
  (do-for-all-facts ((?b backtracking-step)) TRUE (if (> ?b:level ?i) then (bind ?i ?b:level)))

  ;;;; We associate the current backtrackign step to that level
  (do-for-fact ((?b backtracking-step)) (= ?b:level ?i) (assert(backtracking-step (level ?b:level) (row ?r) (column ?c))))
)


;;;============================================================================
;;; Solving Strategies
;;;===========================================================================;


;;; If a digit x is in a cell and both adjacent cells in a row or column contain
;;; the same digit y != x, then x must be assigned.
;;; 
;;; Examples:
;;;
;;;   2 3 2 -> 3 is assigned
;;;
;;;     4
;;;     2   -> 2 is assigned
;;;     4
;;;
(defrule sandwich  
  ;;; We always have to check whether there are errors before we do anything
  (not (is-error)) 
  ?h <- (cell (row ?r1) (column ?c1) (cell-state unknown))
  (cell (row ?r2) (column ?c2) (cell-value ?v))
  (cell (row ?r3) (column ?c3) (cell-value ?v))
  (test (or 
          (and (= ?r1 ?r2) (= ?r1 ?r3) (= ?c2 (+ ?c1 1)) (= ?c3 (- ?c1 1))) ;;; same row
          (and (= ?c1 ?c2) (= ?c1 ?c3) (= ?r2 (+ ?r1 1)) (= ?r3 (- ?r1 1))) ;;; same column
        )   
  )
  =>
  (make-backtracking-step ?r1 ?c1)
  (modify ?h (cell-state assigned))
)

;;; If there is a pair of a digit x in a row/column and there is another NON-ADJACENT cell 
;;; with the value x in the same row/column, then the single x must be eliminated.
;;; 
;;; Examples:
;;;
;;;   1 2 2 3 4 4 2 8 
;;;               ^
;;;               This 2 is eliminated
;;;
;;;   1 
;;;   2 
;;;   2
;;;   3
;;;   4
;;;   2 <- this 2 is eliminated
;;;   8 
;;;
(defrule pair-and-single
  (not (is-error)) 
  ?h <- (cell (row ?r1) (column ?c1) (cell-value ?v) (cell-state unknown))
  (cell (row ?r2) (column ?c2) (cell-value ?v))
  (cell (row ?r3) (column ?c3) (cell-value ?v))
  (test (or 
          ;;; same row, cell2 y cell3 are the pair and cell1 is not adjacent to cell2 or cell3
          (and (= ?r1 ?r2) (= ?r1 ?r3) (= ?c2 (- ?c3 1)) (or (> ?c1 (+ ?c3 1)) (< ?c1 (- ?c2 1)))) 
          ;;; same column, cell2 y cell3 are the pair and cell1 is not adjacent to cell2 or cell3
          (and (= ?c1 ?c2) (= ?c1 ?c3) (= ?r2 (- ?r3 1)) (or (> ?r1 (+ ?r3 1)) (< ?r1 (- ?r2 1)))) 
        )
  )
  => 
  (make-backtracking-step ?r1 ?c1)
  (modify ?h (cell-state eliminated)) 
)

;;; If a cell is marked as 'eliminated' then every adjacent cell has to be assigned, 
;;; because there cannot be two adjacent cells marked as 'eliminated'.
(defrule assign-surroundings-of-eliminated
  (not (is-error)) 
  (cell (row ?r1) (column ?c1) (cell-state eliminated))
  ?h <- (cell (row ?r2) (column ?c2) (cell-state unknown))
  (test (or (and (= ?r2 (+ ?r1 1)) (= ?c1 ?c2)) ;;; bottom cell
           (and (= ?r2 (- ?r1 1)) (= ?c1 ?c2)) ;;; top cell
           (and (= ?c2 (+ ?c1 1)) (= ?r1 ?r2)) ;;; right cell
           (and (= ?c2 (- ?c1 1)) (= ?r1 ?r2)))) ;;; left cell
  => 
  (make-backtracking-step ?r2 ?c2)
  (modify ?h (cell-state assigned)) 
)

;;; Si una cell que contiene x esta amarcada como assigned, entonces cada cell 
;;; en la misma row o column que también contiene x, tiene que estar eliminada.
(defrule eliminar-dobles
  (not (is-error)) 
  (cell (row ?r1) (column ?c1) (cell-value ?v) (cell-state assigned))
  ?h <- (cell (row ?r2) (column ?c2) (cell-value ?v) (cell-state unknown))
  (test (or 
          (and (= ?r1 ?r2) (neq ?c1 ?c2)) ;;; misma row
          (and (neq ?r1 ?r2) (= ?c1 ?c2)) ;;; misma column
        )
  )
  => 
  (make-backtracking-step ?r2 ?c2)
  (modify ?h (cell-state eliminated))
)

;;; Si una cell es la unica que contiene un número x en una row y column, 
;;; o si es la unica que contiene x con el cell-state unknown y todas las otras
;;; cells con un x son eliminadas, entonces esta cell debe estar asignada. 
;;; No hay nada que podría forzarla a estar eliminada.
(defrule asignar-solteros
  (not (is-error)) 
  ?h <- (cell (row ?r) (column ?c) (cell-value ?v) (cell-state unknown))
  (not (cell (row ?r) (column ?c1&~?c) (cell-value ?v) (cell-state ?e&~eliminated)))
  (not (cell (row ?r1&~?r) (column ?c) (cell-value ?v) (cell-state ?e&~eliminated)))
  => 
  (make-backtracking-step ?r ?c)
  (modify ?h (cell-state assigned))
)

;;;============================================================================
;;; Particiones
;;;============================================================================

;;; Template para una partición. Miembros es una lista de cells que pertencecen
;;; a la partición. Vecinos es una lista de cells con cell-state unknown que
;;; son vecinos de al menos una cell que esta en la partición (en la lista
;;; 'miembros').
(deftemplate particion
  (multislot miembros)
  (multislot vecinos)
)

;;; Determina si dos cells son vecinos o no
(deffunction son-vecinos (?r1 ?c1 ?r2 ?c2)
(return (or 
        (and (= ?r2 (- ?r1 1)) (= ?c1 ?c2)) ;;; vecino arriba
        (and (= ?r2 (+ ?r1 1)) (= ?c1 ?c2)) ;;; vecino abajo
        (and (= ?r1 ?r2) (= ?c2 (+ ?c1 1))) ;;; vecino derecho
        (and (= ?r1 ?r2) (= ?c2 (- ?c1 1))) ;;; vecino izquierdo
        ))
)

;;; Cada vez que una cell esta asignada, se une automaticamente a una partición. Si no esta 
;;; vecina de una partición ya existente, se crea una nueva partición que solo contiene la cell 
;;; que acaba de ser asignada.
(defrule añadir-assigned-a-particion-nueva
  (not (is-error)) 
  ?h <- (cell (row ?r) (column ?c) (cell-state assigned))
  (not (particion (miembros $?x ?h $?y)))
  (not (particion (vecinos $?x ?h $?y)))
  => 
  (assert (particion (miembros ?h)))
)

;;; Cada vez que una cell esta asignada, se une automaticamente a una partición. Si esta 
;;; vecina de una partición ya existente, se une a esa partición.
(defrule añadir-assigned-a-particion-existente
  (not (is-error)) 
  ?h1 <- (cell (row ?r1) (column ?c1) (cell-state assigned))
  ?h2 <- (cell (row ?r2) (column ?c2) (cell-state assigned))
  (test (son-vecinos ?r1 ?c1 ?r2 ?c2))
  (not (particion (miembros $?a ?h2 $?b)))
  ?p <- (particion (miembros $?x ?h1 $?y))
  => 
  (modify ?p (miembros $?x ?h1 ?h2 $?y))
)

;;; Cada cell que esta desconocida y que esta vecino de una cell que esta parte de
;;; una partición, se agrega al conjunto de vecinos de la partición
(defrule añadir-vecino-unknown
  (not (is-error)) 
  ?h1 <- (cell (row ?r1) (column ?c1) (cell-state unknown))
  ?h2 <- (cell (row ?r2) (column ?c2))
  ?p <- (particion (miembros $? ?h2 $?) (vecinos $?v))
  (test (son-vecinos ?r1 ?c1 ?r2 ?c2))
  (test (not (member$ ?h1 ?v)))
  => 
  (modify ?p (vecinos $?v ?h1))
)

;;; Si una cell h esta eliminada y es vecino de una cell que esta parte de una partición,
;;; la cell h tiene que quitarse del conjunto de vecinos de la partición
(defrule quitar-vecinos-eliminateds
  (not (is-error)) 
  ?h <- (cell (cell-state eliminated))
  ?p <- (particion (vecinos $?a ?h $?b))
  => 
  (modify ?p (vecinos $?a $?b))
)

;;; Si un vecino ha cell-state assigned y ahora forma parte de los miembros de una partición,
;;; entonces se tiene que quitar de los vecinos de la partición
(defrule quitar-vecinos-assigneds
  (not (is-error)) 
  ?p <- (particion (miembros $? ?v $?) (vecinos $?a ?v $?b))
  => 
  (modify ?p (vecinos $?a $?b))
)

;;; Si una partición solo tiene a una sola cell desconocida como vecino, entonces esa cell
;;; tiene que estar asignada, para que la partición no se divida del resto del tablero.
;;;
;;; Ejemplo:
;;;
;;; X
;;; 3 ?     La partición (2,3) solo tiene a un vecino unknown, el resto esta eliminated.
;;; 2 X     Este vecino tiene que ser assigned, porque el (2,3) no sea aislado del resto del
;;; X       tablero.
;;;
;;; Asignamos una saliencia a esta regla para que solo se ejecute cuando no hay otra regla
;;; que podría añadir nuevos vecinos a la partición, pero antes de que el backtracking
;;; empieza.
(defrule asignar-unico-vecino
  (declare (salience -7))
  (not (is-error)) 
  ?h1 <- (cell (row ?r1) (column ?c1) (cell-state unknown))
  ?p <- (particion (miembros $? ?h2 $?) (vecinos ?h1))
  => 
  (make-backtracking-step ?r1 ?c1)
  (modify ?h1 (cell-state assigned))
)

;;; Cuando una partición tiene como vecino un miembro de una otra partición, las particiones
;;; se unen y una de las dos particiones se elimina.
(defrule unir-dos-particiones
  (not (is-error)) 
  ?h1 <- (cell (row ?r1) (column ?c1))
  ?h2 <- (cell (row ?r2) (column ?c2))
  (test (son-vecinos ?r1 ?c1 ?r2 ?c2))
  ?p1 <- (particion (miembros $?x1 ?h1 $?y1))
  ?p2 <- (particion (miembros $?x2 ?h2 $?y2))
  (test (neq ?p1 ?p2))
  =>
  (modify ?p1 (miembros $?x1 ?h1 $?y1 $?x2 ?h2 $?y2))
  (retract ?p2)
)


;;;============================================================================
;;; Backtracking
;;;============================================================================

;;; Empieza el first level del backtracking, si no hay otra regla que se activa y que el puzle
;;; todavía no está resuelto.
(defrule backtrack-inicio-first-level
 (declare (salience -9))
 (not (backtracking-step))
 (not (puzle-resuelto))
 (not (is-error))
 ?h <- (cell (row ?r) (column ?c) (cell-state unknown))
 => 
 (assert (backtracking-step (level 0) (first TRUE) (row ?r) (column ?c)))
 (modify ?h (cell-state eliminated))
)

;;; Empieza un level avanzado (empieza la recursion) del backtracking, si no hay otra regla 
;;; que se activa y que el puzle todavía no está resuelto.
(defrule backtrack-inicio-level-avanzado
 (declare (salience -9))
 (backtracking-step (level ?i1))
 (forall (backtracking-step (level ?i2)) (test (<= ?i2 ?i1)))
 (not (puzle-resuelto))
 (not (is-error))
 ?h <- (cell (row ?r) (column ?c) (cell-state unknown))
 => 
 (assert (backtracking-step (level (+ ?i1 1)) (first TRUE) (row ?r) (column ?c)))
 (modify ?h (cell-state eliminated))
)

;;; Si cada cell tiene un cell-state no unknown, pero hay mas que 1 partición, hay un error.
(defrule error-mas-que-una-particion-al-final
  (declare (salience -9))
  (not (cell (cell-state unknown)))
  ?p1 <- (particion)
  ?p2 <- (particion)
  (test (neq ?p1 ?p2))
  => 
  (assert (is-error))
)

;;; Si todavia hay cells con cell-state unknown, pero tambien una partición que no tiene
;;; vecinos (porque todos son eliminateds -> la partición es una isla), hay un error.
(defrule cell-encerrada
  (cell (cell-state unknown))
  (particion (vecinos))
  => 
  (assert (is-error))
)

;;; Si descubrimos que hay un error, reasignamos el cell-state unknown a cada cell que
;;; ha cell-state cambiada durante el backtrack.
(defrule desmake-backtracking-step
 (is-error)
 ?b <- (backtracking-step (level ?i1) (first FALSE) (row ?r) (column ?c))
 (forall (backtracking-step (level ?i2)) (test (<= ?i2 ?i1)))
 ?h <- (cell (row ?r) (column ?c))
 => 
 (modify ?h (cell-state unknown))
 (retract ?b)
)

;;; Si descubrimos que haya un error en el level 0 y que solo queda el first paso de backtrack a deshacer,
;;; asignamos el cell-state assigned a la cell que iniciaba el backtrack. Esto es porque cuando
;;; empezamos el backtrack, la primera cell recibió el cell-state eliminated. Pero eso ha provocado
;;; un error, por eso sabemos que la cell tiene que ser asignada.
;;;
;;; Si por otra parte somos en un level n avanzado, no sabemos el cell-value que la cell tiene que tener.
;;; Entonces, la decision que hemos tomado en el level n-1 era incorrecta y tenemos que cambiarla.
;;; Por eso, la cell del inicio del backtrack del level n recibe el cell-state unknown y el
;;; error se propaga al level n-1 (el hecho 'is-error' no se retracta).
(defrule deshacer-primer-paso-de-backtrack
 ?e <- (is-error)
 ?b <- (backtracking-step (level ?i1) (first TRUE) (row ?r) (column ?c))
 (forall (backtracking-step (level ?i2)) (test (<= ?i2 ?i1)))
 (not (backtracking-step (level ?i1) (first FALSE)))
 ?h <- (cell (row ?r) (column ?c) (cell-state ?v))
 (test (or (eq ?v assigned) (eq ?v eliminated)))
 => 
 (if (eq ?v eliminated) then (modify ?h (cell-state assigned)) else (modify ?h (cell-state unknown)))
 (if (or (= ?i1 0) (eq ?v assigned)) then (retract ?b))

 ;;; Guardar como cada partición se cambió durante el backtrack es demasiado cansado, por
 ;;; eso las borramos todas y dejan las reglas reconstruirlas.
 (do-for-all-facts ((?p particion)) TRUE
    (retract ?p)
 )
 (if (eq ?v eliminated) then (retract ?e))
)

;;;============================================================================
;;; Rules to print the result
;;;============================================================================

;;; The following rules allow to visualize the state of the hitori, once
;;; that all the rules that implement the resolution strategies have been applied.
;;; The priority of these printing rules is -10 so that they are the last ones to 
;;; be applied.

;;; For every puzzle the left side shows the initial state of the board and the
;;; right side shows the final state after applying all the resolution strategies.
;;; 
;;; On the right board, the cells that have the status 'assigned' contain the
;;; numeric value associated, the cells that have the status 'eliminated' contain
;;; whitespace and the cells with state 'unknown' contain a '?' symbol.

(defrule print-solution
  (declare (salience -10))
  =>
  (printout t " Original           Solution " crlf)  
  (printout t "+---------+        +---------+" crlf)
  (assert (print 1)))

(defrule print-row
  (declare (salience -10))
  ?h <- (print ?i&:(<= ?i 9))
  (cell (row ?i) (column 1) (cell-value ?v1) (cell-state ?s1))
  (cell (row ?i) (column 2) (cell-value ?v2) (cell-state ?s2))
  (cell (row ?i) (column 3) (cell-value ?v3) (cell-state ?s3))
  (cell (row ?i) (column 4) (cell-value ?v4) (cell-state ?s4))
  (cell (row ?i) (column 5) (cell-value ?v5) (cell-state ?s5))
  (cell (row ?i) (column 6) (cell-value ?v6) (cell-state ?s6))
  (cell (row ?i) (column 7) (cell-value ?v7) (cell-state ?s7))
  (cell (row ?i) (column 8) (cell-value ?v8) (cell-state ?s8))
  (cell (row ?i) (column 9) (cell-value ?v9) (cell-state ?s9))
  =>
  (retract ?h)
  (bind ?row1 (sym-cat ?v1 ?v2 ?v3 ?v4 ?v5 ?v6 ?v7 ?v8 ?v9))
  (bind ?w1 (if (eq ?s1 assigned) then ?v1
	      else (if (eq ?s1 eliminated) then " " else "?")))
  (bind ?w2 (if (eq ?s2 assigned) then ?v2
	      else (if (eq ?s2 eliminated) then " " else "?")))
  (bind ?w3 (if (eq ?s3 assigned) then ?v3
	      else (if (eq ?s3 eliminated) then " " else "?")))
  (bind ?w4 (if (eq ?s4 assigned) then ?v4
	      else (if (eq ?s4 eliminated) then " " else "?")))
  (bind ?w5 (if (eq ?s5 assigned) then ?v5
	      else (if (eq ?s5 eliminated) then " " else "?")))
  (bind ?w6 (if (eq ?s6 assigned) then ?v6
	      else (if (eq ?s6 eliminated) then " " else "?")))
  (bind ?w7 (if (eq ?s7 assigned) then ?v7
	      else (if (eq ?s7 eliminated) then " " else "?")))
  (bind ?w8 (if (eq ?s8 assigned) then ?v8
	      else (if (eq ?s8 eliminated) then " " else "?")))
  (bind ?w9 (if (eq ?s9 assigned) then ?v9
	      else (if (eq ?s9 eliminated) then " " else "?")))
  (bind ?row2 (sym-cat ?w1 ?w2 ?w3 ?w4 ?w5 ?w6 ?w7 ?w8 ?w9))
  (printout t "|" ?row1 "|        |" ?row2 "|" crlf)
  (if (= ?i 9)
      then (printout t "+---------+        +---------+" crlf)
    else (assert (print (+ ?i 1))))
  )

;;;============================================================================
;;; Functionality to read puzzles from a document
;;;============================================================================

;;; This function builds up the assertions that describe a puzzle going from a
;;; line that has been read from an input file.

(deffunction process-puzzle-data (?data)
  (loop-for-count
   (?i 1 9)
   (loop-for-count
    (?j 1 9)
    (bind ?s1 (* 2 (+ ?j (* 9 (- ?i 1)))))
    (bind ?v (sub-string ?s1 ?s1 ?data))
    (assert (cell (row ?i) (column ?j) (cell-value ?v))))))

;;; This function reads the n-th puzzle from the file "puzzles.txt".

(deffunction read-puzzle (?n)
  (open "puzzles.txt" puzzle "r")
  (loop-for-count (?i 1 (- ?n 1))
                  (readline puzzle))
  (bind ?data (readline puzzle))
  (reset)
  (process-puzzle-data ?data)
  (run)
  (close puzzle)
)

;;; This function solves all the puzzles inside a file that follows the same
;;; structure as the file "puzzles.txt". It is used as follows:
;;; CLIPS> (solve-puzzles)

(deffunction solve-puzzles ()
  (open "puzzles.txt" puzzles "r")
  (bind ?data (readline puzzles))
  (bind ?i 0)
  (while (neq ?data EOF)
   (bind ?i (+ ?i 1))
   (reset)
   (process-puzzle-data ?data)
   (printout t "puzzles.txt :" ?i crlf)
   (run)
   (bind ?data (readline puzzles))
  )
  (close puzzles))

;;;============================================================================