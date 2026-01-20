# 8086-Microprocessor-Assembly-Labs



\# ⚙️ 8086 Microprocessor System Architecture Labs



This repository contains a collection of low-level assembly language projects developed for the \*\*BIM303 Microcomputers\*\* course using the \*\*Intel 8086 architecture\*\*.



These projects demonstrate proficiency in direct memory management, hardware interfacing (I/O ports), interrupt handling, and algorithmic logic implementation at the machine level.



\## 📂 Project Catalog \& Technical Skills



| Project / Lab | Technical Focus \& Implementation |

| :--- | :--- |

| \*\*🕹️ Hardware Game: Rock-Paper-Scissors\*\*<br>\*(Lab 07)\* | • \*\*I/O Port Interfacing:\*\* Direct control of \*\*7-Segment Displays\*\*, \*\*Dot Matrix\*\*, and \*\*LCD Panels\*\* via output ports.<br>• \*\*Game Logic:\*\* Implemented AI randomization using System Time (`INT 1Ah`) and lookup tables (`XLAT`).<br>• \*\*User Interface:\*\* Real-time score tracking and visual feedback on hardware simulators. |

| \*\*⌨️ Input Parser \& Filter\*\*<br>\*(Lab 06)\* | • \*\*String Parsing:\*\* An algorithm that filters user input to accept only strictly increasing character sequences (e.g., 'abc').<br>• \*\*Buffer Management:\*\* Dynamic handling of keyboard interrupts (`INT 21h`) and buffer overflow protection. |

| \*\*🔄 Procedural Array Algorithms\*\*<br>\*(Lab 05)\* | • \*\*Modular Programming:\*\* Usage of `PROC` and `RET` for clean code structure.<br>• \*\*Memory Manipulation:\*\* "Mirroring" algorithms to reverse array contents in specific memory blocks. |

| \*\*🧮 Signed Arithmetic \& Flags\*\*<br>\*(Lab 04)\* | • \*\*ALU Operations:\*\* Complex math using Signed Multiplication (`IMUL`) and Addition.<br>• \*\*Condition Handling:\*\* Branching logic based on \*\*Sign Flag (SF)\*\* and \*\*Zero Flag (ZF)\*\* to detect negative/positive results. |

| \*\*📝 String Processing \& Stack\*\*<br>\*(Lab 02 \& 03)\* | • \*\*Stack Operations:\*\* Manual management of the Stack Segment (`SS`) using `PUSH`/`POP` for temporary data storage.<br>• \*\*String Instructions:\*\* Efficient data movement using `MOVSB`, `LODSB`, `STD` (Set Direction Flag) for reverse copying. |



\## 🛠️ Technologies \& Tools

\* \*\*Architecture:\*\* x86 (16-bit Real Mode)

\* \*\*Assembler:\*\* EMU8086 / MASM

\* \*\*Key Concepts:\*\*

&nbsp;   \* Direct Memory Access (DMA)

&nbsp;   \* Interrupt Service Routines (ISRs)

&nbsp;   \* Port Mapping (I/O)

&nbsp;   \* Register Optimization (AX, BX, CX, DX, SI, DI)



\## 💻 Code Snippet: Hardware Control (from Lab 07)

\*Example of sending data to the 7-Segment Display via Output Ports:\*



```assembly

; Initialize 7-Segment Display Port

LEA BX, SEG7\_CODES   ; Load lookup table for digit patterns

MOV AL, user\_choice  ; Get user input

XLAT                 ; Translate value to 7-seg code

MOV DX, 2030h        ; Select Port Address

OUT DX, AL           ; Send signal to hardware



Developed by Yigithan Kuraner - Computer Engineering Student @ ESTÜ

