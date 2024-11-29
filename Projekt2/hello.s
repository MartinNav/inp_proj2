; Autor reseni: jmeno prijmeni login

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
                lb  r2, key(r1)
                sb  r2, ukey(r1)
                addi r1, r1, 1
                lb  r2, key(r1)
                sb  r2, ukey(r1)
                addi r1, r1, 1
                lb  r2, key(r1)
                sb  r2, ukey(r1)
                addi r1, r0, 1
                lb  r2, key(r1)
                addi r1, r0, 3
                sb  r2, ukey(r1)
                
                addi r1, r0, 0;index of an message
start_of_loop:  
                lb r2, cipher(r1); r2 will contain the unencripted message
                beqz r2, end_of_loop; in case we hit null byte we will end the loop
                ; logic will be here
                andi  r3, r1, 1
                beqz  r3, add_key
sub_key:

                ;on the end we will need to skip the end of loop check
                b eol_check
add_key:

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
