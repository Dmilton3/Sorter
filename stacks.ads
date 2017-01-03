
GENERIC

   TYPE ItemType IS PRIVATE;
   WITH Procedure print(Item: ItemType);

package Stacks is

    type Stack is limited private;

    Stack_Empty, Stack_Full: exception;

    function isEmpty(S: Stack) return Boolean;
    function isFull(S: Stack) return Boolean;

    procedure push(Item: ItemType; S : in out Stack);
    procedure pop(S : in out Stack);

    function top(S: Stack) return ItemType;

    PROCEDURE Print(S: IN Stack);

private
    type StackNode;

    TYPE Stack IS ACCESS StackNode;


    type StackNode is record
        Item: ItemType;
        Next: Stack;
    end record;

end Stacks;