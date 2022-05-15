.include "man/entities.h.s"

man_entityVector:
        .ds SIZEOFENTITY * SIZEOFVECTOR

man_nextFreeEntity:
        .dw man_entityVector

;;CreateEntity _player, ^/(PLAYER | CMP_RENDER | CMP_CONTROLS | CMP_PHYSICS)/^, 40, 170, 0, 0, 16, 16, 0x0000, 0xffff, 0xffff

;;*********************************************************************************;;
;;                              RUTINAS PÚBLICAS                                   ;;
;;*********************************************************************************;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Devuelve un puntero al vector de entidades
;; OUTPUT: HL -> Puntero al vector de entidades
;;
man_getVectorPtr::
        ld      hl, #man_entityVector

        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Reserva un nuevo espacio para una entidad y devuelve el puntero a dicho espacio
;; ENTRADA:
;; SALIDA: DE -> puntero a la entidad recién reservada
;; DESTRUYE: AF, DE, HL
;; 
man_entityNew::
        ld      hl, (man_nextFreeEntity)
        ld      de, #SIZEOFENTITY
        ex      de, hl
        add     hl, de
        ld      (man_nextFreeEntity), hl
        
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Llama a la rutina recibida en HL para cada entidad que cumpla la condición 
;; recibida en A.
;; INPUT: HL -> puntero a rutina
;;         A -> componente de la entidad
;; DESTRUYE: 
;;
man_doIt4AllMatching::
        ld      ix, #man_entityVector
        ld       b, #SIZEOFVECTOR
        ld      (cmp_byte), a
checkEntity:
        and     e_cmp(ix)
        jr      z, next_entity
                push    bc
                push    hl
                ld      bc, #returning
                push    bc
                jp      (hl)
returning:
        pop     hl
        pop     bc
next_entity:
cmp_byte = . + 1
        ld       a, #0
        ld      de, #SIZEOFENTITY
        add     ix, de
        djnz    checkEntity

        ret
