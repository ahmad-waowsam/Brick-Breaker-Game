.model small
.stack 100h
.data
input1 db "Input your number = ", '$'
text_score db "SCORE = ", "$"
text_live db "Lives = " , "$"
text_game_end db "THE GAME HAS ENDED",'$'
text_win_screen db "YOU HAVE WON THE GAME","$"
text_enter_name db "Enter your name = ","$"



boundary dw 0
retrieve dw 0
temp dw 0
temp2 dw 0
temp3 dw 0

x_axis_ball dw 200
y_axis_ball dw 150

prev_ball_x dw 200
prev_ball_y dw 150



size_ball dw 6
check_ball dw 0
temp_time db 0

score dw 0     ;score that updates
lives dw 3     ;total lives 

ball_speed_x dw 1 ;speed of ball in x_axis
ball_speed_y dw 2 ; speed of ball in y axis

new_ball_x_speed dw 1
new_ball_y_speed dw 3 


new_ball_level_3_x_speed dw 2
new_ball_level_3_y_speed dw 3




initial_bound_x dw ? ;used to draw boundaries  
initial_bound_y dw ? ;used to draw boundaries
final_bound_y  dw ?  ;used to draw boundaries
final_bound_x dw ?   ;used to draw boundaries

left_bound dw 20     ; setting left boundary collision
upper_bound dw 20    ; setting upper boundary collision
right_bound dw 300   ; setting right boundary collision
lower_bound dw 200

paddle_x dw  152		; intital paddle position x
paddle_y dw  185 		; intital paddle position y
paddle_height dw 8		; sets paddleh height
paddle_length dw 80     ; sets paddle lenth 
paddle_speed dw 10       ; sets speed at which paddle moves 
float_paddle dw 6       ; the floating paddle value
new_paddle_length dw 60 ; length of paddle in level 2
level_counter dw 1      ;check current level


prev_paddle_x dw 152
prev_paddle_y dw 185


;brick 2 and 5 fixed bricks 
;brick 7 special brick

brick_length dw 25   ; brick length 
brick_height dw 15   ;brick height

score_brick1 dw 5    ;bricks 1,4,7,10 score
score_brick2 dw 7 	 ;bricks 2,5,8,11 score
score_brick3 dw 10   ;bricks 3,6,9,12 score

level_2_collision_arr dw 13 DUP(0) 
level_3_collision_arr dw 13 DUP(0)
 
brick1_x dw 50      ;starting coordinates of first brick
brick1_y dw 40		;starting coordinates of first brick
brick1_color db 04h ;color of brick 

brick2_x dw 90     ;starting coordinates of brick 2
brick2_y dw 40  	;starting coordinates of brick 2
brick2_color db 05h

brick3_x dw 130  ;starting coordinates of brick 3
brick3_y dw 40 ;starting coordinates of brick 3
brick3_color db 06h

brick4_x dw 170  ;starting coordinates of brick 4
brick4_y dw 40 ;starting coordinates of brick 4
brick4_color db 04h   

brick5_x dw 210   ;starting coordinates of brick 5
brick5_y dw 40		;starting coordinates of brick 5
brick5_color db 05h

brick6_x dw 250  ;starting coordinates of brick 6
brick6_y dw 40  ;starting coordinates of brick 6
brick6_color db 06h

brick7_x  dw 50 	;starting coordinates of brick 7
brick7_y dw 65 	;starting coordinates of brick 7
brick7_color db 04h

brick8_x dw 90 ;starting coordinates of brick 8
brick8_y dw 65 ;starting coordinates of brick 8
brick8_color db 05h

brick9_x dw 130
brick9_y dw 65
brick9_color db 06h

brick10_x dw 170 
brick10_y dw 65
brick10_color db 04h

brick11_x dw 210
brick11_y dw 65
brick11_color db 05h


brick12_x dw 250
brick12_y dw 65
brick12_color db 06h

temp_color db 0   ;used to store temp color



.code

; macro draw_striker X1 , Y1 
	

	



; endm
draw_pixel macro

mov ah, 0ch ; pixel write
mov al , 0eh ; setting color yellow
mov bh,00h
int 10h



endm



draw_boundary_x macro

mov ax, initial_bound_x
mov bx, final_bound_x
mov cx, initial_bound_x
mov dx, initial_bound_y

.while(cx != final_bound_x)
	inc cx
	draw_pixel

.endw

endm

draw_boundary_y macro

mov ax, initial_bound_x
mov bx, final_bound_x
mov cx, initial_bound_x
mov dx, initial_bound_y

.while(dx != final_bound_y)
	inc dx
	draw_pixel

.endw

endm




; draw_rect proc 

