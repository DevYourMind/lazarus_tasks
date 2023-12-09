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
           color: string[255];
  end;
  arrNotebook = array of Notebook;




{
function read_records(n: integer): arrNotebook;
var
  i:integer;
  cur_notebook: Notebook;
  notebooks: arrNotebook;
begin
  setlength(notebooks, n);
  for i:=0 to n-1 do
  begin
    cur_notebook:=read_record();
    if (check_record_input(cur_notebook)=false) or (check_record_duplicate(cur_notebook, notebooks, i)=false)
    then
       begin
         writeln(utf8encode('Insert error'));
         exit;
       end;
    writeln();
    notebooks[i]:=cur_notebook;
  end;
end;
}

function read_record(): Notebook;
var
  cur_notebook: Notebook;
begin
  writeln();
  write(utf8encode('Number of Pages: '));
  readln(cur_notebook.pages);
  write(utf8encode('Price: '));
  readln(cur_notebook.price);
  write(utf8encode('Color: '));
  readln(cur_notebook.color);
  read_record:=cur_notebook;
end;


function check_record_input(const notebook: Notebook): boolean;
begin
  if (notebook.pages<0) or (notebook.price <0) or (Length(notebook.color)=0) then
     check_record_input:=false
  else check_record_input:=true;
end;


function check_record_duplicate(const cur_notebook: Notebook; notebooks: arrNotebook; curr_index: integer): boolean;
var
   i: integer;
begin
   if curr_index=0 then
      begin
         check_record_duplicate:=true;
      end else
   begin
   for i:=0 to curr_index-1 do
   begin
     if (notebooks[i].pages=cur_notebook.pages) and
        (notebooks[i].price=cur_notebook.price) and
        (notebooks[i].color=cur_notebook.color) then
        begin
         check_record_duplicate:=false;
         break;
        end
        else check_record_duplicate:=true;
   end;
   end;
end;


function Trim(const s: string): string;
var
  i, j: Integer;
begin
  i := 1;
  while (i <= Length(s)) and (s[i] <= ' ') do
    Inc(i);
  j := Length(s);
  while (j >= i) and (s[j] <= ' ') do
    Dec(j);
  Result := Copy(s, i, j - i + 1);
end;


function compare_first(const A, B: notebook): Integer;
begin
  if A.pages < B.pages then
    Result := -1
  else
    Result := 0;
end;


function compare_second(const A, B:notebook): integer;
begin
  if A.price > B.price then
    Result := -1
  else
    Result := 0;
end;


function compare_third(const A, B: notebook): integer;
begin
   if (A.color > B.color) or ((A.color = B.color) and (A.pages > B.pages)) then
     result:=-1
   else
     result:=0;
end;

function sort_records(arr: arrNotebook; field: integer): arrNotebook;
var
  i, j: integer;
  tmp: notebook;
  log_cond: integer;
begin
  for i:=low(arr) to high(arr) do
      for j:=i+1 to high(arr) do
      begin
           case field of
                1:
                  begin;
                        log_cond:=compare_first(arr[j], arr[i]);
                  end;
                2:
                  begin;
                        log_cond:=compare_second(arr[j], arr[i]);
                  end;
                3:
                  begin;
                        log_cond:=compare_third(arr[j], arr[i]);
                  end;
           end;
          if log_cond < 0 then
             begin
                  tmp := Arr[i];
                  Arr[i] := Arr[j];
                  Arr[j] := tmp;
             end;
      end;
  result:=Arr;
end;


procedure WriteNotebooks(const notebooks: arrNotebook);
var
  i: integer;
begin
  for i := Low(notebooks) to High(notebooks) do
  begin
    writeln('Notebook #', i, ':');
    writeln('Pages: ', notebooks[i].pages);
    writeln('Price: ', notebooks[i].price:0:2);
    writeln('Color: ', notebooks[i].color);
    writeln;
  end;
end;


procedure writetofile(cond_string: string; arr_notebooks: arrnotebook);
var
   i: integer;
   fvar: file of notebook;
   cond_presence: boolean;
