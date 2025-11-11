jmp main


posPlayer: var#1
prevposPlayer: var#1
originalposPlayer: var#1
playerMoveDirection: var#1
playerOrientation: var#1


posBox: var#1
prevposBox: var#1


cstagetopology: var#1
curentStage:  var#1
curentTopology: var#1


currentUILayer: string " "
currentPropLayer: string " "
currentBackgroundLayer: string " "


currentScreenIndexesChanged : string "                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                "
loadn r0, "\0"
loadn r1, #currentScreenIndexesChanged
loadi r1, r0
; Makes first character the end string
currentScreenIndexesChangedIndex: var#0
; mustalways pont to /0

; This actes like a stack, but not realy


uiLayerColor: var#1
propLayerColor: var#1
backgroundLayerColor: var#1
currentPrintingColor: var#1


Level1Props : string "                                                                                                                                                                                                                                                                                                                                                                                       @@@@@@@                                 @     @                                 @     @                                 @  A  @                                 @     @                                 @     @                                 @@@@@@@                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  "
Level1Background : string "                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                "


main:

	;SetUp
	loadn r0, #38
	store posPlayer, r0

	loadn r0, #156
	store posBox, r0
	

	loadn r0, #0
	loadn r1, #Level1Props
	loadn r2, #0
	
	call ImprimeStr



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
		jeq Playermvleft
	
	;if d
		loadn r2, 'd' 
		cmp r3, r2
		jeq Playermvright

	;if w
		loadn r2, 'w' 
		cmp r3, r2
		jeq Playermvup

	;if s
		loadn r2, 's' 
		cmp r3, r2
		jeq Playermvdown

	;else
		jmp endMovePlayer

	Playermvleft:
		
		call mvleft

		loadn r2, #3
		store playerMoveDirection, r2
		
		jmp callMovementTopologyPlayer

	Playermvright:

		call mvright

		loadn r2, #1
		store playerMoveDirection, r2

		jmp callMovementTopologyPlayer

	Playermvup:

		call mvup

		loadn r2, #2
		store playerMoveDirection, r2

		jmp callMovementTopologyPlayer
	
	Playermvdown:
		
		call mvdown

		loadn r2, #4
		store playerMoveDirection, r2

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


	load r0, posBox
	load r1, posPlayer
	load r2, playerMoveDirection

	store prevposBox, r0

	; if player position == box position, push box
	cmp r0, r1
	jne endboxmv
	
	;if r2 = 3
		loadn r3, #3
		cmp r3, r2
		jeq boxmvleft
	
	;if r2 = 1
		loadn r3, #1 
		cmp r3, r2
		jeq boxmvright

	;if r2 = 2
		loadn r3, #2
		cmp r3, r2
		jeq boxmvup

	;if r2 = 4
		loadn r3, #4 
		cmp r3, r2
		jeq boxmvdown
	
	boxmvright:
		call mvright
		store posBox, r0
		jmp boxmvtopology
		

	boxmvup:
		call mvup
		store posBox, r0
		jmp boxmvtopology

	boxmvleft:
		call mvleft
		store posBox, r0
		jmp boxmvtopology

	boxmvdown:
		call mvdown
		store posBox, r0
		jmp boxmvtopology


	boxmvtopology:

	load r1, prevposBox

	call mvTopology

	store posBox, r0


	endboxmv:



	pop r3
	pop r2
	pop r1
	pop r0
	rts

mvright:
	
	; takes and operates on r0

	push r2
	loadn r2, #1
	add r0, r0, r2

	store playerMoveDirection, r2
	
	pop r2

	rts

mvleft:
	
	; takes and operates on r0

	push r2
	loadn r2, #1
	sub r0, r0, r2

	store playerMoveDirection, r2
	
	pop r2

	rts

mvup:
	; takes and operates on r0

	push r2

	loadn r2, #40
	sub r0, r0, r2

	loadn r2, #2
	store playerMoveDirection, r2
	
	pop r2

	rts

mvdown:
	; takes and operates on r0

	push r2

	loadn r2, #40
	add r0, r0, r2

	loadn r2, #2
	store playerMoveDirection, r2
	
	pop r2
		
	rts

