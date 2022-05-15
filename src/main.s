.include "cpctelera.h.s"
.include "man/entities.h.s"
.include "sys/render.h.s"
.include "sys/physics.h.s"
.include "cpcteleraFunctions.h.s"

.globl  _Ace

.area _DATA

_enemy_path: .db 1,1,1,1,1,-1,-1,-1,-1,-1

.area _CODE

_initialization:
        call    cpct_disableFirmware_asm
        ld      c, #1
        call    cpct_setVideoMode_asm
        call    sys_render_init
        call    sys_physics_init

        ret

_main::
        call    _initialization

        call    man_entityNew
        ld__ixh_d
        ld__ixl_e
        ld      e_cmp(ix), #(CMP_RENDER | CMP_PHYSICS)
        ld      e_x(ix), #10
        ld      e_y(ix), #10
        ld      e_vx(ix), #0
        ld      e_vy(ix), #0
        ld      e_w(ix), #4
        ld      e_h(ix), #16
        ld      hl, #_Ace
        ld      e_spriteHigh(ix), h
        ld      e_spriteLow(ix), l
        ld      e_prevPtrHigh(ix), #0xFF
        ld      e_prevPtrLow(ix), #0xFF

        call    man_entityNew
        ld__ixh_d
        ld__ixl_e
        ld      e_cmp(ix), #(CMP_PHYSICS)
        ld      e_x(ix), #20
        ld      e_y(ix), #20
        ld      e_vx(ix), #0
        ld      e_vy(ix), #0
        ld      e_w(ix), #4
        ld      e_h(ix), #16


;; Loop forever
loop:
        call    sys_physics_update
        call    sys_render_allEntities
        call    cpct_waitVSYNC_asm

        jr      loop