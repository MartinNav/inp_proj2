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

params_sys5:    .space  8 ; misto pro ulozeni adresy pocatku
                          ; retezce pro vypis pomoci syscall 5
                          ; (viz nize "funkce" print_string)

; CODE SEGMENT
                .text

main:           ; ZDE NAHRADTE KOD VASIM RESENIM
                ; make sure r0 contains zero
                xor     r0, r0, r0
                ;copy/create key
                ;copy 'n'
                addi     r1, r0, 6
                lb      r2, msg(r1)
                sb r2, key(r0)
                ;copy 'a'
                addi     r1, r1, 1
                lb      r2, msg(r1)
                addi     r3, r0, 1
                sb      r2, key(r3)
                ;copy 'v'
                addi     r1, r1, 1
                lb      r2, msg(r1)
                addi     r3, r3, 1
                sb      r2, key(r3)
                ;clean up after setup (will set all used registers to 0)
                xor     r1, r1, r1
                xor     r2, r2, r2
                xor     r3, r3, r3
                ; encryption logic will go here


                daddi   r4, r0, msg ; vozrovy vypis: adresa msg do r4
                jal     print_string ; vypis pomoci print_string - viz nize


; NASLEDUJICI KOD NEMODIFIKUJTE!

                syscall 0   ; halt

print_string:   ; adresa retezce se ocekava v r4
                sw      r4, params_sys5(r0)
                daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
                syscall 5   ; systemova procedura - vypis retezce na terminal
                jr      r31 ; return - r31 je urcen na return address
