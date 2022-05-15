.include "cpctelera.h.s"
.include "man/entities.h.s"
.include "cpcteleraFunctions.h.s"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Inicializa el sistema de render
;; DESTRUYE: A
;;
sys_render_init::
        ld      a, #1                   ; Cargamos un 1 en la dirección de memoria (if_first_render)
        ld      (if_first_render), a    ; para indicar que, al ser el primer render, no hay que borrar

ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Renderiza la entidad recibida en IX
;; INPUT: IX -> puntero a la entidad
;; DESTRUYE: AF, BC, DE, HL
;;
sys_render_oneEntity:
        ;; Calculamos el puntero a la posición de vídeo de la entidad
        ld      de, #CPCT_VMEM_START_ASM        ; DE = 0xC000
        ld       c, e_x(ix)                     ; C  = posición X de la entidad
        ld       b, e_y(ix)                     ; B  = posición Y de la entidad
        call    cpct_getScreenPtr_asm              ; Llamamos a la rutina 
        ;; Comprobamos si la entidad ha cambiado de posición y es necesario render
        ld       a, e_prevPtrLow(ix)    ; A = L(byte bajo del puntero)   
        cp       l                      ; Si A != L es necesario renderizar
        ret      z                      ; En caso contrario, regresamos sin renderizar
        ld      (puntero_obtenido), hl
        
        ;; Borramos la entidad de la posición anterior, excepto si es el primer render
if_first_render = . + 1
        ld       a, #0                  ; El inicializador carga aquí un 1 en la primera ejecución.
        cp      #1                      ; Por lo tanto, no se borra ningún sprite.
        jr       z, first_render        ;\
        ld       d, e_prevPtrHigh(ix)   ; DE = puntero anterior
        ld       e, e_prevPtrLow(ix)    ; \
        ld       c, e_h(ix)             ; C  = Alto de la entidad
        ld       b, e_w(ix)             ; B  = Ancho de la entidad
        ld       h, e_spriteHigh(ix)    ; HL = Puntero al sprite
        ld       l, e_spriteLow(ix)     ; \
        call    cpct_drawSpriteBlended_asm ; Llamamos rutina dibujado

        ;; Modificamos la etiqueta (if_first_render) para que tenga un 0.
first_render:
        ld      a, #0                   ; A = 0
        ld      (if_first_render), a    ; if_first_render = A

        ;; Almacenamos el puntero obtenido mas arriba en la entidad. Para posterior borrado.
        puntero_obtenido = . + 1
        ld      hl, #0
        ld      e_prevPtrLow(ix), l
        ld      e_prevPtrHigh(ix), h

        ;; Dibujamos la entidad mezclándola con el fondo
        ex      de, hl                  ; DE = Puntero a la posición de vídeo
        ld       c, e_h(ix)             ; C  = Alto de la entidad
        ld       b, e_w(ix)             ; B  = Ancho de la entidad
        ld       h, e_spriteHigh(ix)    ; HL = Puntero al sprite
        ld       l, e_spriteLow(ix)     ; \
        call    cpct_drawSpriteBlended_asm ; Llamamos rutina dibujado
        
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Renderiza todas las entidades que tengan bit de render.
;; OUPUT:  A -> Bit de estado 
;;        HL -> puntero a la rutina de pintado
;; DESTRUYE: AF, BC, DE, HL
;;
sys_render_allEntities::
        ld      a, #CMP_RENDER            ; A = Bit de render
        ld      hl, #sys_render_oneEntity ; HL = Puntero a la rutina de pintado
        call    man_doIt4AllMatching      ; Llamamos al mánager

        ret