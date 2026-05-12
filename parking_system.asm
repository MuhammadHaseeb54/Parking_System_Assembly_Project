org 100h

jmp start

; ---------------- DATA ----------------

menu db '**************** MENU ****************',13,10,'$'
menu1 db 'Press 1 for rikshaw',13,10,'$'
menu2 db 'Press 2 for cars',13,10,'$'
menu3 db 'Press 3 for bus',13,10,'$'
menu4 db 'Press 4 to show record',13,10,'$'
menu5 db 'Press 5 to delete LAST record',13,10,'$'
menu6 db 'Press 6 to exit',13,10,'$'

msg1 db 13,10,'Parking Is Full','$'
msg2 db 13,10,'Wrong Input','$'
msg3 db 13,10,'No Record Found','$'

msg7 db 13,10,'Total Amount = ','$'
msg8 db 13,10,'Total Vehicles = ','$'
msg9 db 13,10,'Rikshaws = ','$'
msg10 db 13,10,'Cars = ','$'
msg11 db 13,10,'Buses = ','$'

msg12 db 13,10,'Last Record Deleted','$'

amount dw 0
count db 0

r db 0
c db 0
b db 0

stack db 0,0,0,0,0,0,0,0
top db 0

; ---------------- CODE ----------------
start:
main_loop:

mov dx,menu
mov ah,09h
int 21h

mov dx,menu1
mov ah,09h
int 21h

mov dx,menu2
mov ah,09h
int 21h

mov dx,menu3
mov ah,09h
int 21h

mov dx,menu4
mov ah,09h
int 21h
mov dx,menu5
mov ah,09h
int 21h

mov dx,menu6
mov ah,09h
int 21h

; -------- INPUT --------

mov ah,01h
int 21h
mov bl,al

cmp bl,'1'
jne check2
jmp rikshaw

check2:
cmp bl,'2'
jne check3
jmp car

check3:
cmp bl,'3'
jne check4
jmp bus

check4:
cmp bl,'4'
jne check5
jmp record

check5:
cmp bl,'5'
jne check6
jmp delete_record

check6:
cmp bl,'6'
jne wrong_input
jmp exit_program

; -------- WRONG INPUT --------

wrong_input:

mov dx,msg2
mov ah,09h
int 21h

jmp main_loop

; -------- RIKSHAW --------

rikshaw:

cmp byte [count],8
jae full

add word [amount],200

inc byte [count]
inc byte [r]

mov si,0
mov al,[top]
mov ah,0
mov si,ax

mov byte [stack+si],1

inc byte [top]

jmp main_loop

; -------- CAR --------

car:

cmp byte [count],8
jae full

add word [amount],300

inc byte [count]
inc byte [c]

mov si,0
mov al,[top]
mov ah,0
mov si,ax

mov byte [stack+si],2

inc byte [top]

jmp main_loop

; -------- BUS --------

bus:

cmp byte [count],8
jae full

add word [amount],400

inc byte [count]
inc byte [b]

mov si,0
mov al,[top]
mov ah,0
mov si,ax

mov byte [stack+si],3

inc byte [top]

jmp main_loop

; -------- FULL --------

full:

mov dx,msg1
mov ah,09h
int 21h

jmp main_loop

; -------- RECORD --------
record:
mov dx,msg7
mov ah,09h
int 21h
mov ax,[amount]
call print_num

call newline

mov dx,msg8
mov ah,09h
int 21h
mov al,[count]
call print_digit

call newline

mov dx,msg9
mov ah,09h
int 21h
mov al,[r]
call print_digit

call newline

mov dx,msg10
mov ah,09h
int 21h
mov al,[c]
call print_digit

call newline

mov dx,msg11
mov ah,09h
int 21h

mov al,[b]
call print_digit
call newline

jmp main_loop

; -------- DELETE LAST RECORD --------

delete_record:

cmp byte [top],0
je no_record

dec byte [top]

mov si,0
mov al,[top]
mov ah,0
mov si,ax

mov al,[stack+si]

cmp al,1
je remove_rikshaw

cmp al,2
je remove_car

cmp al,3
je remove_bus

jmp main_loop

; -------- REMOVE RIKSHAW --------

remove_rikshaw:

sub word [amount],200

dec byte [count]
dec byte [r]

jmp deleted

; -------- REMOVE CAR --------

remove_car:

sub word [amount],300

dec byte [count]
dec byte [c]

jmp deleted

; -------- REMOVE BUS --------

remove_bus:

sub word [amount],400

dec byte [count]
dec byte [b]

jmp deleted

; -------- DELETED --------

deleted:

mov dx,msg12
mov ah,09h
int 21h

jmp main_loop

; -------- NO RECORD --------

no_record:

mov dx,msg3
mov ah,09h
int 21h

jmp main_loop

; -------- EXIT --------

exit_program:

mov ah,4Ch
int 21h

; -------- PRINT NUMBER --------

print_num:
push ax
push bx
push cx
push dx

cmp ax,0
jne convert

mov dl,'0'
mov ah,02h
int 21h
jmp done_print

convert:
mov bx,10
mov cx,0

divide:
mov dx,0
div bx

push dx
inc cx

cmp ax,0
jne divide

display:
pop dx
add dl,'0'
mov ah,02h
int 21h

loop display

done_print:

pop dx
pop cx
pop bx
pop ax

ret

; -------- PRINT DIGIT --------

print_digit:

push ax
push dx

add al,'0'

mov dl,al
mov ah,02h
int 21h

pop dx
pop ax

ret

; -------- NEWLINE --------

newline:

mov dl,13
mov ah,02h
int 21h

mov dl,10
mov ah,02h
int 21h

ret