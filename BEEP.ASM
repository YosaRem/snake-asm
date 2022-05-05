beep_m	macro	x,	y
	push	bx
	mov	bh,	x
	mov	bl,	y
	call	beep
	pop	bx
endm

beep	proc
	push	ax
	push	dx
	push	cx

	mov	al,	10110110b
	out	43h,	al
	mov	al,	0dh
	out	42h,	al
	mov	al,	bh
	out	42h,	al
	in	al,	61h
	or	al,	00000011b
	out	61h,	al
	xor	bx,	bx
	xor	bl,	bl
	mov	bl,	bh
	xor	bh,	bh
	mov	cx,	bx
	mov	dx,	0a120h
	mov	ah,	86h
	int	15h
	in	al,	61h
	and	al,	11111100b
	out	61h,	al
	
	pop	cx
	pop	dx
	pop	ax
	ret
beep	endp