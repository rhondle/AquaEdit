unit mouse;

{
Low level mouse interfacing with help from one of my most useful books "Advanced MS-DOS Programming: The Microsoft Guide for Assembly Language and C Programmers" by Ray Duncan, 1988 ISBN 1556151578
}

interface
uses dos;


procedure cursoron;
procedure cursoroff;
function mouseinstalled:boolean;
function getmousex:word;
function getmousey:word;
procedure setmouse(x,y:word);
function leftpressed:boolean;
function rightpressed:boolean;
procedure mousesensetivity(x,y:word); 
procedure mousewindow(l,t,r,b:word); 

implementation

procedure cursoron; assembler;
asm
	mov ax,1
	int 33h
end;

procedure cursoroff; assembler;
asm
	mov ax,2
	int 33h
end;


function mouseinstalled:boolean; assembler;
asm
	xor ax,ax
	int 33h
	cmp ax,-1
	je @skip
	xor al,al
	@skip:
end;

function getmousex:word; assembler;
asm
	mov ax,3
	int 33h
	mov ax,cx
end;

function getmousey:word; assembler;
asm
	mov ax,3
	int 33h
	mov ax,dx
end;

procedure setmouse(x,y:word); assembler;
asm
	mov ax,4
	mov cx,x
	mov dx,y
	int 33h
end;

function leftpressed:boolean; assembler;
asm
	mov ax,3
	int 33h
	and bx,1
	mov ax,bx
end;

function rightpressed:boolean; assembler;
asm
	mov ax,3
	int 33h
	and bx,2
	mov ax,bx
end;

procedure mousesensetivity(x,y:word); assembler;
asm
	mov ax,1ah
	mov bx,x
	mov cx,y
	xor dx,dx
	int 33h
end;

procedure mousewindow(l,t,r,b:word); assembler;
asm
	mov ax,7
	mov cx,l
	mov dx,r
	int 33h
	mov ax,8
	mov cx,t
	mov dx,b
	int 33h
end;

end.