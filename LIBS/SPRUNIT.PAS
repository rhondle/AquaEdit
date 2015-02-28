unit SprUnit;

{
Sprite Library
}

interface
function  IntToStr(i: Longint): string;
procedure PutPix(x, y : integer; c : byte);
Procedure Page(p:byte);
procedure retrace;
procedure SaveBsave(filename:string);
procedure LoadBsave(filename:string);
function  TestDetect : Integer;
procedure Init;
procedure SetUp;
procedure Setpalette(color,r,g,b:byte);
Procedure LoadPalette(filename:string);
Procedure SavePalette(filename:string);
Procedure update;
Function  ReadStr(x,y,len:integer):string;
Function  ColorSet : integer;
Function  ScanSprite(filename:string):Integer;
Procedure SaveSprite(filename:string);
Procedure LoadSprite(filename:string);
procedure UNCRUNCH (var Addr1,Addr2; BlkLen:Integer);
Procedure ExitScreen;

implementation
Uses dos, crt, graph;{$I-}{$G+}
var
t,colval,c,r,g,b:integer;
temp,palette:array[1..768] of byte;

type ScreenType = array [0..3999] of Byte;
var ScreenAddr : ScreenType absolute $B800:$0000;
const
  IMAGEDATA_WIDTH=80;
  IMAGEDATA_DEPTH=25;
  IMAGEDATA_LENGTH=435;
  IMAGEDATA : array [1..435] of Char = (
    #15,#17,'Ú',#26,'M','Ä','¿',#24,'³',#25,'#','T',' ','H',' ','E',#25,
    '$','³',#24,'³',#25,#29,'S',' ','Y',' ','K',' ','K',' ','O',' ','S',
    ' ','O',' ','F',' ','T',#25,#30,'³',#24,'³',#25, #8,'Ö','Ä','¿',' ',
    'Ò','Ä','Ä','¿',' ','Ò','Ä','Ä','¿',' ','Ä','Ò','Ä',' ','Ö','Ä','Ò',
    'Ä','¿',' ','Ò','Ä','Ä','¿',#25, #2,'Ò','Ä','Ä','¿',' ','Ò','Ä','Ä',
    '¿',' ','Ä','Ò','Ä',' ','Ö','Ä','Ò','Ä','¿',' ','Ö','Ä','Ä','¿',' ',
    'Ò','Ä','Ä','¿',#25, #8,'³',#24,'³',#25, #8,'Ó','Ä','¿',' ','Ç','Ä',
    'Ä','Ù',' ','Ç','Ä','Â','Ù',' ',' ','º',#25, #3,'º',#25, #2,'Ç','Ä',
    #25, #4,'Ç','Ä',#25, #2,'º',' ',' ','³',' ',' ','º',#25, #3,'º',#25,
     #2,'º',' ',' ','³',' ','Ç','Ä','Â','Ù',#25, #8,'³',#24,'³',#25, #7,
    'Ó','Ä','Ä','Ù',' ','Ð',#25, #3,'Ð',' ','Á',' ',' ','Ä','Ð','Ä',#25,
     #2,'Ð',#25, #2,'Ð','Ä','Ä','Ù',#25, #2,'Ð','Ä','Ä','Ù',' ','Ð','Ä',
    'Ä','Ù',' ','Ä','Ð','Ä',#25, #2,'Ð',#25, #2,'Ó','Ä','Ä','Ù',' ','Ð',
    ' ','Á',#25, #9,'³',#24,'³',#25,'M','³',#24,'³',#25,'M','³',#24,'³',
    #25,#20,'B','y',' ','M','a','r','t','y',' ','A','n','s','t','e','y',
    ' ','&',' ','A','l','a','s','t','a','i','r',' ','B','r','o','c','k',
    'w','e','l','l',#25,#20,'³',#24,'³',#25,#23,'b','a','s','e','d',' ',
    'o','n',' ','t','h','e',' ','s','p','r','i','t','e',' ','e','d','i',
    't','o','r',' ','b','y',#25,#24,'³',#24,'³',#25,#22,'A','l','a','s',
    't','a','i','r',' ','B','r','o','c','k','w','e','l','l',' ','&',' ',
    'A','l','l','a','n',' ','S','c','o','t','t',#25,#22,'³',#24,'³',#25,
    'M','³',#24,'³',#25,#12,'(','C',')',' ','1','9','9','5',' ','S','y',
    'k','k','o','S','o','f','t',' ','P','r','o','d','u','c','t','i','o',
    'n','s',',',' ','A','l','l',' ','R','i','g','h','t','s',' ','R','e',
    's','e','r','v','e','d',#25,#13,'³',#24,'À',#26,'M','Ä','Ù',#24,#24,
    #24,#24,#24,#24,#24,#24,#24,#24,#24,#24);

function IntToStr(i: Longint): string;
var
  s: string[11];
begin
  Str(i, s);
  IntToStr := s;
end;

procedure PutPix(x, y : integer; c : byte); Assembler;
asm
	mov     ax, 0A000h
	mov     es, ax
	mov     di, x
	mov     ax, y
	mov     bh, al
	shl     ax, 6
	add     ah, bh
	add     di, ax
	mov     al, c
	mov     es:[di], al
end;

Procedure Page(p:byte);
begin
	asm
		mov ah,5
		mov al,[p]
		int 10h
	end;
end;

procedure retrace;
begin
	asm
		mov ax,0a000h
		mov es,ax
		xor di,di
		xor ax,ax
		mov cx,32000
		cld
		rep stosw
	end;
end;


procedure SaveBsave(filename:string);
var
	f:file;
const
	vseg=$a000;
begin
	assign(f,filename);
	rewrite(f,1);
	blockwrite(f,mem[vseg:0],320*200);
	close(f);
end;


procedure LoadBsave(filename:string);
	var
		f:file;
	const
		vseg=$a000;
	begin
		assign(f,filename);
		reset(f,1);
		blockread(f,mem[vseg:0],320*200);
		close(f);
end;

{$F+}
function TestDetect : Integer;
begin
  TestDetect := 1;
end;
{$F-}

procedure init;
var
Driver, Mode, TestDriver, ErrCode  : Integer;
begin
	TestDriver := InstallUserDriver('VGA256', @TestDetect);
	if GraphResult <> grOk then
	begin
		WriteLn('Error installing TestDriver');
		Halt(1);
	end;
	Driver := Detect;
	InitGraph(Driver, Mode, '');
	ErrCode := GraphResult;
	if ErrCode <> grOk then
	begin
		WriteLn('Error during Init: ', ErrCode);
		Halt(1);
	end;
end;

procedure SetUp;
var
i:integer;
begin
	setcolor(15);
	rectangle (96, 36, 96 + 128, 36 + 128);
	i:=96;
	repeat
		LINE(I, 36, I, 36 + 128);
		i:=i+8;
	until i=224;
	i:=36;
	repeat
		LINE(96, I, 96 + 128, I);
		i:=i+8;
	until i=36+128;
end;

procedure Setpalette(color,r,g,b:byte);
begin
	asm
		mov dx,03c8h
		mov al,color
		out dx,al
		inc dx
		mov al,r
		out dx,al
		mov al,g
		out dx,al
		mov al,b
		out dx,al
	end;
end;

procedure LoadPalette(filename:string);
var
	palette:array[0..767] of byte;
	i,i2:integer;
	f:file;
begin
	assign(f,filename);
	{$I-}
	reset(f,1);
	blockread(f,palette,768);
	close(f);
	for i:=0 to 767 do
	palette[i]:=palette[i] shr 2;
	i2:=0;
	for i:=0 to 255 do
	begin
		setpalette(i,palette[i2],palette[i2+1],palette[i2+2]);
		i2:=i2+3;
	end;
end;

procedure SavePalette(filename:string);
var
	f:file;
	i:integer;
	palette,temp:array[1..768] of byte;
begin
	portw[$3c8]:=0;
	for i:=1 to 768 do palette[i]:=port[$3c9];
	for i:=1 to 768 do palette[i]:=palette[i] shl 2;
	for i:=4 to 768 do temp[i-3]:=palette[i];
	for i:=1 to 3 do temp[i+765]:=palette[i];
	for i:=1 to 768 do palette[i]:=temp[i];
	assign(f,filename);
	rewrite(f,1);
	blockwrite(f,palette,768);
	close(f);
end;

procedure Update;
begin
	setpalette(colval,r,g,b);
	setfillstyle(solidfill,0);
	bar(26,160,51,170);
	bar(66,160,91,170);
	bar(106,160,131,170);
	setcolor(4);
	outtextxy(10,160,'R=');
	outtextxy(26,160,inttostr(r));
	setcolor(2);
	outtextxy(50,160,'G=');
	outtextxy(66,160,inttostr(g));
	setcolor(1);
	outtextxy(90,160,'B=');
	outtextxy(106,160,inttostr(b));
	if c=1 then
	begin
		setcolor(12);
		outtextxy(10,160,'R=');
		outtextxy(26,160,inttostr(r));
	end;
	if c=2 then
	begin
		setcolor(10);
		outtextxy(50,160,'G=');
		outtextxy(66,160,inttostr(g));
	end;
	if c=3 then
	begin
		setcolor(9);
		outtextxy(90,160,'B=');
		outtextxy(106,160,inttostr(b));
	end;
end;

function ReadStr(x,y,len:integer): string;
var
	ch:char;
	pos:integer;
	tmp:array[1..40] of char;
begin
	for pos:=1 to 255 do readstr[pos]:=#0;
	for pos:=1 to 40 do tmp[pos]:=#0;
	setcolor(15);
	pos:=0;
	repeat
		ch:=readkey;
		if (ch=#8) and (pos>0) then
		begin
			dec(pos);
			setfillstyle(solidfill,0);
			bar(x+(pos*8),y,x+(pos*8)+8,y+8);
			tmp[pos+1]:=#0;
		end
		else if (ch>#31) and (pos<len) then
		begin
			setfillstyle(solidfill,0);
			bar(x+(pos*8),y,x+(pos*8)+8,y+8);
			outtextxy(x+(pos*8),y,ch);
			tmp[pos+1]:=ch;
			inc(pos);
		end;
	until ch=#13;
	ReadStr:=tmp;
end;


Function  ColorSet : integer;
var
	x,y,i,z,t:integer;
	ch:char;
	f:file;
begin
	setfillstyle(solidfill,0);
	bar(10,180,310,192);
	setcolor(15);
	outtextxy(10,180,'Swapping...');
	SaveBsave('SPREDIT.$$$');
	retrace;
	x:=0;
	y:=0;
	i:=0;
	repeat
		setfillstyle(solidfill,i);
		bar(x,y,x+7,y+7);
		x:=x+8;
		if x>127 then
		begin
			x:=0;
			y:=y+8;
		end;
		inc(i);
	until y>127;

	setcolor(15);
	outtextxy(130,1,#24+#25+#26+#27+', Enter selects');
	outtextxy(135,30,'       - HELP - ');
	outtextxy(135,50,'F1 = Select Color');
	outtextxy(135,70,'F2 = Save file');
	outtextxy(135,90,'F3 = Load file');
	outtextxy(135,110,'F4 = Load Palette');
	outtextxy(135,130,'F5 = Fill');
	outtextxy(135,150,'F10  Clear image');
	outtextxy(135,170,'+/-  Color up/down');
	outtextxy(135,190,#17+'Ù = Color Under Cursor');
	x:=0;
	y:=0;
	i:=0;
	z:=1;
	t:=0;
	repeat
		i:=getpixel(x+1,y+1);
		setfillstyle(solidfill,i);
		bar(319-32,0,319,32);
		setcolor(15);
		rectangle(x,y,x+7,y+7);
		ch:=readkey;
		setcolor(i);
		rectangle(x,y,x+7,y+7);
		if ch=#72 then y:=y-8;
		if ch=#75 then x:=x-8;
		if ch=#77 then x:=x+8;
		if ch=#80 then y:=y+8;
		if x<0 then x:=120;
		if x>120 then x:=0;
		if y<0 then y:=120;
		if y>120 then y:=0;

		if ch=#59 then
		begin
			portw[$3c8]:=0;
			for t:=1 to 768 do palette[t]:=port[$3c9];
			{for t:=1 to 768 do palette[t]:=palette[t] shl 2;}
			for t:=4 to 768 do temp[t-3]:=palette[t];
			for t:=1 to 3 do temp[t+765]:=palette[t];
			for t:=1 to 768 do palette[t]:=temp[t];
			colval:=i;

			c:=1;
			r:=palette[colval*3+1];
			g:=palette[colval*3+2];
			b:=palette[colval*3+3];

			repeat
				update;
				ch:=readkey;
				if ch=#75 then c:=c-1 else
				if ch=#77 then c:=c+1;
				if c<1 then c:=3 else
				if c>3 then c:=1;
				if ch=#80 then
				begin
					if (c=1) and (r>0) then r:=r-1;
					if (c=2) and (g>0) then g:=g-1;
					if (c=3) and (b>0) then b:=b-1;
				end;
				if ch=#72 then
				begin
					if (c=1) and (r<63) then r:=r+1;
					if (c=2) and (g<63) then g:=g+1;
					if (c=3) and (b<63) then b:=b+1;
				end;
			until ch=#13;
			ch:=#0;
		end;

	until (ch=#13) or (ch=#27);
	
	if ch=#13 then
	ColorSet:=i else
	colorset:=-1;
	LoadBsave('SPREDIT.$$$');
	assign(f,'SPREDIT.$$$');
	erase(f);
	setfillstyle(solidfill,0);
	bar(10,180,310,192);
end;


function ScanSprite(filename:string) : integer;
var
	f:file of byte;
	i:longint;
	hdr:array[1..7] of char;
	f1:file;
begin
	setfillstyle(solidfill,0);
	bar(10,180,310,192);
	setcolor(15);
	assign(f,filename);
	reset(f);
	if ioresult<>0 then ScanSprite:=-1
	else
	begin
		close(f);
		outtextxy(10,180,'Scanning file');
		ScanSprite:=0;
		setcolor(4);
		line(150,185,300,185);
		for i:=150 to 300 do
		begin
			putpixel(i,185,12);
			delay(10);
		end;
		reset(f);
		i:=filesize(f);
		close(f);
		if i=256 then
		ScanSprite:=1;
		assign(f1,filename);
		reset(f1,1);
		blockread(f1,hdr,7);
		close(f1);
		if hdr='SPR256A' then ScanSprite:=2;
	end;
end;

procedure LoadSprite(filename:string);
var
	i,x1,y1,c:integer;
	f:file;
	buf:array[1..256] of byte;
begin
	i:=ScanSprite(filename);
	setfillstyle(solidfill,0);
	bar(10,180,310,192);

	if i=-1 then
	begin
		setcolor(15);
		outtextxy(10,180,'File Not Found!');
	end;

	if i=0 then
	begin
		setcolor(15);
		outtextxy(10,180,'Unknown format');
	end;

	if i=1 then
	begin
		setfillstyle(solidfill,0);
		bar(10,180,149,190);
		setcolor(15);
		outtextxy(10,180,'Loading ALB/16');
		setcolor(1);
		line(150,185,300,185);
		for i:=150 to 300 do
		begin
			putpixel(i,185,9);
			delay(10);
		end;
		assign(f,filename);
		reset(f,1);
		blockread(f,buf,256);
		close(f);
		i:=0;
		x1:=96;
		y1:=36;
		repeat
			inc(i);
			setfillstyle(solidfill,buf[i]-65);
			bar(x1+1,y1+1,x1+7,y1+7);
			putpix(x1 div 8,y1 div 8,buf[i]-65);
			x1:=x1+8;
			if x1>96+120 then
			begin
				x1:=96;
				y1:=y1+8;
			end;
		until y1>36+120;
	end;

	if i=2 then
	begin
		setfillstyle(solidfill,0);
		bar(10,180,149,190);
		setcolor(15);
		outtextxy(10,180,'Loading SPR/256');
		setcolor(1);
		line(150,185,300,185);
		for i:=150 to 300 do
		begin
			putpixel(i,185,9);
			delay(10);
		end;
		assign(f,filename);
		reset(f,1);
		seek(f,7);
		blockread(f,buf,256);
		close(f);
		i:=0;
		x1:=96;
		y1:=36;
		repeat
			inc(i);
			c:=buf[i] xor i;
			setfillstyle(solidfill,c);
			bar(x1+1,y1+1,x1+7,y1+7);
			putpix(x1 div 8,y1 div 8,c);
			x1:=x1+8;
			if x1>96+120 then
			begin
				x1:=96;
				y1:=y1+8;
			end;
		until y1>36+120;
	end;
	
end;

procedure SaveSprite(filename:string);
var
	f:file;
	x,y,i,c:integer;
	hdr:array[1..7] of char;
	buf:array[1..256] of byte;
begin
	setfillstyle(solidfill,0);
	bar(10,180,149,190);
	setcolor(15);
	outtextxy(10,180,'Writing SPR/256');
	setcolor(1);
	line(150,185,300,185);
	x:=96;
	y:=36;
	i:=0;
	repeat
		inc(i);
		c:=getpixel(x+1,y+1);
		buf[i]:=c xor i;
		x:=x+8;
		if x>96+120 then
		begin
			x:=96;
			y:=y+8;
		end;
	until y>36+120;
	for i:=150 to 300 do
	begin
		putpixel(i,185,9);
		delay(10);
	end;
	hdr:='SPR256A';
	assign(f,filename);
	rewrite(f,1);
	blockwrite(f,hdr,7);
	blockwrite(f,buf,256);
	close(f);
end;

procedure UNCRUNCH (var Addr1,Addr2; BlkLen:Integer);
begin
  inline (
    $1E/               {       PUSH    DS             ;Save data segment.}
    $C5/$B6/ADDR1/     {       LDS     SI,[BP+Addr1]  ;Source Address}
    $C4/$BE/ADDR2/     {       LES     DI,[BP+Addr2]  ;Destination Addr}
    $8B/$8E/BLKLEN/    {       MOV     CX,[BP+BlkLen] ;Length of block}
    $E3/$5B/           {       JCXZ    Done}
    $8B/$D7/           {       MOV     DX,DI          ;Save X coordinate for later.}
    $33/$C0/           {       XOR     AX,AX          ;Set Current attributes.}
    $FC/               {       CLD}
    $AC/               {LOOPA: LODSB                  ;Get next character.}
    $3C/$20/           {       CMP     AL,32          ;If a control character, jump.}
    $72/$05/           {       JC      ForeGround}
    $AB/               {       STOSW                  ;Save letter on screen.}
    $E2/$F8/           {Next:  LOOP    LOOPA}
    $EB/$4C/           {       JMP     Short Done}
                       {ForeGround:}
    $3C/$10/           {       CMP     AL,16          ;If less than 16, then change the}
    $73/$07/           {       JNC     BackGround     ;foreground color.  Otherwise jump.}
    $80/$E4/$F0/       {       AND     AH,0F0H        ;Strip off old foreground.}
    $0A/$E0/           {       OR      AH,AL}
    $EB/$F1/           {       JMP     Next}
                       {BackGround:}
    $3C/$18/           {       CMP     AL,24          ;If less than 24, then change the}
    $74/$13/           {       JZ      NextLine       ;background color.  If exactly 24,}
    $73/$19/           {       JNC     FlashBitToggle ;then jump down to next line.}
    $2C/$10/           {       SUB     AL,16          ;Otherwise jump to multiple output}
    $02/$C0/           {       ADD     AL,AL          ;routines.}
    $02/$C0/           {       ADD     AL,AL}
    $02/$C0/           {       ADD     AL,AL}
    $02/$C0/           {       ADD     AL,AL}
    $80/$E4/$8F/       {       AND     AH,8FH         ;Strip off old background.}
    $0A/$E0/           {       OR      AH,AL}
    $EB/$DA/           {       JMP     Next}
                       {NextLine:}
    $81/$C2/$A0/$00/   {       ADD     DX,160         ;If equal to 24,}
    $8B/$FA/           {       MOV     DI,DX          ;then jump down to}
    $EB/$D2/           {       JMP     Next           ;the next line.}
                       {FlashBitToggle:}
    $3C/$1B/           {       CMP     AL,27          ;Does user want to toggle the blink}
    $72/$07/           {       JC      MultiOutput    ;attribute?}
    $75/$CC/           {       JNZ     Next}
    $80/$F4/$80/       {       XOR     AH,128         ;Done.}
    $EB/$C7/           {       JMP     Next}
                       {MultiOutput:}
    $3C/$19/           {       CMP     AL,25          ;Set Z flag if multi-space output.}
    $8B/$D9/           {       MOV     BX,CX          ;Save main counter.}
    $AC/               {       LODSB                  ;Get count of number of times}
    $8A/$C8/           {       MOV     CL,AL          ;to display character.}
    $B0/$20/           {       MOV     AL,32}
    $74/$02/           {       JZ      StartOutput    ;Jump here if displaying spaces.}
    $AC/               {       LODSB                  ;Otherwise get character to use.}
    $4B/               {       DEC     BX             ;Adjust main counter.}
                       {StartOutput:}
    $32/$ED/           {       XOR     CH,CH}
    $41/               {       INC     CX}
    $F3/$AB/           {       REP STOSW}
    $8B/$CB/           {       MOV     CX,BX}
    $49/               {       DEC     CX             ;Adjust main counter.}
    $E0/$AA/           {       LOOPNZ  LOOPA          ;Loop if anything else to do...}
    $1F);              {Done:  POP     DS             ;Restore data segment.}
end; {UNCRUNCH}


procedure ExitScreen;
begin
	clrscr;
	UnCrunch (IMAGEDATA,ScreenAddr[ (1*2) + (1*160) -162],IMAGEDATA_LENGTH);
end;

end.