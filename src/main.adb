with Queue_Fifo;
with Ada.Text_IO; use Ada.Text_IO;
--with Ada.Containers.Doubly_Linked_Lists;
--with Ada.Numerics.Elementary_Functions;
procedure Main

is
   pragma Assertion_Policy (Pre  => Check,
                            Post => Check);
  -- N by M Range declaration of map
   N: constant Integer := 4;
   M: constant Integer := 5;
   --type N_Range is new Integer range 1 .. N;
   --staying within a single type
   subtype N_Range is Integer  range 1 .. N;
   subtype M_Range is Integer  range 1 .. M;
   -- This permits the specified integer numbers within the map.
   type Int_Needed is range 0 .. 1;

   --Change Integer to Int_Needed
   --This allows only 0 and 1 in our map
 --type Map is array (N_Range, M_Range) of Integer;
   type Map is array (N_Range, M_Range) of Int_Needed;
   type Visited is array (N_Range, M_Range) of Boolean;

   type Coordinate is record
      x : N_Range;
      y : M_Range;
   end record;

   package Coordinate_Queues is new Queue_Fifo
   (Element_Type => Coordinate,
      "="          => "=");
   subtype Coordinate_Queue is Coordinate_Queues.Queue;
   --This function check if a given cell
   --can be included in BFS=(Visit_Island)

   function Is_Unvisited_Land(Map_Array : Map;
                              i_var : Integer;
                              j_var : Integer;
                              Visited_Array : Visited) return Boolean

     --with Pre => (for all j_var in Map_Array'Range=> Map_Array(1, j_var) < 2)
    is
   begin
      return i_var in N_Range and then
        j_var in M_Range and then
        Map_Array(i_var, j_var)= 1 and then not Visited_Array(i_var, j_var);

   end Is_Unvisited_Land;

   procedure Visit_Island(Map_Array :  Map;
                          Visited_Array : in out Visited;
                          ni : Integer;
                          mj : Integer)
     with Pre => Is_Unvisited_Land(Map_Array, ni, mj, Visited_Array)
   -- This condition must be true for this function to be able to execute when called
   -- within Count_Islands
   --If false then system.assertion.assert_failure is raised
   --There should be unvisited islands before we can visit it.

   is
      --Declaration of fized size row and col array of type integer
      type Row is array (1 .. 4) of Integer;
      type Col is array (1 .. 4) of Integer;
      -- Assignment of values to row_array and col_array of type row and col.
      -- row_array and col_array are instance of row and col
      Row_Array : constant Row := (-1, 0, 0, 1);
      Col_Array : constant Col := (0, -1, 1, 0);
      My_Coord_Queue : Coordinate_Queue;

   begin
      --Simple BFS first step, we enqueue
      -- source and mark it as visited
      My_Coord_Queue.Push ((ni, mj));
      Visited_Array(ni, mj) := true;
      -- Next step of BFS. We take out
      -- items one by one from queue and
      --enqueue their univisited adjacent
      while not My_Coord_Queue.Is_Empty loop
         declare
            Coord : Coordinate := My_Coord_Queue.Pop;
            i : N_Range := Coord.x;
            j : M_Range := Coord.y;
          begin
            for k in Row_Array'Range loop
              if Is_Unvisited_Land (Map_Array, i + Row_Array(k), j + Col_Array(k), Visited_Array)
              then
                  Visited_Array(i + Row_Array(k), j + Col_Array(k)):=True;
                  My_Coord_Queue.Push((i + Row_Array(k), j + Col_Array(k)));
              end if;
        end loop;
         end;
      end loop;

   end Visit_Island;

   function Count_Islands(Map_Array : Map) return Integer
   with Pre => (Map_Array'Length =  N),
        Post => (Count_Islands'Result < (N * M))
     --This condition must be met for this function to execute whenever we call it
     --Giving length less than, equal to zero or greater than N will raise assertion failure
     --The post condition works with the Visit_Island called within the Count_Islands function below
     --If visit_Islands violates requirements regarding the counting of number of islands then Post condition raise an assertion failure.
   is
      -- Mark all cells as not visited

      Visited_Array : Visited := (others => (others=> False));

      Count : Integer := 0;

   begin

      for i in N_Range loop
         for j in M_Range loop
            -- If there is a land and it's not visited
            if (Map_Array(i, j) = 1 and then not Visited_Array(i , j))
            then
               --Then visit the land
               Visit_Island(Map_Array, Visited_Array, i, j);
               Count := Count + 1 ;
            end if;
         end loop;
      end loop;
      return Count;

   end Count_Islands;


 Map_Array : constant Map :=  ((1, 1, 0, 1, 1),
                               (1, 0, 1, 1, 1),
                               (1, 1, 0, 1, 1),
                               (1, 0, 1, 1, 1));
begin
   for i in N_Range loop
      for j in M_Range loop
         Put(Map_Array(i, j)'Img);
      end loop;
      Put_Line("");

   end loop;
   Put_Line("The result is:" & Count_Islands(Map_Array)'Img);

end Main;
