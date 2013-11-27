LEA $8000,A7		;placera stackpekaren
		
PIAINIT:	CLR.B	$10084
      		MOVE.B	#$00,$10080 	;set all PIA A gates to input
      		MOVE.B	#$04,$10084 	;use PIA A
      		CLR.B	$10080 		;initialize PIA A to 0
      		CLR.B	$10086
      		MOVE.B	#$FF,$10082 	;set all PIA B gates to output
      		MOVE.B	#$04,$10086 	;use PIA B
      		MOVE.B	#0,$10082 	;initialize PIA B to 0

PROGRAM:	MOVE.B	$10080,D0 	;move input to D2
      		AND.B	#1,D0	  	;only check last bit
      		CMP.B	#1,D0	  	;check if startbit is set
      		BNE	PROGRAM	  	;keep looping until 1 is input (startbit set)

;;; delay T/2
		MOVE.L	#150,D1
		JSR 	DELAY

;;; check if startbit is still set
		MOVE.B	$10080,D0
		AND.B	#$01,D0
		CMP.B 	#$01,D0
		BNE	PROGRAM		;reset if bit isn't set anymore (bit disturbance)

;;; if startbit still set, delay T
		MOVE.L	#300,D1
		JSR 	DELAY
	
;;; Läsa in första biten
		MOVE.B 	$10080,D0 	;Läsa in PIA A till DO
		AND.B 	#$01,D0		;Titta på d0

;;; Delay T
		MOVE.L	#300,D1
		JSR DELAY
;;; Bit två (d1)

		CLR.B 	D2 		;Tömma D2
		MOVE.B 	$10080,D2 	;Läsa in PIA A till D2
		AND.B 	#$01,D2		;Titta på sista biten
		LSL.B 	#1,D2		;Skifta ett steg åt vänster
		ADD.B 	D2,D0		;Lägg till D2 till D0
		
;;; Delay T
		MOVE.L	#300,D1
		JSR 	DELAY

;;; Bit tre, d2
		CLR.B 	D2
		MOVE.B 	$10080,D2
		AND.B 	#$01,D2		
		LSL.B 	#2,D2		;Skifta två steg åt vänster
		ADD.B 	D2,D0		;Lägga till D2 till D0

;;; Delay T

		MOVE.L	#300,D1
		JSR 	DELAY
	
;;; Sista biten, bit 4, d3
		CLR.B 	D2
		MOVE.B 	$10080,D2
		AND.B 	#$01,D2	
		LSL.B 	#3,D2		;Skifta tre steg åt vänster
		ADD.B 	D2,D0		;Lägga till D2 till D0

		MOVE.B 	D0,$10082 	;Slutligen, skriva ut D0 till PIA B
		MOVE.L	#300,D1
		JSR 	DELAY
		JSR	PROGRAM
;;; Avsluta
		MOVE.B #228,D7 		;Bör vara med för avslut
		TRAP #14 		;Se ovan

DELAY:		BSET	#7,$10082
      		SUB.L	#1,D1
      		BNE.S	DELAY
      		BCLR	#7,$10082
      		RTS
	
