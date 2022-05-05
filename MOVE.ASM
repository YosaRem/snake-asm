x_offset	equ	93
y_offset	equ	22
counter		db	0
counter_max	db	8

init_state	proc
	mov	snake.head_pos, offset field
	push	bx	
	push	dx
	push	cx

	mov	bx,	offset field
	mov	dx,	bx
	add	dx,	6
	mov	ah,	8
	mov	al,	8
	mov	[bx].position,	ax
	mov	[bx].frame,	offset hv_1
	mov	[bx].next,	dx
	
	xor 	cx,	cx
	mov 	cl,	game_init_data.snake_length
	cmp	cl, 	2
	je	set_init_length2
	dec	cl
	dec 	cl
next_snake_part:
	dec	cx
	mov	bx,	dx
	add	dx,	6
	inc	al
	mov	[bx].position, 	ax
	mov	[bx].frame, 	offset sv_1
	mov	[bx].next, 	dx
	
	cmp	cl, 	0
	jne	next_snake_part
set_init_length2:

	mov	bx,	dx
	add	dx,	6
	inc	al
	mov	[bx].position,	ax
	mov	[bx].frame, 	offset tv_1
	mov	[bx].next,	0ffffh

	mov	snake.next_empty_space,	dx

	call	set_apple_random_position

	pop	cx
	pop	dx
	pop	bx	
	ret
init_state	endp

move_if_one	proc
	set_color	green
	xor	ax,	ax
	mov	al,	byte ptr counter
	mov	ah,	byte ptr counter_max
	cmp	al,	ah
	je	mif_co
mif_cont:
	push	ax
	mov	bx,	snake.head_pos
	call	redraw_snake
	call	black_tail
	call	redraw_apple

	pop	ax
	inc	al
	mov	byte ptr counter, al
mif_ex:	ret
mif_co:	mov	byte ptr counter, 0
	call	change_direction
	mov	bx,	snake.head_pos
	xor	ax,	ax
	mov	al,	snake_direction.current_direction
	call	recalculate_frame
	call	check_intersection
	mov	bx,	snake.head_pos
	mov	cx,	word ptr ds:[bx]
	mov	ax,	game_init_data.live_time
	inc	ax
	mov	game_init_data.live_time,	ax
	xor	ax,	ax
	
	jmp	mif_cont
move_if_one	endp

set_cx_di	proc
	push	cx
	shr	cx,	8
	mov	di,	cx
	pop	cx
	xor	ch,	ch
	ret
set_cx_di	endp

redraw_apple	proc
	push	bx
	push	ax
	push	cx

	mov	si,	offset apple_frame1
	mov	cx,	apple.a_position
	call	set_cx_di
	call	draw_block_o

	set_color	dark_green
	mov	si,	offset apple_frame1
	mov	cx,	apple.s_position
	call	set_cx_di
	call	draw_block_o

	set_color	red
	mov	si,	offset apple_frame1
	mov	cx,	apple.d_position
	call	set_cx_di
	call	draw_block_o
	

	pop	cx
	pop	ax
	pop	bx
	ret
redraw_apple	endp

black_tail	proc
	push	ax
	push	bx
	push	dx
	push	cx

	mov	al,	byte ptr counter
	mov	ah,	byte ptr counter_max
	dec	ah
	cmp	al,	ah
	je	bt_draw
bt_ret:
	pop	cx
	pop	dx
	pop	bx
	pop	ax
	ret
bt_draw:
	mov	bx,	offset field
bt_draw2:
	mov	dx,	bx
	mov	bx,	word ptr ds:[bx+4]
	cmp	bx,	0ffffh
	je	bt_draw3
	
	jmp	bt_draw2

bt_draw3:
	mov	bx,	dx
	mov	cx,	word ptr ds:[bx]
	mov	si,	offset	hvs_1
	call	set_cx_di
	call	draw_block_o
	jmp	bt_ret
black_tail	endp

redraw_snake	proc
	cmp	bx,	0ffffh
	je	redraw_ex
	push	ax
	mov	cx,	word ptr ds:[bx]	; in cx x and y withou offset

	mov	si,	word ptr ds:[bx+2]	; in si address of the first sprite
;	shl	ax,	3		; mul on 8	
;	add	si,	ax		; get sprite to draw
	mov	bx,	word ptr ds:[bx+4]
	push	bx
	call	set_cx_di
	call	draw_block_o
	pop	bx
	pop	ax
	call	redraw_snake
redraw_ex:
	
	ret
redraw_snake	endp

recalculate_frame	proc
	cmp	bx,	0ffffh
	je	recal_ex
	mov	cx,	word ptr ds:[bx]
	push	cx
	cmp	al,	10h
	je	move_up
	cmp	al, 	keys.DOWN
	je	move_down
	cmp	al,	keys.RIGHT
	je	move_right
	cmp	al,	keys.LEFT
	je	move_left
