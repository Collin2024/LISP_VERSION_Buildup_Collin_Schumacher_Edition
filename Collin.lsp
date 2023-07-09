;initalize the seed
(setf *random-state* (make-random-state t))
#| *********************************************************************
Function Name: new_list
Purpose: used as a helper function for setting up a new list in a tournament
Parameters: num: the rounds won

Return Value: returns a blank list with 0 and num in it
Algorithm:
            return a blank list with 0 and num in it
Assistance Received:
none 
********************************************************************* |# 
(defun new_list () 
  (list 
    ;used as just a model for let expressions please ignore and don't over complicate me ;)
  )
)
#| *********************************************************************
Function Name: initial_player
Purpose: used as a helper function for setting up a new player in a tournament
Parameters: num: the rounds won

Return Value: returns a blank list with 0 and num in it
Algorithm:
            return a blank list with 0 and num in it
Assistance Received:
none 
********************************************************************* |# 
(defun initial_player (num) 
  (list 0 num)
)
#| *********************************************************************
Function Name: next_player
Purpose: used as a helper function for loading in the next player into game
Parameters: player: the player being loaded in

Return Value: returns a blank list with the player string in it
Algorithm:
           return a blank list with the player string in it
Assistance Received:
none 
********************************************************************* |# 
(defun next_player (player) 
  (list player)
)
#| *********************************************************************
Function Name: final_check
Purpose: final check to see if any other valid moves can be played before scoring
Parameters: game: the game 
            moves: the moves that can be played
            num: the index

Return Value: none
Algorithm:
           since this function is very long I'm going the summerize it
           it basically checks for any playable moves by using a final_check
           and it tries to funnel all possible moves for computer and human 
           if it detects a move it plays it automatically using remaining moves
           otherwise it scores the game
