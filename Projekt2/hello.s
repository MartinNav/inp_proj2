; Autor reseni: Martin Navratil xnavram00

; Projekt 2 - INP 2024
; Vigenerova sifra na architekture MIPS64

; DATA SEGMENT
                .data
msg:            .asciiz "martinnavratil" ; sem doplnte vase "jmenoprijmeni"
cipher:         .space  31 ; misto pro zapis zasifrovaneho textu
; zde si muzete nadefinovat vlastni promenne ci konstanty,
; napr. hodnoty posuvu pro jednotlive znaky sifrovacho klice
key:            .asciiz "xxx"
msg_len:        .byte 14;contains length of msg

params_sys5:    .space  8 ; misto pro ulozeni adresy pocatku
                          ; retezce pro vypis pomoci syscall 5
                          ; (viz nize "funkce" print_string)

; CODE SEGMENT
                .text

main:           ; ZDE NAHRADTE KOD VASIM RESENIM
                ; make sure r0 contains zero
                xor     r0, r0, r0
                ;make r5 with the offset this will make a from 97 to 1 as an char/byte value
                addi    r5, r0, 96
                ;copy/create key
                ;copy 'n'
                addi     r1, r0, 6
                lb      r2, msg(r1)
                sub     r2, r2, r5
                sb r2, key(r0)
                ;copy 'a'
                addi     r1, r1, 1
                lb      r2, msg(r1)
                sub     r2, r2, r5
                addi     r3, r0, 1
                sb      r2, key(r3)
                ;copy 'v'
                addi     r1, r1, 1
                lb      r2, msg(r1)
                sub     r2, r2, r5
                addi     r3, r3, 1
                sb      r2, key(r3)
                ;clean up after setup (will set all used registers to 0)
                xor     r1, r1, r1
                xor     r2, r2, r2
                xor     r3, r3, r3
                xor     r5, r5, r5
                ; encryption logic will go here
                lb      r1, msg_len(r0)
                ;iteration counter
                addi     r11, r0, 0
encryption_loop:
                ;get the value that should be subtracted or added
                ;getting the key index
                addi    r12, r0, 3
                and     r13, r12, r11
                bne     r12, r13, calculate_offset
                ;key will be stored in r5
                xor     r5, r5, r5
                lb      r5, key(r5)
                b is_even
                ;check if is odd or even
calculate_offset:
                lb      r5, key(r13)

is_even:        addi     r12, r0, 1
                addi     r13, r0, 1
                and      r12, r12, r11
                beq      r12, r13, subbing_v
adding_v:
                ;in r15 the msg will be stored 
                lb      r15,  msg(r11)
                add     r15, r5, r15
                ;TODO: check if checking for overflows works correctly
                ; if it is more than the 123 I will need to subtract 26 from it 
                addi    r17, r0, 123
                sub     r17, r15, r17
                ; I am not sure how it will deal with overflow
                bgez    r17, fix_overflow
                b write_to_mem_a
fix_overflow:
                addi r17, r0, 26
                sub  r15, r15, r17
write_to_mem_a: sb      r15, cipher(r11)
                b end_of_loop
subbing_v:
                lb      r15,  msg(r11)
                sub r15, r15, r5
                ;TODO: check for overflows
                sb      r15, cipher(r11)

end_of_loop:
                ;end of loop
                addi r11, r11, 1
                bne       r11, r1, encryption_loop


                ;daddi    r16, r0,  cipher
                ;sd      r16, params_sys5(r0)
                daddi   r4, r0, msg ; vozrovy vypis: adresa msg do r4
                jal     print_string ; vypis pomoci print_string - viz nize


; NASLEDUJICI KOD NEMODIFIKUJTE!

                syscall 0   ; halt

print_string:   ; adresa retezce se ocekava v r4
                sw      r4, params_sys5(r0)
                daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
                syscall 5   ; systemova procedura - vypis retezce na terminal
                jr      r31 ; return - r31 je urcen na return address