rf2:
	call	calculate_walls
	mov	word ptr ds:[bx], cx
	mov	bx,	word ptr ds:[bx+4]
	call	eat_some
	cmp	cx,	1
	je	add_snake_part2
	cmp	cx,	2
	je	remove_snake_part2
cont:
	pop	cx
	call 	move_prev_position
	ret
move_up:
	dec	cl
	jmp	rf2
move_down:
	inc	cl
	jmp	rf2
move_right:
	inc	ch
	jmp	rf2
move_left:
	dec	ch
	jmp	rf2
add_snake_part2:
	pop	cx
	call	add_part_snake
	jmp	recal_ex
remove_snake_part2:
	call	remove_part_snake
	jmp	cont
recal_ex:
	ret
recalculate_frame	endp

calculate_walls		proc
	push	ax
	mov	al,	game_init_data.all_walls_type
	cmp	al,	'm'
	je	cw_m
	cmp	al,	'p'
	je	cw_p
	call	rock_wall

to_wall_ret:
	pop	ax
	ret
cw_m:
	call	mirror_wall
	jmp	to_wall_ret
cw_p:
	call	portal_wall
	jmp	to_wall_ret
calculate_walls		endp

calculate_up_wall	proc
	push 	ax
	mov	al,	game_init_data.up_wall_type
	cmp	al,	'r'
	je	rock_up_wall
	cmp	al,	'm'
	je	mirror_up_wall
	cmp	al,	'p'
	je	portal_up_wall
	mov	al,	game_init_data.all_walls_type
	cmp	al,	'm'
	je	mirror_up_wall
	cmp	al,	'p'
	je	portal_up_wall
rock_up_wall:
	cmp	cl,	-1
	jne	cuw_end
	call	close_game
cuw_end:
	pop	ax
	ret
mirror_up_wall:
	mov	snake_direction.current_direction,	12h
	mov	cl,	0
	inc	ch
	pop	ax
	ret
portal_up_wall:
	mov	snake_direction.current_direction,	10h
	mov	cl,	20
	pop	ax
	ret
calculate_up_wall	endp

mirror_wall 	proc
	cmp	ch,	 -1
	je 	mirror_left
	cmp	cl,	-1
	je	mirror_up
	cmp	ch,	27
	je	mirror_right
	cmp	cl,	21
	je	mirror_down
	ret

mirror_down:
	mov	snake_direction.current_direction,	13h
	mov	cl,	20
	dec	ch
	ret

mirror_right:
	mov	snake_direction.current_direction,	 11h
	mov	ch,	26
	inc	cl
	ret

mirror_up:
	call	calculate_up_wall
	ret

mirror_left:
	mov	snake_direction.current_direction,	10h
	mov	ch,	0
	dec	cl
	ret
mirror_wall	endp

portal_wall	proc
	cmp	ch,	-1
	je	portal_to_right
	cmp	cl,	-1
	je	portal_to_down
	cmp	ch,	27
	je	portal_to_left
	cmp	cl,	21
	je	portal_to_up
	ret

portal_to_left:
	mov	ch,	0
	mov	snake_direction.current_direction, 12h
	ret
portal_to_up:
	mov	cl,	0
	mov	snake_direction.current_direction, 11h
	ret
portal_to_right:
	mov	ch,	26
	mov	snake_direction.current_direction, 13h
	ret
portal_to_down:
	call	calculate_up_wall
	ret
portal_wall	endp

rock_wall 	proc
	cmp	cl,	-1
	je	up_rock_wall_c
	cmp	ch,	-1
	je	endwr
	cmp	cl,	21
	je	endwr
	cmp	ch,	27
	je	endwr
	ret
endwr:
	call	close_game
up_rock_wall_c:
	call	calculate_up_wall
	ret
rock_wall	endp

move_prev_position	proc
	cmp	bx,	0ffffh
	je	mp_exe
	mov	ax,			word ptr ds:[bx]
	mov	word ptr ds:[bx], 	cx
	mov	bx,			word ptr ds:[bx+4]
	mov	cx,			ax
	call	move_prev_position
mp_exe:
	ret
move_prev_position	endp

change_direction	proc
	mov	al,	snake_direction.next_direction
	mov	bl, 	snake_direction.current_direction
	cmp	al,	bl
	je	ch_dir
	cmp	al,	0ffh
	je	ch_dir
	cmp	bl,	10h	
	je	c_d
	cmp	bl,	11h
	je	c_u
	cmp	bl,	12h
	je	c_l
	cmp	bl,	13h
	je	c_r
change:
	mov	snake_direction.current_direction, al
ch_dir:
	mov	al,	keys.NONE
	mov	snake_direction.next_direction, al
	ret
c_d:
	cmp	al,	11h
	je	ch_dir
	jmp	change
c_u:	
	cmp	al,	10h
	je	ch_dir
	jmp	change
c_l:
	cmp	al,	13h
	je	ch_dir
	jmp	change
c_r:
	cmp	al,	12h
	je	ch_dir
	jmp	change
change_direction	endp