clr macro
	mov ah, 00h
	mov al, 13
	int 10h
	

	mov ah,0bh
	mov bh,00h
	mov bl,00h
	int 10h


endm




; draw_rect endp


main proc
mov ax,@data
mov ds,ax
mov ax,0

;Set video mode


clr

call draw_all_bricks
   

recurse:
	mov ah,2ch  ; system time command
	int 21h

	
	cmp dl, temp_time ; new time compared to  prev time
	je recurse


	call draw_ball	
	mov temp_time , dl  ; time update
	call move_b              ;moves the ball
	
	call draw_boundary
		;draws the ball 
	
	call draw_paddle
	call move_paddle
	call check_collision_paddle
	call brick1_collison
	call brick2_collision
	call brick3_collision
	call brick4_collision
	call brick5_collision
	call brick6_collision
	call brick7_collision
	call brick8_collision
	call brick9_collision
	call brick10_collision
	call brick11_collision
	call brick12_collision

	call display_score
	call display_lives 
	call remove_trace

	.if(level_counter == 1)
	call check_level_1_end	
	.endif

	.if(level_counter == 2)
	call check_level_2_end
	.endif

	.if(level_counter == 3)
	call check_level_3_end
	.endif

	jmp recurse



finish_game::
clr
call display_end_game_screen
jmp final_label

final_label::


mov ah,4ch
int 21h

main endp





level_2 proc

mov brick1_color,07h
mov brick4_color,07h
mov brick7_color,07h
mov brick10_color,07h

mov brick2_color,08h
mov brick5_color,08h
mov brick8_color,08h
mov brick11_color,08h

mov brick3_color,09h
mov brick6_color,09h
mov brick9_color,09h
mov brick12_color,09h

mov ax,new_paddle_length
mov paddle_length,ax

mov ax,new_ball_x_speed
mov bx,new_ball_y_speed

mov ball_speed_x,ax
mov ball_speed_y,bx

ret
level_2 endp

level_3 proc


mov brick1_color,11
mov brick4_color,11
mov brick7_color,11
mov brick10_color,11

mov brick2_color,12
mov brick5_color,12
mov brick8_color,12
mov brick11_color,12

mov brick3_color,13
mov brick6_color,13
mov brick9_color,13
mov brick12_color,13


mov ax,new_ball_level_3_x_speed
mov bx,new_ball_level_3_y_speed

mov x_axis_ball , ax
mov y_axis_ball , bx

ret
level_3 endp


display_end_game_screen proc
	
	push ax
	push bx
	push cx
	push dx

	mov ah,02h    ;cursor positon
	mov bh,00h    ;page
	mov dh, 9h	  ;column
	mov dl, 9h	  ;rows
	int 10h

	mov ah,09h   ;displays string
	lea dx, text_game_end  ;string pointer
	int 21h

	mov ah,02h    ;cursor positon
	mov bh,00h    ;page
	mov dh, 10h	  ;column
	mov dl, 10h	  ;rows
	int 10h

	call display_score_endgame



	pop dx
	pop cx
	pop bx
	pop ax


	mov ah,00h
	int 16h

	cmp al,10
	je final_label

ret
display_end_game_screen endp


display_score_endgame proc

push ax 
push bx 
push cx
push dx

mov ah,02h    ;cursor positon
mov bh,00h    ;page
mov dh,10h	  ;column
mov dl,10h	  ;rows
int 10h

mov ah,09h   ;displays string
lea dx,text_score  ;string pointer
int 21h

mov ah,02h    ;cursor positon
mov bh,00h    ;page
mov dh,10h	  ;column
mov dl,16h	  ;rows
int 10h


mov cx,0
    
    mov ax,score
    ll:
    mov bx,10
    mov dx,0
    div bx
    push dx
    inc cx
    cmp ax,0
    jne ll
    
    l2:
    pop dx
    mov ah,2
    add dl,'0'
    int 21h
    loop l2
    






pop dx
pop cx
pop bx
pop ax

ret



display_score_endgame endp


check_level_1_end proc


.if(brick1_color == 00h && brick2_color == 00h && brick3_color == 00h && brick4_color == 00h && brick5_color == 00h && brick6_color == 00h)
.if(brick7_color == 00h && brick8_color == 00h && brick9_color == 00h )
.if(brick10_color == 00h && brick11_color == 00h && brick12_color == 00h)
call level_2
inc level_counter
.endif
.endif
.endif

ret
check_level_1_end endp


check_level_2_end proc


