; Autor reseni: Martin Navratil xnavram00

; Projekt 2 - INP 2024
; Vigenerova sifra na architekture MIPS64

; DATA SEGMENT
                .data
msg:            .asciiz "martinnavratil" ; sem doplnte vase "jmenoprijmeni"
cipher:         .space  31 ; misto pro zapis zasifrovaneho textu
; zde si muzete nadefinovat vlastni promenne ci konstanty,
; napr. hodnoty posuvu pro jednotlive znaky sifrovacho klice

params_sys5:    .space  8 ; misto pro ulozeni adresy pocatku
                          ; retezce pro vypis pomoci syscall 5
                          ; (viz nize "funkce" print_string)

; CODE SEGMENT
                .text

main:           ; ZDE NAHRADTE KOD VASIM RESENIM
                ; make sure r0 contains zero
                xor     r0, r0, r0
                ;first letter of surname
                addi    r8, r0, msg
                addi    r8, r8, 16 
                ;letter offset
                addi    r7, r0, 7
                ;prepare for an aray len
                addi    r1, r0, 30
                enc_loop:
                ;here will be all the instructions
                ;load the ciphertext array
                lbu     r10, r1(cipher); this is going from back and we may want to go from front
                ;load key char
                lbu     r9, r8(r7)
                ;prepare offset for
                addi    r7, r7, 1
                and     r7, r7, 3

                ;end loop
                subi r1, r1, 1
                bne     r1, r0, enc_loop

                daddi   r4, r0, msg ; vozrovy vypis: adresa msg do r4
                jal     print_string ; vypis pomoci print_string - viz nize


; NASLEDUJICI KOD NEMODIFIKUJTE!

                syscall 0   ; halt

print_string:   ; adresa retezce se ocekava v r4
                sw      r4, params_sys5(r0)
                daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
                syscall 5   ; systemova procedura - vypis retezce na terminal
                jr      r31 ; return - r31 je urcen na return address