Assistance Received:
none 
********************************************************************* |# 
(defun final_check (moves game num)
   
  (cond
  ((= num 6)
    (score game)
  )
  ((= (first moves) 0)
   (score game)
  )
  ((< num 6)
  (let ((x(legal_placement (first (third (nth (abs(- (first moves) 1))game))) (nth num (first (nth (abs(- (second moves) 1))game))) game)))
    (cond
      ((null x)
      ;(final_check moves game (+ num 1))
       (cond 
        ((null (first (stack_cycle 1 game (first (third (nth (abs(- (first moves) 1))game))) 0 (new_list))))
            (cond
              ((null (first (stack_cycle 0 game (first (third (nth (abs(- (first moves) 1))game))) 0 (new_list))))
              (final_check moves game (+ num 1))
              ) 
              (t
                  (remaining_moves (cons (first moves) (cons (second moves) (first (stack_cycle 0 game (first (third (nth (abs(- (first moves) 1))game))) 0 (new_list))))) game)

              )
            )
        
        )
        (t
                      
          (remaining_moves (cons (first moves) (cons (second moves) (first (stack_cycle 1 game (first (third (nth (abs(- (first moves) 1))game))) 0 (new_list))))) game)

        )
       )
      
      ) 
      (t
        (let((y(cons (abs(- (second moves) 1)) x)))
          (cond
           ((null x)
            (final_check moves game (+ num 1))        
           )
           (t
           (remaining_moves (cons (first moves) y) game )
           )
            
           
            )
          )
          
        )
        
      )
    )
   
    
  )
  
  (T
    (cond
      ((null (rest (rest moves)))
      ;(make_move game 2)
      
       (final_check (cons (- (first moves) 1) '(1)) game 0)
     ; (exit)
     ;(make_move game 1)
      )
      
    )
  
  )
  )

)
#| *********************************************************************
Function Name: check_again
Purpose: checks to see if any other valid moves can be played before scoring
Parameters: game: the game 
            moves: the moves that can be played
            num: the index

Return Value: none
Algorithm:
           since this function is very long I'm going the summerize it
           it basically checks for any playable moves by using a final_check
           and it tries to funnel all possible moves for computer and human 
           if it detects a move it plays it automatically using remaining moves
           otherwise it goes to check_again function
Assistance Received:
none 
********************************************************************* |# 
(defun check_again (moves game num)


  (cond
  ((>= num 6)
  (final_check '(2 1) game 0)
    
  )
  ((null (third (second game)))
   (final_check '(1 1) game 3)
  )

  ((= (first moves) 0)
   (final_check '(2 0) game 0)
  )
  ((< num 6)
  (let ((x(legal_placement (first (third (nth (abs(- (first moves) 1))game))) (nth num (first (nth (abs(- (second moves) 1))game))) game)))
    (cond
      ((null x)
      (check_again moves game (+ num 1))
      
      ) 
      (t
        (let((y(cons (abs(- (second moves) 1)) x)))
          (cond
           ((null x)
             ;(last_resort (list 2 1) game (+ num 1))
            (check_again moves game (+ num 1))        
           )
           (t
           (remaining_moves (cons (first moves) y) game )
           )
            
           
            )
          )
          
        )
        
      )
    )
   
    
  )
  
  (T
    (cond
      ((null (rest (rest moves)))
       (check_again (cons (- (first moves) 1) '(0)) game 0)
      )
    )
  )
  )
)
#| *********************************************************************
Function Name: remaining_moves
Purpose: checks to see if any other valid moves can be played before scoring
Parameters: game: the game 
            moves: the moves that can be played
            num: the index

Return Value: none
Algorithm:
           since this function is very long I'm going the summerize it
           it basically checks for any playable moves by using a check_again and final_check
           and it tries to funnel all possible moves for computer and human 
           if it detects a move it plays it automatically using remaining moves
           otherwise it goes to check_again function
Assistance Received:
none 
********************************************************************* |# 
(defun last_resort (moves game num) 
      ; (princ "LAST_RESORT")

  (cond
  ((null (third (second game)))
  (check_again '(1 0) game 0)
  )
  ((null (third (first game)))
  (check_again '(2 0) game 0)
  )
  ((= (first moves) 0)
   (check_again '(2 1) game 0)
  )
   ((null (third (nth (- (first moves) 1) game)))
   (score game)
   )
  ((< num 6)
  (let ((x(legal_placement (first (third (nth (abs(- (first moves) 1))game))) (nth num (first (nth (abs(- (second moves) 1))game))) game)))
    (cond
      ((null x)
      (last_resort moves game (+ num 1))
      
      ) 
      (t
        (let((y(cons (abs(- (second moves) 1)) x)))
        ;(princ x)
          (cond
           ((null x)
             ;(last_resort (list 2 1) game )
            (last_resort '(2 0) game (+ num 1))        
           )
           (t
           (remaining_moves (cons (first moves) y) game)
           )
            
           
            )
          )
          
        )
        
      )
    )
   
    
  )
  
  (T
    (cond
      ((null (rest (rest moves)))
        
            (last_resort (cons (- (first moves) 1) '(1)) game 0)
        
        
      )
      
    )
  
  )
  )
  
)
#| *********************************************************************
Function Name: remaining_moves
Purpose: checks to see if any other valid moves can be played before scoring
Parameters: game: the game 
            moves: the moves that can be played
           

Return Value: none
Algorithm:
           since this function is very long I'm going the summerize it
           it basically checks for any playable moves by using a bunch of checker functions
           that were implemented if it doesn't detect any loaded moves 
           OTHERWISE it will AUTOMATICALLY INJECT THE INPUT for the player and update 
           the game and if that fails then it scores 
Assistance Received:
none 
********************************************************************* |# 
(defun remaining_moves (moves game)

;isolator for NO MOVES DEFUN A score game FUNCTION
(cond
  ((eq (third(second game)) (list nil))
  (score game)
  )
  ((null (rest (rest moves)))
          
(last_resort moves game 0)
      
  )
  
)


(let ((stack (cover game (rest (rest moves)) (second moves) 5 (new_list) 0)))

(let ((hand_len (length (third (nth (- (first moves) 1) game)))))
  (let((new_hand (draw_from_hand game (rest (rest moves)) (- (first moves) 1) (- (length (third (first game))) 1) (new_list))))
  (let ((current_player_turn (- (first moves) 1)))  
  (let ((bone_yard (second (second game))))
  (let ((stack_decision (second moves)))
    (cond
      ((eq (first moves) 1)
                                 (cond 
                        ((eq stack_decision 0)
                         (let 
                           ((human 
                              (cons (first (second game)) 
                                    (cons bone_yard 
                                          (cons (third (second game)) 
                                                (cons (fourth (second game)) 
                                                      (cons (fifth (second game)) 
                                                            (new_list)
                                                      )
                                                )
                                          )
                                    )
                              )
                            ) 
                           )
                           (let 
                             ((computer 
                                (cons stack 
                                      (cons (second (first game)) 
                                            (cons new_hand 
                                                  (cons (fourth (first game)) 
                                                        (cons (fifth (first game)) 
                                                              (new_list)
                                                        )
                                                  )
                                            )
                                      )
                                )
                              ) 
                             )
                             (let 
                               ((game 
                                  (cons computer 
                                        (cons human (next_player "Human"))
                                  )
                                ) 
                               )
                               (display_game game)
                               (cond
                                  ((eq (length (third(first game))) 0)
                                    (last_resort '(1 0) game 0)                               
                                  )
                                  (t
                                    (current_hand game 1)
                                  )
                                )
                               ;add a remaining_moves statement for the tail recursion
                               ;(current_hand (first moves) game)
                             )
                           )
                         )
                        )
                        ((eq stack_decision 1)
                         (let 
                           ((human 
                              (cons stack 
                                    (cons bone_yard 
                                          (cons (third (second game))  
                                                (cons (fourth (second game)) 
                                                      (cons (fifth (second game)) 
                                                            (new_list)
                                                      )
                                                )
                                          )
                                    )
                              )
                            ) 
                           )
                           (let 
                             ((computer 
                                (cons (first (first game)) 
                                      (cons (second (first game)) 
                                            (cons new_hand 
                                                  (cons (fourth (first game)) 
                                                        (cons (fifth (first game)) 
                                                              (new_list)
                                                        )
                                                  )
                                            )
                                      )
                                )
                              ) 
                             )
                             (let 
                               ((game 
                                  (cons computer 
                                        (cons human (next_player "Human"))
                                  )
                                ) 
                               )
                               (display_game game)
                                 (cond
                                  ((eq (length (third(second game))) 0)
                                   ;update moves to (1 1) for extra checking
                                    (last_resort '(1 0) game 0)                                  
                                  )
                                  (T
                                    (current_hand game 1);(cons (first game) (cons (second game) (new_list))) 2)
                                  )
                                )
                             )
                           )
                         )
                        )
                      )       
      )
      (t
                            (cond 
                        ((eq stack_decision 0)
                         (let 
                           ((human 
                              (cons (first (second game)) 
                                    (cons bone_yard 
                                          (cons new_hand 
                                                (cons (fourth (second game)) 
                                                      (cons (fifth (second game)) 
                                                            (new_list)
                                                      )
                                                )
                                          )
                                    )
                              )
                            ) 
                           )
                           (let 
                             ((computer 
                                (cons stack 
                                      (cons (second (first game)) 
                                            (cons (third (first game)) 
                                                  (cons (fourth (first game)) 
                                                        (cons (fifth (first game)) 
                                                              (new_list)
                                                        )
                                                  )
                                            )
                                      )
                                )
                              ) 
                             )
                             (let 
                               ((game 
                                  (cons computer 
                                        (cons human (next_player "Computer"))
                                  )
                                ) 
                               )
                               (display_game game)
                                (cond
                                  ((eq (length (third(second game))) 0)
                                      (last_resort '(2 0) game 0)
                                  )
                                  (T
                                    (current_hand game 2)
                                  )
                                )
                             )
                           )
                         )
                        )
                        ((eq stack_decision 1)
                         (let 
                           ((human 
                              (cons stack 
                                    (cons bone_yard 
                                          (cons new_hand 
                                                (cons (fourth (second game)) 
                                                      (cons (fifth (second game)) 
                                                            (new_list)
                                                      )
                                                )
                                          )
                                    )
                              )
                            ) 
                           )
                           (let 
                             ((computer 
                                (cons (first (first game)) 
                                      (cons (second (first game)) 
                                            (cons (third (first game)) 
                                                  (cons (fourth (first game)) 
                                                        (cons (fifth (first game)) 
                                                              (new_list)
                                                        )
                                                  )
                                            )
                                      )
                                )
                              ) 
                             )
                             (let 
                               ((game 
                                  (cons computer 
                                        (cons human (next_player "Computer"))
                                  )
                                ) 
                               )
                               (display_game game)
                               (cond
                                  ((eq (length (third(second game))) 0)
                                   ;update moves to (1 1) for extra checking
                                    (last_resort '(2 0) game 0)                                  
                                  )
                                  (T
                                    (current_hand game 2);(cons (first game) (cons (second game) (new_list))) 2)
                                  )
                                )
                               ;(current_hand (first moves) game)
                             )
                           )
                         )
                        )
                      )
      )
    )
      ; (princ stack)
      ; (terpri)
      ; (princ new_hand)
     
(score game)  )
  )
  )
  )

)
)
)

#| *********************************************************************
Function Name: inital_computer_boneyard
Purpose: computer boneyard model
Parameters: none
           
Return Value: returns the unshuffled computer boneyard
Algorithm:
           return the unshuffled computer boneyard
Assistance Received:
none 
********************************************************************* |#
(defun inital_computer_boneyard () 
  (list '(W 0 0) 
        '(W 0 1)
        '(W 0 2)
        '(W 0 3)
        '(W 0 4)
        '(W 0 5)
        '(W 0 6)
        '(W 1 1)
        '(W 1 2)
        '(W 1 3)
        '(W 1 4)
        '(W 1 5)
        '(W 1 6)
        '(W 2 2)
        '(W 2 3)
        '(W 2 4)
        '(W 2 5)
        '(W 2 6)
        '(W 3 3)
        '(W 3 4)
        '(W 3 5)
        '(W 3 6)
        '(W 4 4)
        '(W 4 5)
        '(W 4 6)
        '(W 5 5)
        '(W 5 6)
        '(W 6 6)
  )
)
#| *********************************************************************
Function Name: inital_human_boneyard
Purpose: human boneyard model
Parameters: none
           
Return Value: returns the unshuffled human boneyard
Algorithm:
           return the unshuffled human boneyard
Assistance Received:
none 
********************************************************************* |#
(defun inital_human_boneyard () 
  (list '(B 0 0) 
        '(B 0 1)
        '(B 0 2)
        '(B 0 3)
        '(B 0 4)
        '(B 0 5)
        '(B 0 6)
        '(B 1 1)
        '(B 1 2)
        '(B 1 3)
        '(B 1 4)
        '(B 1 5)
        '(B 1 6)
        '(B 2 2)
        '(B 2 3)
        '(B 2 4)
        '(B 2 5)
        '(B 2 6)
        '(B 3 3)
        '(B 3 4)
        '(B 3 5)
        '(B 3 6)
        '(B 4 4)
        '(B 4 5)
        '(B 4 6)
        '(B 5 5)
        '(B 5 6)
        '(B 6 6)
  )
)
#| *********************************************************************
Function Name: setup_stack
Purpose: setup the stack from the boneyard
Parameters: boneyard: the boneyard passed in
           
Return Value: returns loaded stack
Algorithm:
           load in the first 6 tiles from the boneyard and return that list
Assistance Received:
none 
********************************************************************* |#
(defun setup_stack (boneyard) 
  ;using let to its limit LOL :)
  (let 
    ((A (cons (sixth boneyard) (new_list))))
    (let 
      ((B (cons (fifth boneyard) A)))
      (let 
        ((C (cons (fourth boneyard) B)))
        (let 
          ((D (cons (third boneyard) C)))
          (let 
            ((E (cons (second boneyard) D)))
            (let 
              ((F (cons (first boneyard) E)))
              (cond 
                (t F)
              )
            )
          )
        )
      )
    )
  )
)
#| *********************************************************************
Function Name: display_game
Purpose: display the game in a readable format
Parameters: game the game LIST

Return Value: none
Algorithm:
           1. print each element in the correct order with text   
Assistance Received:
used to clear the console window
https://stackoverflow.com/questions/4882361/which-command-could-be-used-to-clear-screen-in-clisp 
********************************************************************* |# 
(defun display_game (game) 
  (screen:clear-window (screen:make-window))

  (princ "Computer: ")
  (terpri)
  (princ "Stacks: ")
  (terpri)
  (princ (first (first game)))
  (terpri)
  (princ "Boneyard: ")
  (terpri)
  (princ (second (first game)))
  (terpri)
  (princ "Hand: ")
  (terpri)
  (princ (third (first game)))
  (terpri)
  (princ "score game: ")
  (terpri)
  (princ (fourth (first game)))
  (terpri)
  (princ "Rounds Won: ")
  (terpri)
  (princ (fifth (first game)))
  (terpri)
  (terpri)

  (princ "Human ")
  (terpri)
  (princ "Stacks: ")
  (terpri)
  (princ (first (second game)))
  (terpri)
  (princ "Boneyard: ")
  (terpri)
  (princ (second (second game)))
  (terpri)
  (princ "Hand: ")
  (terpri)
  (princ (third (second game)))
  (terpri)
  (princ "score game: ")
  (terpri)
  (princ (fourth (second game)))
  (terpri)
  (princ "Rounds Won: ")
  (terpri)
  (princ (fifth (second game)))
  (terpri)
  (princ "Turn: ")
  (terpri)
  (princ (third game))
  (terpri)
(sleep 2)
 
)

#| *********************************************************************
Function Name: setup_boneyard
Purpose: setup and shuffle the boneyard
Parameters: boneyard: the boneyard passed in
            position: the index

Return Value: returns the created boneyard
Algorithm:
           1. if position is greater then 1 
           switch the elements around and deincrement position and recursively call this function
           OTHERWISE
           2. return boneyard
            
Assistance Received:
I used these resources to make the shuffling boneyard work correctly
https://github.com/yuval-ash1/Pinochle-LISP/blob/main/pinochle.lsp 
https://stackoverflow.com/questions/49490551/how-to-shuffle-list-in-lisp
********************************************************************* |# 
(defun setup_boneyard (bone_yard position) 
  (cond 
    ((> position 1)
     (rotatef 
       (elt bone_yard (random position))
       (elt bone_yard (- position 1))
     )
     (setup_boneyard bone_yard (- position 1))
    )
    (t
     bone_yard
    )
  )
)
#| *********************************************************************
Function Name: draw_from_boneyard
Purpose: remove the specified amount of tiles from the boneyard
Parameters: boneyard: the boneyard passed in
            times: the amount of tiles to remove
            iterator: the index

Return Value: returns updated bone yard
Algorithm:
           1. if iterator is less then or equal to times delete first file from boneyard increment iterator and recursively call this function
           OTHERWISE
           2. return boneyard
            
Assistance Received:
none 
********************************************************************* |# 
(defun draw_from_boneyard (boneyard times iterator) 
  (cond 
    
    ((<= iterator times)
     (draw_from_boneyard (rest boneyard) times (+ iterator 1))
    )
    (t
     boneyard
    )
  )
)
#| *********************************************************************
Function Name: setup_hand
Purpose: setup the hand from the boneyard
Parameters: boneyard: the boneyard passed in
            counter: the index

Return Value: returns loaded hand
Algorithm:
           1. if counter is 6 load in the first 6 tiles from the boneyard and return that list
           OTHERWISE
           2.  load in the first 4 tiles from the boneyard and return that list
            
Assistance Received:
none 
********************************************************************* |# 
(defun setup_hand (boneyard counter) 
  ;using let to its limit LOL :)
  (cond 
    ((eq counter 6)
     (let 
       ((A (cons (sixth boneyard) (new_list))))
       (let 
         ((B (cons (fifth boneyard) A)))
         (let 
           ((C (cons (fourth boneyard) B)))
           (let 
             ((D (cons (third boneyard) C)))
             (let 
               ((E (cons (second boneyard) D)))
               (let 
                 ((F (cons (first boneyard) E)))
                 F
               )
             )
           )
         )
       )
     )
    )
    (t
     (let 
       ((C (cons (fourth boneyard) (new_list))))
       (let 
         ((D (cons (third boneyard) C)))
         (let 
           ((E (cons (second boneyard) D)))
           (let 
             ((F (cons (first boneyard) E)))
             F
           )
         )
       )
     )
    )
  )
)
#| *********************************************************************
Function Name: domino_value_at_position
Purpose: get the numerical value of the specified 
Parameters: choice: the actual position we are looking at
            pile: The list of dominoes passed in

Return Value: returns the sum of the two faces
Algorithm:
           1. if choice is bigger then the pile length deincrement choice and recursively 
           call this function
           OTHERWISE
           2. return the sum of the two faces
            
Assistance Received:
none 
********************************************************************* |# 
(defun domino_value_at_position (choice pile) 
  (cond 
    ((>= choice (length pile))
     domino_value_at_position
     (- choice 1 pile)
    )
    (t
     (+ (+ (second (nth choice pile)) (+ (third (nth choice pile)))))
    )
  )
)
#| *********************************************************************
Function Name: stand_alone_domio_value
Purpose: get the numerical value of the specified 
Parameters: domino: the tile we are looking at

Return Value: returns 0 if it doesn't exist otherwise add up the two faces
Algorithm:
           1. return 0 if it doesn't exist otherwise add up the two faces
            
Assistance Received:
none 
********************************************************************* |#   
(defun stand_alone_domio_value (domino) 
(cond
  ((null domino)
    0
  )
  (T
  (+ (+ (second domino) (+ (third domino))))
  )
)

  
)
#| *********************************************************************
Function Name: load_player
Purpose: load the player
Parameters: stack: the list we are loading in 
            game: the game LIST

Return Value: returns the updated game
Algorithm:
           1. return (cons stack game)
            
Assistance Received:
none 
********************************************************************* |#   
(defun load_player (stack game) 
  (cons stack game)
)
#| *********************************************************************
Function Name: is_double_domino
Purpose: is the domino a double tile
Parameters: domino: the tile we are looking at

Return Value: returns 1 if its double otherwise return 0
Algorithm:
           1. determine the two faces and if the two facesd equal eachother eg (W 5 5)
           5 = 5 therefore it returns 1 
           OTHERWISE
           2.return 0
            
Assistance Received:
none 
********************************************************************* |#    
(defun load_list (computer_stack game) 
  (append computer_stack game)
)
#| *********************************************************************
Function Name: is_double_domino
Purpose: is the domino a double tile
Parameters: domino: the tile we are looking at

Return Value: returns 1 if its double otherwise return 0
Algorithm:
           1. determine the two faces and if the two facesd equal eachother eg (W 5 5)
           5 = 5 therefore it returns 1 
           OTHERWISE
           2.return 0
            
Assistance Received:
none 
********************************************************************* |#    
(defun is_double_domino (domino) 
  (let 
    ((first_face (second domino)))
    (let 
      ((second_face (third domino)))
      (cond 
        ((eq first_face second_face)
         ;double domino
         1
        )
        (t
         ;NON double domino
         0
        )
      )
    )
  )
)
#| *********************************************************************
Function Name: legal_placement
Purpose: is the move legal
Parameters: game: the game
            tile_hand: the selected domino from the hand
            tile_stack: index at the stack

Return Value: returns the the two pieces in a list if its legal eg tile_hand = W00 on tile_stack = B56 would return ((W 0 0)(B 5 6))
otherwise return nil  
Algorithm:
           1. if the tile hand tile does not exist then see who is the current player from the game list and that player makes the move
           OTHERWISE
           determine if the move is legal based on these guidelines
           A non-double tile may be placed on any tile as long as the total number of pips on it is greater than or equal to that of the tile on which it is placed.
A double tile (e.g., 0-0, 1-1, 2-2) may be placed on any non-double tile, even if the non-double tile has more pips.
A double tile may be placed on another double tile only if it has more total pips than the tile on which it is placed.
            
Assistance Received:
none 
********************************************************************* |#
(defun legal_placement (tile_hand tile_stack game) 
  (cond
    
    ((null tile_hand)
      (cond

        ((string-equal (third game) "Human")
            (cond
              ((eq (length (third (second game))) 0)
                (cond
                  ((eq (length (third (first game))) 0)
                                    (current_hand game 2)
                ;(last_resort '(2 1) game 0)
                  )
                  (T
                  (current_hand game 1)
                  
                  )
                )              
              )
               (T
                 (current_hand game 1)
                  ;(last_resort '(2 1) game 0)
               )
            )
          
          ;(exit)
        )
        (T
         (make_move game 2)    

          ;(exit)
        )
      )
    )
  )
  (let 
    ((hand_double (is_double_domino tile_hand)))
    (let 
      ((stack_double (is_double_domino tile_stack)))
      (let 
        ((hand_value (stand_alone_domio_value tile_hand)))
        (let 
          ((stack_value (stand_alone_domio_value tile_stack)))
          (cond 
            ;if the hand domino is a non double
            ((eq hand_double 0)
             (cond 
               ((>= hand_value stack_value)
                (let 
                  ((legal (cons tile_hand (cons tile_stack (new_list)))))
                  legal
                )
               )
               (t
                nil
               )
             )
            )
            ;if the hand domino is a double
            ((eq hand_double 1)
           
             (cond 
               ((eq stack_double 1)
                (cond 
                  ((> hand_value stack_value)
                   (let 
                     ((legal (cons tile_hand (cons tile_stack (new_list)))))
                     legal
                   )
                  )
                  (t
                  nil
                  )
                )
               )
               (t
                (let 
                  ((legal (cons tile_hand (cons tile_stack (new_list)))))
                  legal
                )
               )
             )
            )
            (t
             (let 
               ((legal (cons tile_hand (cons tile_stack (new_list)))))
               legal
             )
            )
          )
        )
      )
    )
  )
) 
#| *********************************************************************
Function Name: stack_cycle
Purpose: get moves that are valid at each stack position
Parameters: list_number: the stack we are looking at
            game: the game
            hand_domino: the selected domino from the hand
            select_stack: index at the stack
            moves: the valid moves one could play

Return Value: returns the moves that can be played if applicable USED WITH MOVE CHECKING FUNCTIONS like valid_moves
Algorithm:
           1. if the select_stack is less then 6
           2. if it can legally be placed recursively call stack_cycle and increment the select_stack and add the legal move to moves
           OTHERWISE 
           recursively call stack_cycle and increment the select_stack
           ELSE
           return moves

Assistance Received:
none 
********************************************************************* |#
(defun stack_cycle (list_number game hand_domino select_stack moves)  ; add A selector for which stack is desired humans or computers

  (cond 
    ((< select_stack 6)

     (let 
       ((A 
       
          (legal_placement 
            hand_domino
            (nth select_stack (nth 0 (nth list_number game)))
            game
          )
        )
        
        
       )
       (cond 
       

         ((> (length A) 0)
          (stack_cycle 
            list_number 

            game
            hand_domino
            (+ select_stack 1)
            (cons A moves)
          )
         )
         (t
         
         
          (stack_cycle list_number game hand_domino (+ select_stack 1) moves)
         )
       )
     )
    )
    (t
     moves
    )
  )
)
#| *********************************************************************
Function Name: spare_hand
Purpose: get moves that are valid (THIS IS USED AS A CHECKER)
Parameters: player: the current player 
            game: the game
            hand_size: the length of the hand
            hand_pos: the specified position of the hand
            moves: the legal moves
            stack_num: the stack that we ar e looking at

Return Value: returns the moves that can be played if applicable
Algorithm:
          this function is basically an extension of valid moves

Assistance Received:
none 
********************************************************************* |#
(defun spare_hand (player game hand_size hand_pos moves stack_num) 
  ; cycle through one tile in hand
  ; cycle through the stack in hand
  (cond 
    ((eq player 1)
    ; CULPRET is likely that it is not equal 
     (let 
       ((hand_domino (nth hand_pos (third (first game)))))
       
       (cond 
         ((< hand_pos hand_size)
            (cond
              ((eq hand_size 1)
              (valid_moves 
                player
                game
                hand_size
                hand_pos
                (stack_cycle stack_num game hand_domino 0 moves)
                stack_num
              )
              )
              (T
                (valid_moves 
                player
                game
                hand_size
              (+ hand_pos 1)
                (stack_cycle stack_num game hand_domino 0 moves)
                stack_num
              )
              )
            )
         )
         (T
        
          moves
         )
       )
     )
    )

    ((eq player 2)
     (let 
       ((hand_domino (nth hand_pos (third (second game)))))
       (cond 
         ((< hand_pos hand_size)
          (cond
            ((eq hand_size 1)
              (valid_moves 
                player
                game
                hand_size
              hand_pos
                (stack_cycle stack_num game hand_domino 0 moves)
                stack_num
              )
            )
            (t
               (valid_moves 
                player
                game
                hand_size
              (+ hand_pos 1)
                (stack_cycle stack_num game hand_domino 0 moves)
                stack_num
              )
            )
          )
         )
         (t
         
          moves
         )
       )
     )
    )
  )
)
#| *********************************************************************
Function Name: valid_moves
Purpose: get moves that are valid
Parameters: player: the current player 
            game: the game
            hand_size: the length of the hand
            hand_pos: the specified position of the hand
            moves: the legal moves
            stack_num: the stack that we ar e looking at

Return Value: returns the moves that can be played if applicable
Algorithm:
          steps are pretty much the same for both player one and two
          1. if hand_pos is less then hand_size then go through each stack value with stack_cycle
          and add in the legal moves and if there are no moves verify with the remaining moves function
          OTHERWISE return moves

Assistance Received:
none 
********************************************************************* |#
(defun valid_moves (player game hand_size hand_pos moves stack_num) 

  (cond 
    ((eq player 1)
     (let 
       ((hand_domino (nth hand_pos (third (first game)))))
       
       (cond             
      
         ((< hand_pos hand_size)
          (valid_moves 
            player
            game
            hand_size
            (+ hand_pos 1)
            (stack_cycle stack_num game hand_domino 0 moves)
            stack_num
          )
         )
          
         (t
          (cond
            ((null moves)
            
               
            (remaining_moves (cons player (cons stack_num (first moves))) game) 
            ) 
            (t
            (cond
              ((eq (length moves) 1)
                 ;(princ "FIRST_MOVES")
                 (remaining_moves (cons player (cons stack_num (first moves))) game)
              )
              (T
              
                moves
              )
            )
                
            )      
          )
            
         )
       )
     )
    )

    ((eq player 2)
     (let 
       ((hand_domino (nth hand_pos (third (second game)))))
       (cond 

        
         ((< hand_pos hand_size)

          (valid_moves 
            player
            game
            hand_size
            (+ hand_pos 1)
            (stack_cycle stack_num game hand_domino 0 moves)
            stack_num
          )
         )
         (t
           (cond
            ((null moves)              
            (remaining_moves (cons player (cons stack_num (first moves))) game)
            ) 
            (t
           (cond
              ((eq (length moves) 1)
              
                  (remaining_moves (cons player (cons stack_num (first moves))) game)
                
              )
              (T
                (cond 
                  ((null moves)
    
                    (remaining_moves (cons player (cons stack_num (first moves))) game)


                  )
                  (T
                    moves
                  )
                )
              )
            )
            )      
          )
         )
       )
     )
    )
  )
)
#| *********************************************************************
Function Name: computer_choice
Purpose: computer makes their stack choice
Parameters: game: the game 
            moves: the moves that can be played
Return Value: returns 0 to stack on computers side or returns 1 to stack on humans side (if applicable)
Algorithm:
           since this function is very long I'm going the summerize it
           it basically checks for any playable moves by using a bunch of checker functions
           that were implemented if it doesn't detect any loaded moves 
           OTHERWISE it will try to stack on players side if applicable and if not then it will stack on its own side
Assistance Received:
none 
********************************************************************* |#
(defun computer_choice (game moves) 
  (cond  
  ((null moves)
  (princ (valid_moves 1 game (length (third (first game))) 0 (new_list) 0))
  ;(sleep 4)
    (last_resort moves game 0)
  )
  ((> (length (valid_moves 1 game (length (third (first game))) 0 (new_list) 0)) 0)
		1
   )
  
  ((> (length (valid_moves 1 game (length (third (first game))) 0 (new_list) 1)))
    0
   )
    (t
    (last_resort '(2 1) game 0)

    )
  )
) 
#| *********************************************************************
Function Name: human_choice
Purpose: human makes their stack choice
Parameters: game: the game 
            moves: the moves that can be played
Return Value: returns 0 to stack on computers side or returns 1 to stack on humans side (if applicable)
Algorithm:
           since this function is very long I'm going the summerize it
           it basically checks for any playable moves by using a bunch of checker functions
           that were implemented if it doesn't detect any loaded moves 
           OTHERWISE it will allow for the human to determine which side it wants to stack on
Assistance Received:
none 
********************************************************************* |#
(defun human_choice (game moves) 
  ;(princ moves)

  (cond 
  ((null (third (second game)))
  (make_move game 1)
  )
   
      ((null moves)
            (last_resort moves game 0)
      
      )
      ((eq (length (valid_moves 2 game (length (third (second game))) 0 (new_list) 0)) nil)
            (last_resort moves game 0)
 
      )
    ((> (length (valid_moves 2 game (length (third (second game))) 0 (new_list) 1)))


     (cond 
       ((> 
          (length 
            (valid_moves 2 game (length (third (second game))) 0 (new_list) 0)
          )
          1
        )
        
        (princ "Please enter 1 to stack on your side or 2 to stack on opponents side")
        (let 
          ((choice (read)))
          (cond 
            ((eq choice 1)
             1
            )
            ((eq choice 2)
             0
            )
            (t
             (princ "Invalid input, Please try again")
             (terpri)
             (human_choice game moves)
            )
          )
        )
       )
       ((eq (length (valid_moves 2 game (length (third (first game))) 0 (new_list) 0)) 0)
        (cond
          ((eq (length (valid_moves 2 game (length (third (first game))) 0 (new_list) 1)) 0)

           (princ (spare_hand 2 game (length (third (first game))) 0 (new_list) 1))
            (terpri)
            3
          )
          (t
        (princ "Sorry but at this time you can only stack on your own stacks")
        (terpri)
        1
        )
        )
        
       )
     )
    )

    ((> (length (valid_moves 2 game (length (third (first game))) 0 (new_list) 0)) 
        0
     )
     (cond 
       ((eq 
          (length (valid_moves 2 game (length (third (first game))) 0 (new_list) 1))
          0
        )
        (princ "Sorry but at this time you can only stack on your opponent's stacks")
        (terpri)
        0
       )
     )
    )
    (t
     (princ "Sorry but at this time you cannot make any moves it is now the Computers turn")
     (terpri)
     3
    )
  )
)

#| *********************************************************************
Function Name: computer_move_selection
Purpose: computer makes their selected move
Parameters: game: the game 
            moves: the moves that can be played
Return Value: returns the move selection if applicable
Algorithm:
           since this function is very long I'm going the summerize it
           it basically checks for any playable moves by using a bunch of checker functions
           that were implemented if it doesn't detect any loaded moves 
           OTHERWISE it will allow for the computer to randomly generate their desired selection
           and if all else fails it will score the game
Assistance Received:
none 
********************************************************************* |# 
(defun computer_move_selection (moves game)

  (cond
    ((null moves)
      (let((A(length(spare_hand 1 game (length (third (first game))) 0 moves 0))))
      (let((B(length(spare_hand 1 game (length (third (first game))) 0 moves 1))))
        (cond
          ((eq B 0)
            (cond
              ((> A 0)
                (let((moves(spare_hand 1 game (length (third (first game))) 0 moves 0)))
                  (sleep 1)
                  (first moves)
                )
              )
              ((eq (length (third (second game))) 0)
              (score game)              
              )
              (t
                ; check opponent moves if possible then opponent moves otherwise add up score games
                (let((A(length(spare_hand 2 game (length (third (second game))) 0 moves 0))))
                    (let((B(length(spare_hand 2 game (length (third (second game))) 0 moves 1))))
                        (cond
                          ((eq B 0)
                            (cond
                              ((> A 0)
                                (let((moves(spare_hand 2 game (length (third (second game))) 0 moves 0)))
                                  (make_move game 2)
                                )
                              )
                              (t
                                (score game)                              
                              )

                            )
                          )
                          (T
                              (score game)                          
                          )
                        )
                    )
                )
              )
            )

          )
          (T
           (let((moves(spare_hand 1 game (length (third (first game))) 0 moves 1)))
                   (cond
                    ((> (length moves) 0)
                        (first moves)
                    )
                    (T
                      (score game)                    
                    )
                   )

           )
          )
        )
      )
     )
    
    )

     ((< (length moves) 2)
     (first moves)
     )
      ((eq (third (second game)) (list nil))
      (score game)
      )
     ((> (length moves) 2)
      (let ((moves (nth (random (length moves)) moves)))
        (princ "computer chose to move ")
        (princ (first moves))
        (princ " and stack on ")
        (princ (second moves))
        (sleep 3)
        moves
      )     
     )
 
  )
)

#| *********************************************************************
Function Name: human_move_selection
Purpose: human makes their selected move
Parameters: game: the game 
            moves: the moves that can be played
            num: this is the index

Return Value: returns the move selection if applicable
Algorithm:
           since this function is very long I'm going the summerize it
           it basically checks for any playable moves by using a bunch of checker functions
           that were implemented if it doesn't detect any loaded moves 
           OTHERWISE it will allow for the user to enter their desired selection
           and if all else fails it will score the game
Assistance Received:
none 
********************************************************************* |# 
(defun human_move_selection (moves num game) 
   
;(princ moves)
  (cond 
    ((null moves)
      (let((A(length(spare_hand 2 game (length (third (second game))) 0 moves 0))))
        (let((B(length(spare_hand 2 game (length (third (second game))) 0 moves 1))))
          (cond
            ((eq B 0)
              (cond
                ((> A 0)
                  (let((moves(spare_hand 2 game (length (third (second game))) 0 moves 0)))
                    (first moves)
                  )
                )
                ((eq (length (third (first game))) 0)
            (score game)                )
                (t
                   (let((A(length(spare_hand 1 game (length (third (first game))) 0 moves 0))))
                    (let((B(length(spare_hand 1 game (length (third (first game))) 0 moves 1))))
                        (cond
                          ((eq B 0)
                            (cond
                              ((> A 0)
                                (let((moves(spare_hand 1 game (length (third (first game))) 0 moves 0)))
                                  (make_move game 1)
                                )
                              )
                              (t
                                (score game)                              
                              )
                            )
                          )
                          (t
                              (score game)
                          )
                        )
                    )
                  )
                )
              )
            )
            (T
           (let((moves(spare_hand 2 game (length (third (second game))) 0 moves 1)))
                    (cond
                    ((> (length moves) 0)
                        
                        (first moves)
                    )
                    (t
                      (score game)                    
                    )
                   )
            )
          )
          )
        )
      )
    )
    ((eq (length moves) 1)
      (first moves)
    )
    ((<= num (length moves))
      (cond
          ((<= num 0)
            (princ " Invalid entry please Enter a number between 1 and ")
            (princ (length moves))
            (princ " based on the selected move you would like to play ")
            (terpri)
            (human_move_selection moves (read) game)
          )
          (T
            (nth (- num 1) moves)
          )
      )
    )
    
    (t
     (princ " Invalid entry please Enter a number between 1 and ")
     (princ (length moves))
     (princ " based on the selected move you would like to play ")
     (terpri)
     (human_move_selection moves (read) game)
    )
  ) 
)
#| *********************************************************************
Function Name: cover
Purpose: to play the selected domino from the hand and stack it on the specified stack
Parameters: game: the game 
            selection: the specified move selected
            stack_decision: the hand that will have a domino drawn 
            num: this is the index
            new: the new hand 
            covered: is it already covered
Return Value: returns the updated desired stack
Algorithm:
           1. if num is greater then or equal to zero then...
           if the num stack at num is equal to the first tile selected from selection
           then deincrement the counter along with adding the selected hand domino (AKA drawn_hand) and recursively call the function again 
           and make covered one
           OTHERWISE 
           2. recursively call the function again and add the domino found in stack to the 
           new parameter and deincrement num 
           ELSE 
           3. if num is 0 and covered is 0 return original stack
           ELSE
           4. repeat step 2
           ELSE 
           5. return the new stack
Assistance Received:
none 
********************************************************************* |# 
(defun cover (game selection stack_decision num new covered) 
  

  (let 
    ((stack (nth 0 (nth stack_decision game))))
    (let 
      ((drawn_hand (first selection)))
      (let 
        ((tile (second selection)))
        (cond 
      
          ((>= num 0)
           (cond 
             ((eq (nth num stack) tile)
             
              (cover game selection stack_decision (- num 1) (cons drawn_hand new) (+ covered 1))
             )
             ((eq num 0)
                  (cond
                    ((eq covered 0)
                      
                        stack
                        
                      
                    )
                     (t
                        (cover game selection stack_decision (- num 1) (cons (nth num stack) new) covered)
                     )
                    
                  )
              )     
             (t
              (cover 
                game
                selection
                stack_decision
                (- num 1)
                (cons (nth num stack) new)
                covered
              )
             )
           )
          )
          (t
           new
          )
        )
      )
    )
  )
)
#| *********************************************************************
Function Name: draw_from_hand
Purpose: to remove the selected domino from the hand
Parameters: game: the game 
            selection: the specified move selected
            stack_decision: the hand that will have a domino drawn 
            num: this is the index
            new: the new hand 
Return Value: returns the new hand
Algorithm:
           1. if num is greater then or equal to zero then...
           if the num stack at num is equal to the first tile selected from selection
           then deincrement the counter and recursively call the function again
           OTHERWISE 
           2. recursively call the function again and add the domino found in hand to the 
           new parameter and deincrement num 
           ELSE 
           3. return new
Assistance Received:
none 
********************************************************************* |#   
(defun draw_from_hand (game selection stack_decision num new) 

  (let 
    ((stack (nth 2 (nth stack_decision game))))
    (let 
      ((drawn_hand (first selection)))
      (let 
        ((tile (second selection)))
        (cond 
          ((>= num 0)
           (cond 

             ((eq (nth num stack) drawn_hand)
              (draw_from_hand game selection stack_decision (- num 1) new)
             )
             (t
              (draw_from_hand 
                game
                selection
                stack_decision
                (- num 1)
                (cons (nth num stack) new)
              )
             )
           )
          )
          (t
           (cond
            ((<= (length new) 3)
              (cond
              ;left in for future editors for ease of debugging
                ((eq (sixth stack) (first new))
                  ;(rest new)
                  new
                )
                (T
                
                  new
                )
              )
            )
            (t
              new
            )
           )
          )
        )
      )
    )
  )
)
#| *********************************************************************
Function Name: current_hand
Purpose: to play the current hand
Parameters: game: the game 
            player: the current player 
Return Value: none
Algorithm:
           1. if third hand is empty score game
           2. if the players hand is empty then opposing player plays
           OTHERWISE 
           3. if the player is one then player 2 makes the move
           OTHERWISE 
           4. if the computer hand is not empty then it moves
           OTHERWISE
           5. the human can play
Assistance Received:
none 
********************************************************************* |#   
(defun current_hand (game player)
  (cond
   ((null (first (third(second game))))
   (score game)
  
  )
    ((null (third (nth (- player 1) game)))
      (cond
        ((= player 1)
        (make_move game 2)
        )
        ((= player 2)
        (make_move game 1)
        )
      )
    )
  )

  (let ((game (make_move game player)))
    (cond
      ((= player 1)
        (current_hand game 2)
      )
      (t
        (cond
          ((> (length (third (first game))) 0)
            (current_hand game 1)
          ) 
          (t
            (current_hand game 2)
          ) 
        )
      
      )
    )
  )

)
#| *********************************************************************
Function Name: make_move
Purpose: to make a move 
Parameters: game: the game list 
            player: the current_player 
Return Value: returns the updated game
Algorithm:
           1. if computer hand is empty then score the game
           (please note I may have over complicated the recursion here)
           2. Else check if the hand length bigger then 0 if so make the move
           3. ELSE IF current_player is 1 then computer makes move 
           ELSE IF current_player is 2 then human makes its move 
           Below is the actual algorithm for each player (for the most part its the same)
           the specified player will choose on where it wants to stack (computer's side vs human's side)
           what domino it wants to play from its hand what domino it wants to cover
           After that it will cover the desired domino and delete it from the hand  
           4. then update the game list and determine who goes next         
           return game
Assistance Received:
none 
********************************************************************* |#   
(defun make_move (game current_player) 
  (cond 
    ((null (third (first game)))
      (score game)
    )
    ((> (- (length (third (second game))) 1) 0)
    (cond
        ((eq (nth (- (length (third (second game))) 1) (third (second game))) nil)
          (let ((revised (reverse (cdr (reverse (third (second game)))))))
            (let((A (cons (cons (first (second game))(cons (second (second game))(cons revised (cons (fourth (second game))(cons (fifth (second game)) (new_list)))))) (cons (third game) (new_list)))))
              (let((game (cons (first game )A)))
              (display_game game)
                (make_move game current_player)
              )
            )
          )
        )

        (T
          (cond
             ((eq current_player 1)
     (let 
       ((stack_decision (computer_choice game (valid_moves 
                 current_player
                 game
                 (length (third (first game)))
                 0
                 (new_list)
                 0
               ))))
       ;(princ (nth stack_decision game)) <- prints out all components of the player selected
       ;(terpri)
       (cond 
         ((< stack_decision 3)
          (let 
            ((move_selection 
               (valid_moves 
                 current_player
                 game
                 (length (third (first game)))
                 0
                 (new_list)
                 stack_decision
               )
             ) 
            )
           
            ;(terpri)
            (let 
              ((move_selection (computer_move_selection move_selection game)))
              (let 
                ((stack (cover game move_selection stack_decision 5 (new_list) 0)))
                (let 
                  ((bone_yard (second (second game))))

                  (let 
                    ((new_hand (draw_from_hand game move_selection (- current_player 1) (- (length (third (first game))) 1) (new_list))))
                     
                    (let 
                      ((current_player_turn (nth (- current_player 1) game)))
                      (cond 
                        ((eq stack_decision 0)
                         (let 
                           ((human 
                              (cons (first (second game)) 
                                    (cons bone_yard 
                                          (cons (third (second game)) 
                                                (cons (fourth (second game)) 
                                                      (cons (fifth (second game)) 
                                                            (new_list)
                                                      )
                                                )
                                          )
                                    )
                              )
                            ) 
                           )
                           (let 
                             ((computer 
                                (cons stack 
                                      (cons (second (first game)) 
                                            (cons new_hand 
                                                  (cons (fourth (first game)) 
                                                        (cons (fifth (first game)) 
                                                              (new_list)
                                                        )
                                                  )
                                            )
                                      )
                                )
                              ) 
                             )
                             (let 
                               ((game 
                                  (cons computer 
                                        (cons human (next_player "Human"))
                                  )
                                ) 
                               )
                               (display_game game)
                               game
                             )
                           )
                         )
                        )
                        ((eq stack_decision 1)
                         (let 
                           ((human 
                              (cons stack 
                                    (cons bone_yard 
                                          (cons (third (second game))  
                                                (cons (fourth (second game)) 
                                                      (cons (fifth (second game)) 
                                                            (new_list)
                                                      )
                                                )
                                          )
                                    )
                              )
                            ) 
                           )
                           (let 
                             ((computer 
                                (cons (first (first game)) 
                                      (cons (second (first game)) 
                                            (cons new_hand 
                                                  (cons (fourth (first game)) 
                                                        (cons (fifth (first game)) 
                                                              (new_list)
                                                        )
                                                  )
                                            )
                                      )
                                )
                              ) 
                             )
                             (let 
                               ((game 
                                  (cons computer 
                                        (cons human (next_player "Human"))
                                  )
                                ) 
                               )
                               (display_game game)
                               game
                             )
                           )
                         )
                        )
                      )
                    )
                  )
                )
              )
            )
          )
         )
         (t
          game
         )
       )
     )
    )
    ((eq current_player 2)

    

    ; (cond
    ; ((eq (third (second game)) nil)
           
    ; ;(score game) 
    ; )
    ; )
     (let 
       ((stack_decision (human_choice game (valid_moves 
                 current_player
                 game
                 (length (third (second game)))
                 0
                 (new_list)
                 0
               ))))
       ;(princ (nth stack_decision game)) <- prints out all components of the player selected
       ;(terpri)
       
       (cond 
         ((< stack_decision 3)
          (let 
            ((move_selection 
               (valid_moves 
                 current_player
                 game
                 (length (third (second game)))
                 0
                 (new_list)
                 stack_decision
               )
             ) 
            ) 
            (princ move_selection)
            (terpri)
            (princ "Enter a number between 1 and ")
            (princ (length move_selection))
            (princ " based on the selected move you would like to play ")
            (terpri)
            (let 
              ((move_selection (human_move_selection move_selection (read) game)))
             ; (princ move_selection)
              ;(sleep 3)
              (let 
                ((stack (cover game move_selection stack_decision 5 (new_list) 0)))
                (let 
                  ((bone_yard (second (second game))))

                  (let 
                    ((new_hand 
                       (draw_from_hand 
                         game
                         move_selection
                         (- current_player 1)
                         (- (length (third (second game))) 1)
                         (new_list)
                       )
                     ) 
                    )

                    (let 
                      ((current_player_turn (nth (- current_player 1) game)))
                      (cond 
                        ((eq stack_decision 0)
                         (let 
                           ((human 
                              (cons (first (second game)) 
                                    (cons bone_yard 
                                          (cons new_hand 
                                                (cons (fourth (second game)) 
                                                      (cons (fifth (second game)) 
                                                            (new_list)
                                                      )
                                                )
                                          )
                                    )
                              )
                            ) 
                           )
                           (let 
                             ((computer 
                                (cons stack 
                                      (cons (second (first game)) 
                                            (cons (third (first game)) 
                                                  (cons (fourth (first game)) 
                                                        (cons (fifth (first game)) 
                                                              (new_list)
                                                        )
                                                  )
                                            )
                                      )
                                )
                              ) 
                             )
                             (let 
                               ((game 
                                  (cons computer 
                                        (cons human (next_player "Computer"))
                                  )
                                ) 
                               )
                               (display_game game)
                               game
                             )
                           )
                         )
                        )
                        ((eq stack_decision 1)
                         (let 
                           ((human 
                              (cons stack 
                                    (cons bone_yard 
                                          (cons new_hand 
                                                (cons (fourth (second game)) 
                                                      (cons (fifth (second game)) 
                                                            (new_list)
                                                      )
                                                )
                                          )
                                    )
                              )
                            ) 
                           )
                           (let 
                             ((computer 
                                (cons (first (first game)) 
                                      (cons (second (first game)) 
                                            (cons (third (first game)) 
                                                  (cons (fourth (first game)) 
                                                        (cons (fifth (first game)) 
                                                              (new_list)
                                                        )
                                                  )
                                            )
                                      )
                                )
                              ) 
                             )
                             (let 
                               ((game 
                                  (cons computer 
                                        (cons human (next_player "Computer"))
                                  )
                                ) 
                               )
                               (display_game game)
                               game
                             )
                           )
                         )
                        )
                      )
                    )
                  )
                )
              )
            )

              )
            )
            (T
            (princ (spare_hand 
                 2
                 game
                 (length (third (first game)))
                 0
                 (new_list)
                 1
               ))
                (spare_hand 
                 2
                 game
                 (length (third (first game)))
                 0
                 (new_list)
                 1
               )
            )
          )
         )
    
       )
          )
        )
    )
    )
    
    ((eq current_player 1)
     (let 
       ((stack_decision (computer_choice game (valid_moves 
                 current_player
                 game
                 (length (third (first game)))
                 0
                 (new_list)
                 0
               ))))
       ;(princ (nth stack_decision game)) <- prints out all components of the player selected
       ;(terpri)
       (cond 
         ((< stack_decision 3)
          (let 
            ((move_selection 
               (valid_moves 
                 current_player
                 game
                 (length (third (first game)))
                 0
                 (new_list)
                 stack_decision
               )
             ) 
            )
           
            ;(terpri)
            (let 
              ((move_selection (computer_move_selection move_selection game)))
              (let 
                ((stack (cover game move_selection stack_decision 5 (new_list) 0)))
                (let 
                  ((bone_yard (second (second game))))

                  (let 
                    ((new_hand (draw_from_hand game move_selection (- current_player 1) (- (length (third (first game))) 1) (new_list))))
                     
                    (let 
                      ((current_player_turn (nth (- current_player 1) game)))
                      (cond 
                        ((eq stack_decision 0)
                         (let 
                           ((human 
                              (cons (first (second game)) 
                                    (cons bone_yard 
                                          (cons (third (second game)) 
                                                (cons (fourth (second game)) 
                                                      (cons (fifth (second game)) 
                                                            (new_list)
                                                      )
                                                )
                                          )
                                    )
                              )
                            ) 
                           )
                           (let 
                             ((computer 
                                (cons stack 
                                      (cons (second (first game)) 
                                            (cons new_hand 
                                                  (cons (fourth (first game)) 
                                                        (cons (fifth (first game)) 
                                                              (new_list)
                                                        )
                                                  )
                                            )
                                      )
                                )
                              ) 
                             )
                             (let 
                               ((game 
                                  (cons computer 
                                        (cons human (next_player "Human"))
                                  )
                                ) 
                               )
                               (display_game game)
                               game
                             )
                           )
                         )
                        )
                        ((eq stack_decision 1)
                         (let 
                           ((human 
                              (cons stack 
                                    (cons bone_yard 
                                          (cons (third (second game))  
                                                (cons (fourth (second game)) 
                                                      (cons (fifth (second game)) 
                                                            (new_list)
                                                      )
                                                )
                                          )
                                    )
                              )
                            ) 
                           )
                           (let 
                             ((computer 
                                (cons (first (first game)) 
                                      (cons (second (first game)) 
                                            (cons new_hand 
                                                  (cons (fourth (first game)) 
                                                        (cons (fifth (first game)) 
                                                              (new_list)
                                                        )
                                                  )
                                            )
                                      )
                                )
                              ) 
                             )
                             (let 
                               ((game 
                                  (cons computer 
                                        (cons human (next_player "Human"))
                                  )
                                ) 
                               )
                               (display_game game)
                               game
                             )
                           )
                         )
                        )
                      )
                    )
                  )
                )
              )
            )
          )
         )
         (t
          game
         )
       )
     )
    )
    ((eq current_player 2)

    

    (cond
    ((eq (length (third (second game))) 0)
           
    (make_move game 1)    
    )
    )
     (let 
       ((stack_decision (human_choice game (valid_moves 
                 current_player
                 game
                 (length (third (second game)))
                 0
                 (new_list)
                 0
               ))))
       ;(princ (nth stack_decision game)) <- prints out all components of the player selected
       ;(terpri)
       
       (cond 
         ((< stack_decision 3)
          (let 
            ((move_selection 
               (valid_moves 
                 current_player
                 game
                 (length (third (second game)))
                 0
                 (new_list)
                 stack_decision
               )
             ) 
            ) 
            (princ move_selection)
            (terpri)
            (princ "Enter a number between 1 and ")
            (princ (- (length move_selection) 1))
            (princ " based on the selected move you would like to play ")
            (terpri)
            (let 
              ((move_selection (human_move_selection move_selection (read) game)))
             ; (princ move_selection)
              ;(sleep 3)
              (let 
                ((stack (cover game move_selection stack_decision 5 (new_list) 0)))
                (let 
                  ((bone_yard (second (second game))))

                  (let 
                    ((new_hand 
                       (draw_from_hand 
                         game
                         move_selection
                         (- current_player 1)
                         (- (length (third (second game))) 1)
                         (new_list)
                       )
                     ) 
                    )

                    (let 
                      ((current_player_turn (nth (- current_player 1) game)))
                      (cond 
                        ((eq stack_decision 0)
                         (let 
                           ((human 
                              (cons (first (second game)) 
                                    (cons bone_yard 
                                          (cons new_hand 
                                                (cons (fourth (second game)) 
                                                      (cons (fifth (second game)) 
                                                            (new_list)
                                                      )
                                                )
                                          )
                                    )
                              )
                            ) 
                           )
                           (let 
                             ((computer 
                                (cons stack 
                                      (cons (second (first game)) 
                                            (cons (third (first game)) 
                                                  (cons (fourth (first game)) 
                                                        (cons (fifth (first game)) 
                                                              (new_list)
                                                        )
                                                  )
                                            )
                                      )
                                )
                              ) 
                             )
                             (let 
                               ((game 
                                  (cons computer 
                                        (cons human (next_player "Computer"))
                                  )
                                ) 
                               )
                               (display_game game)
                               game
                             )
                           )
                         )
                        )
                        ((eq stack_decision 1)
                         (let 
                           ((human 
                              (cons stack 
                                    (cons bone_yard 
                                          (cons new_hand 
                                                (cons (fourth (second game)) 
                                                      (cons (fifth (second game)) 
                                                            (new_list)
                                                      )
                                                )
                                          )
                                    )
                              )
                            ) 
                           )
                           (let 
                             ((computer 
                                (cons (first (first game)) 
                                      (cons (second (first game)) 
                                            (cons (third (first game)) 
                                                  (cons (fourth (first game)) 
                                                        (cons (fifth (first game)) 
                                                              (new_list)
                                                        )
                                                  )
                                            )
                                      )
                                )
                              ) 
                             )
                             (let 
                               ((game 
                                  (cons computer 
                                    (cons human (next_player "Computer"))
                                  )
                                ) 
                               )
                               (display_game game)
                               game
                             )
                           )
                         )
                        )
                      )
                    )
                  )
                )
              )
            )

              )
            )
            (T
            (princ (spare_hand 
                 2
                 game
                 (length (third (first game)))
                 0
                 (new_list)
                 1
               ))
                (spare_hand 
                 2
                 game
                 (length (third (first game)))
                 0
                 (new_list)
                 1
               )
            )
          )
         )
    
       )
     )
    )
#| *********************************************************************
Function Name: hand_total
Purpose: subtract the total hand_value for the respective player's score
Parameters: game: the game list 
            player: the current_player 
            total: the score passed in
            iterator: the index at which we are at in the recursion 
            stack_num: the specified stack we are looking at
Return Value: returns the updated total
Algorithm:
           1. if iterator is less then the length of the hand and if length of hand is greater then 0
           then subtract the domino value from the total and increment iterator and recursive call function
           ELSE IF the total is 0 return total
           ELSE
           return total
Assistance Received:
none 
********************************************************************* |#   
(defun hand_total (player total iterator game)
  (let ((A (length(third (nth (- player 1) game)))))
    (cond
      ((< iterator A)
        (cond
          ((> A 0)
            ;(princ "Hand length is ") (princ A)
            ;(terpri)
            (let ((B (stand_alone_domio_value(nth iterator (third (nth (- player 1) game))))))
               ; (princ total)
                ;(terpri)
                (hand_total player (- total B) (+ iterator 1) game)
            )
          )
          (T
            total
          )
        )
      )
      (T
        total
      )
  )
  )
   
)
#| *********************************************************************
Function Name: add
Purpose: add the total stack value (only counts based on the color) of the specified stack for the specified players score
Parameters: game: the game list 
            player: the current_player 
            color: the specified color 
            total: the total value of the stack (only includes bones that are the same color as the "color" parameter)
            iterator: the index at which we are at in the recursion 
            stack_num: the specified stack we are looking at
Return Value: returns the stack total
Algorithm:
           1. if iterator is less then 6 and if the first position of the bone matches color
           then add its value to the total and increment iterator and recursively call add
           ELSE
          return total
Assistance Received:
none 
********************************************************************* |#
(defun add (game player color total iterator stack_num) 

  (cond
      ((< iterator 6)
        (cond
          
          ((eq (nth stack_num(nth iterator (nth stack_num (nth (- player 1) game)))) color)
            (add game player color (+ total (stand_alone_domio_value (nth iterator (nth stack_num (nth (- player 1) game))))) (+ iterator 1) stack_num)
          )
          (T
            (add game player color total (+ iterator 1) stack_num)
          )
      

        )
      ) 
      (T
     
      total
      )
      
    )
)


#| *********************************************************************
Function Name: another_one
Purpose: does the user want to play another round
Parameters: game: the game list 
            choice: the passed in option
Return Value: none
Algorithm:
           1. if choice is not between 1 or 2 recursively prompt user again
           ELSE
           2. if choice is one then play a new round
           3. if choice is 2 then announce tournament winner and terminate
Assistance Received:
none 
********************************************************************* |#
(defun another_one (game choice)
  
    (cond
      ((eq choice 1)
      (screen:clear-window (screen:make-window))
      (new_round (fifth (first game)) (fifth (second game)))
      )
      ((eq choice 2)
        (cond
          ((> (fifth (first game)) (fifth (second game)))
            (princ "computer won the tournament with a score of ")
            (princ (fifth (first game)))
            (exit)

          )
           ((> (fifth (second game)) (fifth (first game)))
            (princ "Human won the tournament with a score of ")
            (princ (fifth (second game)))
            (exit)
            
          )
          (t
            (princ "tournament is a draw")
            (exit)
          )
        )
        
      )
      (t
        (princ "Invalid entry please try again")
        (terpri)
         (princ "Would you like to play another round?")
  (terpri)
  (princ "Enter 1 to play another round or 2 to quit")
        (another_one game (read))
      )
    )
  
)
#| *********************************************************************
Function Name: reload_hand
Purpose: reload the hands for each player
Parameters: game: the game list 
Return Value: none
Algorithm:
            1. if the length of the boneyards is greater then 4 then load the first 6 boneyard tiles into the respective hands 
            and remove those tiles from the boneyards 
            2. load updated components into the list
            3. if third element is human then human makes move otherwise computer makes move
            ELSE
            1. if the length of the boneyards is equal to 4 then load the last 4 boneyard tiles into the respective hands 
            and remove those tiles from the boneyards 
            2. load updated components into the list
            3. if third element is human then human makes move otherwise computer makes move
            ELSE 
            1. determine and announce winner and prompt user for another round if so then new_round is started else 
            tournament winner is announced and terminate the program

Assistance Received:
none 
********************************************************************* |#
(defun reload_hand (game)
  (cond
    ((> (length (second (second game))) 4)
     (let ((human (cons (first (second game)) (cons (draw_from_boneyard (second (second game)) 6 1) (cons (setup_hand (second (second game)) 6) (cons (fourth (second game)) (cons (fifth (second game)) (new_list))))))))
        (let ((computer (cons (first (first game)) (cons (draw_from_boneyard (second (first game)) 6 1) (cons (setup_hand (second (first game)) 6) (cons (fourth (first game)) (cons (fifth (first game)) (new_list))))))))
          (let ((game (cons computer(cons human(next_player (third game))))))
            (display_game game)
            (cond
              ((string-equal (third game) "Human")
                (current_hand game 2)
              )
              (t
                (current_hand game 1)
              )
            )
          )
        )
      
     )

    
    )
    ((= (length (second (second game))) 4)

    (let ((human (cons (first (second game)) (cons (draw_from_boneyard (second (second game)) 4 0) (cons (setup_hand (second (second game)) 4) (cons (fourth (second game)) (cons (fifth (second game)) (new_list))))))))
        (let ((computer (cons (first (first game)) (cons (draw_from_boneyard (second (first game)) 4 0) (cons (setup_hand (second (first game)) 4) (cons (fourth (first game)) (cons (fifth (first game)) (new_list))))))))
          (let ((game (cons computer(cons human(next_player (third game))))))
            (display_game game)
            (cond
              ((string-equal (third game) "Human")
                (current_hand game 2)
              )
              (t
                (current_hand game 1)
              )
            )
          )
        )
      
     )

    )
    (T
      (cond
        ((> (fourth (second game)) (fourth (first game)))
          (let ((human (cons (first (second game)) (cons (second (second game)) (cons (second (second game)) (cons (fourth (second game)) (cons (+ (fifth (second game)) 1) (new_list))))))))
            (let ((computer (cons (first (first game)) (cons (second (first game)) (cons (second (first game)) (cons (fourth (first game)) (cons (+ (fifth (first game)) 0) (new_list))))))))
              (let ((game (cons computer(cons human(next_player (third game))))))
                (display_game game)
                (princ "Human has won the round with a score of ")
                (princ (fourth (second game)))
                (terpri)
                 (princ "Would you like to play another round?")
  (terpri)
  (princ "Enter 1 to play another round or 2 to quit")
                (another_one game (read))
              )
            )          
          )
          
          
        )
        ((> (fourth (first game)) (fourth (second game)))
         (let ((human (cons (first (second game)) (cons (second (second game)) (cons (second (second game)) (cons (fourth (second game)) (cons (+ (fifth (second game)) 0) (new_list))))))))
            (let ((computer (cons (first (first game)) (cons (second (first game)) (cons (second (first game)) (cons (fourth (first game)) (cons (+ (fifth (first game)) 1) (new_list))))))))
              (let ((game (cons computer(cons human(next_player (third game))))))
                (display_game game)   
                (princ "Computer has won the round with a score of ")
                (princ (fourth (first game)))
                (terpri)
                 (princ "Would you like to play another round?")
  (terpri)
  (princ "Enter 1 to play another round or 2 to quit")
                (another_one game (read))
              )
            )          
          )
       
          
        )
        (t
          (princ "game is tied ")
          (terpri)
           (princ "Would you like to play another round?")
  (terpri)
  (princ "Enter 1 to play another round or 2 to quit")
           (another_one game (read))
        )
      )
    )
  )
)
#| *********************************************************************
Function Name: score
Purpose: determines the score of the player
Parameters: game: the game list 
Return Value: none
Algorithm:
            1. determine the the dominoe total from the stacks eg: black domino total for human and white domino for computer
            2. subtract the total hand difference from the players calculated score eg dominoe total from the stacks - total hand value and clear the hand
            3. load in the scores into game display the updated game and reload hand (if applicable)
Assistance Received:
none 
********************************************************************* |#
(defun score (game)
(princ "At this time there are no more playable moves. Time to add up the scores for this hand")
(sleep 6)
(let ((A(add game 1 (first (first (inital_computer_boneyard))) (fourth (first game)) 0 0)))
  (let ((B(add game 2 (first (first (inital_computer_boneyard))) A 0 0)))
     (let ((F(hand_total 1 B 0 game)))
     (let ((C(add game 2 (first (first (inital_human_boneyard))) (fourth (second game)) 0 0)))
      (let ((D(add game 1 (first (first (inital_human_boneyard))) C 0 0)))
        (let ((E(hand_total 2 D 0 game)))
          (let ((computer (cons (first (first game)) (cons (second (first game)) (cons (rest '()) (cons F (cons (fifth (first game)) (new_list))))))))
            
            (let ((human (cons (first (second game)) (cons (second (second game)) (cons (rest '()) (cons E (cons (fifth (second game)) (new_list))))))))
              (princ computer)
              (terpri)     
              (princ human)
              (terpri)
              (cond
                ((string-equal (third game) "Computer")
                (let ((game (cons computer(cons human(next_player "Human")))))
                  (display_game game)
                  (reload_hand game)
                )
                )
                ((string-equal (third game) "Human")
                (let ((game(cons computer(cons human(next_player "Computer")))))
                  (display_game game)
                   (reload_hand game)
                )
                    
                )
              )
            )
          )
        )
      )
    )
    )
  )
)
)

#| *********************************************************************
Function Name: new_round
Purpose: creates the new round
Parameters: Cwins: the round wins of the computer 
            Hwins: the round wins of the human
Return Value: none
Algorithm:
            1. sets up new pieces and determine who goes first 
            2. if the first 2 drawn dominoes of their respective players are equal reset pieces and start again
            3. else first player makes their move
Assistance Received:
none 
********************************************************************* |#
(defun new_round (Cwins Hwins) 
  (let 
    ((computer_boneyard 
       (setup_boneyard 
         (inital_computer_boneyard)
         (length (inital_computer_boneyard))
       )
     ) 
    )
    (let 
      ((computer_stack (setup_stack computer_boneyard)))

      (let 
        ((human_boneyard 
           (setup_boneyard 
             (inital_human_boneyard)
             (length (inital_human_boneyard))
           )
         ) 
        )

        (let 
          ((human_stack (setup_stack human_boneyard)))
          (let 
            ((computer_boneyard (draw_from_boneyard computer_boneyard 6 1)))
            (let 
              ((computer_hand (setup_hand computer_boneyard 6)))
              (let 
                ((computer_boneyard (draw_from_boneyard computer_boneyard 6 1)))
                (let 
                  ((human_boneyard (draw_from_boneyard human_boneyard 6 1)))
                  (let 
                    ((human_hand (setup_hand human_boneyard 6)))
                    (let 
                      ((human_boneyard (draw_from_boneyard human_boneyard 6 1)))
                      (princ "Computer")
                      (terpri)
                      (princ computer_stack)
                      (terpri)
                      (princ "Boneyard")
                      (terpri)
                      (princ computer_boneyard)
                      (terpri)
                      (princ "Hand")
                      (terpri)
                      (princ computer_hand)
                      (terpri)
                      (terpri)
                      (princ "Human")
                      (terpri)
                      (princ "stacks")
                      (terpri)
                      (princ human_stack)
                      (terpri)
                      (princ "Boneyard")
                      (terpri)
                      (princ human_boneyard)
                      (terpri)
                      (princ "Hand")
                      (terpri)
                      (princ human_hand)
                      (terpri)
                      (let 
                        ((first_human_domino 
                           (domino_value_at_position 0 human_hand)
                         ) 
                        )
                        (let 
                          ((first_computer_domino 
                             (domino_value_at_position 0 computer_hand)
                           ) 
                          )
                          (cond 
                            ((> first_computer_domino first_human_domino)
                             ;https://stackoverflow.com/questions/4882361/which-command-could-be-used-to-clear-screen-in-clisp
                             ;(screen:clear-window (screen:make-window))
                            
                             (let 
                               ((A (load_player human_hand (initial_player Hwins))))
                               (let 
                                 ((B (load_player human_boneyard A)))
                                 (let ((C (load_player human_stack B)))
                                   
                                  (let ((E (load_player computer_hand (initial_player Cwins))))
                                    (let ((F (load_player computer_boneyard E)))
                                 (let ((G (load_player computer_stack F)))
                                 
                                  (let((game (cons G (cons C(append (next_player "Computer") (new_list))))))
                                    (princ "Computer goes first becuase it drew a bigger domino it drew ")
                                    (princ (first (third (first game))))
                                    (princ " while human drew ")
                                    (princ (first (third (second game))))
                                    (sleep 5)
                                    (display_game game)
                                    (current_hand game 1)
                                    
                                  )
                                 )
                               )
                             )                        
                                 )
                               )
                             )
                            )
                               
                             
                            
                            ((> first_human_domino first_computer_domino)
                             ;(screen:clear-window (screen:make-window))
                            
                             (let 
                               ((A (load_player human_hand (initial_player Hwins))))
                               (let 
                                 ((B (load_player human_boneyard A)))
                                 (let ((C (load_player human_stack B)))
                                   
                                  (let ((E (load_player computer_hand (initial_player Cwins))))
                                    (let ((F (load_player computer_boneyard E)))
                                 (let ((G (load_player computer_stack F)))
                                  ;(princ G)
                                  ;(terpri)
                                  ;(princ C)
                                  (let((game (cons G (cons C(append (next_player "Human") (new_list))))))
                                    (princ "Human goes first becuase it drew a bigger domino it drew ")
                                    (princ (first (third (second game))))
                                    (princ " while computer drew ")
                                    (princ (first (third (first game))))
                                    (sleep 5)
                                    (display_game game)
                                    (current_hand game 2)
                                  )
                                 )
                               )
                             )                        
                                 )
                               )
                             )
                            )
                            (t
                             (screen:clear-window (screen:make-window))
                             (new_round Cwins Hwins)
                            )
                          )
                        )
                      )
                    )
                  )
                )
              )
            )
          )
        )
      )
    )
  )
)
#| *********************************************************************
Function Name: serial
Purpose: creates the actual loaded game from the loaded serial file
Parameters: game: the loaded game
Return Value: none
Algorithm:
            1. Determines the who is supposed to go first by determing what the third item (third game) is "HUMAN" or "COMPUTER" and the 
            corresponding player will make a move 
            2. ELSE if there is no third game item then setup all stacks hands and boneyards and from 
            there determine who goes first if the two first drawn tiles numerically equal each other reset and start a new round
            3. ELSE the player that goes first make their move respectively
Assistance Received:
none 
********************************************************************* |#
(defun serial (game)
  (cond
    ((null (third game))
      (cond
        ((= (length (second (second game))) 22)
          (screen:clear-window (screen:make-window))
          (cond
            ((= (stand_alone_domio_value (first (second (first game)))) (stand_alone_domio_value (first (second (second game)))))
                (screen:clear-window (screen:make-window))
                (princ "Dominoes are equal stacks, boneyards, and hands will now reset")
                (sleep 5)
                (screen:clear-window (screen:make-window))

                (new_round (fifth (first game)) (fifth (second game)))
            )
            (T
                (let ((human (cons (first (second game)) (cons (draw_from_boneyard (second (second game)) 6 0) (cons (setup_hand (second (second game)) 6) (cons (fourth (second game)) (cons (fifth (second game)) (new_list))))))))
               ; (princ human)
                  (let ((computer (cons (first (first game)) (cons (draw_from_boneyard (second (first game)) 6 0) (cons (setup_hand (second (first game)) 6) (cons (fourth (first game)) (cons (fifth (first game)) (new_list))))))))
                    (let ((game (cons computer (cons human (new_list)))))
                      (display_game game)

                      (cond
                        ((> (stand_alone_domio_value (first (third (first game)))) (stand_alone_domio_value (first (third (second game)))))
                          (princ "Computer goes first becuase it drew a bigger domino it drew ")
                          (princ (first (third (first game))))
                          (princ " while human drew ")
                          (princ (first (third (second game))))
                          (sleep 5)
                          (display_game (append game (next_player "Computer")))
                          (current_hand (append game (next_player "Computer")) 1)
                        )
                        ((= (stand_alone_domio_value (first (second (first game)))) (stand_alone_domio_value (first (second (second game)))))
                          (screen:clear-window (screen:make-window))
                          (princ "Dominoes are equal stacks, boneyards, and hands will now reset ")
                          (sleep 5)
                          (screen:clear-window (screen:make-window))

                          (new_round (fifth (first game)) (fifth (second game)))
                        )
                        (T
                          (princ "Human goes first becuase it drew a bigger domino it drew ")
                          (princ (first (third (second game))))
                          (princ " while computer drew ")
                          (princ (first (third (first game))))
                          (sleep 5)
                          (display_game (append game (next_player "Human")))
                          (current_hand (append game (next_player "Human")) 2)
                        )
                      )
                    )
                
                  )
                )

            )

          )
        )
        
      )
    )
    (T
    (display_game game)
      (cond
        ((string-equal (third game) "Human")
          (current_hand game 2)
        )
        (T
          (current_hand game 1)
        )
      )
    )
  )
)
#| *********************************************************************
Function Name: valid_welcome_menu
Purpose: validates the opening menu input
Parameters: none
Return Value: returns the validated input (1-3)
Algorithm:
            1. reads input and if it is within range (1-3) return the inputed number
            2. ELSE recursively call the game menu
Assistance Received:
none 
********************************************************************* |#
(defun valid_welcome_menu () 
  (let 
    ((choice (read)))
    (cond 
      ((= choice 1)
       1
      )
      ((= choice 2)
       2
      )
      ((= choice 3)
       3
      )
      (t
       (princ "Invalid input, Please try again")
       (terpri)
       (Game_menu)
      )
    )
  )
)
#| *********************************************************************
Function Name: game_grabber
Purpose: get the game LIST (serialization)
Parameters: file: the file to be read
Return Value: returns the game list AKA the file_contents 
Algorithm:
            1. reads the file 
            2. returns the file contents this function works with in loadfile
Assistance Received: 
https://github.com/yuval-ash1/Pinochle-LISP/blob/main/pinochle.lsp (lines 1534 - 1549)
********************************************************************* |#
(defun game_grabber (file)

        (let* ((in (open file))

                   (file_contents (read in)))

                (close in)

                file_contents

        )

)
#| *********************************************************************
Function Name: loadfile
Purpose: loads the game (serialization)
Parameters: file: the file to be read
Return Value: returns the game list
Algorithm:
            1. reads the file 
            2. if the file doesn't exist prompt user again recursively
            3. Else return the game LIST
Assistance Received: 
https://github.com/yuval-ash1/Pinochle-LISP/blob/main/pinochle.lsp (lines 1534 - 1549)
********************************************************************* |#
(defun loadfile (file)
        (cond
          ((null (probe-file file))
             (screen:clear-window (screen:make-window))
            (princ "ERROR: file does not exist please try again")
            (terpri)    
            (princ "please enter the specified file name ")
            (terpri)
            (loadfile (read))
          )
          (t
            (game_grabber file)
          )
        )
)

#| *********************************************************************
Function Name: Game_menu
Purpose: displays menu for the game and does its action based on its valid selection
Parameters: none
Return Value: none
Algorithm:
            1. run game menu and if user enters 1 then load a game 
            2. if user enters 2 play a new game 
            3. otherwise quit
Assistance Received: none
********************************************************************* |#
(defun Game_menu () 
  (princ "Welcome to Buildup please choose from one of the following options")
  (terpri)
  (princ "1. load a game")
  (terpri)
  (princ "2. Play a new game")
  (terpri)
  (princ "3. Quit")
  (terpri)
  (let* 
    ((selection (valid_welcome_menu)))
    (cond 
      ((= selection 1)
       (screen:clear-window (screen:make-window))
       (princ "please enter the specified file name ")
       (terpri)
        (serial (loadfile(read)))
      )
      ((= selection 2)
       (new_round 0 0)
      )
      ((= selection 3)
       (princ "closing Build Up until next time")
       (terpri)
       (exit)
      )
    )
  )
)
#| *********************************************************************
Function Name: main
Purpose: main executer
Parameters: none
Return Value: none
Algorithm:
            run game menu
Assistance Received: none
********************************************************************* |#
(defun main () 
  (Game_menu)
)
;............................................... execute the driver HERE ..............................................
(main)