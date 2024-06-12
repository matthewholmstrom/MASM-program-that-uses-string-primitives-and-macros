
TITLE Program Template     (template.asm)

; Author: Matt Holmstrom 
; Last Modified: 3/17/2024
; OSU email address: holmstrm@oregonstate.edu
; Course number/section:   CS271 Section 401
; Project Number: 6                Due Date: 3/17/2024
; Description: This program is an introduction to using string primitives and macros. The program uses to two macros,
; one to get get the user's string input into a memory location, and the other to display the string the user inputted at
; that memory location. The program implements a procedure (ReadVal), which calls one of the macros (mGetString), to 
; get the user's string, and then converts the string of ascii digits (entered by the user) into its numeric value representation.
; The numeric value is then stored as an output parameter. The procedure also validates that the users input is a string of numeric
; characters, possibly with a plus or minus sign at the beginning. The program also implements a procedure (WriteVal) which converts,
; the numeric value the user entered, back to its string of ascii characters, and invokes the (mDisplayString) macro to print
; the value to output. The program also uses the ReadVal and WriteVal procedures to get 10 valid integers from the user (using
; a counted loop in main), stores these integers in an array, and then displays these integers and their truncated average.

INCLUDE Irvine32.inc




; ---------------------------------------------------------------------------------
; Name: mGetString
;
; This macro displays a prompt to the user, and then gets a string which is
; inputted by the user. The users inputted string is then stored as at a
; memory location, as well as the number of bytes that the string is.
; Preconditions: None
; Postconditions: EDX contains the address of the string entered by the user.
; ECX contains the number of elements that the string can hold. EAX contains
; the number of bytes read by the user's input.
; Receives: Reference parameters (UserPrompt, userString, retAddress), and value
; parameters (maxNumberOfElements, bytesRead)
; Returns: the address of the user's string is stored in the retAddress variable,
; and the number of bytes the user entered is stored in the bytesRead variable.
; ---------------------------------------------------------------------------------
mGetString		Macro userPrompt, userString, retAddress, maxNumberOfElements, bytesRead
	
	push	ECX
	push    EDX
	push    EAX

	mDisplayString userPrompt
	mov     EDX,	userString
	mov     ECX,	maxNumberOfElements
	call    ReadString
	mov     retAddress, EDX
	
	mov     bytesRead,	EAX
    pop	    EAX
	pop     EDX
	pop     ECX

	
ENDM




; ---------------------------------------------------------------------------------
; Name: mDisplayString
;
; This macro displays the string that is referenced by the string's address (passed in
; as a reference parameter)
; Preconditions: None
; Postconditions: EDX contains the address of the string given by the reference parameter.
; Receives: Reference parameter (addressString)
; Returns: the string is printed to the console.
; ---------------------------------------------------------------------------------

mDisplayString		Macro	addressString
	
	push    EDX

	mov     EDX,	addressString
	call    WriteString
    
	pop	    EDX
	

ENDM


HI = 12     ; constant representing the maximum number to integers that the user can enter

.data

programTitle			 BYTE    " PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures",0
programmerName           BYTE    " Written by: Matt Holmstrom  "  , 0
intro1                   BYTE    " Please provide 10 signed decimal integers. " , 0
intro2                   BYTE    " Each number needs to be small enough to fit inside a 32 bit register. After you have finished inputting " , 0
intro3                   BYTE    " the raw numbers I will display a list of the integers, their sum, and their average value. " , 0
prompt                   BYTE    " Please enter an signed number: " , 0
errorMessage             BYTE    " ERROR: You did not enter a signed number or your number was too big.  " , 0
tryAgain                 BYTE    " Please try again " , 0
displayMessage1          BYTE    " You entered the following numbers: " , 0
displayMessage2          BYTE    " The sum of these numbers is:  " , 0
displayMessage3          BYTE    " The truncated average is: " , 0
farewellMessage          BYTE    " Thanks for playing!  " , 0
stringInput              BYTE    12 DUP(?)                  ; string to be entered by the user
retAddress               BYTE    12 DUP(?)                  ; the return address of the string entered by the user
IntegerArray             SDWORD  10 DUP(?)                  ; an array to hold the integers that the user enters
bytesRead                DWORD   ?                          ; the number of bytes read from the user's string



