stacks segment stack
   db 128 dup ('?')
stacks ends
 
data segment
    v1      db  0,0,0,0,0                            ; number1
    v2      db  0,0,0,0,0                            ; number2
    ans1    db  0,0,0,0,0,0,0,0,0,0                  ; answer
    c       db  0                                    ; cary for any levevl
    msgv1   db  'enter number 1 :',10,13,'$'
    msgv2   db  10,13,'enter number 2 :',10,13,'$'
    msgrs   db  10,13,'result :   $'
    
data ends

code segment                      
    main  proc far
    assume      ds:data,cs:code,ss:stacks
    mov ax,data
    mov ds,ax 
    
    mov ah,09h
    mov dx,offset msgv1
    int 21h
    
    mov si,0                     ;counter
    in1:                         ;give a number1
    mov ah,01h
    int 21h  
    sub al,48                    ;????????
    mov v1[si],al
    inc si
    cmp si,5
    jne in1
    
    mov ah,09h                   
    mov dx,offset msgv2
    int 21h
    
    mov si,0                     ;counter
    in2:                         ;give a number2
    mov ah,01h
    int 21h  
    sub al,48
    mov v2[si],al
    inc si
    cmp si,5
    jne in2
    
    mov si,4                     ;index of number2 (0-4)
    mov bp,9                     ;index of answer
    mult1:                       
        mov al,v2[si]            ;Get each digit from number2               
        mov dl,al                ;save al to dl
        mov di,4                 ;index of number1
        mult2:                   ;mult in all digit from number1
            mov bl,v1[di]
            mov al,dl            
            mul bl               ;al * bl               
            add al,c
            aam
           ; cmp al,10
           ; jl notcary
           ; mov al,0
           ; inc ah 
       ; notcary:    
            mov c,ah            ;ferestadan dhagan be cary
            mov cx,si           ;save counter si in cx
            mov si,bp           
            ;mov ah,0
            cmp di,0            ;if di ==0   =>   baray har raghm az num2 dar akharin marhale zarb hastim
            jne nf_step         ;dar marhale akhar dahgan be cary nmiravad v dar answer neveshte mishavad
            mov ans1[si-1],ah
            nf_step:
            add al,ans1[si]
            aam
            cmp ah,0
            je continue
            add ans1[si-1],ah
            ;mov ans1[si],al
            ;mov ah,0
            continue:
            mov ans1[si],al
            dec bp              ;kaheshe shomarande answer
            mov si,cx           ;bargardandane si az cx 
            dec di
            cmp di,-1           ; if di == -1   => argham num1 be payan reside
        jne mult2
        mov al,0
        mov c ,0
           
        add bp,4                ;baray har marhale yek 0 dar nazar migirim leza be jay 5 ta 4 ta be index answer add mikonim
        dec si                  ;ragham baadi az num2
        cmp si,-1               ;if si == -1   => num2 be payan reside
        jne mult1                     
        
        mov ah,09h              ;print for result msg
        mov dx,offset msgrs
        int 21h
        
        mov si,0                 
        print:                  ;print for result value
        mov ah , 02h
        mov dl, ans1[si]
        add dl,30h
        int 21h
        inc si
        cmp si,10
        jne print    
    main endp    
code ends
    end main