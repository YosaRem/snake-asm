check_intersection	proc
	push	ax
	push	cx
	push	bx
	push	dx

	xor	ax,	ax
	mov	al,	game_init_data.intersection_behavior
	cmp	al,	'n'
	je	inter_ret
	cmp	al,	'd'
	je	death_inter
	cmp	al,	'c'
	je	cut_inter

inter_ret:
	pop	dx
	pop	bx
	pop	cx
	pop	ax
	ret

death_inter:
	call	is_intersect
	cmp	cx,	0ffffh
	je	inter_ret
	call	close_game
cut_inter:
	call	is_intersect
	cmp	cx,	0ffffh
	je	inter_ret
	call	del_tail
	jmp	inter_ret

check_intersection	endp

del_tail	proc
	mov	bx,	offset field
	mov	dx,	word ptr ds:[bx]
	mov	bx,	word ptr ds:[bx+4]
	mov	cx,	1
	push	cx
del_next:
	mov	cx,	word ptr ds:[bx]
	cmp	dx,	cx
	je	del_inter
	pop	cx
	inc	cx
	push	cx
	mov	ax,	bx
	mov	bx,	word ptr ds:[bx+4]
	cmp	bx,	0ffffh
	jne	del_next
	ret
del_inter:
	mov	dx,	bx
	mov	bx,	ax
	mov	[bx].next,	0ffffh
	mov	[bx].frame,	offset tv_1
	mov	bx,	dx

del_cont:
	set_color	black
	mov	si,	offset hvs_1
	mov	cx,	word ptr ds:[bx]
	call	set_cx_di
	push	bx
	push	ax
	call	draw_block_o
	pop	ax
	pop	bx
	mov	bx,	word ptr ds:[bx+4]
	cmp	bx, 	0ffffh
	jne	del_cont
	pop	cx
	mov	game_init_data.snake_length,	cl
	mov	al,	game_init_data.min_snake_length
	cmp	cl,	al
	jb	change_min_del
del_final_ret:	
	ret
change_min_del:
	mov	game_init_data.min_snake_length,	cl
	jmp	del_final_ret
del_tail	endp

is_intersect	proc
	mov	bx,	offset field
	mov	dx,	word ptr ds:[bx]
	mov	bx,	word ptr ds:[bx+4]
is_next:
	mov	cx,	word ptr ds:[bx]
	cmp	dx,	cx
	je	is_intersec
	mov	bx,	word ptr ds:[bx+4]
	cmp	bx,	0ffffh
	jne	is_next	
	
	mov	cx,	0ffffh
is_intersec:
	mov	cx,	bx
	ret
is_intersect	endp