.code
main PROC

	 push  offset programTitle
	 push  offset programmerName
	 push  offset intro1
	 push  offset intro2
	 push  offset intro3
	 call  introduction



     mov   ECX,   10                       ;sets the loop counter to continue to call the ReadVal procedure
_sendToReadVal:                            ; loop used to keep calling the ReadVal procedure
	 
	 push  ECX                             ; pushes the value in ECX
	 push  offset HI
	 push  offset errorMessage
	 push  offset prompt
	 push  bytesRead
	 push  offset retaddress
	 push  offset stringInput
	 push  offset integerArray
	 call  ReadVal
	 pop     ECX


	Invoke ExitProcess,0	; exit to operating system
main ENDP




; ---------------------------------------------------------------------------------
; Name: Introduction 
;
; This procedure displays the programmer's name and program title.
; This procedure also displays what the program does to the user. the calls the
;  procedure calls the mDisplayString macro, to help print the output.
; Preconditions: None
; Postconditions: EDX contains the offset of the global variable intro3.
; Receives: Reference parameters (ProgramTitle, ProgrammerName, intro1, intro2, and intro3.)
; Returns: Output message to the console.
; ---------------------------------------------------------------------------------
introduction PROC

; Display the title of the program, programmer's name, and what the program does.
	push    EBP
    mov     EBP,    ESP
	mov     EDX,	[EBP + 24]        ;EDX contains the programTitle variable
	mDisplayString  EDX
	call    Crlf
	
	mov     EDX,	[EBP + 20]        ;EDX contains the programmerName variarable
	mDisplayString  EDX
	call    Crlf
	call    Crlf
	
	mov     EDX,	[EBP + 16]        ;EDX contains the intro1 variable
	mDisplayString  EDX
	call    Crlf

	mov     EDX,	[EBP + 12]        ;EDX contains the intro2 variable
	mDisplayString  EDX
	call    Crlf

	mov     EDX,	[EBP + 8]        ;EDX contains the intro3 variable
	mDisplayString  EDX
	call    Crlf

	pop     EBP
	ret     20


introduction ENDP



; ---------------------------------------------------------------------------------
; Name: ReadVal
; This procedure invokes the mGetString macro to get the user's input,
; which must be a string of digits. The user is prompted to enter 10 digits (one by one).
; The procedure verifies that the user's input is a valid string representation of a number. If the
; the user entered an invalid number, then an error message is displayed, and the user is then again asked
; to enter a valid number. If the number entered is valid then the procedure converts
; this string of ascii digits to its numeric value. The value is then stored in array (which is an output
; parameter by reference)
; Preconditions: None
; Postconditions: EDX contains the offset of the global variable intro3.
; Receives: Reference parameters (Hi, ErrorMessage, prompt, integerArray, bytesRead, stringInput, retAddress)
; Returns: Output message to the console.
; ---------------------------------------------------------------------------------

ReadVal PROC

   
	push    EBP
    mov     EBP,    ESP
	mGetString [EBP + 24],  [EBP + 12], [EBP + 16],  [EBP + 36],  [EBP + 20]    ; call mGetString to prompt the user and get the user's string input

	
	mov     EDI,    [EBP + 8]          ; store the address of the integerArray in EDI
	mov     ECX,    [EBP + 20]         ; ecx contains the number of bytes read from the users input
	mov     EAX,    0
	cmp     ECX,    0                  ; if this is true, then the user enter no numbers text (empty input)
	je      _error

	mov     ESI,    [EBP +12]          ; store the users string in ESI
	CLD                                
	LODSB                              ; use string primitives to track each character of the user's string, moving forward character by character
	cmp    AL,  45                     ; if the user entered a negative sign, jump to _negativeVal
	je    _negativeVal
	cmp    AL,  43                     ; if the user entered a positive sign, jump to _positiveVal
	je    _positiveVal
	cmp    AL,  57                     ; if the users string is an ascii digit above 57, then its not a valid ascii number representation
	jg     _error
	cmp    AL,  48                     ; if the users string is an ascii digit below 48, then its not a valid ascii number representation
	jl     _error


	jmp     _done

	_error:
		mDisplayString [EBP + 28]      ; displays error message


	
	_negativeVal:
	
	_positiveVal:


    _done:


	ret     32


readVal ENDP


END main