mvTopology:
		
		; This function with on r0 and r1 as inputs
		; and returns the value on r0.

		; it takes a movement, and makes it within the topological constraint

		;todo: Make it take a variable to chose which topology to solve for	

		;refactor code to make it elagent and good, this is trash	
		
		; r0 = curent position
		push r1 ; previous position
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

		; r0, new positon
		; r1, previous position still

		call setIndexChanged

		; marks what must be re-rendered
	
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
	push r3
	push r4


	; Todo: Completely change this function, create a top layer map, and than a bootom layer one. Draw once at start, and just update the screen as needed.
	
	; Must be called in all positions that changed
	
	; currentScreenIndexesChanged stores all indexes that must be rewriten. 
	; it will write them left to right, and when a \0 is met, it will stop. 
	; has 1200 bytes alocated, but it will most likely never be used, but GUI can benefit from this large buffer
	
	
	loadn r3, #'\0'

	loadn r0, #currentScreenIndexesChanged
	ScreenRenderIndex_Loop:

		loadi r4, r0          	   ; Carrega no r4 o caractere apontado por r0
		cmp r4, r3            	   ; Compara o caractere atual com '\0'
		jeq ScreenRenderIndexExit    ; Se for igual a '\0', salta para ScreenRenderIndexExit, encerrando a impressão.

		
		; Takes r1 as the position to render
		; Takes currentPrintingColor as a color variable
		call ScreenRenderIndex
		

		inc r0
		jmp ScreenRenderIndex_Loop

	ScreenRenderIndexExit:

	; todo create a help menu that shows the topology of the stage

	; todo, create a interactive main menu, in which you can chose a level by stading on a tile
	; menu animations
	; esc animation	
	
	;Epilogue
	
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	
	rts


ImprimeStr:
	push r0     ; printing position
	push r1	 ; String Address
	push r2	 ; color
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


AccesStringIndex:
	; too small for actual use, can just be copied and pasted
	; r0 String Addres / first character
	; r1 Index of interest

	add r0, r0, r1 ; addres of character in index r1	
	loadi r2, r0  ;returns on r2 can become a memory variable if needed
				  
	rts

ScreenRenderIndex:
	
	push r0
	push r2
	push r3
	push r4
	; Takes r1 as the position to render
	; Takes currentPrintingColor as a color variable

	; if there is a character on the top layer, it will print it,
	; otherwise, it will check the background layer and print it, even if empty

	; functionality can be expanded to add a UI layer, on top of the prop layer

	;currentUiLayer
	;currentPropLayer
	;currentBackgroundLayer

	loadn r0, #currentPropLayer
	; r1 = Index
	; call AccesStringIndex

		add r0, r0, r1 ; addres of character in index r1	
		loadi r2, r0  ;returns on r2 the value in the string

	; if r2, the value of the string in index r1, is not = " ":
	loadn r3, " "
	cmp r2, r3
	jeq printsecondlayer

		;; Checks if color was passed, if zero, gets default color for layer
		load r3, currentPrintingColor
		add r4, r3, r3
		jnz skipDefaultColorProps
		load r3, propLayerColor
		skipDefaultColorProps:

		add r4, r2, r3
		outchar r4, r1
	
		jmp endprintindex
	; else:
	printsecondlayer:

	loadn r0, #currentBackgroundLayer
	; r1 = Index
	; call AccesStringIndex

		add r0, r0, r1 ; addres of character in index r1	
		loadi r2, r0  ;returns on r2 the value in the string

	; if r2, the value of the string in index r1, is not = " ":
	loadn r3, " "
	cmp r2, r3
	jeq printblank
	
	;; Checks if color was passed, if zero, gets default color for layer
		load r3, currentPrintingColor
		add r4, r3, r3
		jnz skipDefaultColorBackground
		load r3, backgroundLayerColor
		skipDefaultColorBackground:
	
		add r4, r2, r3
		outchar r4, r1
	
		jmp endprintindex
	
	printblank:
	outchar r3, r1
	endprintindex:
	
	pop r4
	pop r2
	pop r0
	rts

setIndexChanged:

	; Takes r0 and r1 as inputs. This way it can be pluged directly into the movement logic
	; does not modify them, has no output to be handled


	push r2
	push r3
	push r4

	loadn r2, #currentScreenIndexesChanged ; Addres to first character of string
	load r3, currentScreenIndexesChangedIndex

	 r2 + r3, points to the last changed index
	add r4, r3, r2

	storei r4, r0
	inc r4
	inc r3
	
	storei r4, r1
	inc r4
	inc r3
	
	loadn r2, "\0"
	storei r4, r2

	store currentScreenIndexesChangedIndex, r3

	; can be optimized by making currentScreenIndexesChangedIndex point directly to "\0" so no need to have r4 and inc it


	pop r4
	pop r3
	pop r2



