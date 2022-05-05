redraw_main_button	proc
	mov	bl,	menu.is_enter
	cmp	bl,	1
	je	handle_enter
	mov	bl,	menu.pos
	cmp	bl,	0h
	je	s1
	cmp	bl,	1h
	je	s2
	jmp	s3
rmb_ex:
	mov	bx,	0ffh
	ret
s1:
	call	draw_black
	call	draw_sstart
	call 	draw_levels
	call	draw_exit
	jmp	rmb_ex
s2:
	call	draw_black
	call	draw_start
	call	draw_slevels
	call	draw_exit
	jmp	rmb_ex
s3:
	call	draw_black
	call	draw_start
	call	draw_levels
	call	draw_sexit
	jmp	rmb_ex
handle_enter:
	call	handle_main_enter
	ret
redraw_main_button	endp

handle_main_enter	proc
	mov	bl,	menu.pos
	cmp	bl,	02h
	je	exitb
	cmp	bl,	00h
	je	start_game
	xor	bx,	bx
	ret
exitb:
	call	restore3h
	xor	ax,	ax
	int	21h

start_game:
	mov	bx, 	0
	ret
handle_main_enter	endp
