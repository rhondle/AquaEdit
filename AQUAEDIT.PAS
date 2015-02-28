{

 AquaEdit
 By Marty Anstey & Alastair Brockwell
 14 June 1996

 1.0 - First Version
 1.1 - Cleaned up, added all blocks
 1.2 - Added block images instead of coloured bars, sprite library
 1.3 - Added loading & saving routines, fixed lots of bugs
 1.4 - Added level naming

 FORMAT OF DATA.AQA

     컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
     | Title of level (pad to 35 with 20h)             | 
     컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
     | IR | IG | IB | 00 | RV | GV | BV | 00 | PT | 00 |
     컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
     | Data (238 bytes, blanks = 09Ah)                 |
     컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
     | LD | 00 | LV | 00 |
     컴컴컴컴컴컴컴컴컴컴�

DATA - 17x14 grid (238 bytes)
IR   - Red Intensity
IG   - Green Intensity
IB   - Blue Intensity
RV   - Red Value
GV   - Green Value 
BV   - Blue Value
PT   - Background Pattern   
LD   - Number of blocks in level
LV   - Level Rating
       ------------
       0 - Simple
       1 - Challenging
       2 - Risky
       3 - Hard
       4 - Extreme
       ------------
Data - 9A - Blank
       9B - Brown      (0)
       9C - Red        (10)
       9D - Lt Blue    (20)
       9E - Yellow     (30)
       9F - Lt Green   (40) 
       80 - Lt Gray    (50)
       81 - Purple     (60)
       82 - Dark Blue  (70)
       83 - Pink       (80)
       84 - Dark Green (90)
       85 - Dark Gray  (100)
       86 - Titan
       87 - Cracker i
       88 - Cracker ii
       89 - Cracker iii
       8A - Cracker iv
       8B - Cracker v
       8C - Shooter (regular)
       8D - Shooter (cracker buster)
       8E - Shooter (titan buster)

  Letter - Hex Equivalent

       A - C7
       B - C4
       C - C5
       D - C2
       E - C3
       F - C0
       G - C1
       H - CE
       I - CF
       J - CC
       K - CD
       L - CA
       M - CB
       N - C8
       O - C9
       P - D6
       Q - D7
       R - D4
       S - D5
       T - D2
       U - D3
       V - D0
       W - D1
       X - DE
       Y - DF
       Z - DD
       ! - A7
       ? - B9
   SPACE - A6

note: There are at least 4 or 5 other characters including @, $ and *

 ============================================================================

 TO DO
 -----

 [x] Right Mouse Button Erase
 [ ] Background colour & pattern, level title, level rating
 [x] Alternate "Quit" hotkey (ALT-X?)
 [x] Fix readstr bug
 [x] Add new graphics (so-so = they'll have to do)
 [x] Level title decoding
 [ ] Fix readstr erasing bug

}

uses dos, crt, sprunit, graph, mouse, mouse2;

var
	sprite:array[1..45,1..256] of byte;
	ch:char;
	s:string;
	i,x,y,mx,my,col:integer;
	block,blk:byte;
	grid:boolean;
	palette:array[0..767] of byte;
	i2:integer;
	f:file;
	f1,f2,f3,b1,b2,b3:byte;       { fore 1-3, back 1-3, backgnd, level}
	bk,lev:integer;
	title : array[1..35] of byte;
	data1 : array[1..10] of byte;
	blox  : array[1..238] of byte;
	data2 : array[1..4] of byte;


procedure Pixel(x,y,c:integer);
begin
	mem[$a000:y*320+x]:=c;
end;

procedure LoadLib(filename:string);
var
	f:file;
	i:integer;
	ch:byte;
	hdr:array[1..7] of char;
begin
	assign(f,filename);
	reset(f,1);
	for i:=1 to 45 do                       { adjust as needed : sprites }
	begin
		blockread(f,hdr,7);                     { past header }
		blockread(f,sprite[i],256);             { read sprite }
	end;
	blockread(f,palette,768);               { palette's the last file in there! }
	close(f);
end;


{ modified drawsprite routine - will only draw the first 8x16 pixels of }
{ a standard SPREDIT sprite.                                            }
procedure DrawSprite(ofs,x,y:integer);
var
	i,c,x1,y1:integer;
begin
	i:=0;
	for y1:=y to y+7 do
	for x1:=x to x+15 do
	begin
		inc(i);
		c:=sprite[ofs][i] xor i;
		if c<255 then pixel(x1,y1,c);    { colour 255 = invisible }
	end;
end;

procedure Draw20x14Sprite(ofs,x,y:integer);
var
	i,c,x1,y1:integer;
begin
	i:=0;
	for y1:=y to y+13 do
	for x1:=x to x+15 do
	begin
		inc(i);
		c:=sprite[ofs][i] xor i;
		if c<255 then pixel(x1+2,y1,c);    { colour 255 = invisible! }
	end;
end;

procedure StatBox(s:string);
var
	hx,hy:integer;
	x,y,i:integer;
	p:pointer;
	ch:char;
begin
	cursoroff;
	hx:=320 div 2;
	hy:=200 div 2;
	getmem(p,imagesize(hx-102,hy-32,hx+102,hy+32));
	getimage(hx-102,hy-32,hx+102,hy+32,p^);
	setcolor(15);
	rectangle(hx-102,hy-32,hx+102,hy+32);
	setcolor(1);
	rectangle(hx-101,hy-31,hx+101,hy+31);
	setcolor(9);
	rectangle(hx-100,hy-30,hx+100,hy+30);
	setfillstyle(solidfill,0);
	bar(hx-99,hy-29,hx+99,hy+29);
	setcolor(15);
	outtextxy(hx{-100)+(50 - length(s) div 2)},(hy-30)+10,s);
	ch:=readkey;
	putimage(hx-102,hy-32,p^,normalput);
	freemem(p,imagesize(hx-102,hy-32,hx+102,hy+32));
	cursoron;
end;

procedure updatescreen;
var
	x,y,blk,col,block,i:integer;
begin
	cursoroff;
	i:=0;
	for x:=1 to 14 do
	for y:=1 to 17 do
	begin
		inc(i);
		block:=blox[i];
		if block=$9b then
		col:=6;
		if block=$9c then
		col:=12;
		if block=$9d then
		col:=9;
		if block=$9e then
		col:=14;
		if block=$9f then
		col:=10;
		if block=$80 then
		col:=7;
		if block=$81 then
		col:=5;
		if block=$82 then
		col:=1;
		if block=$83 then
		col:=13;
		if block=$84 then
		col:=2;
		if block=$85 then
		col:=8;
		if block=$86 then
		col:=15;
		if block=$87 then
		col:=16;
		if block=$88 then
		col:=17;
		if block=$89 then
		col:=18;
		if block=$8a then
		col:=19;
		if block=$8b then
		col:=20;
		if block=$8c then
		col:=21;
		if block=$8d then
		col:=22;
		if block=$8e then
		col:=23;
		if col=1 then blk:=9;
		if col=2 then blk:=11;
		if col=5 then blk:=3;
		if col=6 then blk:=1;
		if col=7 then blk:=6;
		if col=8 then blk:=7;
		if col=9 then blk:=8;
		if col=10 then blk:=10;
		if col=12 then blk:=5;
		if col=13 then blk:=4;
		if col=14 then blk:=2;
		if col=15 then blk:=12;
		if col=16 then blk:=13;
		if col=17 then blk:=14;
		if col=18 then blk:=15;
		if col=19 then blk:=16;
		if col=20 then blk:=17;
		if col=21 then blk:=18;
		if col=22 then blk:=19;
		if col=23 then blk:=20;
		setfillstyle(solidfill,0);
		if block<>$9a then drawsprite(blk,x*17-15,y*9-7) else
		bar(x*17-15,y*9-7,x*17,y*9);
	end;
	cursoron;
end;

procedure loadfile(filename:string);
var
	f:file;
begin
	assign(f,filename);
	{$I-}
	reset(f,1);
	if ioresult<>0 then
	begin
		statbox('File not found!');
	end
	else
	begin
		{$I+}
		blockread(f,title,35);
		blockread(f,data1,10);
		blockread(f,blox,238);
		blockread(f,data2,4);
		close(f);
		f1:=data1[1];
		f2:=data1[2];
		f3:=data1[3];
		b1:=data1[5];
		b2:=data1[6];
		b3:=data1[7];
		bk:=data1[9];
		lev:=data2[3];
		updatescreen;
	end;
end;

procedure savefile(filename:string);
var
	f:file;
	count:integer;
begin
	count:=0;
	for i:=1 to 238 do
	begin
		if (blox[i]<>$9a) and (blox[i]<>$86) and (blox[i]<>$8c) and
		(blox[i]<>$8d) and (blox[i]<>$8e) then
		inc(count);
	end;
	data2[1]:=count;
	assign(f,filename);
	rewrite(f,1);
	blockwrite(f,title,35);
	blockwrite(f,data1,10);
	blockwrite(f,blox,238);
	blockwrite(f,data2,4);
	close(f);
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

procedure SetupPalette;
begin
	for i:=0 to 767 do
	palette[i]:=palette[i] shr 2;
	i2:=0;
	for i:=0 to 255 do
	begin
		setpalette(i,palette[i2],palette[i2+1],palette[i2+2]);
		i2:=i2+3;
	end;
end;

function popbox(s:string;n:byte):string;
var
	hx,hy:integer;
	x,y,i:integer;
	p:pointer;
begin
	cursoroff;
	hx:=320 div 2;
	hy:=200 div 2;
	getmem(p,imagesize(hx-102,hy-32,hx+102,hy+32));
	getimage(hx-102,hy-32,hx+102,hy+32,p^);
	setcolor(15);
	rectangle(hx-102,hy-32,hx+102,hy+32);
	setcolor(1);
	rectangle(hx-101,hy-31,hx+101,hy+31);
	setcolor(9);
	rectangle(hx-100,hy-30,hx+100,hy+30);
	setfillstyle(solidfill,0);
	bar(hx-99,hy-29,hx+99,hy+29);
	setfillstyle(solidfill,0);
	bar(hx-99,hy-29,hx+99,hy+29);
	setcolor(15);
	outtextxy(hx{-100)+(50 - length(s) div 2)},(hy-30)+10,s);
	s:=readstr((hx-100)+(50 - 6),(hy-30)+40,n);
	if ord(s[1])>31 then
		popbox:=s
	else
		popbox:='';
	putimage(hx-102,hy-32,p^,normalput);
	freemem(p,imagesize(hx-102,hy-32,hx+102,hy+32));
	cursoron;
