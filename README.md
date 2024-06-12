# MASM-program-that-uses-string-primitives-and-macros

This is a partially completed program using MASM in Visual Studio. The program string primitives
and two macros. The program involves using a macros to get a numerical value entered by the user,
and then converts the string of ascii digits (entered by the user) into its numeric value representation.
The numeric value is then stored as an output parameter. Theprogram also validates that the user's input is a string of numeric
characters, possibly with a plus or minus sign at the beginning. The program also implements a procedure (WriteVal) which converts,
the numeric value the user entered, back to its string of ascii characters, and invokes the (mDisplayString) macro to print
the value to output. The program also uses the ReadVal and WriteVal procedures to get 10 valid integers from the user (using
a counted loop in main), stores these integers in an array, and then displays these integers and their truncated average.