begin
   cond_presence:=False;
   assign(fvar, 'task3.dat');
   rewrite(fvar);
   for i:= Low(arr_notebooks) to High(arr_notebooks) do
   begin
        if arr_notebooks[i].color=cond_string then
          begin
               write(fvar, arr_notebooks[i]);
               cond_presence:=True;
          end;
   end;
   if cond_presence=false then
     writeln('No recodrds with condition');
   close(fwar);
end;


var
   punkt: string;
   ipunkt, n_records, n_cur_notebook, i: integer;
   err: integer;
   cur_notebook: notebook;
   arr_notebooks: arrNotebook;
   arr_green_notebook: arrNotebook;
   flg_green: boolean;
   cond_string: string;
   color_condition: string;
begin
  n_records:=0;
  n_cur_notebook:=0;
  repeat
  // тут печатаем текст меню, чтоб пользователь понял смысл номеров пунктов меню
     writeln();
     WriteLn(utf8decode('1. Добавление записи с проверкой корректности и дубликатов'));
     WriteLn(utf8decode('2. Сортировка по полю Pages'));
     WriteLn(utf8decode('3. Сортировка по полю Price'));
     WriteLn(utf8decode('4. Двойная сортировка по текстовому полю'));
     WriteLn(utf8decode('5. Поиск 1я из зелёных тетрадей в 12 стр. (если есть)'));
     WriteLn(utf8decode('6. Записать данные из массива в файл по условию'));
     WriteLn(utf8decode('0. Выход'));
     Write(utf8decode('Ваш выбор: '));
     ReadLn(punkt);
     punkt := Trim(punkt); // обрезка пробелов по краям строки
     Val(punkt, ipunkt, err);
     if (err > 0) then
        WriteLn(utf8decode('Ошибка: некорректно введён номер пункта меню'))
     else
       begin
       case ipunkt of // разбор возможных входных значений успешно введённого пункта меню
            1: begin
              // тут решение для 1го пункта меню
              if n_records=0 then
                 begin
                      write(utf8decode('Введите количество записей в массиве: '));
                      readln(n_records);
                      setlength(arr_notebooks, n_records);
                 end;
              cur_notebook:=read_record();
              if check_record_input(cur_notebook) and check_record_duplicate(cur_notebook, arr_notebooks, n_cur_notebook) then
                 begin
                      arr_notebooks[n_cur_notebook]:=cur_notebook;
                      inc(n_cur_notebook);
                 end
                 else
                   begin
                        writeln(utf8decode('Ошибка ввода'));
                   end;
              end;
            2: begin
               arr_notebooks:=sort_records(arr_notebooks, 1);
               writeln(utf8decode('Отсортированый массив записей: '));
               WriteNotebooks(arr_notebooks);
               end;
            3: begin
               arr_notebooks:=sort_records(arr_notebooks, 2);
               writeln(utf8decode('Отсортированый массив записей: '));
               WriteNotebooks(arr_notebooks);
            end;
            4: begin
               arr_notebooks:=sort_records(arr_notebooks, 3);
               writeln(utf8decode('Отсортированый массив записей: '));
               WriteNotebooks(arr_notebooks);
            end;
            5: begin
               flg_green:=false;
               for i:=0 to n_records do
               begin
                 if (arr_notebooks[i].pages=12) and (arr_notebooks[i].color='green') then
                    begin
                         setlength(arr_green_notebook, 1);
                         arr_green_notebook[0]:=arr_notebooks[i];
                         writeln(utf8decode('Запись найдена'));
                         WriteNotebooks(arr_green_notebook);
                         flg_green:=true;
                         break;
                    end;
               end;
               if flg_green=false then
                  writeln(utf8decode('Запись не найдена'));
            end;
            6: begin
               write(utf8decode('Введите цвет тетрадей, которые нужно записать в файл: '));
               readln(color_condition);
               writetofile(color_condition, arr_notebooks);
            end;
       end;
       end;
  until ipunkt = 0;
end.

