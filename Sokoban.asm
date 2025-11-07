jmp main

posPlayer: var#1

main:

	;SetUp
	loadn r0, #34
	store posPlayer, r0
	
	mainLoop:
	load r0, posPlayer
	inc r0
	store posPlayer, r0 
	
	;RenderLoop:
	call render


	jmp mainLoop
	

render:
	;Protect registers
	push r0
	push r1
	
	;Render Player
	loadn r1, 'A'
	load r0, posPlayer
	outchar r1, r0
	
	;Return Registers
	pop r1
	pop r0
	RTS