.if(brick1_color == 00h && brick2_color == 00h && brick3_color == 00h && brick4_color == 00h && brick5_color == 00h && brick6_color == 00h)
.if(brick7_color == 00h && brick8_color == 00h && brick9_color == 00h )
.if(brick10_color == 00h && brick11_color == 00h && brick12_color == 00h)
call level_3
inc level_counter
.endif
.endif
.endif



ret
check_level_2_end endp

check_level_3_end proc

.if(brick1_color == 00h  && brick3_color == 00h && brick4_color == 00h && brick6_color == 00h)
.if(brick7_color == 00h && brick8_color == 00h && brick9_color == 00h )
.if(brick10_color == 00h && brick11_color == 00h && brick12_color == 00h)
call finish_game
.endif
.endif
.endif





ret
check_level_3_end endp

remove_lives proc 

	


ret 
remove_lives endp




display_lives proc

push ax
push bx
push cx
push dx


mov ah,02h    ;cursor positon
mov bh,00h    ;page
mov dh,01h	  ;column
mov dl,19h	  ;rows
int 10h

mov ah,09h   ;displays string
lea dx, text_live  ;string pointer
int 21h



mov ah,02h    ;cursor positon
mov bh,00h    ;page
mov dh,01h	  ;column
mov dl,21h	  ;rows
int 10h

mov cx, lives

l3:	
mov ah,02h	
mov dl , 3h
int 21h


loop l3

pop dx
pop cx
pop bx
pop ax


ret
display_lives endp


display_score proc

push ax 
push bx 
push cx
push dx

mov ah,02h    ;cursor positon
mov bh,00h    ;page
mov dh,01h	  ;column
mov dl,01h	  ;rows
int 10h

mov ah,09h   ;displays string
lea dx,text_score  ;string pointer
int 21h

mov ah,02h    ;cursor positon
mov bh,00h    ;page
mov dh,01h	  ;column
mov dl,08h	  ;rows
int 10h


mov cx,0
    
    mov ax,score
    ll:
    mov bx,10
    mov dx,0
    div bx
    push dx
    inc cx
    cmp ax,0
    jne ll
    
    l2:
    pop dx
    mov ah,2
    add dl,'0'
    int 21h
    loop l2
    






pop dx
pop cx
pop bx
pop ax

ret
display_score endp


check_collision_paddle proc
	
	mov ax, paddle_x
	mov bx, ax
	add bx, paddle_length
	mov cx , paddle_y
	sub cx, float_paddle
	.if(x_axis_ball >= ax && x_axis_ball <= bx && y_axis_ball>= cx)	
	neg ball_speed_y
	.endif
ret
check_collision_paddle endp


brick1_collison proc


push ax
push bx
push cx
push dx

.if(brick1_color == 0)

jmp end1
.endif

mov ax,brick1_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick1_y
mov dx, cx
sub cx,size_ball

add dx,brick_height


.if(level_counter == 1)
	.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
	neg ball_speed_y
	mov brick1_color, 00h
	push ax
	mov ax, score_brick1
	add score,ax
	pop ax
	call draw_all_bricks
	.endif
.endif


mov ax,brick1_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick1_y
mov dx, cx
sub cx,size_ball

add dx,brick_height


.if(level_counter == 2)
.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
neg ball_speed_y
inc level_2_collision_arr[1]
.if(level_2_collision_arr[1] >= 2)
	push ax
	mov ax, score_brick1
	add score,ax
	pop ax

mov brick1_color , 00h
.endif
call draw_all_bricks
.endif
.endif



mov ax,brick1_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick1_y
mov dx, cx
sub cx,size_ball

add dx,brick_height



.if(level_counter == 3)

.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
neg ball_speed_y
inc level_3_collision_arr[1]
.if(level_3_collision_arr[1] >= 3)
	push ax
	mov ax, score_brick1
	add score,ax
	pop ax

mov brick1_color , 00h
.endif
call draw_all_bricks
.endif
.endif



jmp end1



end1:
pop dx
pop cx
pop bx
pop ax

ret
brick1_collison endp


brick2_collision proc


push ax
push bx
push cx
push dx

.if(brick2_color == 0)

jmp end2
.endif

mov ax,brick2_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick2_y
mov dx, cx
sub cx,size_ball

add dx,brick_height


.if(level_counter == 1)
	.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
	neg ball_speed_y
	mov brick2_color, 00h
	push ax
	mov ax, score_brick2
	add score,ax
	pop ax
	call draw_all_bricks
	.endif
.endif


mov ax,brick2_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick2_y
mov dx, cx
sub cx,size_ball

add dx,brick_height


.if(level_counter == 2)
.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
neg ball_speed_y
inc level_2_collision_arr[2]
.if(level_2_collision_arr[2] >= 2)
	push ax
	mov ax, score_brick2
	add score,ax
	pop ax

