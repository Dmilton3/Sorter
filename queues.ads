-- This is the generic specification for a dynamic queue abstract data type.

generic

   TYPE ItemType IS PRIVATE;
   WITH PROCEDURE Print(Item: ItemType);


package Queues is

    type Queue is limited private;

    Queue_Empty, Queue_Full: exception;

    function  isEmpty(Q: Queue) return Boolean;
    FUNCTION  IsFull(Q: Queue) RETURN Boolean;

   function  size(Q: Queue) return Natural;

    function  front(Q: Queue) return ItemType;

    procedure enqueue (Item: ItemType; Q: in out Queue);
    PROCEDURE Dequeue (Q: IN OUT Queue);

    PROCEDURE Print(Q: IN Queue);

private

    type QueueNode;

    type QueueNodePointer is access QueueNode;

    type QueueNode is record
        Data: ItemType;
        Next: QueueNodePointer;
    end record;

    type Queue is record
        Front: QueueNodePointer := NULL;
        Back: QueueNodePointer := NULL;
        Count: Natural := 0;
    end record;

end Queues;