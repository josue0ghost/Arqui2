	ORG	0X00		;ORIGEN
	GOTO START
START
	BSP STATUS, 5
	CLRF TRISB		;MODIFICA TODOS COMO SALIDA
	BCF STATUS, PRO
	BCF STATUS, 5
	MOVLW OXOO
	MOVWF PORTB
	GOTO INC
INC
	ADDLW OX01
	MOVWF PORTB
	GOTO INC		;CICLO INFINITO
END