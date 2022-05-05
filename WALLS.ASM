draw_walls	proc
	push	ax
	push	bx
	push	cx
	push	dx
	push	di
	
	mov	al,	game_init_data.up_wall_type
	mov	ah,	game_init_data.all_walls_type	

	call	draw_all_walls
	mov	al,	game_init_data.up_wall_type
	mov	ah,	game_init_data.all_walls_type
	call	draw_up_wall_c

draw_wall_ret:
	pop	di
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	ret
all_rock:
	ret
draw_walls	endp

draw_up_wall_c	proc
	cmp	al,	'n'
	je	as_all_walls
	cmp	al,	'm'
	je	draw_mirror_up_wall
	cmp	al,	'p'
	je	draw_portal_up_wall
	cmp	al,	'r'
	je	up_exit
as_all_walls:
	cmp	ah,	'p'
	je	draw_portal_up_wall
	cmp	ah,	'm'
	je	draw_mirror_up_wall
up_exit:
	ret
draw_portal_up_wall:
	set_color	blue
	call	draw_up_wall
	ret
draw_mirror_up_wall:
	set_color	white
	call	draw_up_wall
	ret
draw_up_wall_c	endp

draw_all_walls	proc
	cmp	ah,	'p'
	je	draw_portal_all_walls
	cmp	ah,	'm'
	je	draw_mirror_all_walls
draw_all_walls_ret:
	ret
draw_mirror_all_walls:
	set_color	white
draw_all:
	call	draw_left_wall
	call	draw_right_wall
	call	draw_down_wall
	jmp	draw_all_walls_ret
draw_portal_all_walls:
	set_color	blue
	jmp	draw_all
draw_all_walls	endp

draw_gwall	macro	y
	mov	di,	93
	mov	cx,	y
	mov	bx,	216
	call	draw_gline
endm

draw_vwall	macro	x
	mov	di,	x
	mov	cx,	22
	mov	bx,	168
	call	draw_vline
endm

draw_up_wall	proc
	draw_gwall	19
	draw_gwall	20
	draw_gwall	21
	ret
draw_up_wall	endp

draw_down_wall	proc
	draw_gwall	190
	draw_gwall	191
	draw_gwall	192
	ret
draw_down_wall	endp

draw_left_wall	proc
	draw_vwall	90
	draw_vwall	91
	draw_vwall	92
	ret
draw_left_wall	endp

draw_right_wall	proc
	draw_vwall	309
	draw_vwall	310
	draw_vwall	311
	ret
draw_right_wall	endp