handle_main_key	proc
	mov	ah,	07h
hm_st:	int	21h
	cmp	al,	0dh
	je	press_enter
	cmp	al,	1bh
	je	prog_exit
	cmp	al,	0
	jne	hm_st
	int	21h
	cmp	al,	48h
	je	key_up
	cmp	al,	50h
	je	key_dawn
	jmp	hm_st
hm_ex:	ret
key_up:
	mov	bl,	menu.pos
	cmp	bl,	0
	je	to_3
	dec	bl
	mov	menu.pos,	bl
	jmp	hm_ex
to_3:
	mov	menu.pos,	02h
	jmp	hm_ex

key_dawn:
	mov	bl,	menu.pos
	cmp	bl,	02h
	je	to_1
	inc	bl
	mov	menu.pos,	bl
	jmp	hm_ex
to_1:
	mov	menu.pos,	00h
	jmp 	hm_ex
prog_exit:
	call	restore3h
	xor	ax,	ax
	int	21h
press_enter:
	mov	menu.is_enter,	1h
	ret
handle_main_key	endp

set_dir_key	macro	key
	xor	ax,	ax
	mov	al,	keys.&key
	mov	snake_direction.next_direction,	al
endm

set_game_key	macro	key
	xor	ax,	ax
	mov	al,	keys.&key
	mov	handle_keys.key,	al
endm

read_game_key	proc
	jmp rgk_init
show_help:
	beep_m	01h, 	01h
	call	help_f1
	ret	
rgk_init:
	xor	ax,	ax
	mov	ah,	01h
	int	16h
	jz	gk_ex
	mov	ah, 	0h
	int	16h
	cmp	ah,	3bh
	je	show_help
	cmp	ah,	48h
	je	up_a
	cmp	ah,	50h
	je	down_a
	cmp	ah,	4bh
	je	left_a
	cmp	ah,	4dh
	je	right_a
	cmp	ah,	39h
	je	space_k
	cmp	ah,	01h
	je	esc_k3
	cmp	al,	2bh
	je	minus_key_press
	cmp	al,	2dh
	je	plus_key_press
gk_ex:	ret

up_a:	set_dir_key 	UP
	jmp	gk_ex
down_a:	set_dir_key 	DOWN
	jmp	gk_ex
right_a:	set_dir_key 	RIGHT
		jmp	gk_ex
left_a: set_dir_key	LEFT
	jmp	gk_ex
space_k:
	set_game_key	SPACE
	jmp	gk_ex
plus_key_press:
	push	ax
	mov	al,	byte ptr counter_max
	cmp	al,	12
	je	no_slow
	inc	al
	mov	byte ptr counter_max,	al
	mov	byte ptr counter,	0h
	beep_m	01h,	01h
	pop	ax
	jmp	gk_ex
minus_key_press:
	push	ax
	xor	ax,	ax
	mov	al,	byte ptr counter_max
	cmp	al,	4
	je	no_slow
	dec	al
	mov	byte ptr counter_max,	al
	mov	byte ptr counter,	0h
	beep_m	01h,	01h
	pop	ax
	jmp	gk_ex
esc_k3:
	set_game_key	ESC_K
	jmp	gk_ex
no_slow:
	beep_m	03h,	01h
	pop	ax
	jmp	gk_ex
read_game_key	endp
