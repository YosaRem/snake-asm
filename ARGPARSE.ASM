parse 	proc
parse_start:
	inc	si
	mov 	ah, 	byte ptr [si]
	cmp	ah,	20h
	je	parse_start
	cmp	ah,	5ch
	je	parse_sign
	cmp	ah,	0dh
	je	end_parse
	cmp	ah,	0
	je	end_parse

parse_sign:
	inc	si
	mov	ah,	byte ptr [si]
	cmp 	ah, 	'l'		; parse snake length
	je	write_init_snake_length
	cmp	ah,	'h'	
	je 	print_key_help
	cmp	ah,	'c'
	je	intersection_type
	cmp	ah,	'w'
	je	add_up_wall_type
	cmp	ah,	'k'
	je	add_all_wall_type
	cmp	ah,	'a'
	je	add_apple_init_position
	cmp	ah,	'r'
	je	add_scissors_init_position
	cmp	ah,	'd'
	je	add_death_init_position
	cmp	ah,	0h
	je	end_parse
	call	print_unknown_key	
	
end_parse:
	ret

add_scissors_init_position:
	call	scissors_init_position_parse
	inc	si
	jmp	parse_start
add_death_init_position:
	call	death_init_position_parse
	inc	si
	jmp	parse_start

add_apple_init_position:
	call	apple_init_position_parse
	inc	si
	jmp	parse_start

add_all_wall_type:
	add	si,	2
	mov	al,	byte ptr [si]
	call	check_wall_letters
	mov	game_init_data.all_walls_type,	al
	inc	si
	jmp parse_start

write_init_snake_length:
	call	init_snake_length_setup
	jmp 	parse_start
	
print_key_help:
	call	print_key_help_f

intersection_type:
	add	si,	2
	mov	al,	byte ptr [si]
	call	check_inter_type
	mov	game_init_data.intersection_behavior,	al
	inc	si
	jmp	parse_start

add_up_wall_type:
	add	si,	2
	mov	al,	byte ptr [si]
	call	check_wall_letters
	mov	game_init_data.up_wall_type,	al
	inc	si
	jmp	parse_start
parse	endp

check_inter_type	proc
	cmp	al,	'd'
	je	check_inter_ok
	cmp	al,	'c'
	je	check_inter_ok
	cmp	al,	'n'
	je	check_inter_ok
	mov	dl,	al
	mov	ah,	02h
	int 	21h
	mov	dx,	offset	wrong_char_str
	mov	ah,	09h
	int	21h
	xor	ax,	ax
	int	21h
check_inter_ok:
	ret
check_inter_type	endp

death_init_position_parse	proc
	add	si,	2
	call	parse_coord
	cmp	ch,	27
	jae	death_init_too_long
	cmp	cl,	21
	jae	death_init_too_long
	mov	game_init_data.start_deathe,	cx
	ret
death_init_too_long:
	call	too_long_coord
death_init_position_parse	endp

check_wall_letters	proc
	cmp	al,	'r'
	je	check_wall_ok
	cmp	al,	'm'
	je	check_wall_ok
	cmp	al,	'p'
	je	check_wall_ok
	
	mov	dl,	al
	mov	ah,	02h
	int	21h
	mov	dx,	offset 	wrong_char_str
	mov	ah,	09h
	int	21h
	xor	ax,	ax
	int	21h
check_wall_ok:
	ret
check_wall_letters	endp

scissors_init_position_parse	proc
	add	si,	2
	call	parse_coord
	cmp	ch,	27
	jae	scissors_init_too_long
	cmp	cl,	21
	jae	scissors_init_too_long
	mov	game_init_data.start_s,	cx
	ret
scissors_init_too_long:
	call	too_long_coord
scissors_init_position_parse	endp

apple_init_position_parse	proc
	add	si,	2
	call	parse_coord
	cmp	ch,	27
	jae	apple_init_too_long
	cmp	cl,	21
	jae	apple_init_too_long
	mov	game_init_data.start_apple,	cx
	ret
apple_init_too_long:
	call 	too_long_coord
apple_init_position_parse	endp

