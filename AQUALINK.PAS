uses dos, crt;

var
	f:text;
	s:string;
	size,cnt:longint;
	f1,f2:file;
	buf:array[1..300] of byte;

begin
	if paramcount<>1 then
	halt;

	writeln;
	writeln('AQUALINK 1.10');
	writeln;

	assign(f,paramstr(1));
	reset(f);
	assign(f1,'DATA.AQA');
	rewrite(f1,1);
	cnt:=0;

	while not eof(f) do
	begin
		inc(cnt);
		readln(f,s);
		assign(f2,s);
		reset(f2,1);
		size:=filesize(f2);
		writeln(s,' (',size,' bytes)');
		if size<>287 then
		begin
			writeln('> Warning: File wrong size (not a valid level) - skipped.');
			close(f2);
		end
		else
		begin
			blockread(f2,buf,size);
			close(f2);
			blockwrite(f1,buf,size);
		end;
	end;
									   { 20 levels?? }
	if cnt<26 then
	writeln('> Warning: Too few levels! Aquanoid may not run properly.');

	close(f);
	close(f1);
	writeln('> Done. (',cnt,' levels)');
end.
