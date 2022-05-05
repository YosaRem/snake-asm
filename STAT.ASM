print_stat	macro	init_fields, str_names, regs
	xor	ax,	ax
	mov	&regs,	game_init_data.&init_fields
	call	int_to_string
	mov	dx,	offset &str_names
	mov	ah,	09h
	int	21h
endm
	

print_statistic	proc
	xor	ax,	ax
	push	ss
	pop	ds

	print_stat	snake_length,	final_length_str, al
	print_stat	max_snake_length, max_length_str, al
	print_stat	min_snake_length, min_length_str, al
	print_stat	eat_s_count, scissors_count_str,  al
	print_stat	eat_apple_count, apple_count_str, al
	print_stat	live_time, live_time_str, 	  ax	

	ret
print_statistic	endp

int_to_string	proc
	mov	cx,	0
	mov	dx,	0

	cmp	ax,	0
	je	its_print_0
its_start:
	cmp	ax,	0
	je	its_print
	mov	bx,	10
	div	bx
	push	dx
	inc	cx
	xor	dx,	dx
	jmp	its_start	
its_print:
	cmp	cx,	0
	je	its_exit
	pop	dx
	add	dx,	'0'
	mov	ah,	02h
	int	21h
	dec	cx
	jmp	its_print
its_exit:
	ret
its_print_0:
	mov	dx, 	'0'
	mov	ah,	02h
	int	21h
	jmp	its_exit
int_to_string	endp