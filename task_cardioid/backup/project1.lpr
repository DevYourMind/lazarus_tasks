program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes
  { you can add units after this };

type
  twoDimArray = array of array of double;


function readarr(n: integer): twoDimArray;
var
  arr: twoDimArray;
  i, j, m: integer;
begin
     m:=2;
     setlength(arr, n, m);
     writeln(utf8decode('Введите координаты точек:'));
     for i:=0 to n-1 do
     begin
          for j:=0 to m-1 do
          begin
               read(arr[i, j]);
          end;
          writeln();
     end;
     readarr:=arr;
end;


procedure writearr(arr: twoDimArray; n: integer);
var
  i, j, m: integer;
begin
     m := 2;
     writeln(utf8decode('Массив:'));
     for i := 0 to n - 1 do
     begin
          for j := 0 to m - 1 do
          begin
               write(arr[i,j], ' ');
          end;
          writeln();
     end;
     readln();
end;


function checkdot(x: double; y: double; r: double): boolean;
var
  left_side, right_side: double;
begin
     left_side:=(x*x+y*y-2*r*x)*(x*x+y*y-2*r*x);
     right_side:=4*r*r*(x*x+y*y);
     checkdot:= left_side = right_side;
end;


function calculaterows(arr: twoDimArray; n: integer; r: double): integer;
var
  m, i, j: integer;
  curr_x, curr_y: double;
begin
     m:=0;
     for i:=0 to n-1 do
     begin
          curr_x:=arr[i, 0];
          curr_y:=arr[i, 1];
          if not checkdot(curr_x, curr_y, r)
          then
          begin
               inc(m);
          end;
     end;
     calculaterows:=m;
end;

function filterarr(arr: twoDimArray; n: integer; m:integer; r: double): twoDimArray;
var
  i, j, k: integer;
  curr_x, curr_y: double;
  filtered_arr: twoDimArray;
begin
     if m<>0 then
     begin
       setlength(filtered_arr, m, 2);
       k:=0;
       for i:=0 to n-1 do
       begin
            curr_x:=arr[i, 0];
            curr_y:=arr[i, 1];
            if not checkdot(curr_x, curr_y, r)
            then
            begin
                 filtered_arr[k, 0]:= curr_x;
                 filtered_arr[k, 1]:= curr_y;
                 inc(k);
            end;
       end;
       filterarr:=filtered_arr;
     end
     else
         filterarr:=arr;
end;


var
  cardioid: string;
  r: double;
  arr, filtered_arr: twoDimArray;
  n, m: integer;
begin
     cardioid:='(x^2+y^2-2rx)^2=4r^2(x^2+y^2)';
     writeln(utf8decode('Уравнение кардиоиды:  '), cardioid);
     write(utf8decode('Введите радиус: '));
     readln(r);
     write(utf8decode('Введите количество точек: '));
     readln(n);
     arr:=readarr(n);
     m:=calculaterows(arr, n, r);
     filtered_arr:=filterarr(arr, n, m, r);
     writeln(utf8decode('Отфильтрованный массив'));
     writearr(filtered_arr, m);
     readln();
end.

