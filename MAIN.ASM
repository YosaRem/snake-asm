; created by Yosa Rem
.model tiny
.code
org 100h
start:
	jmp	init
include		beep.asm
include		help.asm
include		draw.asm
include		walls.asm
include		random.asm
include		stat.asm
include		inters.asm
include		apple.asm
include		parts.asm
include		screens.asm
include		keys.asm
include		switch.asm
include		inter.asm
include		move.asm
include		argparse.asm
init:
	beep_m	0dh, 	01h
	beep_m	0ch, 	01h
	beep_m	0ach, 	02h
	beep_m	00h,	01h
	beep_m	0dh,	01h
	beep_m	00h,	01h
	beep_m	0dh,	01h

	mov	si,	81h
	call	parse
	xor	si, 	si
	call	set13h
	call	draw_main
s33:	
	call	handle_main_key
	call	redraw_main_button
	cmp	bx,	0
	jne	s33

	call	draw_field1
	call	draw_walls
	call	init_state
	call	set_fps

circle:
	call	read_game_key
	call	if_pause
	call	if_exit
	xor	ax,	ax
	mov	al,	byte ptr is_move
	cmp	al,	1
	jne	circle
	mov	byte ptr is_move,	0
	call	move_if_one
	jmp	circle

	xor	ax,	ax
	int	16h
gexi:
	call	restore3h
	call	restore_fps
	ret	

close_game	proc
	call	restore3h
	call	restore_fps
	beep_m	03fh,	01h
	call	print_statistic
	xor	ax,	ax
	int	21h
close_game	endp

include		data.asm
include		letters.asm
include		frames.asm
org	0a0ch
field		dw	?
org	0f00h
buf		db	?
end start
