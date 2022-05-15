;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Rutinas públicas
;;
.globl  man_entityNew
.globl  man_doIt4AllMatching
.globl  man_getVectorPtr

;; Tamaño de la entidad en bytes
SIZEOFENTITY =   13

;; Tamaño del vector de entidades (en número de entidades)
SIZEOFVECTOR = 10

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Distintos componentes para las entidades
;;
PLAYER          = 0b00000001
ENEMY           = 0b00000010
CMP_IA          = 0b00000100
CMP_RENDER      = 0b00001000
CMP_PHYSICS     = 0b00010000
CMP_CONTROLS    = 0b00100000

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Desplazamientos para acceder a los componentes de cada entidad
;;
e_cmp           = 0           
e_x             = e_cmp         + 1
e_y             = e_x           + 1 
e_vx            = e_y           + 1
e_vy            = e_vx          + 1
e_w             = e_vy          + 1
e_h             = e_w           + 1
e_pathLow       = e_h           + 1
e_pathHigh      = e_pathLow     + 1
e_spriteLow     = e_pathHigh    + 1
e_spriteHigh    = e_spriteLow   + 1
e_prevPtrLow    = e_spriteHigh  + 1
e_prevPtrHigh   = e_prevPtrLow  + 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Macro que define una entidad con los parámetros recibidos como argumentos
;;
.macro CreateEntity _name, _cmp, _ex, _ey, _evx, _evy, _ew, _eh, _path, _sprite, _prevPtr
        _name:
                .db     _cmp ; Byte de máscara con los componentes de la entidad
                .db     _ex  ; Coordenada x  
                .db     _ey  ; Coordenada y
                .db     _evx ; Velocidad vx
                .db     _evy ; Velocidad vy
                .db     _ew  ; Ancho de la entidad en bytes
                .db     _eh  ; Alto de la entidad en bytes
                .dw     _path    ; Puntero a la patrulla de la entidad
                .dw     _sprite  ; Puntero al sprite de la entidad
                .dw     _prevPtr ; Puntero a la posición previa de la entidad
.endm

