; set 13h video mode
set13h	proc
	mov	ax,	0013h
	int	10h
	push	0A000h
	pop	es
	ret
set13h	endp

restore3h	proc	;10
	mov	ax,	0003h
	int	10h
	ret
restore3h	endp

; di - x (0 to 319)
; cx - y (0 to 199)
; dl - color
; es = 0A000h
draw_pixel	proc	; 20
	mov	ax,	320
	push 	dx
	mul	cx
	pop 	dx
	mov	bx,	ax
	mov	es:[bx+di],	dl
	ret
draw_pixel	endp

; di - x	30
; cx - y 
; dl - color
; bx - lenght
draw_vline	proc
	mov	ax, 	320
	push	dx
	mul	cx
	pop 	dx
	mov	cx,	bx
	mov	bx,	ax	;40
linev_loop:
	mov	es:[bx+di], 	dl
	add	di,	320
	dec	cx
	cmp	cx,	0
	jnz	linev_loop
	ret
draw_vline	endp

; si - block address	50
draw_block 	proc
	mov	dh,	0
	xor	bx,	bx
bline2:
	lodsb
	mov	bl, 	80h
bline:
	test	al,	bl
	jz	not_draw
	push	ax
	push	bx			; 60
	call	draw_pixel
	pop	bx
	pop	ax
	jmp	ddd
not_draw:
	push	ax
	push	bx
	push	dx

	mov	dl,	0h
	call	draw_pixel

	pop	dx
	pop	bx
	pop	ax
ddd:
	shr	bl,	1
	inc	di
	cmp	bx,	0
	jnz	bline
	cmp	dh,	7		; 70	
	jz	endb
	inc	cx
	inc	dh
	sub	di,	8
	jmp	bline2
endb:
	ret
draw_block	endp

draw_block_o	proc
	push	di
	push	cx
	shl	di,	3
	shl	cx,	3
	add	di,	x_offset
	add	cx,	y_offset
	call	draw_block
	pop	cx
	pop	di
	ret
draw_block_o	endp

; bx - lenght				  80
draw_gline	proc
	mov	ax,	320
	push	dx
	mul	cx
	pop	dx
	add	di,	ax
	mov	al,	dl
	mov	cx,	bx
	rep	stosb
	ret				; 90
draw_gline	endp

set_color	macro	c
	mov	dl,	color.&c
endm

set_pixel_attr	macro	x, y, c
	mov	di,	x
	mov	cx,	y		; 100
	set_color 	&c
endm

set_pixel_attr_wc	macro	x, y
	mov	di,	x
	mov	cx,	y
endm

draw_file_x_start	dw	?
draw_file_y_start	dw	?

; di - start
save_pixel_file_start	proc
	push	di
	push	ax
	mov	ax,	di
	mov	di,	offset draw_file_x_start
	push	es
	push	ds
	pop	es
	stosw	
	pop	es
	pop	ax
	pop	di
	ret
save_pixel_file_start	endp

save_pixel_file_y_start	proc
	push	di
	push	ax
	mov	ax,	cx
	mov	di,	offset draw_file_y_start
	push	es
	push	ds
	pop	es
	stosw
	pop	es
	pop	ax
	pop	di
	ret
save_pixel_file_y_start endp

set_pixel_file_start	proc	
	push	si
	push	ax
	mov	si,	offset draw_file_x_start
	lodsw
	mov	di,	ax
	pop	ax
	pop	si
	ret
set_pixel_file_start	endp

set_pixel_file_y_start	proc
	push	si
	push	ax
	mov	si,	offset draw_file_y_start
	lodsw
	mov	cx,	ax
	pop	ax
	pop	si
	ret
set_pixel_file_y_start	endp

; in stack
; file name address
; buffer address
draw_from_file	proc
	call	set_pixel_file_start	; set x to default 
	pop	cx			; get return address
	pop	dx			; get file name
	mov	ax,	3d00h		; open file for reading
	int	21h

	pop	dx		; get buffer address
	push	cx		; set return address
	mov	cx, 	0 	; for a while set y(cx) to 0
	xchg	ax,	bx	; file id to bx
	call	set_pixel_file_y_start
conf:	mov	ah,	3fh	; function for reading
	push	cx
	mov	cx,	0ffffh	; read 500 bytes
	int	21h
	pop	cx
	push	bx
	push	ax
	push	dx
	call	parse_and_draw
	pop	dx
	pop	ax
	cmp	bx,	0ffffh
	je	do_pop
	pop	bx
	jmp	conf
dff_end:
	mov	ah,	3eh	; close file
	int	21h
	ret
do_pop: pop	bx
	jmp 	dff_end
draw_from_file	endp


; dx - buff address
parse_and_draw	proc
	mov	bx,	ax	; bx - amount
	xor	ax,	ax
	mov	si,	dx
st_parse:
	lodsb
	dec	bx
	cmp	al, 	'n'
	je 	skip_l
	cmp	al,	'b'
	je	set_b
	cmp	al, 	'g'
	je	set_g
	cmp	al,	'd'
	je	set_dg
	cmp	al, 	'l'
	je	set_lg
	cmp	al,	'p'
	je	set_bl
	cmp	al,	'w'
	je	set_w
	cmp	al,	'r'
	je	set_r
	cmp	al,	'e'
	mov	bx,	0ffffh
	je	pd_end
to_count:
	cmp	bx,	0
	je	pd_end
	lodsb
	dec	bx
	sub	al,	'0'
	push	cx
	push	bx
	push	ax
	xor	bx,	bx
	mov	bl,	al
	push	di
	call 	draw_gline
	pop	di
	pop	ax
	pop	bx
	add 	di,	ax
	pop	cx

	cmp	bx,	0
	jne	st_parse
	jmp	pd_end

skip_l:	inc	cx	
	call	set_pixel_file_start
	jmp	st_parse
set_b:	set_color	black
	jmp 	to_count
set_w:	set_color	white
	jmp	to_count
set_g:	set_color	green
	jmp	to_count
set_r:	set_color	red
	jmp	to_count
set_bl:	set_color	blue
	jmp	to_count
set_dg: set_color	dark_green
	jmp	to_count
set_lg:	set_color	light_green
	jmp	to_count
pd_end:	ret
parse_and_draw	endp




