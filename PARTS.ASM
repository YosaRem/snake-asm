draw_snake_letter	proc
	set_pixel_attr 		12, 40, green
	mov	si,	offset s1_letter
	call	draw_block
	set_pixel_attr_wc	20, 40
	mov	si,	offset s2_letter
	call	draw_block
	set_pixel_attr_wc	28, 40
	mov	si, 	offset s3_letter
	call	draw_block			; 10
	set_pixel_attr_wc	20, 32
	mov	si,	offset s4_letter
	call	draw_block
	set_pixel_attr_wc	28, 32
	mov	si,	offset s5_letter
	call	draw_block
	set_pixel_attr_wc	20, 24
	mov	si,	offset s6_letter
	call	draw_block
	set_pixel_attr_wc	20, 16		; 20
	mov	si,	offset	s7_letter
	call	draw_block
	set_pixel_attr_wc	28, 14
	mov	si,	offset	s8_letter
	call	draw_block
	set_pixel_attr_wc	36, 13
	mov	si,	offset	s9_letter
	call	draw_block
	set_pixel_attr		36, 13, red
	mov	si,	offset	s10_letter	; 30
	call	draw_block
	ret
draw_snake_letter	endp