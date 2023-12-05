program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes
  { you can add units after this };

type
  Notebook = record
           pages: integer;
           price: double;
           color: string;
  end;
  arrNotebook = array of Notebook;



function check_record_input(const notebook: Notebook): boolean;
begin
  if (notebook.pages<0) or (notebook.price <0) or (Length(notebook.color)=0) then
     check_record_input:=false
  else check_record_input:=true;
end;

// duplicate checks
{
function check_record_duplicate(const cur_notebook: Notebook; noteboooks: arrNotebook; curr_index: integer): boolean;
var
   i: integer;
begin
   for i:=0 to
end;
}
function read_record(): Notebook;
var
  cur_notebook: Notebook;
begin
  write(utf8encode('Number of Pages: '));
  readln(cur_notebook.pages);
  write(utf8encode('Price: '));
  readln(cur_notebook.price);
  write(utf8encode('Color: '));
  readln(cur_notebook.color);
  read_record:=cur_notebook;
end;


function read_records(n: integer): arrNotebook;
var
  i:integer;
  cur_notebook: Notebook;
begin
  setlength(result, n);
  for i:=0 to n-1 do
  begin
    cur_notebook:=read_record();
    writeln(check_record_input(cur_notebook));
    if not check_record_input(cur_notebook)
    then
       begin
         writeln(utf8encode('Insert error'));
         exit;
       end;
    writeln();
    result[i]:=cur_notebook;
  end;
end;

var
   notebooks: arrNotebook;
begin
   notebooks:=read_records(3);
   readln();
end.

