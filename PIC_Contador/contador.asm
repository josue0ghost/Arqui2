Device = 16F84A ‘PIC a usar

Xtal 4          ‘Frecuencia de reloj

TRISB=0         ‘Puerto B como salida

TRISA=15        ‘Todo el puerto A como entrada

Dim CONTADOR As Word  

Symbol BOTON1 = PORTA.0   ‘BOTON1 va a ser PORTB.0

Symbol BOTON2 = PORTA.1   ‘BOTON1 va a ser PORTB.1

Symbol Q3 = PORTB.4

Symbol Q2 = PORTB.5

Symbol Q1 = PORTB.6

Symbol Q0 = PORTB.7

Dim UNIDAD As Byte

Dim DECENA As Byte

Dim CENTENA As Byte

Dim MILLAR As Byte

 

PORTB=0

INICIO:

If BOTON1 = 1 Then     

        DelayMS 100

CONTADOR = CONTADOR + 1

If CONTADOR >9999  Then CONTADOR=0

EndIf      

    If BOTON2 = 1 Then     

        DelayMS 100

CONTADOR = CONTADOR – 1

If CONTADOR < 0 Then CONTADOR = 9999

EndIf

    DelayMS 5

PORTB= 16 + Dig 0, CONTADOR

DelayMS 5

PORTB= 32 + Dig 1, CONTADOR

DelayMS 5

PORTB= 64 + Dig 1, CONTADOR

DelayMS 5

PORTB= 128 + Dig 2, CONTADOR

DelayMS 5

PORTB=0

DelayMS 5

GoTo INICIO

End