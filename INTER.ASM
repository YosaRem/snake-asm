last_presed	dw	0
old_int9h	dd	0

game_keyboard_handler	proc
	pushf
;	call	game_keyboard_handler
;	mov	word ptr last_presed, 0ffh


;	iret
	db	0eah
old_key dd	?
game_keyboard_handler	endp

set_keyboard	proc
; save
	push	es
	mov	ax,	3509h
	int	21h
	mov	word ptr old_key,	bx
	mov	word ptr old_key+2,	es
	mov	ax,	2509h
	mov	dx,	offset	game_keyboard_handler
	int	21h
	pop	es
	ret
set_keyboard	endp

restore_keyboard	proc
	mov	ax,	word ptr old_key
	mov	dx,	word ptr old_key+2
	push	dx
	pop	ds
	mov	dx,	ax
	mov	ax,	2509h
	int	21h
	ret
restore_keyboard	endp

fps_counter	db	0
is_move		db	1

game_fps	proc
	push	ax
	push	es
	xor	ax,	ax
	mov	al, 	byte ptr fps_counter
	cmp	ax,	0
	jne	fps_end
	mov	ax,	01h		; FPS SPEED
	mov	byte ptr fps_counter,	al
	mov	byte ptr is_move,	1	; move on one
	jmp	poppp
fps_end:
	dec	al
	mov	byte ptr fps_counter, 	al
poppp:	pop	es
	pop	ax
	db	0eah
old_1ch	dd	?

game_fps	endp

set_fps		proc
	push	es
	mov	ax,	351ch
	int	21h
	mov	word ptr old_1ch,	bx
	mov	word ptr old_1ch+2,	es
	mov	ax,	251ch
	mov	dx,	offset	game_fps
	int	21h
	pop	es
	ret
set_fps		endp

restore_fps	proc
	mov	ax,	word ptr old_1ch
	mov	dx,	word ptr old_1ch+2
	push	dx
	pop	ds
	mov	dx,	ax
	mov	ax,	251ch
	int	21h
	ret
restore_fps	endp
