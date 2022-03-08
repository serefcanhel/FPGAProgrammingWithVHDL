# FPGAProgrammingWithVHDL

   In this repository, the SPARTAN 3E Starter Kit is programmed by using VHDL.
   
# CONTENTS

   # DEBOUNCE
   
      * Debounce application is made to reduce bounce of the push buttons.
      * In the top.vhd, two push buttons are used to control bounce of the push buttons.
      
   # NBitAdder
   
      * NBitAdder application is made to made a N-bit adder.
      * In this application, 2-bit adder is implemented because SPARTAN 3E exist four switches. First two switches are represent first 2-bit number, adn last two switches are represent second 2-bit number.
      * The carry in implemented as zero but it can be changed through top.vhd
      * The result is respresented by LED's. The last LED is represent carry out.
      
   # RotaryEncoder
   
      * RotaryEncoder application is made to control encoder.
      * In this application, the encoder controls LED's. If the encoder is changed, the illuminated LED changes.
      * All LED's are used in the SPARTAN 3E.
      
   # SequentilLogicExample
   
      * Sequential Logic application is made to create a sequential circuit.
      * In this application, a counter is made by using sequential circuit design. The speed of the counter is changed by using switches.
      * The LED's are represent counter. First two switches are used to control speed of the counter.
      * ==> If the switches are "00" then counter counts with 2 sec.
        ==> If the switches are "01" then counter counts with 1 sec.
        ==> If the switches are "10" then counter counts with 500 ms.
        ==> If the switches are "11" then counter counts with 250 ms.
   
   # ShiftRegister
      
      * Shift Register applicaiton is implemented and simulated.
      * In this application, 4-bit shift register is implemented. Also, the test bench is written in this application.
      * The top module and test bench module can be found in the files.
