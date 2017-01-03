WITH Ada.Text_IO;        USE Ada.Text_IO;
WITH Ada.Integer_Text_IO;USE Ada.Integer_Text_IO;
WITH Queues;             WITH Stacks;
WITH Ada.Strings.Fixed;  USE Ada.Strings.Fixed;
WITH Ada.Exceptions;     USE Ada.Exceptions;

-- Name : Dewey Milton
-- Date : 06 December 2016
-- Purpose : Sorts a given list of Integer Knights into
--           a Ascending or Descending list calculated
--           by wins and losses
-- Pointers for Both Players and Name String Used


PROCEDURE Sorter IS

   --Exception List
   NoPlayers : EXCEPTION;
   Stack_Empty : EXCEPTION;
   Stack_Full : EXCEPTION;
   Queue_Empty : EXCEPTION;
   Queue_Full : EXCEPTION;





   TYPE NamePtr is access String; -- Used to assign player names

   TYPE Order IS (Ascending, Descending); --For selected Order Value

   PACKAGE Order_IO IS NEW Ada.Text_IO.Enumeration_IO(Order);
   USE Order_IO;  --Able to use Ada.Text methods for enumerated type


   --Player type that holds the following
   TYPE Player IS RECORD
      Name : NamePtr; --Player Name, Use of pointer.
      Skill : Positive; --Players skill
      Arrival : Natural := 0;  --players arrival time
      Wins : Natural := 0; --players wins
      Losses : Natural := 0; -- players losses
   END RECORD;



    TYPE PlayerPtr IS ACCESS Player;  --Pointer to a player



        ----------------------------------------------------------
        -- Purpose: Prints the values of a Player Record
        -- Parameters: Player Record
        -- Precondition: Unprinted Player values
        -- Postcondition: Printed Player values
        ----------------------------------------------------------
   PROCEDURE Print(P: Player) IS

   BEGIN

      Put(P.Arrival, 6);
      Put(P.Skill, 8);
      Put(P.Wins, 7);
      Put(P.Losses, 6);
      Put("     ");
      Put(P.Name.all);
      New_Line;

   END Print;


   PACKAGE MyStack IS NEW Stacks(Player, Print);
   USE MyStack;

   PACKAGE Arena IS NEW Queues(Player, Print);
   USE Arena;



   TYPE Tournament IS RECORD

      Winners : Arena.Queue; --Stores winner list

      -- Stores first row of contestants
      Field1 : Arena.Queue;

     -- Holds second round of games
      Field2 : Arena.Queue;

      --Stores the order the winners will be listed
      Ordr : Order;


   END RECORD;


       ----------------------------------------------------------
        -- Purpose: Stores the input of player info into records and queues
        -- Parameters: Tournament record with list to hold players
        -- Precondition: Tournament queues empty
        -- Postcondition: Tournament queues filled
        ----------------------------------------------------------
   PROCEDURE GatherKnights (Contest : IN OUT Tournament) IS

   Contestant : Player; --Stores player info

   Arrival : Natural := 0; --Calculates Arrival time

   BEGIN

      WHILE NOT End_Of_File LOOP

       Arrival := Arrival + 1;

       Contestant.Arrival := Arrival;

       Get(Contestant.Skill);

         DECLARE

            NewName : Constant String :=
               Trim(Get_Line, Ada.Strings.Both);  --Gets players name
          BEGIN
            --Stores player name
            Contestant.Name := new String'(NewName);

          END;
            --Adds player to the first field
          Enqueue(Contestant, Contest.Field1);

      END Loop;

    END;



                 ----------------------------------------------------------
        -- Purpose: Finds the winner between two knights, earliest arrival wins
        -- Parameters: Knight1, Knight2 : Player Record, Contest : Tournment Record
        -- Precondition: Winner Unknown
        -- Postcondition: Winner placed on Winner row, Scores adjusted
        ----------------------------------------------------------

    PROCEDURE FindLeastArrival(Knight1 : IN PlayerPtr; Knight2 : IN PlayerPtr;
                               Fighters : IN OUT Queue; Losers : IN OUT Queue) IS

    BEGIN

                IF Knight1.Arrival < Knight2.Arrival THEN

                   Knight1.Wins := Knight1.Wins + 1;
                   Knight2.Losses := Knight2.Losses + 1;

                  Enqueue(Knight1.all, Fighters);
                  Enqueue(Knight2.all, Losers);

                ELSE

                   Knight2.Wins := Knight2.Wins + 1;
                   Knight1.Losses := Knight1.Losses + 1;

                  Enqueue(Knight2.all, Fighters);
                  Enqueue(Knight1.all, Losers);

                END IF;

    END FindLeastArrival;


              ----------------------------------------------------------
        -- Purpose: Finds the winner between two knights with lowest losses
        -- Parameters: Knight1, Knight2 : Player Record,
        --            Contest : Tournment Record
        -- Precondition: Winner Unknown
        -- Postcondition: Winner placed on Winner row, Scores adjusted
        ----------------------------------------------------------

    PROCEDURE FindLeastLost(Knight1 : IN PlayerPtr; Knight2 : IN PlayerPtr;
                            Fighters : IN OUT Queue; Losers : IN OUT Queue) IS

    BEGIN

                IF Knight1.Losses < Knight2.Losses THEN

                   Knight1.Wins := Knight1.Wins + 1;
                   Knight2.Losses := Knight2.Losses + 1;

                  Enqueue(Knight1.all, Fighters);
                  Enqueue(Knight2.all, Losers);

                ELSIF Knight1.Losses = Knight2.Losses THEN

                    FindLeastArrival(Knight1, Knight2, Fighters, Losers);


                ELSE

                   Knight2.Wins := Knight2.Wins + 1;
                   Knight1.Losses := Knight1.Losses + 1;

                  Enqueue(Knight2.all, Fighters);
                  Enqueue(Knight1.all, Losers);

                END IF;

    END FindLeastLost;




               ----------------------------------------------------------
        -- Purpose: Finds the winner between two knights with most Wins
        -- Parameters: Knight1, Knight2 : Player Record,
         --            Contest : Tournment Record
        -- Precondition: Winner Unknown
        -- Postcondition: Winner placed on Winner row, Scores adjusted
        ----------------------------------------------------------

    PROCEDURE FindIfTie(Knight1 : IN PlayerPtr; Knight2 : IN PlayerPtr;
                        Fighters : IN OUT Queue; Losers : IN OUT Queue) IS

    BEGIN


                IF Knight1.Wins > Knight2.Wins THEN

                   Knight1.Wins := Knight1.Wins + 1;
                   Knight2.Losses := Knight2.Losses + 1;

                  Enqueue(Knight1.all, Fighters);
                  Enqueue(Knight2.all, Losers);

                ELSIF Knight1.Wins = Knight2.Wins THEN

                    FindLeastLost(Knight1, Knight2, Fighters, Losers);


                ELSE

                   Knight2.Wins := Knight2.Wins + 1;
                   Knight1.Losses := Knight1.Losses + 1;

                  Enqueue(Knight2.all, Fighters);
                  Enqueue(Knight1.all, Losers);

                END IF;

    END FindIfTie;

            ----------------------------------------------------------
        -- Purpose: Finds the winner between two knights
        -- Parameters: Knight1, Knight2 : Player Record, Contest : Tournment Record
        -- Precondition: Winner Unknown
        -- Postcondition: Winner placed on Winner row, Scores adjusted
        ----------------------------------------------------------

    PROCEDURE FindWinner(Knight1 : IN PlayerPtr; Knight2 : IN PlayerPtr;
                         Fighters : IN OUT Queue; Losers : IN OUT Queue) IS

    BEGIN

               IF Knight1.Skill > Knight2.Skill THEN

                  Knight1.Wins := Knight1.Wins + 1;
                  Knight2.Losses := Knight2.Losses + 1;

                  Enqueue(Knight1.all, Fighters);
                  Enqueue(Knight2.all, Losers);

                ELSIF Knight1.Skill = Knight2.Skill THEN

                    FindIfTie(Knight1, Knight2, Fighters, Losers);

                ELSE

                   Knight2.Wins := Knight2.Wins + 1;
                   Knight1.Losses := Knight1.Losses + 1;

                  Enqueue(Knight2.all, Fighters);
                  Enqueue(Knight1.all, Losers);

                END IF;

    END FindWinner;

        ----------------------------------------------------------
        -- Purpose: Processes the fights to find winners
        -- Parameters: Player Record
        -- Precondition: Unprinted Player values
        -- Postcondition: Printed Player values
        ----------------------------------------------------------

    PROCEDURE GamesBegin(Contest : IN OUT Tournament) IS

       Knight1 : PlayerPtr;

       Knight2 : PlayerPtr;

       EndGame : Boolean := False;

       Joust : Boolean := False; -- Jousting match completion

       SwordFight : Boolean := False; -- Sword match ended

    BEGIN

       --Loops until all matches are finished
       WHILE NOT EndGame LOOP

         --First Match
          WHILE NOT IsEmpty(Contest.Field1) LOOP

             --Assigns pointer to player

             Knight1 := new Player'(Front(Contest.Field1));

             Dequeue(Contest.Field1);

             --For only 1 knight in the list
             IF IsEmpty(Contest.Field1) THEN

                Enqueue(Knight1.all, Contest.Winners);

             ELSE

               --Assigns pointer to player 2
               Knight2 := new Player'(Front(Contest.Field1));

               Dequeue(Contest.Field1);

               FindWinner(Knight1, Knight2, Contest.Field1, Contest.Field2);


             END IF;
          END LOOP;


          --Match two
          WHILE NOT IsEmpty(Contest.Field2) LOOP

              -- Assign pointer to a player
             Knight1 := new Player'(Front(Contest.Field2));

             Dequeue(Contest.Field2);

             IF IsEmpty(Contest.Field2) THEN
                --Last on the list
                Enqueue(Knight1.all, Contest.Winners);

             ELSE
               --assign pointer to player two
               Knight2 := new Player'(Front(Contest.Field2));

               Dequeue(Contest.Field2);

               FindWinner(Knight1, Knight2, Contest.Field2, Contest.Field1);


             END IF;
          END LOOP;

          --Calculates the end of the games
          IF IsEmpty(Contest.Field1) THEN
             Joust := True;
          ELSE
             Joust := False;
          END IF;

          IF IsEmpty(Contest.Field1) THEN
             SwordFight := True;
          ELSE
             SwordFight := False;
          END IF;

          IF Joust AND SwordFight THEN
             EndGame := True;
          END IF;

       END LOOP;

    END;


         ----------------------------------------------------------
        -- Purpose: Prints the winner list in Ascending order
        -- Parameters: Tournament Record
        -- Precondition: Unprinted Stack
        -- Postcondition: Printed Output Stack
        ----------------------------------------------------------
    PROCEDURE PrintAsc(Contest : IN OUT Tournament) IS

      --Reverses win list
      AscList : Stack;

    BEGIN

     WHILE NOT IsEmpty(Contest.Winners) LOOP

             Push(Front(Contest.Winners), AscList);

             Dequeue(Contest.Winners);

          END LOOP;

       WHILE NOT IsEmpty(AscList) LOOP

             Print(Top(AscList));

             Pop(AscList);

          END Loop;


    END PrintAsc;


        ----------------------------------------------------------
        -- Purpose: Outputs win list in chosen order
        -- Parameters: Tournament Record
        -- Precondition: Unprinted Winners
        -- Postcondition: Printed Winners
        ----------------------------------------------------------
    PROCEDURE CallTheWinners(Contest : IN OUT Tournament) IS

    BEGIN


      Put("   Number  Skill  Wins  Losses  Name");New_Line;

       IF Contest.Ordr = Ascending THEN

          PrintAsc(Contest);

       ELSE

        Print(Contest.Winners);

       END IF;


    END CallTheWinners;


   --Record of Tournament Values
   Contest : Tournament;

BEGIN

   Get(Contest.Ordr);

   GatherKnights(Contest);

   IF IsEmpty(Contest.Field1) THEN
      RAISE NoPlayers WITH "Tournament post-poned, no players came today";
   ELSE

   GamesBegin(Contest);

   CallTheWinners(Contest);
   END IF;

EXCEPTION

   WHEN E: NoPlayers =>
      Put(Exception_Name(E));
      PUT(Exception_Message(E));

   WHEN E: End_Error =>
      Put(Exception_Name(E));
      Put(". No order value");

   WHEN E: Queue_Full =>
      Put(Exception_Name(E));
      Put(". Queue is full");

   WHEN E: Queue_Empty =>
      Put(Exception_Name(E));
      Put(". Queue is Empty");

   WHEN E: Stack_Empty =>
      Put(Exception_Name(E));
      Put(". Stack is Empty");

   WHEN E: Stack_Full =>
      Put(Exception_Name(E));
      Put(". Stack is Full");



END Sorter;

