mp		db	'files\main.txt', 0
mp2		db	'files\main2.txt', 0
start_f		db	'files\start.txt', 0
sstart_f	db	'files\sstart.txt', 0
exit_f		db	'files\exit.txt', 0
sexit_f		db	'files\sexit.txt', 0
levels_f	db	'files\levels.txt', 0
slevels_f	db	'files\slevels.txt', 0
black_f		db	'files\black.txt', 0
field1_f	db	'files\field1.txt', 0

unknown_key	db	' unknown key given; use \h for help', 0ah, '$'
wrong_char_str	db	' wrong char', 0ah, '$'
too_long_str	db	'snake too long', 0ah, '$'
wrong_coord_str	db	'invalid coord data', 0ah, '$'

help1		db	'\h for help', 0ah, '$'
help2		db	'\w for up wall, possible values: r (rock, default), p (portal), m (mirror)', 0ah, '$'
help3		db	'\l for snake length, possible from 2 to 12', 0ah, '$'
help4		db	'\c for intersections, possible: d (deaht, default), c (cut), n (no effect)', 0ah, '$'
help5		db	'\k for all walls type, possible r (default), p, m', 0ah, '$'
help6		db	'\a for init apple position. Format: XX_XX', 0ah, '$'
help7		db	'\r for init scissors position. Format XX_XX', 0ah, '$'
help8		db	'\d for init death point position. Format XX_XX', 0ah, '$'

help_f1_1	db	'arrows for snake control', 0ah, '$'
help_f1_2	db	'+ and - for speed up and slow down', 0ah, '$'
help_f1_3	db	'F1 for this help', 0ah, '$'
help_f1_4	db	'Space for pause', 0ah, '$'
help_f1_5	db	'Red walls are rock walls', 0ah, '$'
help_f1_6	db	'Blue walls are portal walls', 0ah, '$'
help_f1_7	db	'White walls ar mirror walls', 0ah, '$'
help_f1_8	db	'Green point - apple', 0ah, '$'
help_f1_9	db	'Pink point - scissors', 0ah, '$'
help_f1_10	db	'Red point - permament death!', 0ah, '$'

final_length_str	db	' - final length', 0ah, '$'
max_length_str		db	' - max snake length', 0ah, '$'
min_length_str		db	' - min snake length', 0ah, '$'
scissors_count_str	db	' - ate scissors count', 0ah, '$'
apple_count_str		db	' - ate apple count', 0ah, '$'
live_time_str		db	' - live time in steps', 0ah, '$'

colors	struc
	white		db	00000111b
	green		db	00000010b
	dark_green	db	10000111b
	light_green	db	00001000b
	black		db	00000000b
	red		db	00000100b
	blue		db	00110110b
colors	ends

color	colors	<>

main_key_pos	struc
	pos		db	0h
	is_enter	db	0h
main_key_pos	ends

menu	main_key_pos	<>

snake_data	struc
	head_pos		dw	0
	next_empty_space 	dw	0
snake_data	ends

snake	snake_data	<>

kyes_c	struc
	UP	db	10h
	DOWN	db	11h
	RIGHT	db	12h
	LEFT	db	13h
	SPACE	db	14h
	ENTER_K	db	15h
	ESC_K	db	16h
	NONE	db	0ffh
kyes_c	ends

keys	kyes_c	<>

direction	struc
	next_direction		db	0ffh
	current_direction	db	10h
	next_frame_direction	db	0ffh
direction	ends

snake_direction	direction	<>

handle_game_keys	struc
	key	db	0ffh
handle_game_keys	ends

handle_keys	handle_game_keys	<>

game_initial_data	struc
	snake_length		db	04h
	up_wall_type		db	'n'
	intersection_behavior	db	'd'
	start_apple		dw	-1
	start_deathe		dw	-1
	start_s			dw	-1
	all_walls_type		db	'r'
	eat_apple_count		db	0h
	eat_s_count		db	0h
	max_snake_length	db	04h
	min_snake_length	db	04h
	live_time		dw	0h
game_initial_data	ends

game_init_data	game_initial_data	<>

snake_state	struc
	position	dw	?
	frame		dw	?
	next		dw	?
	
snake_state	ends

snake_struc	snake_state	<>

apple_s		struc
	a_position	dw	?
	d_position	dw	?
	s_position	dw	?
apple_s		ends

apple		apple_s		<>

