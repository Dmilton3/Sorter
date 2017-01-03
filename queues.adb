-- Name : Dewey Milton
-- Date : 7 December 2016
-- Purpose : Pkg Body for a queue

WITH Unchecked_Deallocation;

PACKAGE BODY Queues IS


        ----------------------------------------------------------
        -- Purpose: Disposes pointers current reference
        -- Parameters: Player Record
        -- Precondition: Unprinted Player values
        -- Postcondition: Printed Player values
        ----------------------------------------------------------
      PROCEDURE Dispose IS
      NEW Unchecked_Deallocation (Object => QueueNode,
      Name  => QueueNodePointer);

    FUNCTION IsFull (Q : Queue) RETURN Boolean IS

      Tmp_Pointer : QueueNodePointer;

   BEGIN

      Tmp_Pointer := NEW QueueNode;
      Dispose (Tmp_Pointer);
      RETURN False;

   EXCEPTION
      WHEN STORAGE_ERROR =>
         RETURN TRUE;
   END IsFull;


   FUNCTION IsEmpty(Q: Queue) RETURN Boolean IS

   BEGIN

      IF Q.Front /= NULL THEN
         RETURN False;
      ELSE
         RETURN True;
      END IF;
   END IsEmpty;


   FUNCTION Size(Q: Queue) RETURN Natural IS

   BEGIN

    Return Q.Count;

   END Size;

   PROCEDURE Print (Q : IN Queue) IS

      Current : QueueNodePointer;
   BEGIN

      Current := Q.Front;

      IF IsEmpty(Q) THEN
         RAISE Queue_Empty;
      ELSIF Current /= NULL THEN

         WHILE Current /= Null LOOP

            Print(Current.Data);
            Current := Current.all.next;
         END LOOP;

      END IF;

   END Print;




   FUNCTION Front(Q: Queue) RETURN ItemType IS

   BEGIN

      RETURN Q.Front.Data;

   END Front;

      PROCEDURE Enqueue(Item: ItemType; Q: IN OUT Queue) IS 
      NewNode : QueueNodePointer;

      BEGIN
         
     IF isEmpty(Q) THEN
            Q.Front := NEW QueueNode'(Item, NULL);
            Q.Count := Q.Count + 1;

      ELSIF IsFull(Q) THEN
            RAISE Queue_Full;

      ELSIF Q.Front.All.Next = NULL THEN

            Q.Back := NEW QueueNode'(Item, NULL);

            Q.Front.All.Next := Q.Back;

            Q.Count := Q.Count + 1;

         ELSE

            NewNode := New QueueNode'(Item, Null);

            Q.Back.All.Next := NewNode;

            Q.Back := Q.Back.All.Next;

            Q.Count := Q.Count + 1;

     END IF;

   END Enqueue;


   PROCEDURE Dequeue(Q: IN OUT Queue) IS

   Current : QueueNodePointer;

   BEGIN


    IF NOT IsEmpty(Q) THEN

        IF Q.Front.Next /= NULL THEN
            Current := Q.Front.Next;
            Dispose(Q.Front);
            Q.Front := Current;
            Q.Count := Q.Count - 1;
         ELSE
            Q.Count := Q.Count - 1;
            Dispose(Q.Front);
        END IF;

    ELSE
         RAISE Queue_Empty;
    END IF;

   END Dequeue;





 END Queues;
