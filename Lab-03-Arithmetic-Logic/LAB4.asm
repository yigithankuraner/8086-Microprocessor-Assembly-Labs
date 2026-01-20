ORG 100h
MOV AX, 0005h
MOV [3000h], AX
MOV AX, 0FFF6h
MOV [3002h], AX
MOV AX, 0FFF9h
MOV [3010h], AX
MOV AX, 0002h
MOV [3012h], AX
MOV AX, [3000h]
IMUL WORD PTR [3010h]
MOV BX, AX
MOV AX, [3002h]
IMUL WORD PTR [3012h]
ADD AX, BX
MOV [3030h], AX
CMP AX, 0
JL negative_loc
JG positive_loc
JZ zero_loc
negative_loc:
MOV WORD PTR [3060h], 0FFFFh
JMP stop_prog
zero_loc:
MOV WORD PTR [3060h], 0000h
JMP stop_prog
positive_loc:
MOV WORD PTR [3060h], 0001h
stop_prog:
RET



