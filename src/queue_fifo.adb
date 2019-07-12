package body Queue_Fifo
 
is
   
   --PUSH
   
   procedure Push (Self : in out Queue; Elem : Element_Type) 
   is
      
   begin
     Self.Prepend(Elem);
   end Push;
 
   -- POP
   
   function Pop (Self : out Queue) return Element_Type
    
   is
      
      Res : Element_Type := Self.Last_Element;
      
   begin
    Self.Delete_Last;
      return Res; 
   end Pop;
   
end Queue_Fifo;