mov brick2_color , 00h
.endif
call draw_all_bricks
.endif
.endif


mov ax,brick2_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick2_y
mov dx, cx
sub cx,size_ball

add dx,brick_height


.if(level_counter == 3)

.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
neg ball_speed_y
call draw_all_bricks
.endif

.endif





jmp end2



end2:
pop dx
pop cx
pop bx
pop ax

ret
brick2_collision endp


brick3_collision proc

push ax
push bx
push cx
push dx

.if(brick3_color == 0)

jmp end3
.endif

mov ax,brick3_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick3_y
mov dx, cx
sub cx,size_ball

add dx,brick_height


.if(level_counter == 1)
	.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
	neg ball_speed_y
	mov brick3_color, 00h
	push ax
	mov ax, score_brick3
	add score,ax
	pop ax
	call draw_all_bricks
	.endif
.endif


mov ax,brick3_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick3_y
mov dx, cx
sub cx,size_ball

add dx,brick_height


.if(level_counter == 2)
.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
neg ball_speed_y
inc level_2_collision_arr[3]
.if(level_2_collision_arr[3] >= 2)
	push ax
	mov ax, score_brick3
	add score,ax
	pop ax

mov brick3_color , 00h
.endif
call draw_all_bricks
.endif
.endif

mov ax,brick3_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick3_y
mov dx, cx
sub cx,size_ball

add dx,brick_height


.if(level_counter == 3)

.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
neg ball_speed_y
inc level_3_collision_arr[3]
.if(level_3_collision_arr[3] >= 3)
	push ax
	mov ax, score_brick3
	add score,ax
	pop ax

mov brick3_color , 00h
.endif
call draw_all_bricks
.endif
.endif




jmp end3



end3:
pop dx
pop cx
pop bx
pop ax

ret
brick3_collision endp

brick4_collision proc

push ax
push bx
push cx
push dx

.if(brick4_color == 0)

jmp end4
.endif

mov ax,brick4_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick4_y
mov dx, cx
sub cx,size_ball

add dx,brick_height


.if(level_counter == 1)
	.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
	neg ball_speed_y
	mov brick4_color, 00h
	push ax
	mov ax, score_brick1
	add score,ax
	pop ax
	call draw_all_bricks
	.endif
.endif


mov ax,brick4_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick4_y
mov dx, cx
sub cx,size_ball

add dx,brick_height


.if(level_counter == 2)
.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
neg ball_speed_y
inc level_2_collision_arr[4]
.if(level_2_collision_arr[4] >= 2)
	push ax
	mov ax, score_brick1
	add score,ax
	pop ax

mov brick4_color , 00h
.endif
call draw_all_bricks
.endif
.endif

mov ax,brick4_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick4_y
mov dx, cx
sub cx,size_ball

add dx,brick_height



.if(level_counter == 3)

.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
neg ball_speed_y
inc level_3_collision_arr[4]
.if(level_3_collision_arr[4] >= 3)
	push ax
	mov ax, score_brick1
	add score,ax
	pop ax

mov brick4_color , 00h
.endif
call draw_all_bricks
.endif
.endif




jmp end4



end4:
pop dx
pop cx
pop bx
pop ax

ret
brick4_collision endp


brick5_collision proc

push ax
push bx
push cx
push dx

.if(brick5_color == 0)

jmp end5
.endif

mov ax,brick5_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick5_y
mov dx, cx
sub cx,size_ball

add dx,brick_height


.if(level_counter == 1)
	.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
	neg ball_speed_y
	mov brick5_color, 00h
	push ax
	mov ax, score_brick2
	add score,ax
	pop ax
	call draw_all_bricks
	.endif
.endif


mov ax,brick5_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick5_y
mov dx, cx
sub cx,size_ball

add dx,brick_height


.if(level_counter == 2)
.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
neg ball_speed_y
inc level_2_collision_arr[5]
.if(level_2_collision_arr[5] >= 2)
	push ax
	mov ax, score_brick2
	add score,ax
	pop ax

mov brick5_color , 00h
.endif
call draw_all_bricks
.endif
.endif


mov ax,brick5_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick5_y
mov dx, cx
sub cx,size_ball

add dx,brick_height


.if(level_counter == 3)
.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
neg ball_speed_y
call draw_all_bricks
.endif
.endif


jmp end5


end5:
pop dx
pop cx
pop bx
pop ax

ret
brick5_collision endp


brick6_collision proc

push ax
push bx
push cx
push dx

.if(brick6_color == 0)

jmp end6
.endif

mov ax,brick6_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick6_y
mov dx, cx
sub cx,size_ball

add dx,brick_height


