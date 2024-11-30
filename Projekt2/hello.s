; Autor reseni: martin navratil xnavram00

; Projekt 2 - INP 2024
; Vigenerova sifra na architekture MIPS64

; DATA SEGMENT
                .data
msg:            .asciiz "martinnavratil" ; sem doplnte vase "jmenoprijmeni"
cipher:         .space  31 ; misto pro zapis zasifrovaneho textu
; zde si muzete nadefinovat vlastni promenne ci konstanty,
; napr. hodnoty posuvu pro jednotlive znaky sifrovacho klice
key:            .asciiz "nav"; this 'variable' will contain the key
ukey:           .space 4 ; key transform to be usefull/easy to use

params_sys5:    .space  8 ; misto pro ulozeni adresy pocatku
                          ; retezce pro vypis pomoci syscall 5
                          ; (viz nize "funkce" print_string)

; CODE SEGMENT
                .text

main:           ; ZDE NAHRADTE KOD VASIM RESENIM
                ; this will copy the key to usefull(ukey) so it can be used for (while using and the 2 LSBs)
                addi r3, r0, 96
                lb  r2, key(r1)
                sub r2, r2, r3
                sb  r2, ukey(r1)
                addi r1, r1, 1
                lb  r2, key(r1)
                sub r2, r2, r3
                sb  r2, ukey(r1)
                addi r1, r1, 1
                lb  r2, key(r1)
                sub r2, r2, r3
                sb  r2, ukey(r1)
                addi r1, r0, 0
                lb  r2, key(r1)
                sub r2, r2, r3
                addi r1, r0, 3
                sb  r2, ukey(r1)
                ; must iterate from zero
                addi r1, r0, 0;index of an message
start_of_loop:  
                lb r2, msg(r1); r2 will contain the unencripted message
                beqz r2, end_of_loop; in case we hit null byte we will end the loop
                ; logic will be here
                ; will compare the last bit if it is odd or even(if it should be added)
                xor   r3, r3, r3
                andi  r3, r1, 1
                beqz  r3, add_key
sub_key:
                xor r3, r3, r3
                add r3, r0, r1
                andi r3, r3, 3
                lb r3, ukey(r3)
                sub r3, r2, r3
                sb r3, cipher(r1)
                
                ;on the end we will need to skip the end of loop check
                addi r10, r0, 97
                sub  r10, r10, r3
                bgez r10, fix_underflow
                b eol_check
fix_underflow:
                addi r10, r3, 26
                sb r10, cipher(r1)
                b eol_check
add_key:
                xor r3, r3, r3
                add r3, r0, r1
                andi r3, r3, 3; only last two bits
                lb r3, ukey(r3)
                add r3, r3, r2
                sb r3, cipher(r1)

                addi r10, r0, 122
                sub r10, r3, r10
                bgez r10, fix_overflow
                b eol_check
                ;check for overflows
fix_overflow:
                addi r10, r0, 26
                sub r10, r3, r10
                sb r10, cipher(r1)

eol_check:
                addi r1, r1, 1; will move to the next character
                b start_of_loop; and repeat it again

end_of_loop:
                daddi   r4, r0, msg ; vozrovy vypis: adresa msg do r4
                jal     print_string ; vypis pomoci print_string - viz nize


; NASLEDUJICI KOD NEMODIFIKUJTE!

                syscall 0   ; halt

print_string:   ; adresa retezce se ocekava v r4
                sw      r4, params_sys5(r0)
                daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
                syscall 5   ; systemova procedura - vypis retezce na terminal
                jr      r31 ; return - r31 je urcen na return address
