print_f1	macro	number
	mov	dx,	offset help_f1_&number
	int	21h
endm

help_f1	proc
	push	ax
	push	cx
	push	dx
	push	bx
	push	ds
	push	si

	call	restore3h

	mov	ah,	09h
	print_f1	1
	print_f1	2
	print_f1	3
	print_f1	4
	print_f1	5
	print_f1	6
	print_f1	7
	print_f1	8
	print_f1	9
	print_f1	10
	

help_f1_wait:
	xor	ax,	ax
	mov	ah,	01h
	int	16h
	jz	help_f1_wait
	mov	ah,	0h
	int	16h
	call	set13h
	call	draw_field1
	call	draw_walls

	pop	si
	pop	ds
	pop	bx
	pop	dx
	pop	cx
	pop	ax
	ret
help_f1 endp