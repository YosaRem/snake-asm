eat_some	proc
	push	bx

	mov	bx,	apple.a_position
	cmp	cx,	bx
	je	eat_apple
	mov	bx,	apple.s_position
	cmp	cx,	bx
	je	eat_s
	mov	bx,	apple.d_position
	cmp	cx,	bx
	je	eat_d

eat_end:
	pop	bx
	ret

eat_apple:
	beep_m	01h,	01h
	mov	cl,	game_init_data.eat_apple_count
	inc	cl
	mov	game_init_data.eat_apple_count,	cl
	mov	cl,	game_init_data.snake_length
	inc	cl
	mov	game_init_data.snake_length,	cl
	
	push	ax
	mov	al,	game_init_data.max_snake_length
	cmp	cl,	al
	pop	ax
	ja	change_max_length
apple_ret:
	mov	cx, 	1
	jmp	eat_end
change_max_length:
	mov	game_init_data.max_snake_length, cl
	jmp	apple_ret

eat_s:
	beep_m	01fh,	01h
	mov	cl,	game_init_data.snake_length
	dec	cl
	cmp	cl,	1
	je	eat_d
	mov	game_init_data.snake_length,	cl
	push	ax
	mov	al,	game_init_data.min_snake_length
	cmp	cl,	al
	jb	change_min_length
scissors_ret:
	pop	ax
	mov	cx,	2
	inc	game_init_data.eat_s_count
	jmp	eat_end
change_min_length:
	mov	game_init_data.min_snake_length, 	cl
	jmp	scissors_ret
eat_d:
	beep_m	04fh,	01h
	call	close_game
eat_some	endp

add_part_snake	proc
	push	bx
	push	dx
	mov	dx,	bx

	mov	bx,	snake.next_empty_space	; add the second part
	mov	[bx].position,	cx
	mov	[bx].frame,	offset hv_1
	mov	[bx].next,	dx

	mov	dx,	bx
	mov	bx,		offset	field
	mov	[bx].next,	dx

	add	dx,	6
	mov	snake.next_empty_space,	dx
	
	push	cx
	call	redraw_apples_black
	call	set_apple_random_position
	pop	cx

	pop	dx
	pop	bx
	ret
add_part_snake	endp

remove_part_snake	proc
	push	bx
	push	dx
	push	ax
	push	cx

	mov	bx,	offset field
	
remove_to_tail:
	cmp	bx,	0ffffh
	je	remove_tail_found
	mov	cx,	dx
	mov	dx,	bx
	mov	bx,	[bx].next
	jmp	remove_to_tail

remove_end:
	call	redraw_apples_black
	call	set_apple_random_position
	pop	cx
	pop	ax
	pop	dx
	pop	bx
	ret
remove_tail_found:
	mov	bx,	cx
	mov	word ptr ds:[bx + 2], 	offset tv_1
	mov	word ptr ds:[bx + 4],	0ffffh

	set_color	black
	mov	si,	offset hvs_1
	mov	cx,	word ptr ds:[bx]
	call	set_cx_di
	call	draw_block_o
	
	jmp	remove_end
remove_close:
	call	close_game
remove_part_snake	endp


set_apple_random_position	proc
	jmp	set_apple_random_pos_start
init_apple_exist:
	mov	apple.a_position,	bx
	mov	bx,	-1
	mov	game_init_data.start_apple,	bx
	call	get_random
	jmp	d_pos_cont
init_death_exist:
	mov	apple.d_position,	bx
	mov	bx,	-1
	mov	game_init_data.start_deathe,	bx
	jmp	s_pos_cont
init_scissors_exist:
	mov	apple.s_position,	bx
	mov	bx,	-1
	mov	game_init_data.start_s,		bx
	jmp	s_end_pos_cont	
		
set_apple_random_pos_start:
	push	cx
	push	ax
	push	bx
	mov	bx,	game_init_data.start_apple
	cmp	bx,	-1
	jne	init_apple_exist

	call	get_random
	add	cx,	dx
	mov	ax,	cx
	mul	ax
	shr	ax,	4
	mov	bl,	14h
	div	bl
	mov	cl,	ah
	mov	bl,	01ah
	div	bl
	mov	ch,	ah
	mov	apple.a_position,	cx
d_pos_cont:	
	mov	bx,	game_init_data.start_deathe
	cmp	bx,	-1
	jne	init_death_exist
	add	cx,	dx
	mov	ax,	cx
	mul	ax
	shr	ax,	4
	mov	bl,	14h
	div	bl
	mov	cl,	ah
	mov	bl,	01ah
	div	bl
	mov	ch,	ah
	mov	apple.d_position,	cx
	
s_pos_cont:
	mov	bx,	game_init_data.start_s
	cmp	bx,	-1
	jne	init_scissors_exist
	add	cx,	dx
	mov	ax,	cx
	mul	ax
	shr	ax,	4
	mov	bl,	14h
	div	bl
	mov	cl,	ah
	mov	bl,	01ah
	div	bl
	mov	ch,	ah
	mov	apple.s_position,	cx
s_end_pos_cont:	

	pop	bx
	pop	ax
	pop	cx
	ret
set_apple_random_position	endp

redraw_apples_black	proc
	push	bx
	push	ax
	push	dx
	
	set_color	black
	mov	si,	offset hvs_1
	mov	cx,	apple.a_position
	call	set_cx_di
	call 	draw_block_o
	mov	si,	offset hvs_1
	mov	cx,	apple.d_position
	call	set_cx_di
	call	draw_block_o
	mov	si,	offset hvs_1
	mov	cx,	apple.s_position
	call	set_cx_di
	call	draw_block_o

	pop	dx
	pop	ax
	pop	bx
	ret
redraw_apples_black	endp
