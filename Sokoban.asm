jmp main

posPlayer: var#1
prevposPlayer: var#1
originalposPlayer: var#1
stagetopology: var#1

main:

	;SetUp
	loadn r0, #38
	store posPlayer, r0


	
	mainLoop:
	
	
	;Movement
	call movePlayer
	
	
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
		jmp mvTopology

	mvright:
		loadn r2, #1
		add r0, r0, r2
		jmp mvTopology

	mvup:
		loadn r2, #40
		sub r0, r0, r2
		jmp mvTopology
	
	mvdown:
		loadn r2, #40
		add r0, r0, r2
		jmp mvTopology

	mvTopology:

		; r0 = posPlayer
		; r1, prevposPlayer
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

	;todo, other movement like pushing boxes etc. 
	;might need to make the topology check a function

	endMovePlayer:
	store posPlayer, r0 
	

	pop r3
	pop r2
	pop r1
	pop r0
	RTS




render:
	;Prologue
	push r0
	push r1
	push r2
	
	;Render Player

	load r2, prevposPlayer
	load r0, posPlayer
	
	cmp r0, r2
	jeq renderSkipPrevPosClear	

	loadn r1, ' '
	outchar r1, r2
	renderSkipPrevPosClear:
		
	loadn r1, 'A'
	loadn r2, #769
	add r1, r1,r2 
	outchar r1, r0
	
	renderCleanPlayerSkip:
	
	;Epilogue
	
	pop r2
	pop r1
	pop r0
	RTS
