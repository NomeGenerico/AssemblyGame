jmp main

posPlayer: var#1
prevposPlayer: var#1
originalposPlayer: var#1
playerMoveDirection: var#1

posBox: var#1
prevposBox: var#1

stagetopology: var#1
CurentStage:  
CurentTopology:


lineone: string`Aaaaaaaaaaa` ; not used yet, just a syntax test

main:

	;SetUp
	loadn r0, #38
	store posPlayer, r0

	
	mainLoop:
	
	
	;Movement
	call movePlayer

	call checkPushMovement
	
	;RenderLoop:
	call render

	jmp mainLoop


movePlayer:
	
	push r0
	push r1
	push r2
	push r3


	load r0, posPlayer
	store originalposPlayer, r0
	mov r1, r0
	store prevposPlayer, r1
	inchar r3

	; r0 posPlayer
	; r1 prevposPlayer
	; r2 localHelper
	; r3 inchar


	;if a
		loadn r2, 'a' 
		cmp r3, r2
		jeq mvleft
	
	;if d
		loadn r2, 'd' 
		cmp r3, r2
		jeq mvright

	;if w
		loadn r2, 'w' 
		cmp r3, r2
		jeq mvup

	;if s
		loadn r2, 's' 
		cmp r3, r2
		jeq mvdown

	;else
		jmp endMovePlayer

	mvleft:
		loadn r2, #1
		sub r0, r0, r2

		loadn r2, #3
		store moveDirection, r2
		
		jmp callMovementTopologyPlayer

	mvright:
		loadn r2, #1
		add r0, r0, r2

		store moveDirection, r2
		
		jmp callMovementTopologyPlayer

	mvup:
		loadn r2, #40
		sub r0, r0, r2

		loadn r2, #2
		store moveDirection, r2

		jmp callMovementTopologyPlayer
	
	mvdown:
		loadn r2, #40
		add r0, r0, r2

		loadn r2, #4
		store moveDirection, r2

		jmp callMovementTopologyPlayer


	callMovementTopologyPlayer:		
	call mvTopology

	endMovePlayer:
	store posPlayer, r0 

	pop r3
	pop r2
	pop r1
	pop r0
	RTS

checkPushMovement:
	

	push r0
	push r1
	push r2
	push r3


	load r0, posPlayer
	load r1, posBox
	load r2, playerMoveDirection

	; if player position == box position, push box
	cmp r0, r1
	jne skip
	
	;if 1
		loadn r2, 'a' 
		cmp r3, r2
		jeq mvleft
	
	;if 2
		loadn r2, 'd' 
		cmp r3, r2
		jeq mvright

	;if 3
		loadn r2, 'w' 
		cmp r3, r2
		jeq mvup

	;if 4
		loadn r2, 's' 
		cmp r3, r2
		jeq mvdown






	skip:










	pop r3
	pop r2
	pop r1
	pop r0





mvTopology:
		
		; This function with on r0 and r1 as inputs
		; and returns the value on r0.

		; it takes a movement, and makes it within the topological constraint

		;todo: Make it take a variable to chose which topology to solve for	

		;refactor code to make it elagent and good, this is trash	
		
		
		push r1
		push r2
		push r3
		push r4
		push r5
		push r6
		push r7
		

			
		; r0 = pos
		; r1, prevpos
		loadn r2, #40 ;local helper / Screen Size
		; r3, local helper 2
		; r4, local helper 3
		; r5, local helper 4
		; r6, local helper 5
	
		;torus
			
			; tries for horizontal wrap
			mod r4, r1, r2 ; The colum of the previous position
			mod r3, r0, r2 ; The colum of the new position
				
			add r5, r3, r4 ; if 39, we have a horizontal wrap around candidate	

			dec r2		; r2 40 -> 39
			cmp r5, r2	;checks if sum is 39,	
			inc r2  	  ;39 to 40	   	
			jne verticalTorusWrap  ; if it is not 39, skips to vertical check

			horizontaltoruswrap:
			loadn r5, #0
			;if r3 = 0     colum 39 -> 0
				cmp r3, r5
				jne horizontaltoruswrap2

				; move up  
				loadn r6, #9
				sub r0, r0, r2  ; subs 40 from new position   					

				jmp endmvTopoplogy

			horizontaltoruswrap2:
				
			;if r3 = 39     colum 0 -> 39
				loadn r5, #39	
				cmp r3, r5; 
				jne verticalTorusWrap
					
				loadn r6, #5   ; debug
				add r0, r0, r2		; correct line + 40 move down

				jmp endmvTopoplogy

			verticalTorusWrap:

			div r3, r0, r2 ; The row of the new position r2 = 40
				
			; if r3 = 30
			loadn r2, #30  ; number of rows
			cmp r3, r2
			jne verticalTorusWrap2
				
				loadn r4, #1200
				sub r0, r0, r4

				jmp endmvTopoplogy
		
			;else
			
			verticalTorusWrap2:

			; if r3 = 1637
			loadn r2, #1630
			
			mov r6, r2		
			mov r7, r3

			cmp r2, r3
			jeg endmvTopoplogy
				
				
				loadn r4, #1200
				add r0, r0, r4

				jmp endmvTopoplogy
			; vertical logic, todo:
			
		

		endmvTopoplogy:
	
		pop r7
		pop r6
		pop r5
		pop r4
		pop r3
		pop r2
		pop r1
		

		rts


render:
	;Prologue
	push r0
	push r1
	push r2

	;render stage






	;render props

	load r2, prevposBox
	load r0, posBox
		
	loadn r1, '@'
	loadn r2, #768
	add r1, r1,r2 
	outchar r1, r0
	
	renderCleanBoxSkip:




	;Render Player

	load r2, prevposPlayer
	load r0, posPlayer
	
	cmp r0, r2
	jeq renderSkipPrevPosClear	

	loadn r1, ' '
	outchar r1, r2
	renderSkipPrevPosClear:
		
	loadn r1, 'A'
	loadn r2, #768
	add r1, r1,r2 
	outchar r1, r0
	
	renderCleanPlayerSkip:


	; todo create a help menu that shows the topology of the stage

	; todo, create a interactive main menu, in which you can chose a level by stading on a tile
	; menu animations
	; esc animation	
	
	;Epilogue
	
	pop r2
	pop r1
	pop r0
	
	rts


ImprimeStr:
	push r0
	push r1
	push r2
	push r3
	push r4
	
	loadn r3, #'\0'

	ImprimeStr_Loop:
		loadi r4, r1          ; Carrega no r4 o caractere apontado por r1
		cmp r4, r3            ; Compara o caractere atual com '\0'
		jeq ImprimeStr_Sai    ; Se for igual a '\0', salta para ImprimeStr_Sai, encerrando a impressão.
		
		add r4, r2, r4        ; Soma r2 ao valor do caractere. 
		
		outchar r4, r0         ; Imprime o caractere (r4) na posição de tela (r0).
		inc r0                 ; Incrementa a posição na tela para o próximo caractere.
		inc r1                 ; Incrementa o ponteiro da string para o próximo caractere.
		jmp ImprimeStr_Loop    ; Volta ao início do loop para continuar imprimindo.

   ImprimeStr_Sai:	
	pop r4	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r3
	pop r2
	pop r1
	pop r0
	rts
