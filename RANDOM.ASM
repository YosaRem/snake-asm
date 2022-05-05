get_random	proc
	push	ax
	push	dx
	push	bx
	push	es
	
	push	0
	pop	es

	mov	ax,	es:[046ch]
	shr	ax,	4
	mov	bl,	14h
	div	bl
	mov	cl,	ah

	mov	ax,	es:[046ch]
	shr	ax,	4
	mov	bl,	01ah
	div	bl
	mov	ch,	ah
	
	pop	es
	pop	bx
	pop	dx
	pop	ax
	ret 
get_random	endp