.if(level_counter == 1)
	.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
	neg ball_speed_y
	mov brick6_color, 00h
	push ax
	mov ax, score_brick3
	add score,ax
	pop ax
	call draw_all_bricks
	.endif
.endif


mov ax,brick6_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick6_y
mov dx, cx
sub cx,size_ball

add dx,brick_height


.if(level_counter == 2)
.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
neg ball_speed_y
inc level_2_collision_arr[6]
.if(level_2_collision_arr[6] >= 2)
	push ax
	mov ax, score_brick3
	add score,ax
	pop ax

mov brick6_color , 00h
.endif
call draw_all_bricks
.endif
.endif

mov ax,brick6_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick6_y
mov dx, cx
sub cx,size_ball

add dx,brick_height




.if(level_counter == 3)

.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
neg ball_speed_y
inc level_3_collision_arr[6]
.if(level_3_collision_arr[6] >= 3)
	push ax
	mov ax, score_brick3
	add score,ax
	pop ax

mov brick6_color , 00h
.endif
call draw_all_bricks
.endif
.endif




jmp end6



end6:
pop dx
pop cx
pop bx
pop ax

ret
brick6_collision endp

brick7_collision proc
push ax
push bx
push cx
push dx

.if(brick7_color == 0)

jmp end7
.endif

mov ax,brick7_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick7_y
mov dx, cx
sub cx,size_ball

add dx,brick_height


.if(level_counter == 1)
	.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
	neg ball_speed_y
	mov brick7_color, 00h
	push ax
	mov ax, score_brick1
	add score,ax
	pop ax
	call draw_all_bricks
	.endif
.endif


mov ax,brick7_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick7_y
mov dx, cx
sub cx,size_ball

add dx,brick_height


.if(level_counter == 2)
.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
neg ball_speed_y
inc level_2_collision_arr[7]
.if(level_2_collision_arr[7] >= 2)
	push ax
	mov ax, score_brick1
	add score,ax
	pop ax

mov brick7_color , 00h
.endif
call draw_all_bricks
.endif
.endif

mov ax,brick7_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick7_y
mov dx, cx
sub cx,size_ball

add dx,brick_height


.if(level_counter == 3)

.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
neg ball_speed_y
inc level_3_collision_arr[7]
.if(level_3_collision_arr[7] >= 3)
	push ax
	mov ax, score_brick1
	add score,ax
	pop ax


mov brick8_color,00h
mov brick9_color,00h
mov brick10_color,00h
mov brick11_color,00h
mov brick12_color,00h
mov brick7_color , 00h

mov ax, score_brick2
add score, ax
add score, ax

mov ax, score_brick3
add score, ax
add score, ax



.endif
call draw_all_bricks
.endif
.endif




jmp end7



end7:
pop dx
pop cx
pop bx
pop ax

ret


brick7_collision endp

brick8_collision proc

push ax
push bx
push cx
push dx

.if(brick8_color == 0)

jmp end8
.endif

mov ax,brick8_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick8_y
mov dx, cx
sub cx,size_ball

add dx,brick_height


.if(level_counter == 1)
	.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
	neg ball_speed_y
	mov brick8_color, 00h
	push ax
	mov ax, score_brick2
	add score,ax
	pop ax
	call draw_all_bricks
	.endif
.endif


mov ax,brick8_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick8_y
mov dx, cx
sub cx,size_ball

add dx,brick_height


.if(level_counter == 2)
.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
neg ball_speed_y
inc level_2_collision_arr[8]
.if(level_2_collision_arr[8] >= 2)
	push ax
	mov ax, score_brick2
	add score,ax
	pop ax

mov brick8_color , 00h
.endif
call draw_all_bricks
.endif
.endif


.if(level_counter == 3)

.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
neg ball_speed_y
inc level_3_collision_arr[8]
.if(level_3_collision_arr[8] >= 3)
	push ax
	mov ax, score_brick2
	add score,ax
	pop ax

mov brick8_color , 00h
.endif
call draw_all_bricks
.endif
.endif





jmp end8



end8:
pop dx
pop cx
pop bx
pop ax

ret


brick8_collision endp

brick9_collision proc
push ax
push bx
push cx
push dx

.if(brick9_color == 0)

jmp end9
.endif

mov ax,brick9_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick9_y
mov dx, cx
sub cx,size_ball

add dx,brick_height


.if(level_counter == 1)
	.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
	neg ball_speed_y
	mov brick9_color, 00h
	push ax
	mov ax, score_brick3
	add score,ax
	pop ax
	call draw_all_bricks
	.endif
.endif


mov ax,brick9_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick9_y
mov dx, cx
sub cx,size_ball

