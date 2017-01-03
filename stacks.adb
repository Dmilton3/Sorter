-- This is a partial dynamic implementation of the generic specification
--    for a stack abstract data type.

WITH Unchecked_Deallocation;


package body Stacks is

    procedure Dispose is
        new Unchecked_Deallocation (Object => StackNode,
                        Name   => Stack);


   function isFull (S : Stack) return Boolean is
        Tmp_Pointer : Stack;

    begin
        Tmp_Pointer := new StackNode;
        Dispose (Tmp_Pointer);
        return False;
    exception
        when STORAGE_ERROR =>
            return TRUE;
    END isFull;


    FUNCTION IsEmpty(S : Stack) RETURN Boolean IS

    BEGIN

       IF S = NULL THEN
          RETURN TRUE;
       ELSE
          RETURN False;
       END IF;
    END IsEmpty;


    PROCEDURE Pop(S : in out Stack) IS

      Current : Stack;

    BEGIN

       IF IsEmpty(S) THEN
          RAISE Stack_Empty;

       ELSIF S.Next = NULL THEN
          Dispose(S);
       ELSE

          Current := S.Next;

          Dispose(S);

          S := Current;
       END IF;

       END Pop;

       FUNCTION Top (S : IN Stack) RETURN ItemType IS

       BEGIN

          Return S.Item;

      END Top;

    procedure Push (Item : ItemType; S : in out Stack) is
    begin
        if isFull (S) then
            raise Stack_Full;
       ELSIF S = NULL THEN

          S := NEW StackNode'(Item, NULL);

       ELSE
          S := NEW StackNode'(Item, S);
        end if;
    END Push;

    PROCEDURE Print(S: IN Stack) IS

     Current : Stack;

    BEGIN

       Current := S;

       IF IsEmpty(S) THEN
          RAISE Stack_Empty;
       ELSIF Current /= NULL THEN

       WHILE Current /= NULL LOOP

          Print(Current.Item);

          Current := Current.Next;

          END LOOP;

       END IF;

    END Print;

end Stacks;