draw_file_m	macro 	buf,	name
	push	offset	&buf
	push	offset	&name
	call	draw_from_file
endm

save_x_pos	macro	pos
	mov	di,	pos
	call	save_pixel_file_start
endm
save_y_pos	macro	pos
	mov	cx,	pos
	call	save_pixel_file_y_start
endm

draw_black	proc
	save_x_pos	20
	save_y_pos	110
	draw_file_m	buf,	black_f
	ret
draw_black	endp

draw_sstart	proc
	save_x_pos	20
	save_y_pos	110
	draw_file_m	buf,	sstart_f
	ret
draw_sstart	endp
draw_start	proc
	save_x_pos	20
	save_y_pos	110
	draw_file_m	buf,	start_f
	ret
draw_start	endp
draw_levels	proc
	save_x_pos	20
	save_y_pos	140
	draw_file_m	buf,	levels_f
	ret
draw_levels	endp
draw_slevels	proc
	save_x_pos	20
	save_y_pos	140
	draw_file_m	buf,	slevels_f
	ret
draw_slevels	endp
draw_exit	proc
	save_x_pos	20
	save_y_pos	170
	draw_file_m	buf,	exit_f
	ret
draw_exit	endp
draw_sexit	proc
	save_x_pos	20
	save_y_pos	170
	draw_file_m	buf,	sexit_f
	ret
draw_sexit	endp

draw_main	proc
	save_x_pos	0
	draw_file_m	buf,	mp
	save_x_pos	20
	save_y_pos	110
	draw_file_m	buf,	sstart_f
	save_y_pos	140
	draw_file_m	buf,	levels_f
	save_y_pos	170
	draw_file_m	buf,	exit_f	
	ret
draw_main	endp

draw_field1	proc
	call	set13h
	save_x_pos	0
	save_y_pos	0
	draw_file_m	buf,	field1_f
	ret
draw_field1	endp

drop_handle_game_key	macro
	mov	ah,	keys.NONE
	mov	handle_keys.key,	ah
endm

if_pause	proc
	mov	al,	handle_keys.key
	cmp	al,	keys.SPACE
	jne	if_e
	drop_handle_game_key
	mov	ah,	0h
	int	16h

if_e:	ret
endp

if_exit		proc
	mov	al,	handle_keys.key
	cmp	al,	keys.ESC_k
	jne	@@1
	drop_handle_game_key
	call	close_game
	

@@1:	ret
endp