add dx,brick_height


.if(level_counter == 2)
.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
neg ball_speed_y
inc level_2_collision_arr[9]
.if(level_2_collision_arr[9] >= 2)
	push ax
	mov ax, score_brick3
	add score,ax
	pop ax

mov brick9_color , 00h
.endif
call draw_all_bricks
.endif
.endif

mov ax,brick9_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick9_y
mov dx, cx
sub cx,size_ball

add dx,brick_height


.if(level_counter == 3)

.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
neg ball_speed_y
inc level_3_collision_arr[9]
.if(level_3_collision_arr[9] >= 3)
	push ax
	mov ax, score_brick3
	add score,ax
	pop ax

mov brick9_color , 00h
.endif
call draw_all_bricks
.endif
.endif




jmp end9



end9:
pop dx
pop cx
pop bx
pop ax

ret

brick9_collision endp

brick10_collision proc


push ax
push bx
push cx
push dx

.if(brick10_color == 0)

jmp end10
.endif

mov ax,brick10_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick10_y
mov dx, cx
sub cx,size_ball

add dx,brick_height


.if(level_counter == 1)
	.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
	neg ball_speed_y
	mov brick10_color, 00h
	push ax
	mov ax, score_brick1
	add score,ax
	pop ax
	call draw_all_bricks
	.endif
.endif


mov ax,brick10_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick10_y
mov dx, cx
sub cx,size_ball

add dx,brick_height


.if(level_counter == 2)
.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
neg ball_speed_y
inc level_2_collision_arr[10]
.if(level_2_collision_arr[10] >= 2)
	push ax
	mov ax, score_brick1
	add score,ax
	pop ax

mov brick10_color , 00h
.endif
call draw_all_bricks
.endif
.endif

mov ax,brick10_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick10_y
mov dx, cx
sub cx,size_ball

add dx,brick_height


.if(level_counter == 3)

.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
neg ball_speed_y
inc level_3_collision_arr[10]
.if(level_3_collision_arr[10] >= 3)
	push ax
	mov ax, score_brick1
	add score,ax
	pop ax

mov brick10_color , 00h
.endif
call draw_all_bricks
.endif
.endif






jmp end10



end10:
pop dx
pop cx
pop bx
pop ax

ret
brick10_collision endp


brick11_collision proc
push ax
push bx
push cx
push dx

.if(brick11_color == 0)

jmp end11
.endif

mov ax,brick11_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick11_y
mov dx, cx
sub cx,size_ball

add dx,brick_height


.if(level_counter == 1)
	.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
	neg ball_speed_y
	mov brick11_color, 00h
	push ax
	mov ax, score_brick2
	add score,ax
	pop ax
	call draw_all_bricks
	.endif
.endif


mov ax,brick11_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick11_y
mov dx, cx
sub cx,size_ball

add dx,brick_height


.if(level_counter == 2)
.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
neg ball_speed_y
inc level_2_collision_arr[11]
.if(level_2_collision_arr[11] >= 2)
	push ax
	mov ax, score_brick2
	add score,ax
	pop ax

mov brick11_color , 00h
.endif
call draw_all_bricks
.endif
.endif

mov ax,brick11_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick11_y
mov dx, cx
sub cx,size_ball

add dx,brick_height




.if(level_counter == 3)

.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
neg ball_speed_y
inc level_3_collision_arr[11]
.if(level_3_collision_arr[11] >= 3)
	push ax
	mov ax, score_brick2
	add score,ax
	pop ax

mov brick11_color , 00h
.endif
call draw_all_bricks
.endif
.endif




jmp end11



end11:
pop dx
pop cx
pop bx
pop ax

ret

brick11_collision endp

brick12_collision proc

push ax
push bx
push cx
push dx

.if(brick12_color == 0)

jmp end12
.endif

mov ax,brick12_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick12_y
mov dx, cx
sub cx,size_ball

add dx,brick_height


.if(level_counter == 1)
	.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
	neg ball_speed_y
	mov brick12_color, 00h
	push ax
	mov ax, score_brick3
	add score,ax
	pop ax
	call draw_all_bricks
	.endif
.endif


mov ax,brick12_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick12_y
mov dx, cx
sub cx,size_ball

add dx,brick_height


.if(level_counter == 2)
.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
neg ball_speed_y
inc level_2_collision_arr[12]
.if(level_2_collision_arr[12] >= 2)
	push ax
	mov ax, score_brick3
	add score,ax
	pop ax

mov brick12_color , 00h
.endif
call draw_all_bricks
.endif
.endif

