CLASS lhc_comment DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS getNextCommentNum FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Comment~getNextCommentNum.

ENDCLASS.

CLASS lhc_comment IMPLEMENTATION.

  METHOD getNextCommentNum.
    DATA:
      max_comment_num TYPE zde_comment_count,
      update          TYPE TABLE FOR UPDATE ZI_Dev\\Comment.

    "Read all Developments for the requested Comments.
    "If multiple comments of the same development are requested,
    "the Development is returned only once.
    READ ENTITIES OF ZI_Dev IN LOCAL MODE
    ENTITY Comment BY \_Development
      FIELDS ( DevUuid )
      WITH CORRESPONDING #( keys )
      RESULT DATA(developments).

    " Process all affected Developments.
    " Read respective comments, to determine the max-id
    " and update the bookings without ID.
    LOOP AT developments INTO DATA(development).
      READ ENTITIES OF ZI_Dev IN LOCAL MODE
        ENTITY Development BY \_Comment
          FIELDS ( CommentCount )
        WITH VALUE #( ( %tky = development-%tky ) )
        RESULT DATA(comments).

      "Find max used Comment Number under all Comments of this Development
      DATA(max_comment_count) = REDUCE zde_comment_count( INIT res = '0000' FOR line IN comments
        NEXT res = COND #( WHEN line-CommentCount > res THEN line-CommentCount ELSE res )
      ).

      "Provide a Comment Number for all Comments that have none.
      LOOP AT comments INTO DATA(comment) WHERE CommentCount IS INITIAL.
        max_comment_count += 1.
        APPEND VALUE #(
          %tky      = comment-%tky
          CommentCount = max_comment_count
        ) TO update.
      ENDLOOP.
    ENDLOOP.

    "Update the Comment Number of all relevant Comments
    MODIFY ENTITIES OF ZI_Dev IN LOCAL MODE
    ENTITY Comment
      UPDATE FIELDS ( CommentCount ) WITH update
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

ENDCLASS.
