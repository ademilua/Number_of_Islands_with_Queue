with Ada.Containers.Doubly_Linked_Lists;

generic
    type Element_Type is private;
    
 with function "=" (Left, Right : Element_Type)
 return Boolean is <>;
package Queue_Fifo
is
      
   package Queues is new Ada.Containers.Doubly_Linked_Lists
     (Element_Type => Element_Type,
      "="          => "=");
   
   type Queue is new Queues.List with null record;
   
   procedure Push (Self : in out Queue; Elem : Element_Type);
   
   function Pop (Self :  out Queue) return Element_Type;
 
end Queue_Fifo;