mov ax,brick12_x
mov bx,ax
sub ax,size_ball
add bx,brick_length
mov cx,brick12_y
mov dx, cx
sub cx,size_ball

add dx,brick_height


.if(level_counter == 3)

.if(x_axis_ball> ax && x_axis_ball < bx && y_axis_ball <dx &&  y_axis_ball > cx)
neg ball_speed_y
inc level_3_collision_arr[12]
.if(level_3_collision_arr[12] >= 3)
	push ax
	mov ax, score_brick3
	add score,ax
	pop ax

mov brick12_color , 00h
.endif
call draw_all_bricks
.endif
.endif



jmp end12



end12:
pop dx
pop cx
pop bx
pop ax

ret


brick12_collision endp


reset proc 

push ax

mov x_axis_ball , 200
mov ax,upper_bound
add ax,size_ball
mov y_axis_ball , ax 

pop ax

ret
reset endp


move_paddle proc
	
	mov ah,01h
	int 16h
	jnz check_paddle_move 
	jmp retur

	
	check_paddle_move:
	mov ah,00h
	int 16h

	cmp al,27
	je finish_game

	cmp ah,4Bh
	je left


	cmp ah,4Dh
	je right
	jmp retur

	left:
	mov ax, paddle_speed
	sub paddle_x, ax
	call remove_left_side

	mov bx , left_bound
	.if(paddle_x < bx)
	mov paddle_x,bx
	
	.endif

	jmp retur

	right:
	mov ax, paddle_speed
	add paddle_x, ax
	
	call remove_right_side
	mov bx, right_bound
	sub bx,paddle_length
	.if(paddle_x > bx)
	mov paddle_x , bx
	.endif

retur:
ret 
move_paddle endp

remove_left_side proc

push ax
push bx
push cx
push dx

mov cx,paddle_x
add cx,paddle_length
mov dx,paddle_y
mov ax,cx
add ax,paddle_speed
mov bx, paddle_y
add bx,paddle_height


.while(cx <= ax)

	.while(dx <= bx)

	push ax
	push bx
	
	mov ah, 0ch ; pixel write
	mov al , 00h ; setting black color
	mov bh,00h
	int 10h

	pop bx    ; preserves ax and bx values 
	pop ax

	inc dx
	.endw
inc cx 
mov dx,paddle_y

.endw


pop dx
pop cx
pop bx
pop ax


ret 
remove_left_side endp

remove_right_side proc


push ax
push bx
push cx
push dx

mov cx,paddle_x
sub cx,paddle_speed
mov ax,paddle_x



mov dx,paddle_y
mov bx, paddle_y
add bx,paddle_height


.while(cx <= ax)

	.while(dx <= bx)

	push ax
	push bx
	
	mov ah, 0ch ; pixel write
	mov al , 00h ; setting black color
	mov bh,00h
	int 10h

	pop bx    ; preserves ax and bx values 
	pop ax

	inc dx
	.endw
inc cx 
mov dx,paddle_y

.endw


pop dx
pop cx
pop bx
pop ax




ret
remove_right_side endp



draw_all_bricks proc ;draws all bricks by calling small functions 

	
	mov cx , brick1_x
	mov dx , brick1_y
	mov al,brick1_color
	call draw_small_brick

	mov cx , brick2_x
	mov dx , brick2_y
	mov al,brick2_color
	call draw_small_brick

	mov cx , brick3_x
	mov dx , brick3_y
	mov al,brick3_color
	call draw_small_brick

	mov cx , brick4_x
	mov dx , brick4_y
	mov al,brick4_color
	call draw_small_brick

	mov cx , brick5_x
	mov dx , brick5_y
	mov al,brick5_color
	call draw_small_brick

	mov cx , brick6_x
	mov dx , brick6_y
	mov al,brick6_color
	call draw_small_brick

	mov cx , brick7_x
	mov dx , brick7_y
	mov al,brick7_color
	call draw_small_brick

	mov cx , brick8_x
	mov dx , brick8_y
	mov al,brick8_color
	call draw_small_brick

	mov cx , brick9_x
	mov dx , brick9_y
	mov al,brick9_color
	call draw_small_brick

	mov cx , brick10_x
	mov dx , brick10_y
	mov al,brick10_color
	call draw_small_brick

	mov cx , brick11_x
	mov dx , brick11_y
	mov al,brick11_color
	call draw_small_brick

	mov cx , brick12_x
	mov dx , brick12_y
	mov al,brick12_color
	call draw_small_brick

	


ret
draw_all_bricks endp