end;

procedure InfoBox;
var
	hx,hy:integer;
	x,y,i:integer;
	p:pointer;
	ch:char;
	s1,s2,s3:string;
begin
	hx:=320 div 2;
	hy:=200 div 2;
	getmem(p,imagesize(hx-102,hy-32,hx+102,hy+32));
	getimage(hx-102,hy-32,hx+102,hy+32,p^);
	setcolor(15);
	rectangle(hx-102,hy-32,hx+102,hy+32);
	setcolor(1);
	rectangle(hx-101,hy-31,hx+101,hy+31);
	setcolor(9);
	rectangle(hx-100,hy-30,hx+100,hy+30);
	setfillstyle(solidfill,0);
	bar(hx-99,hy-29,hx+99,hy+29);
	s1:='AQUAEDIT v1.4';
	s2:='By Marty Anstey & Alastair Brockwell';
	s3:='Press any key';
	setcolor(15);
	settextjustify(centertext,toptext);
	outtextxy(hx{-100)+(50 - (length(s1) div 2))},(hy-30)+15,s1);
	outtextxy(hx{-100){+(50 - (length(s2) div 2))},(hy-30)+25,s2);
	outtextxy(hx{-100)+(50 - (length(s3) div 2))},(hy-30)+45,s3);
	ch:=#0;
	repeat
		if keypressed then
		ch:=readkey;
	until (leftpressed) or ((rightpressed) or (rightpressed)) or (ch<>#0);
	if leftpressed then repeat until not leftpressed;
	if ((rightpressed) or (rightpressed)) then repeat until not ((rightpressed) or (rightpressed));
	putimage(hx-102,hy-32,p^,normalput);
	freemem(p,imagesize(hx-102,hy-32,hx+102,hy+32));
end;

{ This function translates plain text into aquanoid's encrypted text }
function translatetext(s:string) : string;
var
	in_text,out_text:string;
	i:integer;
begin
	in_text:='';
	out_text:='';
	for i:=1 to length(s) do
	if ord(s[i])>31 then in_text:=in_text+upcase(s[i]);
	for i:=1 to length(in_text) do
	begin
		if in_text[i]='A' then out_text:=out_text+chr($C7);
		if in_text[i]='B' then out_text:=out_text+chr($C4);
		if in_text[i]='C' then out_text:=out_text+chr($C5);
		if in_text[i]='D' then out_text:=out_text+chr($C2);
		if in_text[i]='E' then out_text:=out_text+chr($C3);
		if in_text[i]='F' then out_text:=out_text+chr($C0);
		if in_text[i]='G' then out_text:=out_text+chr($C1);
		if in_text[i]='H' then out_text:=out_text+chr($CE);
		if in_text[i]='I' then out_text:=out_text+chr($CF);
		if in_text[i]='J' then out_text:=out_text+chr($CC);
		if in_text[i]='K' then out_text:=out_text+chr($CD);
		if in_text[i]='L' then out_text:=out_text+chr($CA);
		if in_text[i]='M' then out_text:=out_text+chr($CB);
		if in_text[i]='N' then out_text:=out_text+chr($C8);
		if in_text[i]='O' then out_text:=out_text+chr($C9);
		if in_text[i]='P' then out_text:=out_text+chr($D6);
		if in_text[i]='Q' then out_text:=out_text+chr($D7);
		if in_text[i]='R' then out_text:=out_text+chr($D4);
		if in_text[i]='S' then out_text:=out_text+chr($D5);
		if in_text[i]='T' then out_text:=out_text+chr($D2);
		if in_text[i]='U' then out_text:=out_text+chr($D3);
		if in_text[i]='V' then out_text:=out_text+chr($D0);
		if in_text[i]='W' then out_text:=out_text+chr($D1);
		if in_text[i]='X' then out_text:=out_text+chr($DE);
		if in_text[i]='Y' then out_text:=out_text+chr($DF);
		if in_text[i]='Z' then out_text:=out_text+chr($DD);
		if in_text[i]='!' then out_text:=out_text+chr($A7);
		if in_text[i]='?' then out_text:=out_text+chr($B9);
		if in_text[i]=' ' then out_text:=out_text+chr($A6);
	end;
	translatetext:=out_text;
end;

procedure bruhaha;
begin
	setpalette(254,f1,f2,f3);
	setpalette(255,b1,b2,b3);
	setfillstyle(solidfill,254);
	bar(251,26,316,34);
	setfillstyle(solidfill,255);
	bar(251,86,316,94);
	settextjustify(lefttext,toptext);
	if (f1>30) or (f2>30) or (f3>30) then setpalette(253,0,0,0) else
	setpalette(253,63,63,63);
	setcolor(253);
	outtextxy(254,27,inttostr(f1));
	outtextxy(275,27,inttostr(f2));
	outtextxy(300,27,inttostr(f3));
	if (b1>30) or (b2>30) or (b3>30) then setpalette(252,0,0,0) else
	setpalette(252,63,63,63);
	setcolor(252);
	outtextxy(254,87,inttostr(b1));
	outtextxy(275,87,inttostr(b2));
	outtextxy(300,87,inttostr(b3));
	setfillstyle(solidfill,0);
	bar(274,126,293,139);
	bar(274,151,293,164);
	outtextxy(280,154,inttostr(lev));
	draw20x14sprite(23+bk,274,126);
end;

begin
	for i:=1 to 35 do title[i]:=$20;
	for i:=1 to 10 do data1[i]:=0;
	for i:=1 to 238 do blox[i]:=$9a;
	for i:=1 to 4 do data2[i]:=0;

	data2[1]:=5;
	data2[3]:=4;

	f1:=0;
	f2:=0;
	f3:=0;
	b1:=0;
	b2:=0;
	b3:=0;
	bk:=0;
	lev:=0;

	if not mouseinstalled then
	begin
		writeln('Sorry, this program requires a Microsoft-compatible mouse.');
		halt;
	end;

	loadlib('AQUAEDIT.LIB');

	init;
	setuppalette;
	{mousewindow(0,0,639,199);}

	grid:=true;

	setcolor(15);

	x:=1;
	repeat
	line(x,170,x,188);
	x:=x+17;
	until x>171;
	line(1,170,171,170);
	line(1,179,171,179);
	line(1,188,171,188);

	drawsprite(1,2,171);
	drawsprite(5,19,171);
	drawsprite(8,36,171);
	drawsprite(2,53,171);
	drawsprite(10,70,171);
	drawsprite(6,87,171);
	drawsprite(3,104,171);
	drawsprite(9,121,171);
	drawsprite(4,138,171);
	drawsprite(11,155,171);
	drawsprite(7,2,180);
	drawsprite(12,19,180);

	drawsprite(13,36,180);
	drawsprite(14,53,180);
	drawsprite(15,70,180);
	drawsprite(16,87,180);
	drawsprite(17,104,180);

	drawsprite(18,121,180);
	drawsprite(19,138,180);
	drawsprite(20,155,180);


	block:=$9b;
	col:=6;

	x:=1;
	y:=x;

	repeat
		if x<=239 then
		line(x,1,x,154);
		line(1,y,239,y);
		x:=x+17;
		y:=y+9;
	until (x>239) and (y>154);

	rectangle(248,1,319,169);

	rectangle(250,5,271,20);
	rectangle(273,5,294,20);
	rectangle(296,5,317,20);

	rectangle(250,25,317,35);

	rectangle(250,40,271,55);
	rectangle(273,40,294,55);
	rectangle(296,40,317,55);

	rectangle(250,65,271,80);
	rectangle(273,65,294,80);
	rectangle(296,65,317,80);

	rectangle(250,85,317,95);

	rectangle(250,100,271,115);
	rectangle(273,100,294,115);
	rectangle(296,100,317,115);

	rectangle(250,125,271,140);
	rectangle(273,125,294,140);
	rectangle(296,125,317,140);

	rectangle(250,150,271,165);
	rectangle(273,150,294,165);
	rectangle(296,150,317,165);

	setfillstyle(solidfill,4);
	bar(251,6,270,19);
	draw20x14sprite(21,251,6);

	setfillstyle(solidfill,2);
	bar(274,6,293,19);
	draw20x14sprite(21,274,6);

	setfillstyle(solidfill,9);
	bar(297,6,316,19);
	draw20x14sprite(21,297,6);

	setfillstyle(solidfill,4);
	bar(251,41,270,54);
	draw20x14sprite(22,251,41);

	setfillstyle(solidfill,2);
	bar(274,41,293,54);
	draw20x14sprite(22,274,41);

	setfillstyle(solidfill,9);
	bar(297,41,316,54);
	draw20x14sprite(22,297,41);

	setfillstyle(solidfill,4);
	bar(251,66,270,79);
	draw20x14sprite(21,251,66);

	setfillstyle(solidfill,2);
	bar(274,66,293,79);
	draw20x14sprite(21,274,66);

	setfillstyle(solidfill,9);
	bar(297,66,316,79);
	draw20x14sprite(21,297,66);

	setfillstyle(solidfill,4);
	bar(251,101,270,114);
	draw20x14sprite(22,251,101);

	setfillstyle(solidfill,2);
	bar(274,101,293,114);
	draw20x14sprite(22,274,101);

	setfillstyle(solidfill,9);
	bar(297,101,316,114);
	draw20x14sprite(22,297,101);

	setfillstyle(solidfill,3);
	bar(251,126,270,139);
	draw20x14sprite(44,250,126);

	setfillstyle(solidfill,3);
	bar(297,126,316,139);
	draw20x14sprite(45,298,126);


	setfillstyle(solidfill,3);
	bar(251,151,270,164);
	draw20x14sprite(44,250,151);

	setfillstyle(solidfill,3);
	bar(297,151,316,164);
	draw20x14sprite(45,298,151);

	InfoBox;
	bruhaha;
	cursoron;

	repeat
		settextjustify(centertext,toptext);
		ch:=#0;
		if keypressed then ch:=readkey;
		if upcase(ch)='S' then
		begin
			s:=popbox('Save Filename:',12);
			if s<>'' then savefile(s);
		end;

		if upcase(ch)='L' then
		begin
			s:=popbox('Load Filename:',12);
			if s<>'' then loadfile(s);
			bruhaha;
		end;

		if upcase(ch)='N' then
		begin
			for i:=1 to 35 do s[i]:=chr($20);
			s:=popbox('Level Title:',20);
			s:=translatetext(s);
			{if length(s)>35 then s:=copy(s,1,35);}
			{if length(s)<=35 then
			for i:=length(s) to 35 do
			s[i]:=chr($20);}
			for i:=1 to length(s) do
			title[i]:=ord(s[i]);
		end;

		if upcase(ch)='G' then
		begin
		cursoroff;
		if grid then
		begin
			setcolor(0);
			grid:=false;
			end
			else
			begin
				setcolor(15);
				grid:=true;
			end;
			x:=1;
			y:=x;
			repeat
				if x<=239 then
				line(x,1,x,154);
				line(1,y,239,y);
				x:=x+17;
				y:=y+9;
			until (x>239) and (y>154);
			cursoron;
		end;

		if upcase(ch)='C' then
		begin
			for i:=1 to 35 do title[i]:=$20;
			for i:=1 to 10 do data1[i]:=0;
			for i:=1 to 238 do blox[i]:=$9a;
			for i:=1 to 4 do data2[i]:=0;
			updatescreen;
		end;

		mx:=(getmousex) div 34+1;
		my:=(getmousey) div 9+1;

		if (rightpressed) then if (mx<15) and (my<18) then
		begin
			cursoroff;
			{if rightpressed then outtextxy(1,190,'Righteth');}
			setfillstyle(solidfill,0);
			bar(mx*17-15,my*9-7,mx*17,my*9);
			blox[mx*17-17+my]:=$9a;
			cursoron;
			repeat until not rightpressed;
		end;

		if (leftpressed) and (getmousex>2) and (getmousex<342) and (getmousey>170) and (getmousey<188) then
		begin
			if box(4,171,34,178) then
			begin
				block:=$9b;
				col:=6;
			end;
			if box(38,171,68,178) then
			begin
				block:=$9c;
				col:=12;
			end;
			if box(72,171,102,178) then
			begin
				block:=$9d;
				col:=9;
			end;
			if box(106,171,136,178) then
			begin
				block:=$9e;
				col:=14;
			end;
			if box(140,171,170,178) then
			begin
				block:=$9f;
				col:=10;
			end;
			if box(174,171,204,178) then
			begin
				block:=$80;
				col:=7;
			end;
			if box(208,171,238,178) then
			begin
				block:=$81;
				col:=5;
			end;
			if box(242,171,272,178) then
			begin
				block:=$82;
				col:=1;
			end;
			if box(276,171,306,178) then
			begin
				block:=$83;
				col:=13;
			end;
			if box(310,171,340,178) then
			begin
				block:=$84;
				col:=2;
			end;
			if box(4,180,34,187) then
			begin
				block:=$85;
				col:=8;
			end;
			if box(38,180,68,187) then
			begin
				block:=$86;
				col:=15;
			end;
			if box(72,180,102,187) then
			begin
				block:=$87;
				col:=16;
			end;
			if box(106,180,136,187) then
			begin
				block:=$88;
				col:=17;
			end;
			if box(140,180,170,187) then
			begin
				block:=$89;
				col:=18;
			end;
			if box(174,180,204,187) then
			begin
				block:=$8a;
				col:=19;
			end;
			if box(208,180,238,187) then
			begin
				block:=$8b;
				col:=20;
			end;
			if box(242,180,272,187) then
			begin
				block:=$8c;
				col:=21;
			end;
			if box(276,180,306,187) then
			begin
				block:=$8d;
				col:=22;
			end;
			if box(310,180,340,187) then
			begin
				block:=$8e;
				col:=23;
			end;
		end;

		if (leftpressed) and (mx<15) and (my<18) then
		begin
			cursoroff;
			{if blox[mx*17-17+my]=$9a then}
			{begin}
			if col=1 then blk:=9;
			if col=2 then blk:=11;
			if col=5 then blk:=3;
			if col=6 then blk:=1;
			if col=7 then blk:=6;
			if col=8 then blk:=7;
			if col=9 then blk:=8;
			if col=10 then blk:=10;
			if col=12 then blk:=5;
			if col=13 then blk:=4;
			if col=14 then blk:=2;
			if col=15 then blk:=12;
			if col=16 then blk:=13;
			if col=17 then blk:=14;
			if col=18 then blk:=15;
			if col=19 then blk:=16;
			if col=20 then blk:=17;
			if col=21 then blk:=18;
			if col=22 then blk:=19;
			if col=23 then blk:=20;
			drawsprite(blk,mx*17-15,my*9-7);
			{end else
			begin
			setfillstyle(solidfill,0);
			bar(mx*17-15,my*9-7,mx*17,my*9);
			end;}
			blox[mx*17-17+my]:=block;
			cursoron;
			repeat until not leftpressed;
		end;

		if (leftpressed) and (getmousex>248*2) and (getmousex<319*2) and (getmousey<170) then
		begin
		cursoroff;
		while leftpressed do
			begin
				if box(250*2,5,271*2,20) and (f1<$3F) then inc(f1);
				if box(273*2,5,294*2,20) and (f2<$3F) then inc(f2);
				if box(296*2,5,317*2,20) and (f3<$3F) then inc(f3);
				if box(250*2,40,271*2,55) and (f1>0) then dec(f1);
				if box(273*2,40,294*2,55) and (f2>0) then dec(f2);
				if box(296*2,40,317*2,55) and (f3>0) then dec(f3);
				if box(250*2,65,271*2,80) and (b1<$3F) then inc(b1);
				if box(273*2,65,294*2,80) and (b2<$3F) then inc(b2);
				if box(296*2,65,317*2,80) and (b3<$3F) then inc(b3);
				if box(250*2,100,271*2,115) and (b1>0) then dec(b1);
				if box(273*2,100,294*2,115) and (b2>0) then dec(b2);
				if box(296*2,100,317*2,115) and (b3>0) then dec(b3);
				if box(250*2,125,271*2,140) and (bk>0) then
				begin
					dec(bk);
					delay(200);
				end;
				if box(296*2,125,317*2,140) and (bk<20) then
				begin
					inc(bk);
					delay(200);
				end;

				if box(250*2,150,271*2,165) and (lev>0) then
				begin
					dec(lev);
					delay(200);
				end;
				if box(296*2,150,317*2,165) and (lev<4) then
				begin
					inc(lev);
					delay(200);
				end;

				settextjustify(lefttext,toptext);
				setfillstyle(solidfill,0);
				bar(274,126,293,139);
				bar(274,151,293,164);

				draw20x14sprite(23+bk,274,126);

				setcolor(15);
				{outtextxy(276,129,inttostr(bk));}
				outtextxy(280,154,inttostr(lev));

				setpalette(254,f1,f2,f3);
				setpalette(255,b1,b2,b3);

				setfillstyle(solidfill,254);
				bar(251,26,316,34);
				setfillstyle(solidfill,255);
				bar(251,86,316,94);

				{if (f1>22) and (f1<38) and (f2>22) and (f2<38) and (f3>22) and (f3<38) then
				setpalette(253,0,0,0)
				else setpalette(253,63-f1,63-f2,63-f3);}

				if (f1>30) or (f2>30) or (f3>30) then setpalette(253,0,0,0) else
				setpalette(253,63,63,63);

				setcolor(253);
				outtextxy(254,27,inttostr(f1));
				outtextxy(275,27,inttostr(f2));
				outtextxy(300,27,inttostr(f3));

				if (b1>30) or (b2>30) or (b3>30) then setpalette(252,0,0,0) else
				setpalette(252,63,63,63);

				setcolor(252);
				outtextxy(254,87,inttostr(b1));
				outtextxy(275,87,inttostr(b2));
				outtextxy(300,87,inttostr(b3));


				if leftpressed then delay(50);
			end;

			data1[1]:=f1;
			data1[2]:=f2;
			data1[3]:=f3;
			data1[5]:=b1;
			data1[6]:=b2;
			data1[7]:=b3;
			data1[9]:=bk;
			data2[3]:=lev;

			repeat until not leftpressed;
			cursoron;
		end;

	until upcase(ch)='Q';

	closegraph;
end.
