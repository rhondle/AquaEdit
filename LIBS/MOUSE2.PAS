unit mouse2;

interface

function box(x1,y1,x2,y2:word) : boolean;
procedure clickbox(ex1,why1,ex2,why2:integer; tekst:string; tstyle:integer; invert:boolean);
procedure clickbox320(ex1,why1,ex2,why2:integer; tekst:string; tstyle:integer; invert:boolean);
function button(x1,y1,x2,y2:integer;txt:string;styl:integer) : boolean;
function button320(x1,y1,x2,y2:integer;txt:string;styl:integer) : boolean;


implementation
uses dos, crt, mouse, graph;

function box (x1,y1,x2,y2:word) : boolean;
begin
box:=false;
if (getmousex>x1) and
   (getmousey>y1) and
   (getmousex<x2) and
   (getmousey<y2) then
   box:=true;
end;

procedure clickbox(ex1,why1,ex2,why2:integer; tekst:string; tstyle:integer; invert:boolean);
var
zz,zzz,eye,ay,bee,see,bord1,bord2:integer;
begin
	bord1:=15;
	bord2:=8;
	if tstyle=1 then
	begin
		ay:=15;
		bee:=8;
		see:=7;
	end
	else if tstyle=2 then
	begin
		ay:=8;
		bee:=15;
		see:=7;
	end
	else
	begin
		ay:=7;
		bee:=7;
		see:=15;
	end;

	if invert then
	begin
		bord1:=8;
		bord2:=15;
		if ay<>7 then
		begin
			if ay=15 then ay:=8
			else ay:=15;
		end;
		if bee<>7 then
		begin
			if bee=15 then bee:=8
			else bee:=15;
		end;
		if see<>7 then
		begin
			if see=15 then see:=8
			else see:=15;
		end;
	end;

	if (ex1>-1) and (ex2<640) and (why1>-1) and (why2<480) then
	begin
	if ((length(tekst)*8)<(ex2-ex1-12)) and (why2-why1>22) then
	begin
	for eye:=0 to 3 do
	begin
	setcolor(bord1);
	line(ex1,why1+eye,ex2-eye,why1+eye);
	line(ex1+eye,why1,ex1+eye,why2-eye);
	setcolor(bord2);
	line(ex2,why2-eye,ex1+eye,why2-eye);
	line(ex2-eye,why2,ex2-eye,why1+eye);
	end;
	setfillstyle(solidfill,7);
	bar(ex1+4,why1+4,ex2-4,why2-4);
	zz:=(((ex2-ex1)-(length(tekst)*8))div 2);
	zzz:=(why2-why1-8) div 2;
	setcolor(ay);
	outtextxy(ex1+zz-1,why1+zzz-1,tekst);
	setcolor(bee);
	outtextxy(ex1+zz+1,why1+zzz+1,tekst);
	setcolor(see);
	outtextxy(ex1+zz,why1+zzz,tekst);
	end
	else
	begin
	rectangle(ex1,why1,ex2,why2);
	line(ex1,why1,ex2,why2);
	line(ex1,why2,ex2,why1);
	end;
	end;
end;

procedure clickbox320(ex1,why1,ex2,why2:integer; tekst:string; tstyle:integer; invert:boolean);
var
	zz,zzz,eye,ay,bee,see,bord1,bord2:integer;
begin
	bord1:=15;
	bord2:=8;
	if tstyle=1 then
	begin
		ay:=15;
		bee:=8;
		see:=7;
	end
	else if tstyle=2 then
	begin
		ay:=8;
		bee:=15;
		see:=7;
	end
	else
	begin
		ay:=7;
		bee:=7;
		see:=15;
	end;

	if invert then
	begin
		bord1:=8;
		bord2:=15;
		if ay<>7 then
		begin
			if ay=15 then ay:=8
			else ay:=15;
		end;
		if bee<>7 then
		begin
			if bee=15 then bee:=8
			else bee:=15;
		end;
		if see<>7 then
		begin
			if see=15 then see:=8
			else see:=15;
		end;
	end;

	if (ex1>-1) and (ex2<320) and (why1>-1) and (why2<200) then
	begin
	if ((length(tekst)*8)<(ex2-ex1-10)) and (why2-why1>20) then
	begin
	for eye:=0 to 1 do
	begin
	setcolor(bord1);
	line(ex1,why1+eye,ex2-eye,why1+eye);
	line(ex1+eye,why1,ex1+eye,why2-eye);
	setcolor(bord2);
	line(ex2,why2-eye,ex1+eye,why2-eye);
	line(ex2-eye,why2,ex2-eye,why1+eye);
	end;
	setfillstyle(solidfill,7);
	bar(ex1+2,why1+2,ex2-2,why2-2);
	zz:=(((ex2-ex1)-(length(tekst)*8))div 2);
	zzz:=(why2-why1-8) div 2;
	setcolor(ay);
	outtextxy(ex1+zz-1,why1+zzz-1,tekst);
	setcolor(bee);
	outtextxy(ex1+zz+1,why1+zzz+1,tekst);
	setcolor(see);
	outtextxy(ex1+zz,why1+zzz,tekst);
	end
	else
	begin
	rectangle(ex1,why1,ex2,why2);
	line(ex1,why1,ex2,why2);
	line(ex1,why2,ex2,why1);
	end;
	end;
end;


function button(x1,y1,x2,y2:integer;txt:string;styl:integer) : boolean;
begin
	button:=false;
	if (box(x1,y1,x2,y2)) and (leftpressed) then
	begin
		cursoroff;
		clickbox(x1,y1,x2,y2,txt,styl,true);
		cursoron;
		repeat
		until (not leftpressed) or (not box(x1,y1,x2,y2));
		if box(x1,y1,x2,y2) then button:=true;
		cursoroff;
		clickbox(x1,y1,x2,y2,txt,styl,false);
		cursoron;
	end;
end;

function button320(x1,y1,x2,y2:integer;txt:string;styl:integer) : boolean;
begin
	button320:=false;
	if (box(x1*2,y1,x2*2,y2)) and (leftpressed) then
	begin
		cursoroff;
		clickbox320(x1,y1,x2,y2,txt,styl,true);
		cursoron;
		repeat
		until (not leftpressed) or (not box(x1*2,y1,x2*2,y2));
		if box(x1*2,y1,x2*2,y2) then button320:=true;
		cursoroff;
		clickbox320(x1,y1,x2,y2,txt,styl,false);
		cursoron;
	end;
end;


end.