draw_small_brick proc

	mov temp_color,al
	
	mov bx ,0
	mov ax, 0

	.while(ax<=brick_length)
		
		push dx
		.while(bx<=brick_height)

		push ax
		push bx

		mov ah, 0ch ; pixel write
		mov al , temp_color ; setting color yellow
		mov bh,00h
		int 10h

		pop bx
		pop ax
		inc dx
		inc bx
		.endw
		inc ax
		mov bx,0
		pop dx
		inc cx
	.endw

ret
draw_small_brick endp


draw_paddle proc

mov cx,paddle_x
mov dx,paddle_y
mov ax, paddle_x

add ax,paddle_length

mov bx, paddle_y
add bx,paddle_height



.while(cx < ax)

	.while(dx < bx)

	push ax
	push bx
	
	mov ah, 0ch ; pixel write
	mov al , 0dh ; setting color
	mov bh,00h
	int 10h

	pop bx    ; preserves ax and bx values 
	pop ax

	inc dx
	.endw
inc cx 
mov dx,paddle_y

.endw


ret
draw_paddle endp

draw_horizontal proc

	mov retrieve, 0

	.while(retrieve<10)
	mov temp,320
	mov temp2,0

check1:


	mov cx,temp2
	inc temp2

	mov ah,0ch
	mov al,14
	mov bh,0
	mov dx, temp3

	int 10h


	mov cx,temp
	dec temp 


	loop check1
	inc temp3
	inc retrieve
.endw

ret
draw_horizontal endp

draw_boundary proc
mov initial_bound_x, 20
mov initial_bound_y,20
mov final_bound_x , 300
mov final_bound_y, 20

draw_boundary_x

mov final_bound_x, 20
mov final_bound_y, 200
mov initial_bound_y,20
mov initial_bound_x,20

draw_boundary_y

mov initial_bound_x,300
mov final_bound_x,300
mov initial_bound_y,20
mov final_bound_y,200


draw_boundary_y

ret
draw_boundary endp


move_b proc

	
	mov ax , ball_speed_x
	add x_axis_ball ,ax
	mov ax, x_axis_ball
	mov bx,x_axis_ball   
	add bx,size_ball        ; compensates for the edges
	sub ax,size_ball		; compensates for the edges

	.if(ax < left_bound  || bx > right_bound )
	neg ball_speed_x  ;changes direction if encountered with a boundary 
	.endif



	mov ax,ball_speed_y
	add y_axis_ball , ax                    ;upadting ball corordinates
	mov bx,y_axis_ball					
	add bx,size_ball
	mov ax,y_axis_ball
	sub ax,size_ball

	.if(ax < upper_bound)
	neg ball_speed_y
	.endif
	
	mov bx,y_axis_ball      
	.if(bx > lower_bound)          ; decreases lives
	dec lives
	clr                           ;cleares whole screen
	call draw_all_bricks
	call reset
	.if(lives <=0)
	jmp finish_game
	.endif
	.endif
ret
move_b endp




draw_ball proc

	mov cx,x_axis_ball
	mov dx, y_axis_ball
	mov check_ball , 0

	mov prev_ball_x,cx
	mov prev_ball_y,dx

inside:

	mov ah, 0ch ; pixel write
	mov al , 0fh ; setting color
	mov bh,00h
	int 10h
	inc cx
	mov ax,cx

	sub ax,x_axis_ball
	cmp ax,size_ball
	je outside
	jmp inside



outside:
	inc check_ball
	mov ax,size_ball
	inc dx                ;y-axis icreased
	mov cx, x_axis_ball
	cmp check_ball,ax
	jge outside2
	jmp inside

outside2:


ret
draw_ball endp

remove_trace proc


	mov cx,prev_ball_x
	mov dx, prev_ball_y
	mov check_ball , 0

inside_1:

	mov ah, 0ch ; pixel write
	mov al , 00h ; setting black color
	mov bh,00h   ;page number
	int 10h      ; draws a pixel
	inc cx
	mov ax,cx

	sub ax,prev_ball_x
	cmp ax,size_ball
	je outside_1
	jmp inside_1



outside_1:
	inc check_ball
	mov ax,size_ball
	inc dx                ;y-axis icreased
	mov cx, prev_ball_x
	cmp check_ball,ax
	jge outside_3
	jmp inside_1

outside_3:



ret
remove_trace endp

start_screen proc

;set cursor_psotion

	mov ah,02h    ;cursor positon
	mov bh,00h    ;page
	mov dh, 9h	  ;column
	mov dl, 9h	  ;rows
	int 10h

	mov ah,09h   ;displays string
	lea dx, text_enter_name  ;string pointer
	int 21h

	mov ah,02h    ;cursor positon
	mov bh,00h    ;page
	mov dh, 10h	  ;column
	mov dl, 10h	  ;rows
	int 10h



ret
start_screen endp


end