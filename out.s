.text
    .global _start

_start:

# Codigo para empilhar o número 5
    pushq   $5

# Codigo para empilhar o número 2
    pushq   $2

# Codigo para operação de +
    popq    %rax
    popq    %rbx
    addq    %rax, %rbx
    pushq     %rbx

# Codigo para empilhar o número 1
    pushq   $1

# Codigo para operação de -
    popq    %rax
    popq    %rbx
    subq    %rax, %rbx
    pushq     %rbx

    popq    %rbx
    movq    $1, %rax
    int     $0x80