too_long_coord	proc
	mov	ah,	09h
	mov	dx,	offset wrong_coord_str
	int	21h
	xor	ax,	ax
	int	21h
too_long_coord 	endp

parse_coord	proc
	push	bx
	push	dx
	push	ax
	xor	cx,	cx
	mov	ch,	 -1

coord_parse_next:
	mov	al,	byte ptr [si]
	sub	al,	'0'
	cmp	al,	0
	jb	wrong_char_coord
	cmp	al,	10
	ja	wrong_char_coord

	inc	si
	mov	bl,	10
	mul	bl
	mov	bl,	byte ptr [si]
	sub	bl,	'0'
	xchg	bl,	al
	cmp	al,	0
	jb	wrong_char_coord
	cmp	al,	10
	ja	wrong_char_coord
	xchg	bl,	al
	add	al,	bl
	cmp	ch,	-1
	jne	second_part
	
	mov	ch,	al

	inc	si
	mov	al,	byte ptr [si]
	cmp	al,	'_'
	jne	wrong_char_coord
	inc	si	
	jmp	coord_parse_next

second_part:
	mov	cl,	al
	pop	ax
	pop	dx
	pop	bx
	ret
wrong_char_coord:
	add	al,	'0'
	mov	dl,	al
	mov	ah,	02h
	int	21h
	mov	ah, 	09h
	mov	dx,	offset wrong_char_str
	int	21h
	xor	ax,	ax
	int	21h
parse_coord	endp

init_snake_length_setup	proc
	add	si,	2
	call	str_to_int
	cmp	al,	2
	jb	min_2_length
	cmp	al,	13
	jae	min_2_length
length_setup_cont:
	mov	game_init_data.snake_length,		al
	mov	game_init_data.max_snake_length,	al
	mov	game_init_data.min_snake_length,	al
	inc	si
	ret
min_2_length:
	mov	al,	2
	jmp	length_setup_cont
init_snake_length_setup	endp

print_key_help_f	proc
	mov	ah,	09h
	mov	dx,	offset help1
	int	21h
	mov	dx,	offset help2
	int	21h
	mov	dx,	offset help3
	int	21h
	mov	dx,	offset help4
	int	21h
	mov	dx,	offset help5
	int	21h
	mov	dx,	offset help6
	int	21h
	mov	dx,	offset help7
	int	21h
	mov	dx,	offset help8
	int	21h
	xor	ax,	ax
	int	21h
	ret
print_key_help_f	endp

one_char_print	macro	char
	push	dx
	push	ax
	mov	dl,	'&char'
	mov	ah,	02h
	int	21h
	pop	ax
	pop	dx
endm

print_unknown_key	proc
	xor	dx,	dx
	mov	dl,	ah
	mov	ah,	02h
	int	21h
	mov	dx, 	offset unknown_key
	mov	ah,	09h
	int	21h
	xor	ax,	ax
	int	21h	
	ret
print_unknown_key	endp

str_to_int	proc
	push	cx
	push	dx
	push	bx

	mov	al,	byte ptr [si]
	sub	al,	'0'
	cmp	al, 	10
	jae	wrong_char
	cmp	al,	0
	jbe	wrong_char
	mov	bl,	byte ptr [si+1]
	cmp	bl,	' '
	je	str_to_int_ret
	cmp	bl,	0dh
	je	str_to_int_ret
	jmp	two_long

str_to_int_ret:
	pop	bx
	pop	dx
	pop	cx
	ret
two_long:
	inc	si
	mov	bl,	10
	mul	bl
	mov	bl,	byte ptr [si]
	sub	bl,	'0'
	cmp	bl,	10
	jae	wrong_char
	cmp	bl,	0
	jbe	wrong_char
	add	al,	bl
	cmp	al,	13
	jae	too_long
	jmp str_to_int_ret
too_long:
	mov	dx,	offset too_long_str
	mov	ah,	09h
	int	21h
	xor	ax,	ax
	int	21h
wrong_char:
	add	al,	'0'
	mov	dl,	al
	mov	ah,	02h
	int	21h
	mov	ah,	09h
	mov	dx,	offset wrong_char_str
	int	21h
	xor	ax,	ax
	int	21h
str_to_int	endp