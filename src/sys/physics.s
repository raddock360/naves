.include "sys/physics.h.s"
.include "man/entities.h.s"
.include "cpctelera.h.s"
.include "cpcteleraFunctions.h.s"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Inicializa el sistema de render.
;;
sys_physics_init::
        call    man_getVectorPtr        ; Obtenemos el puntero al vector de entidades
        ld      (vector_entidades),  hl ; y lo cargamos donde se necesite mas tarde.

        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Actualiza todas las físicas
;;
sys_physics_update::
        call    sys_physics_checKeyboard
        call    sys_physics_updateAllEntities

        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Escanea el teclado para la entidad del jugador
;;
sys_physics_checKeyboard::
        vector_entidades = . + 2        ; El inicializador carga aquí el puntero al vector
        ld      ix, #0                  ; de entidades.

        call    cpct_scanKeyboard_asm   ; Escaneamos el teclado completo.
_Key_O:
        ld      hl, #Key_O              ; HL = Tecla O
        call    cpct_isKeyPressed_asm   ; Comprobamos si ha sido pulsada.
        jr      z, _Key_P
                ld      e_vx(ix), #-1
_Key_P:
        ld      hl, #Key_P              ; HL = Tecla O
        call    cpct_isKeyPressed_asm   ; Comprobamos si ha sido pulsada.
        jr      z, _Key_Q
                ld      e_vx(ix), #1
_Key_Q:
        ld      hl, #Key_Q              ; HL = Tecla O
        call    cpct_isKeyPressed_asm   ; Comprobamos si ha sido pulsada.
        jr      z, _Key_A
                ld      e_vy(ix), #-2
_Key_A:
        ld      hl, #Key_A              ; HL = Tecla O
        call    cpct_isKeyPressed_asm   ; Comprobamos si ha sido pulsada.
        jr      z, _Not_pressed
                ld      e_vy(ix), #2

_Not_pressed:

        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Actualiza las físicas de una entidad
;; INPUT:       IX -> Puntero a la entidad
;; DESTRUYE: 
;;
sys_physics_updateOneEntity:
        ld      a, e_x(ix)      ; Cargamos en A el valor de e_x
        add     e_vx(ix)        ; le sumamos e_vx
_left_border:
        cp      #LEFT_BORDER
        jr      nz, _right_border
                sub     e_vx(ix)
                jr      _act_ex
_right_border:
        add     e_w(ix)
        cp      #RIGHT_BORDER
        jr      nz, _continue
                sub     e_vx(ix)
_continue:
        sub     e_w(ix)
_act_ex:
        ld      e_x(ix), a      ; y lo volvemos a cargar en la entidad

        ld      a, e_y(ix)      ; Repetimos el mismo proceso para la 
        add     e_vy(ix)        ; coordenada e_y
        ld      e_y(ix), a      ;\

        ld      e_vx(ix), #0    ; Reseteamos ambas velocidades a 0
        ld      e_vy(ix), #0    ;\

        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Llama al mánager de entidades para que actualice las físicas de todas las
;; entidades con el componente de físicas activo.
;; OUTPUT:       A -> CMP_PHYSICS
;;              HL -> Puntero a la rutina de actualización de físicas
;; DESTRUYE:    AF, BC, DE, HL
;;
sys_physics_updateAllEntities:
        ld       a, #CMP_PHYSICS
        ld      hl, #sys_physics_updateOneEntity
        call    man_doIt4AllMatching

        ret     